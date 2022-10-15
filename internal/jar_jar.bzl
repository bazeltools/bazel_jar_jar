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
    args.add(ctx.outputs.output_jar)

    ctx.actions.run(
        inputs = [rule_file, ctx.file.input_jar],
        outputs = [ctx.outputs.output_jar],
        executable = ctx.executable._jarjar_runner,
        progress_message = "jarjar %s" % ctx.label,
        arguments = [args],
    )

    return [
        JavaInfo(
            output_jar = ctx.outputs.output_jar,
            compile_jar = ctx.outputs.output_jar,
        ),
        DefaultInfo(files = depset([ctx.outputs.output_jar])),
    ]

jar_jar = rule(
    implementation = _jar_jar_impl,
    attrs = {
        "output_jar": attr.output(mandatory = True),
        "input_jar": attr.label(allow_single_file = True),
        "rules": attr.label(allow_single_file = True),
        "inline_rules" : attr.string_list(),
        "_jarjar_runner": attr.label(executable = True, cfg = "exec", default = "//src/main/java/com/github/johnynek/jarjar:app"),
    },
    provides = [JavaInfo],
)
