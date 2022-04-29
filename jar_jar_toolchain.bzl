def _jar_jar_toolchain_impl(ctx):
    toolchain = platform_common.ToolchainInfo(
        rules = ctx.attr.rules,
        jar_jar_runner = ctx.attr.jar_jar_runner,
        duplicate_class_to_warn = ctx.attr.duplicate_class_to_warn
    )
    return [toolchain]

jar_jar_toolchain = rule(
    _jar_jar_toolchain_impl,
    attrs = {
        "rules": attr.label(allow_single_file = True),
        "duplicate_class_to_warn": attr.bool(mandatory = False, default = False),
        "jar_jar_runner": attr.label(executable = True, cfg = "host", default = Label("@com_github_johnynek_bazel_jar_jar//src/main/java/com/github/johnynek/jarjar:app")),
    },
)
