load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_jar",
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

    args = ctx.actions.args()
    args.add("process")
    args.add(rule_file)
    args.add(ctx.file.input_jar)
    args.add(ctx.outputs.jar)

    ctx.actions.run(
        inputs = [rule_file, ctx.file.input_jar],
        outputs = [ctx.outputs.jar],
        executable = ctx.executable._jarjar_runner,
        progress_message = "jarjar %s" % ctx.label,
        arguments = [args],
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
        "_jarjar_runner": attr.label(executable = True, cfg = "exec", default = "//src/main/java/com/github/johnynek/jarjar:app"),
    },
    outputs = {
        "jar": "%{name}.jar",
    },
    provides = [JavaInfo],
)

def _http_jar_with_servers(name, path, sha256, servers):
    http_jar(
      name = name,
      urls = [server + path for server in servers],
      sha256 = sha256,
    )

def jar_jar_repositories(servers=["https://repo1.maven.org/maven2"]):
    _http_jar_with_servers(
      name = "bazel_jar_jar_asm",
      path = "/org/ow2/asm/asm/7.0/asm-7.0.jar",
      sha256 = "b88ef66468b3c978ad0c97fd6e90979e56155b4ac69089ba7a44e9aa7ffe9acf",
      servers = servers,
    )
    _http_jar_with_servers(
      name = "bazel_jar_jar_asm_commons",
      path = "/org/ow2/asm/asm-commons/7.0/asm-commons-7.0.jar",
      sha256 = "fed348ef05958e3e846a3ac074a12af5f7936ef3d21ce44a62c4fa08a771927d",
      servers = servers,
    )
