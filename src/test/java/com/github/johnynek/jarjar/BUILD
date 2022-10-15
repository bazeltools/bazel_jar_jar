java_test(
    name = "GenericsTest",
    srcs = ["GenericsTest.java"],
    resources = [
        "//src/test:generics-precompiled",
    ],
    test_class = "com.github.johnynek.jarjar.GenericsTest",
    deps = [
        "@bazel_jar_jar_asm//jar",
        "@bazel_jar_jar_asm_commons//jar",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "MethodRewriterTest",
    srcs = ["MethodRewriterTest.java"],
    resources = [
        "BigtableIO$Write.class",
    ],
    test_class = "com.github.johnynek.jarjar.MethodRewriterTest",
    deps = [
        "@bazel_jar_jar_asm//jar",
        "@bazel_jar_jar_asm_commons//jar",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "PackageRemapperTest",
    srcs = ["PackageRemapperTest.java"],
    test_class = "com.github.johnynek.jarjar.PackageRemapperTest",
    deps = [
        "@bazel_jar_jar_asm//jar",
        "@bazel_jar_jar_asm_commons//jar",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "WildcardTest",
    srcs = ["WildcardTest.java"],
    test_class = "com.github.johnynek.jarjar.WildcardTest",
    deps = [
        "@bazel_jar_jar_asm//jar",
        "@bazel_jar_jar_asm_commons//jar",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "ZapProcessorTest",
    srcs = ["ZapProcessorTest.java"],
    test_class = "com.github.johnynek.jarjar.ZapProcessorTest",
    deps = [
        "@bazel_jar_jar_asm//jar",
        "@bazel_jar_jar_asm_commons//jar",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)
