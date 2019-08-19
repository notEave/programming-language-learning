#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x

function valof {
    value=$(awk '/'"${1^^}"'/,/^$/' "${2}" | awk 'NF' | tail -n +2)
    echo "${value:--}"
}

function fieldsof {
    grep '^@' "$1"
}

fmt="$(cat 'info.ms')"

for field in $(fieldsof <(echo "${fmt}"))
do
    val=$(valof "${field}" 'config.txt')
    fmt=${fmt//$field/$val}
done
groff -ms -T pdf <(echo "${fmt}") > 'info.pdf'
