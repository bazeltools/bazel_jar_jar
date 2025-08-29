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

def jar_jar_repositories(servers = ["https://repo1.maven.org/maven2"]):
    _http_jar_with_servers(
        name = "jvm__jarjar_abrams_assembly",
        path = "/com/eed3si9n/jarjarabrams/jarjar-abrams-assembly_2.12/1.15.0/jarjar-abrams-assembly_2.12-1.15.0.jar",
        sha256 = "cc896901e66bc65aeab164e914040aacea16e8a4108b385142b2c68207d5881b",
        servers = servers,
    )
    _http_jar_with_servers(
        name = "jvm__com_twitter__scalding_args",
        path = "/com/twitter/scalding-args_2.12/0.17.4/scalding-args_2.12-0.17.4.jar",
        sha256 = "e0de2ad8ef344bb11a2854275b5b85a1adb17f0e0ed9740177d940a602cd977b",
        servers = servers,
    )
