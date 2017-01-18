# bazel_jar_jar
JarJar rules for bazel (rename packages and classes in existing jars)

This rule uses [pantsbuild's jarjar fork](https://github.com/pantsbuild/jarjar).
The main use case is to use more than one version of a jar at a time with different versions mapped to
a different package.

As an example, see the test/example.
