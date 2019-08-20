#!/usr/bin/env bash

#
# preproc.sh
#
# Insert variables into a groff source file
#

set -euo pipefail
[ -v DEBUG ] && set -x

function valof {
    fval=$(awk '/'"${1^^}"'/,/^$/' "${2}" | awk 'NF' | tail -n +2)
    echo "${fval:--}"
}

function fieldsof {
    grep '^@' "$1"
}

deffile=$(cat "${2}")

for field in $(fieldsof "${2}")
do
    fval=$(valof "${field}" "${1}")
    deffile="${deffile//$field/$fval}"
done

echo "$deffile"
