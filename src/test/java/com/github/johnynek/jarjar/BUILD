java_test(
    name = "GenericsTest",
    srcs = ["GenericsTest.java"],
    resources = [
        "//src/test:generics-precompiled",
    ],
    test_class = "com.github.johnynek.jarjar.GenericsTest",
    deps = [
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
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
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "PackageRemapperTest",
    srcs = ["PackageRemapperTest.java"],
    test_class = "com.github.johnynek.jarjar.PackageRemapperTest",
    deps = [
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "WildcardTest",
    srcs = ["WildcardTest.java"],
    test_class = "com.github.johnynek.jarjar.WildcardTest",
    deps = [
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)

java_test(
    name = "ZapProcessorTest",
    srcs = ["ZapProcessorTest.java"],
    test_class = "com.github.johnynek.jarjar.ZapProcessorTest",
    deps = [
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
        "//src/main/java/com/github/johnynek/jarjar",
    ],
)
