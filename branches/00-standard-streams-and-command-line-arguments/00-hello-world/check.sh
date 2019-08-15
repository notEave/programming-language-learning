#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x


# TODO Parallelize running of checks
# for when a problem might require internet access
checks=".components/[[:digit:]][[:digit:]]-check.sh"
for check in ${checks}
do
    echo 'Running check' "$(basename "$check")"
    bash "$check" "${@}"
done
