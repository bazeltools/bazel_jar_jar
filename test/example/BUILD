load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar"
)

jar_jar(
    name = "shaded_args",
    input_jar = "@com_twitter_scalding_args//jar",
    rules = "shade_rule"
    )

java_import(
    name = "shaded_scalding",
    jars = ["shaded_args.jar"]
    )

java_library(
    name = "use_foo",
    srcs = ["UseFoo.java"],
    deps = [":shaded_scalding"])
