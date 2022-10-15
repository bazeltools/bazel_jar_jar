java_library(
    name = "jarjar",
    srcs = glob(["**/*.java"]),
    resources = [
        "help.txt",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@bazel_jar_jar_asm//jar",
        "@bazel_jar_jar_asm_commons//jar",
    ],
)

java_binary(
    name = "app",
    main_class = "com.github.johnynek.jarjar.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [":jarjar"],
)
