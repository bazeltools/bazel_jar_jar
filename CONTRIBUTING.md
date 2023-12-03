## Releasing

As one-time setup, follow the first step of https://github.com/bazel-contrib/publish-to-bcr#how-it-works.

1. Create an annotated tag with `git tag -a v1.2.3`, where the message will be used in the release notes.
2. Push the tag with `git push origin v1.2.3` to trigger the creation of a GitHub pre-release as well as a Bazel Central Registry (BCR) PR.
   The PR will be associated with the GitHub account configured in `.bcr/config.yml`.
3. Review the release notes on https://github.com/bazeltools/bazel_jar_jar/releases and mark the release as final.