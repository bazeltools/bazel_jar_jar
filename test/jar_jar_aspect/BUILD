load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar_toolchain.bzl",
    "jar_jar_toolchain",
)

toolchain(
    name = "jar_jar_toolchain",
    toolchain = ":jar_jar_toolchain_impl",
    toolchain_type = "@com_github_johnynek_bazel_jar_jar//toolchains:toolchain_type",
    visibility = ["//visibility:public"],
)

jar_jar_toolchain(
    name = "jar_jar_toolchain_impl",
    rules = "shade_rule",
    visibility = ["//visibility:public"],
)
