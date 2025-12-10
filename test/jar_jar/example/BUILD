load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar",
)
load("@rules_java//java:java_import.bzl", "java_import")
load("@rules_java//java:java_library.bzl", "java_library")

alias(
    name = "file_output",
    actual = "shaded_args.jar",
)

alias(
    name = "custom_file_output",
    actual = "custom_name.jar",
)

jar_jar(
    name = "shaded_args_custom_out",
    input_jar = "@com_twitter_scalding_args",
    output_jar = "custom_name.jar",
    rules = "shade_rule",
)

jar_jar(
    name = "shaded_args",
    input_jar = "@com_twitter_scalding_args",
    jvm_flags = [
        "-Xmx2g",
        "-Xms256m",
    ],
    rules = "shade_rule",
)

java_import(
    name = "shaded_scalding",
    jars = ["shaded_args.jar"],
)

java_library(
    name = "use_foo",
    srcs = ["UseFoo.java"],
    deps = [":shaded_scalding"],
)
