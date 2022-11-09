# This is the provider we pass up along to the outer thin_jar_jar rule.
ShadedJars = provider(fields = [
    "java_info",
    "output_files",
    "tags",
    "transitive_shaded",
])

def merge_shaded_jars_info(shaded_jars):
    return ShadedJars(
        output_files = depset(transitive = [s.output_files for s in shaded_jars]),
        java_info = java_common.make_non_strict(java_common.merge([s.java_info for s in shaded_jars])),
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

def _build_nosrc_jar(ctx):
    manifest_content = ctx.actions.declare_file("%s_manifest" % ctx.label.name)
    ctx.actions.write(manifest_content, "Manifest-Version: 1.0")

    resources = "META-INF/MANIFEST.MF=%s\n" % manifest_content.path
    jar = ctx.actions.declare_file("%s_empty.jar" % ctx.label.name)

    zipper_arg_path = ctx.actions.declare_file("%s_zipper_args" % ctx.label.name)
    ctx.actions.write(zipper_arg_path, resources)
    cmd = """
rm -f {jar_output}
{zipper} c {jar_output} @{path}
"""

    cmd = cmd.format(
        path = zipper_arg_path.path,
        jar_output = jar.path,
        zipper = ctx.executable._zipper.path,
    )

    ctx.actions.run_shell(
        inputs = [manifest_content],
        tools = [ctx.executable._zipper, zipper_arg_path],
        outputs = [jar],
        command = cmd,
        progress_message = "jar jar empty %s" % ctx.label,
        arguments = [],
    )
    return jar

def _jar_jar_aspect_impl(target, ctx):
    if JavaInfo not in target:
        return []

    current_jars = [j for j in target[JavaInfo].runtime_output_jars]
    # For some outputs, like those from the built in java proto aspect, the runtime output jars is empty, but the jars
    # exist instead in the java_outputs section.
    current_jars.extend([e.class_jar for e in target[JavaInfo].java_outputs])

    toolchain_cfg = ctx.toolchains["@com_github_johnynek_bazel_jar_jar//toolchains:toolchain_type"]
    rules = toolchain_cfg.rules.files.to_list()[0]
    duplicate_to_warn = toolchain_cfg.duplicate_class_to_warn

    # Since the JavaInfo constructor requires you have a jar
    # if there is none, so a java library just exporting things maybe
    # We then need to make an empty jar.
    # This seems due to java_library being native in java and not having to obey having an output jar.
    if len(current_jars) == 0:
        current_jars = [_build_nosrc_jar(ctx)]

    transitive_shaded=[]
    java_info_runtime_deps = []
    if hasattr(ctx.rule.attr, "runtime_deps"):
        for d in ctx.rule.attr.runtime_deps:
            if ShadedJars in d:
                shaded_jars = d[ShadedJars]
                transitive_shaded.append(depset([shaded_jars]))
                transitive_shaded.append(shaded_jars.transitive_shaded)
                java_info_runtime_deps.append(shaded_jars.java_info)

    java_info_exports = []
    if hasattr(ctx.rule.attr, "exports"):
        for d in ctx.rule.attr.exports:
            if ShadedJars in d:
                shaded_jars = d[ShadedJars]
                transitive_shaded.append(depset([shaded_jars]))
                transitive_shaded.append(shaded_jars.transitive_shaded)
                java_info_exports.append(shaded_jars.java_info)

    java_info_deps = []
    for d in ctx.rule.attr.deps:
        if ShadedJars in d:
            shaded_jars = d[ShadedJars]
            transitive_shaded.append(depset([shaded_jars]))
            transitive_shaded.append(shaded_jars.transitive_shaded)
            java_info_deps.append(shaded_jars.java_info)

    java_outputs = []
    output_files = []
    for input_jar in current_jars:
        output_file_name = "{prefix}-shaded.jar".format(prefix = __get_no_ext_name(input_jar))
        output_file = ctx.actions.declare_file(output_file_name)
        output_files.append(output_file)
        java_outputs.append(
            JavaInfo(
                output_jar = output_file,
                compile_jar = output_file,
                deps = java_info_deps,
                runtime_deps = java_info_runtime_deps,
                exports = java_info_exports,
            ),
        )
        flags = []
        if duplicate_to_warn:
            flags.append("-DduplicateClassToWarn={duplicate_to_warn}".format(duplicate_to_warn=duplicate_to_warn))

        args = ctx.actions.args()
        for flag in flags:
            if toolchain_cfg.jar_jar_is_native_image:
                args.add(flag)
            else:
                args.add("--jvm_flag=%s" % flag)
        args.add_all(["process", rules.path, input_jar.path, output_file.path])
        ctx.actions.run(
            inputs = [rules, input_jar],
            outputs = [output_file],
            executable = toolchain_cfg.jar_jar_runner.files_to_run,
            progress_message = "thin jarjar %s" % ctx.label,
            arguments = [args],
        )

    return [
        ShadedJars(
            java_info = java_common.make_non_strict(java_common.merge(java_outputs)),
            output_files = depset(output_files),
            tags = ctx.rule.attr.tags or [],
            transitive_shaded = depset(transitive=transitive_shaded)
        ),
    ]

jar_jar_aspect = aspect(
    implementation = _jar_jar_aspect_impl,
    attr_aspects = ["deps", "runtime_deps", "exports"],
    required_aspect_providers = [
        [JavaInfo],
        [ShadedJars],
        # Allows this to pass through java proto libraries
        ['proto_java'],
        []
    ],
    attrs = {
        "_java_toolchain": attr.label(
            default = Label("@bazel_tools//tools/jdk:current_java_toolchain"),
        ),
        "_zipper": attr.label(
            executable = True,
            cfg = "host",
            default = Label("@bazel_tools//tools/zip:zipper"),
            allow_files = True,
        )
    },

    toolchains = [
        "@com_github_johnynek_bazel_jar_jar//toolchains:toolchain_type",
    ],
)
