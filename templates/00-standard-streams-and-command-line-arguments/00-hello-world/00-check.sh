#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x

# Fields for generating info.md file
# Write additional notes about the test here
# Reaching EOF causes read to exit with non-zero exit code, so wrap it in
# set +e set -e.
set +e
read -r -d '' notes << EOF
EOF
set -e

# Command-line arguments given to the program
args=''
# Standard input directed at the program
set +e
read -r -d '' stdin << EOF
EOF
set -e

# Expected standard output and standard error of the program
# read -r to not interpret backslash characters, read delimits with \n by
# default, so use -d '' to remove delimiting for multiline heredocs.
set +e
read -r -d '' stdout << EOF
Hello world
EOF
set -e

set +e
read -r -d '' stderr << EOF
EOF
set -e

exitcode='0'

# We want to record output into temporary files for later inspection
stdoutfile="$(mktemp -t stdout.XXXXXX)"
stderrfile="$(mktemp -t stderr.XXXXXX)"

# Actual execution of the program, outputs redirected
set +e
"${@}" "${args}" > "${stdoutfile}" 2> "${stderrfile}" <<< "${stdin}"
code="$?"
set -e

errors='0'
# If files differ, diff's exit code will be non-zero,
# which would cause the script to terminate when set -e is active.
# Stop this from happening with <command> || true
# -B to ignore blank lines, -u for unified output, -s reports when files match
echo "Notes: ${notes:--}"

echo 'Standard output:'
set +e
diff -B --color "${stdoutfile}" <(echo "${stdout}") && echo '-' || exit 1
set -e

echo 'Standard error:'
set +e
diff -B --color "${stderrfile}" <(echo "${stderr}") && echo '-' || exit 1
set -e


echo 'Exit code:'
set +e
diff -B --color <(echo "${code}") <(echo "${exitcode}") && echo '-' || exit 1
set -e
