

# This is the provider we pass up along to the outer thin_jar_jar rule.
ShadedJars = provider(fields = [
    "java_info",
    "output_files"
])

def merge_shaded_jars_info(shaded_jars):
    return ShadedJars(
        output_files = depset(transitive = [s.output_files for s in shaded_jars]),
        java_info = java_common.merge([s.java_info for s in shaded_jars]),
    )

# To name the files in a helpful manner
# we strip off from the last '.' and will then append '-shaded.jar'
def __get_no_ext_name(jar_path):
    fname = jar_path.basename
    last_indx = fname.rindex(".")
    if last_indx <= 0:
        return fname
    else:
        return fname[:last_indx]

def _jar_jar_aspect_impl(target, ctx):
    current_jars = target[JavaInfo].runtime_output_jars
    toolchain_cfg = ctx.toolchains["@com_github_johnynek_bazel_jar_jar//toolchains:toolchain_type"]
    rules = toolchain_cfg.rules.files.to_list()[0]

    java_outputs = []
    output_files = []
    for input_jar in current_jars:
        output_file_name = "{prefix}-shaded.jar".format(prefix=__get_no_ext_name(input_jar))
        output_file = ctx.actions.declare_file(output_file_name)
        output_files.append(output_file)
        java_outputs.append(
            JavaInfo(
                output_jar = output_file,
                compile_jar = output_file,
            )
        )
        ctx.actions.run(
            inputs=[rules, input_jar],
            outputs=[output_file],
            executable = toolchain_cfg.jar_jar_runner.files_to_run,
            progress_message="thin jarjar %s" % ctx.label,
            arguments=["process", rules.path, input_jar.path, output_file.path]
        )

    this_shaded =  ShadedJars(
            java_info = java_common.merge(java_outputs),
            output_files = depset(output_files),
    )
    return [
        merge_shaded_jars_info(
            [d[ShadedJars] for d in ctx.rule.attr.deps] + [this_shaded]
        )
    ]


jar_jar_aspect = aspect(
    implementation = _jar_jar_aspect_impl,
    attr_aspects = ["deps", "runtime_deps"],
    required_aspect_providers = [
        [JavaInfo],
        [ShadedJars],
    ],
    attrs = {
         "_java_toolchain": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_toolchain"),
        ),
    },
    toolchains = [
        "@com_github_johnynek_bazel_jar_jar//toolchains:toolchain_type",
    ],

)
