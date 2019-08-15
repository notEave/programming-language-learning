#!/usr/bin/env bash
set -e -u -o pipefail

[ -v DEBUG ] && set -x

args=''
stdin='another hello world'
expect='Hello world'

# TODO Move diff command somewhere else
diff  --color <("${@}" "${args}" <<< "${stdin}") <(echo "${expect}")

