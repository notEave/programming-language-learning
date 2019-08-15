#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x

for check in .components/check_[[:digit:]].sh
do
     bash "$check" "${@}"
done
