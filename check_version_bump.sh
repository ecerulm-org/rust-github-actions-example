#!/bin/bash
set -uo pipefail

git fetch || exit 1
VERSION=$(git show origin/main:VERSION.txt)
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "VERSION.txt does not exist in origin/main yet so we skip the test"
    exit 0
fi

pysemver bump patch "${VERSION}" >VERSION.txt || exit 1
exit 0


