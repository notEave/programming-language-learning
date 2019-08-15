#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x


# TODO Parallelize running of checks
# for when a problem might require internet access
for check in .components/check_[[:digit:]].sh
do
     bash "$check" "${@}"
done
