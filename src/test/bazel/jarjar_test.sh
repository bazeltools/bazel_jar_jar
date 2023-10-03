#!/bin/bash

set -o nounset
set -o errexit
set -o xtrace
set -o pipefail

ls "$SCALDING_ARGS__SHADED"
unzip -l "$SCALDING_ARGS__SHADED" > unzip.txt
cat unzip.txt | grep "01-01-2010 00:00"
cat unzip.txt | grep "foo/Args.class"
