load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar",
)
load("@rules_java//java:java_import.bzl", "java_import")
load("@rules_java//java:java_library.bzl", "java_library")

jar_jar(
    name = "shaded_args",
    inline_rules = ["rule com.twitter.scalding.** foo.@1"],
    input_jar = "@com_twitter_scalding_args",
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
