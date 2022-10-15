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
      path = "/org/ow2/asm/asm/9.4/asm-9.4.jar",
      sha256 = "39d0e2b3dc45af65a09b097945750a94a126e052e124f93468443a1d0e15f381",
      servers = servers,
    )
    _http_jar_with_servers(
      name = "bazel_jar_jar_asm_commons",
      path = "/org/ow2/asm/asm-commons/9.4/asm-commons-9.4.jar",
      sha256 = "0c128a9ec3f33c98959272f6d16cf14247b508f58951574bcdbd2b56d6326364",
      servers = servers,
    )
