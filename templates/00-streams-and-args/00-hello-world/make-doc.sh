#!/usr/bin/env bash

#
# make-doc.sh
#
# Preprocess a groff document with variables inserted from
# configuration files and spit out a pdf document.
#

set -euo pipefail
[ -v DEBUG ] && set -x

# Create a temporary directory containing a named pipe for writing
# text.
tempdir=$(mktemp -t -d "${0##*/}.XXXXXX")
fifo="${tempdir}/fifo"
mkfifo -m600 "${fifo}"
groff -ms -T pdf "${fifo}" &
exec 3> "${fifo}"
./preproc.sh config.txt  docdef.ms > "${fifo}"
for config in config-*.txt
do
    ./preproc.sh "${config}" docdef-check.ms > "${fifo}"
done
exec 3>&-
# Remove the created temporary directory, if this doesn't succeed the
# operating system should clear this up on next boot.
rm -r "${tempdir}"

