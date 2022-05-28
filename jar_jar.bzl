load(
    "@bazel_tools//tools/build_defs/repo:jvm.bzl",
    "jvm_maven_import_external",
)

def _jar_jar_impl(ctx):
    rule_file = ctx.file.rules
    if rule_file != None and ctx.attr.inline_rules != []:
        fail("Using both a rules file and inline_rules are incompatible; use one or the other.")
    if rule_file == None and ctx.attr.inline_rules == []:
        fail("You have to specify either a rules file or inline_rules.")
    if rule_file == None:
        rule_file = ctx.actions.declare_file("jar_jar-rules-" + ctx.label.name + ".tmp")
        ctx.actions.write(
            output = rule_file,
            content = "\n".join(ctx.attr.inline_rules)
        )

    ctx.actions.run(
        inputs = [rule_file, ctx.file.input_jar],
        outputs = [ctx.outputs.jar],
        executable = ctx.executable._jarjar_runner,
        progress_message = "jarjar %s" % ctx.label,
        arguments = ["process", rule_file.path, ctx.file.input_jar.path, ctx.outputs.jar.path],
    )

    return [
        JavaInfo(
            output_jar = ctx.outputs.jar,
            compile_jar = ctx.outputs.jar,
        ),
        DefaultInfo(files = depset([ctx.outputs.jar])),
    ]

jar_jar = rule(
    implementation = _jar_jar_impl,
    attrs = {
        "input_jar": attr.label(allow_single_file = True),
        "rules": attr.label(allow_single_file = True),
        "inline_rules" : attr.string_list(),
        "_jarjar_runner": attr.label(executable = True, cfg = "host", default = Label("@com_github_johnynek_bazel_jar_jar//src/main/java/com/github/johnynek/jarjar:app")),
    },
    outputs = {
        "jar": "%{name}.jar",
    },
    provides = [JavaInfo],
)

def _mvn_name(coord):
    nocolon = "_".join(coord.split(":"))
    nodot = "_".join(nocolon.split("."))
    nodash = "_".join(nodot.split("-"))
    return nodash

def _mvn_jar(coord, sha, bname, servers):
    nm = "jar_jar_" + _mvn_name(coord)
    jvm_maven_import_external(
        name = nm,
        artifact = coord,
        server_urls = servers,
        artifact_sha256 = sha,
        licenses = [],
    )
    native.bind(name = ("com_github_johnynek_bazel_jar_jar/%s" % bname), actual = "@%s//jar" % nm)

def jar_jar_repositories(servers = ["https://repo1.maven.org/maven2"]):
    _mvn_jar(
        "org.ow2.asm:asm:7.0",
        "b88ef66468b3c978ad0c97fd6e90979e56155b4ac69089ba7a44e9aa7ffe9acf",
        "asm",
        servers,
    )
    _mvn_jar(
        "org.ow2.asm:asm-commons:7.0",
        "fed348ef05958e3e846a3ac074a12af5f7936ef3d21ce44a62c4fa08a771927d",
        "asm_commons",
        servers,
    )
