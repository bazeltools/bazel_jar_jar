java_library(
    name = "jarjar",
    srcs = glob(["**/*.java"]),
    resources = [
        "help.txt",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
    ],
)

java_binary(
    name = "app",
    main_class = "com.github.johnynek.jarjar.Main",
    visibility = ["//visibility:public"],
    runtime_deps = [":jarjar"],
)
