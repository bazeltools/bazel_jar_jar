workspace(name = "com_github_johnynek_bazel_jar_jar")

load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar_repositories",
)

jar_jar_repositories()

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

RULES_JVM_EXTERNAL_TAG = "4.5"

RULES_JVM_EXTERNAL_SHA = "b17d7388feb9bfa7f2fa09031b32707df529f26c91ab9e5d909eb1676badd9a6"

http_archive(
    name = "rules_jvm_external",
    sha256 = RULES_JVM_EXTERNAL_SHA,
    strip_prefix = "rules_jvm_external-%s" % RULES_JVM_EXTERNAL_TAG,
    url = "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/%s.zip" % RULES_JVM_EXTERNAL_TAG,
)

load("@rules_jvm_external//:repositories.bzl", "rules_jvm_external_deps")

rules_jvm_external_deps()

load("@rules_jvm_external//:setup.bzl", "rules_jvm_external_setup")

rules_jvm_external_setup()

load("@rules_jvm_external//:defs.bzl", "maven_install")

maven_install(
    artifacts = [
        "junit:junit:4.13",
        "org.apache.commons:commons-lang3:3.11",
        "org.hamcrest:hamcrest-core:1.3",
        "org.openjdk.jmh:jmh-core:1.34",
        "org.openjdk.jmh:jmh-generator-annprocess:1.34",
    ],
    fail_if_repin_required = True,
    maven_install_json = "@//:maven_install.json",
    repositories = [
        "https://maven.google.com",
        "https://repo1.maven.org/maven2",
    ],
)

load("@maven//:defs.bzl", "pinned_maven_install")

pinned_maven_install()
