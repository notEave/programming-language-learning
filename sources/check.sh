#!/usr/bin/env bash

#
# check.sh
#

[ -v DEBUG ] && set -x

srcdir=$(readlink -f "${BASH_SOURCE[0]}" | xargs dirname)
conff="${srcdir}/conf.txt"

# Compile together our inputs and outputs
notes=$(plle.readk -k 'notes' "${conff}")
args=$(plle.readk -k 'args' "${conff}")
stdin=$(plle.readk -k 'stdin' "${conff}")
stdout=$(plle.readk -k 'stdout' "${conff}")
stderr=$(plle.readk -k 'stderr' "${conff}")
code=$(plle.readk -k 'code' "${conff}")
checknum=$(plle.readk -k 'checknum' "${conff}")

# We want to record output/error into temporary files
outf=$(mktemp -t stdout.XXXXXX)
errf=$(mktemp -t stderr.XXXXXX)

# Program execution
"${@}" "${args}" > "${outf}" 2> "${errf}" <<< "${stdin}"
ecode="${?}"
nofail=0

# Print diagnostics about the test
echo "Check ${checknum}"
echo 'Standard input:'
echo "${stdin:--}"
echo 'Command-line arguments:'
echo "${args:--}"
echo "Notes:"
echo "${notes:--}"

echo 'Standard output:'
diff -B --color "${outf}" <(echo "${stdout}")
diffexit="${?}"
[ "${diffexit}" -eq 0 ] && echo '-'
[ "${diffexit}" -gt "${nofail}" ] && nofail=1

echo 'Standard error:'
diff -B --color "${errf}" <(echo "${stderr}")
diffexit="${?}"
[ "${diffexit}" -eq 0 ] && echo '-'
[ "${diffexit}" -gt "${nofail}" ] && nofail=1

echo 'Exit code:'
diff -B --color <(echo "${ecode}") <(echo "${code}")
diffexit="${?}"
[ "${diffexit}" -eq 0 ] && echo '-'
[ "${diffexit}" -gt "${nofail}" ] && nofail=1

########################################
# Additional checks after this comment #
########################################

##############################
# Additional checks end here #
##############################

exit "${nofail}"
