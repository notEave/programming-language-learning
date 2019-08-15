#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x

# Fields for generating info.md file
# Write additional notes about the test here
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
# Reaching EOF causes read to exit with non-zero exit code, so wrap it in
# set +e set -e.
set +e
read -r -d '' stdout << EOF
Hello world
EOF
set -e

set +e
read -r -d '' stderr << EOF
EOF

# We want to record output into temporary files for later inspection
stdoutfile="$(mktemp -t stdout.XXXXXX)"
stderrfile="$(mktemp -t stderr.XXXXXX)"

# Actual execution of the program, outputs redirected
"${@}" "${args}" > "${stdoutfile}" 2> "${stderrfile}" <<< "${stdin}"

# If files differ, diff's exit code will be non-zero,
# which would cause the script to terminate when set -e is active.
# Stop this from happening with <command> || true
# -B to ignore blank lines
diff --color -B -u -s "${stdoutfile}" <(echo "${stdout}") || true
diff --color -B -u -s "${stderrfile}" <(echo "${stderr}") || true
