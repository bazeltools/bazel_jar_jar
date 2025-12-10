load(
    "@com_github_johnynek_bazel_jar_jar//:thin_jar_jar.bzl",
    "thin_jar_jar",
)
load("@rules_java//java:java_library.bzl", "java_library")

java_library(
    name = "using_unshaded",
    srcs = ["UseUseUnshadedFoo.java"],
    deps = [
        "@org_twitter4j_twitter4j_core",
    ],
)

thin_jar_jar(
    name = "shaded_deps",
    deps = [
        ":using_unshaded",
    ],
)

java_library(
    name = "use_foo",
    srcs = ["UseFoo.java"],
    deps = [":shaded_deps"],
)
