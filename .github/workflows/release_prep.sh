#!/usr/bin/env bash

# Based on
# https://github.com/bazel-contrib/rules-template/blob/07fefdbc09d7ca2a49d24220e00dac2efc2bf9b7/.github/workflows/release_prep.sh

set -o errexit -o nounset -o pipefail

# Set by GH actions, see
# https://docs.github.com/en/actions/learn-github-actions/environment-variables#default-environment-variables
TAG=${GITHUB_REF_NAME}
# The prefix is chosen to match what GitHub generates for source archives
PREFIX="bazel_jar_jar-${TAG:1}"
ARCHIVE="bazel_jar_jar-$TAG.tar.gz"
git archive --format=tar --prefix=${PREFIX}/ ${TAG} | gzip > $ARCHIVE
SHA=$(shasum -a 256 $ARCHIVE | awk '{print $1}')

cat << EOF
## Using Bzlmod

1. Enable with \`common --enable_bzlmod\` in \`.bazelrc\` (default with Bazel 7).
2. Add to your \`MODULE.bazel\` file:

\`\`\`starlark
bazel_dep(name = "bazel_jar_jar", version = "${TAG:1}")
\`\`\`

## Using WORKSPACE

Paste this snippet into your \`WORKSPACE.bazel\` file:

\`\`\`starlark
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_jar_jar",
    sha256 = "${SHA}",
    strip_prefix = "${PREFIX}",
    url = "https://github.com/bazeltools/bazel_jar_jar/releases/download/${TAG}/${ARCHIVE}",
)

load(
    "@com_github_johnynek_bazel_jar_jar//:jar_jar.bzl",
    "jar_jar_repositories",
)

jar_jar_repositories()
\`\`\`
EOF
