#!/usr/bin/env bash

#
# check.sh
#

[ -v DEBUG ] && set -x

srcdir=$(readlink -f "${BASH_SOURCE[0]}" | xargs dirname)
rundir="${srcdir}/.."

cd "${srcdir}" || exit 1

function exec-check {
    notes=$(plle.readk -k 'notes' -f 'conf.txt')
    args=$(plle.readk -k 'args' -f 'conf.txt')
    stdin=$(plle.readk -k 'stdin' -f 'conf.txt')
    stdout=$(plle.readk -k 'stdout' -f 'conf.txt')
    stderr=$(plle.readk -k 'stderr' -f 'conf.txt')
    code=$(plle.readk -k 'code' -c 'conf.txt')
    
    # We want to record output into temporary files for later
    # inspection
    stdoutf="$(mktemp -t stdout.XXXXXX)"
    stderrf="$(mktemp -t stdout.XXXXXX)"
    # Actual execution of the program, outputs redirected
    cd "${rundir}" || exit 1
    "${@}" "${args}" > "${stdoutf}" 2> "${stderrf}" <<< "${stdin}"
    ecode="$?"
    echo "Notes: ${notes:--}"
    echo 'Standard output:'
    diff -B --color "${stdoutf}" <(echo "${stdout}") && echo '-'
    echo 'Standard error:'
    diff -B --color "${stderrf}" <(echo "${stderr}") && echo '-'
    echo 'Exit code:'
    diff -B --color <(echo "${ecode}") <(echo "${code}") && echo '-'
}

exec-check "${@}"

#### Additional checks after this line

# We want to record output into temporary files for later inspection
#stdoutfile="$(mktemp -t stdout.XXXXXX)"
#stderrfile="$(mktemp -t stderr.XXXXXX)"

# Actual execution of the program, outputs redirected
#set +e
#"${@}" "${args}" > "${stdoutfile}" 2> "${stderrfile}" <<< "${stdin}"
#code="$?"
#set -e

#echo "Notes: ${notes:--}"

#echo 'Standard output:'
#set +e
#diff -B --color "${stdoutfile}" <(echo "${stdout}") && echo '-' || exit 1
#set -e

#echo 'Standard error:'
#set +e
#diff -B --color "${stderrfile}" <(echo "${stderr}") && echo '-' || exit 1
#set -e


#echo 'Exit code:'
#set +e
#diff -B --color <(echo "${code}") <(echo "${exitcode}") && echo '-' || exit 1
#set -e
