
load(
  "@bazel_tools//tools/build_defs/repo:jvm.bzl",
  "jvm_maven_import_external"
)

def _jar_jar_impl(ctx):
  ctx.actions.run(
    inputs=[ctx.file.rules, ctx.file.input_jar],
    outputs=[ctx.outputs.jar],
    executable=ctx.executable._jarjar_runner,
    progress_message="jarjar %s" % ctx.label,
    arguments=["process", ctx.file.rules.path, ctx.file.input_jar.path, ctx.outputs.jar.path])

  return [
    JavaInfo(
        output_jar = ctx.outputs.jar,
        compile_jar = ctx.outputs.jar
    ),
    DefaultInfo(files = depset([ctx.outputs.jar]))
  ]

jar_jar = rule(
    implementation = _jar_jar_impl,
    attrs = {
        "input_jar": attr.label(allow_single_file=True),
        "rules": attr.label(allow_single_file=True),
        "_jarjar_runner": attr.label(executable=True, cfg="host", default=Label("@com_github_johnynek_bazel_jar_jar//:jarjar_runner")),
    },
    outputs = {
      "jar": "%{name}.jar"
    },
    provides = [JavaInfo])

def _mvn_name(coord):
  nocolon = "_".join(coord.split(":"))
  nodot = "_".join(nocolon.split("."))
  nodash = "_".join(nodot.split("-"))
  return nodash

def _mvn_jar(coord, sha, bname, servers):
  nm = "jar_jar_" + _mvn_name(coord)
  jvm_maven_import_external(
      name=nm,
      artifact=coord,
      server_urls=servers,
      artifact_sha256=sha,
      licenses = []
  )
  native.bind(name=("com_github_johnynek_bazel_jar_jar/%s" % bname), actual = "@%s//jar" % nm)

def jar_jar_repositories(servers=["https://repo1.maven.org/maven2"]):
  _mvn_jar(
    "org.pantsbuild:jarjar:1.7.2",
    "0706a455e17b67718abe212e3a77688bbe8260852fc74e3e836d9f2e76d91c27",
    "jarjar",
    servers)
  _mvn_jar(
    "org.ow2.asm:asm:7.0",
    "b88ef66468b3c978ad0c97fd6e90979e56155b4ac69089ba7a44e9aa7ffe9acf",
    "asm",
    servers)
  _mvn_jar(
    "org.ow2.asm:asm-commons:7.0",
    "fed348ef05958e3e846a3ac074a12af5f7936ef3d21ce44a62c4fa08a771927d",
    "asm_commons",
    servers)
