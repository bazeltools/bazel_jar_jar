java_library(
    name = "base",
    srcs = [
        "FileTree.java",
        "IntegrationTestBase.java",
        "JarJarFailedException.java",
        "ProcessCommunicator.java",
    ],
    deps = [
        "//external:com_github_johnynek_bazel_jar_jar/asm",
        "//external:com_github_johnynek_bazel_jar_jar/asm_commons",
        "//src/main/java/com/github/johnynek/jarjar",
        "@commons_lang3",
        "@junit_junit",
        "@org_hamcrest_hamcrest_core",
    ],
)

java_test(
    name = "BadPackagesTest",
    srcs = ["BadPackagesTest.java"],
    test_class = "com.github.johnynek.jarjar.integration.BadPackagesTest",
    deps = [":base"],
)

java_test(
    name = "JavaVersionsTest",
    srcs = ["JavaVersionsTest.java"],
    test_class = "com.github.johnynek.jarjar.integration.JavaVersionsTest",
    deps = [":base"],
)

java_test(
    name = "DuplicateClassTest",
    srcs = ["DuplicateClassTest.java"],
    data = ["duplicate_class.jar"],
    test_class = "com.github.johnynek.jarjar.integration.DuplicateClassTest",
    deps = [":base"],
)
