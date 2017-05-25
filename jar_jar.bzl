
def _jar_jar_impl(ctx):
  ctx.action(
    inputs=[ctx.file.rules, ctx.file.input_jar],
    outputs=[ctx.outputs.jar],
    executable=ctx.executable._jarjar_runner,
    progress_message="jarjar %s" % ctx.label,
    arguments=["process", ctx.file.rules.path, ctx.file.input_jar.path, ctx.outputs.jar.path])

jar_jar = rule(
    implementation = _jar_jar_impl,
    attrs = {
        "input_jar": attr.label(allow_files=True, single_file=True),
        "rules": attr.label(allow_files=True, single_file=True),
        "_jarjar_runner": attr.label(executable=True, cfg="host", default=Label("@com_github_johnynek_bazel_jar_jar//:jarjar_runner")),
    },
    outputs = {
      "jar": "%{name}.jar"
    })

def _mvn_name(coord):
  nocolon = "_".join(coord.split(":")[0:-1])
  nodot = "_".join(nocolon.split("."))
  nodash = "_".join(nodot.split("-"))
  return nodash

def mvn_jar(coord, sha):
  native.maven_jar(
    name = _mvn_name(coord),
    artifact = coord,
    sha1 = sha
  )

def jar_jar_repositories():
  mvn_jar(
    "org.pantsbuild:jarjar:1.6.3",
    "cf54d4b142f5409c394095181c8d308a81869622")
  mvn_jar(
    "org.ow2.asm:asm:5.0.4",
    "0da08b8cce7bbf903602a25a3a163ae252435795")
  mvn_jar(
    "org.ow2.asm:asm-commons:5.0.4",
    "5a556786086c23cd689a0328f8519db93821c04c")
