load("//:jar_jar.bzl", "jar_jar_repositories")

non_module_deps = module_extension(lambda _: jar_jar_repositories())
