#!/usr/bin/env bash

set -euo pipefail
[ -v DEBUG ] && set -x

# Fields for generating info.md file
# Write additional notes about the test here
notes=\
""

# Command-line arguments given to the program
args=''

# Standard input directed at the program
set +e
stdin=\
""

# Expected standard output and standard error of the program
stdout=\
"Hello, world!
And others
In existence"

stderr=\
""

# Expected exit code
exitcode=\
"0"

# We want to record output into temporary files for later inspection
stdoutfile="$(mktemp -t stdout.XXXXXX)"
stderrfile="$(mktemp -t stderr.XXXXXX)"

# Actual execution of the program, outputs redirected
set +e
"${@}" "${args}" > "${stdoutfile}" 2> "${stderrfile}" <<< "${stdin}"
code="$?"
set -e

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
