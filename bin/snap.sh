#!/bin/zsh

set -eu -o pipefail

SCEXEC=/usr/sbin/screencapture
DEST=${HOME}/Downloads/ScreenCaptures
# Seconds offset
OFFSET=1607446328


function rand() {
	 random=$(head -c2 /dev/urandom | base64 | head -c 1 | tr '+/' '-_')
	 printf $random
}

function epochms() {
	set +u
	milliseconds=$(($(date +'%s')-${OFFSET}))
	set -u

	printf $milliseconds
}

mkdir -p ${DEST}

TAG=${1:-screenshot}
FILE=${DEST}/$(date +"%F")-${TAG}-$(epochms)$(rand).png

echo $FILE

$SCEXEC -i ${FILE}

open "${DEST}"


