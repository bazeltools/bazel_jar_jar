workspace(name = "com_github_johnynek_bazel_jar_jar")

load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar_repositories",
)

jar_jar_repositories()

load(
    "@bazel_tools//tools/build_defs/repo:jvm.bzl",
    "jvm_maven_import_external",
)

jvm_maven_import_external(
    name = "org_hamcrest_hamcrest_core",
    artifact = "org.hamcrest:hamcrest-core:1.3",
    artifact_sha256 = "66fdef91e9739348df7a096aa384a5685f4e875584cce89386a7a47251c4d8e9",
    licenses = [],
    server_urls = ["https://repo1.maven.org/maven2"],
)

jvm_maven_import_external(
    name = "junit_junit",
    artifact = "junit:junit:4.13",
    artifact_sha256 = "4b8532f63bdc0e0661507f947eb324a954d1dbac631ad19c8aa9a00feed1d863",
    licenses = [],
    server_urls = ["https://repo1.maven.org/maven2"],
)

jvm_maven_import_external(
    name = "commons_lang3",
    artifact = "org.apache.commons:commons-lang3:3.11",
    artifact_sha256 = "4ee380259c068d1dbe9e84ab52186f2acd65de067ec09beff731fca1697fdb16",
    licenses = [],
    server_urls = ["https://repo1.maven.org/maven2"],
)
