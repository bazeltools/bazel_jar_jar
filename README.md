# bazel_jar_jar

JarJar rules for [Bazel](https://bazel.build/) (rename packages and classes in existing jars)

This rule uses [pantsbuild's jarjar fork](https://github.com/pantsbuild/jarjar).
The main use case is to use more than one version of a jar at a time with different versions mapped to a different package. It can also be used to do [*dependency shading*](https://softwareengineering.stackexchange.com/questions/297276/what-is-a-shaded-java-dependency).


## How to add to Bazel `WORKSPACE`

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "com_github_johnynek_bazel_jar_jar",
    commit = "16e48f319048e090a2fe7fd39a794312d191fc6f", # Latest commit SHA as at 2019/02/13
    remote = "git://github.com/johnynek/bazel_jar_jar.git",
)

load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar_repositories",
)
jar_jar_repositories()
```


## Usage

> _Note_: Example code exists in [`test/example`](/test/example)

Specify a rule in a file that will remap one package path into another. For example:

```
rule com.twitter.scalding.** foo.@1
```

> _Note_: See [Rules File Formatting](#rules-file-formatting) for formatting details

Put that file in the same directory as the Bazel `BUILD` file that will specify the `jar_jar` rules. Reference that file in the `rules` field of the `jar_jar` rule.

```
jar_jar(
    name = "shaded_args",
    input_jar = "@com_twitter_scalding_args//jar",
    rules = "<FILENAME>"
)
```

The `input_jar` specifies the package that will be relocated. `name` is the target label to be used in place of the original package target label.


Change any references in your code from the original package path to the new shaded package path. For example: `import com.twitter.scalding.Args` becomes `import foo.Args`.

## Rules File Formatting

Rules file format
The rules file is a text file, one rule per line. Leading and trailing whitespace is ignored. There are three types of rules:

```
rule <pattern> <result>
zap <pattern>
keep <pattern>
```

The standard rule (rule) is used to rename classes. All references to the renamed classes will also be updated. If a class name is matched by more than one rule, only the first one will apply.

`<pattern>` is a class name with optional wildcards. `**` will match against any valid class name substring. To match a single package component (by excluding . from the match), a single * may be used instead.

`<result>` is a class name which can optionally reference the substrings matched by the wildcards. A numbered reference is available for every `*` or `**` in the `<pattern>`, starting from left to right: `@1`, `@2`, etc. A special `@0` reference contains the entire matched class name.

The zap rule causes any matched class to be removed from the resulting jar file. All zap rules are processed before renaming rules.

The keep rule marks all matched classes as "roots". If any keep rules are defined all classes which are not reachable from the roots via dependency analysis are discarded when writing the output jar. This is the last step in the process, after renaming and zapping.
