#!/bin/bash
set -uo pipefail

git fetch || exit 1
MAIN_VERSION=$(git show origin/main:VERSION.txt)
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "VERSION.txt does not exist in origin/main yet so we skip the test"
    exit 0
fi

set -e
STAGINGAREA_VERSION="$(git show :VERSION.txt)"
COMPARISON=$(pysemver compare "${STAGINGAREA_VERSION}" "${MAIN_VERSION}")

if [ "${COMPARISON}" = "1" ]; then
  # no need to bump the version, the staging area version is already higher than the one in origin/main
  # 1 if the first version is greater than the second version.
  echo "Version ${STAGINGAREA_VERSION} is already higher than the version in origin/main ${MAIN_VERSION}"
  exit 0
fi
pysemver bump patch "${MAIN_VERSION}" >VERSION.txt
cargo release version --execute --no-confirm $(cat VERSION.txt)
echo "Current VERSION.txt is ${STAGINGAREA_VERSION}"
echo "The PR can't be merged if the VERSION.txt (${STAGINGAREA_VERSION}) is not bumped to be higher that origin/main version ${MAIN_VERSION}"
exit 1


