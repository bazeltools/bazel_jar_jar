def _jarjar_abrams_impl(ctx):
    # Create alias to the maven artifact for jarjar-abrams
    # http_jar creates a 'jar' subdirectory, so we replicate that structure
    ctx.file("BUILD.bazel", "# Root BUILD file\n")
    ctx.file("jar/BUILD.bazel", """
alias(
    name = "jar",
    actual = "@maven//:com_eed3si9n_jarjarabrams_jarjar_abrams_assembly_2_12",
    visibility = ["//visibility:public"],
)
""")

def _scalding_args_impl(ctx):
    # Create alias to the maven artifact for scalding-args
    # http_jar creates a 'jar' subdirectory, so we replicate that structure
    ctx.file("BUILD.bazel", "# Root BUILD file\n")
    ctx.file("jar/BUILD.bazel", """
alias(
    name = "jar",
    actual = "@maven//:com_twitter_scalding_args_2_12",
    visibility = ["//visibility:public"],
)
""")

_jarjar_abrams_repo = repository_rule(
    implementation = _jarjar_abrams_impl,
)

_scalding_args_repo = repository_rule(
    implementation = _scalding_args_impl,
)

def _non_module_deps_extension_impl(ctx):
    _jarjar_abrams_repo(name = "jvm__jarjar_abrams_assembly")
    _scalding_args_repo(name = "jvm__com_twitter__scalding_args")

non_module_deps = module_extension(implementation = _non_module_deps_extension_impl)
