load(
    "@com_github_johnynek_bazel_jar_jar//:thin_jar_jar.bzl",
    "thin_jar_jar"
)

java_library(
    name = "using_unshaded",
    deps = [
        "@org_twitter4j_twitter4j_core//jar"
    ],
        srcs = ["UseUseUnshadedFoo.java"],
    )

thin_jar_jar(
    name = "shaded_deps",
    deps = [
        ":using_unshaded"
    ]
)

java_library(
    name = "use_foo",
    srcs = ["UseFoo.java"],
    deps = [":shaded_deps"])
