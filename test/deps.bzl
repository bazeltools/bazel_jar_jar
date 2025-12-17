def _scalding_args_test_impl(ctx):
    # Create alias to the maven artifact for scalding-args
    ctx.file("BUILD.bazel", """
alias(
    name = "com_twitter_scalding_args",
    actual = "@maven//:com_twitter_scalding_args_2_9_3",
    visibility = ["//visibility:public"],
)
""")

def _twitter4j_impl(ctx):
    # Create alias to the maven artifact for twitter4j
    ctx.file("BUILD.bazel", """
alias(
    name = "org_twitter4j_twitter4j_core",
    actual = "@maven//:org_twitter4j_twitter4j_core",
    visibility = ["//visibility:public"],
)
""")

_scalding_args_test_repo = repository_rule(
    implementation = _scalding_args_test_impl,
)

_twitter4j_repo = repository_rule(
    implementation = _twitter4j_impl,
)

def _deps_ext_impl(ctx):
    _scalding_args_test_repo(name = "com_twitter_scalding_args")
    _twitter4j_repo(name = "org_twitter4j_twitter4j_core")

deps_ext = module_extension(implementation = _deps_ext_impl)
