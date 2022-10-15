load(
    "@bazel_tools//tools/build_defs/repo:http.bzl",
    "http_jar",
)
load(
    "//internal:jar_jar.bzl",
    _jar_jar = "jar_jar",
)

def jar_jar(name, output_jar = None, **kwargs):
    _jar_jar(
        name = name,
        output_jar = output_jar or (name + ".jar"),
        **kwargs
    )

def _http_jar_with_servers(name, path, sha256, servers):
    http_jar(
      name = name,
      urls = [server + path for server in servers],
      sha256 = sha256,
    )

def jar_jar_repositories(servers=["https://repo1.maven.org/maven2"]):
    _http_jar_with_servers(
      name = "bazel_jar_jar_asm",
      path = "/org/ow2/asm/asm/7.0/asm-7.0.jar",
      sha256 = "b88ef66468b3c978ad0c97fd6e90979e56155b4ac69089ba7a44e9aa7ffe9acf",
      servers = servers,
    )
    _http_jar_with_servers(
      name = "bazel_jar_jar_asm_commons",
      path = "/org/ow2/asm/asm-commons/7.0/asm-commons-7.0.jar",
      sha256 = "fed348ef05958e3e846a3ac074a12af5f7936ef3d21ce44a62c4fa08a771927d",
      servers = servers,
    )
