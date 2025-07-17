#!/bin/bash
set -uo pipefail

git show origin/main:VERSION.txt >/dev/null
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "VERSION.txt does not exist in origin/main yet so we skip the test"
    exit 0
fi


exit 1
