load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")

def deps():
    jvm_maven_import_external(
        name = "com_twitter_scalding_args",
        # Workaround for https://github.com/bazelbuild/bazel/pull/19997 with Bzlmod.
        generated_rule_name = "com_twitter_scalding_args",
        artifact = "com.twitter:scalding-args_2.9.3:0.12.0",
        artifact_sha256 = "2869f65981e57b34e25eb46e3dd2dda170ee7db7cdce04db3c7bf3d53c75084b",
        server_urls = ["https://repo.maven.apache.org/maven2"],
    )

    jvm_maven_import_external(
        name = "org_twitter4j_twitter4j_core",
        # Workaround for https://github.com/bazelbuild/bazel/pull/19997 with Bzlmod.
        generated_rule_name = "org_twitter4j_twitter4j_core",
        artifact = "org.twitter4j:twitter4j-core:4.0.7",
        artifact_sha256 = "f3d28049f1c13752c2ea71397fdcda8d9723cf315e7101502997fddfe9aad66d",
        server_urls = ["https://repo.maven.apache.org/maven2"],
    )

deps_ext = module_extension(lambda _: deps())
