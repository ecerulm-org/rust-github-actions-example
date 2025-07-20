#!/bin/bash
set -uo pipefail


update_cargo_toml_and_lock() {
  # Ensure the version in Cargo.toml and Cargo.lock always matches VERSION.txt
  # cargo release version --execute --no-confirm $(cat VERSION.txt)
  cargo set-version $(cat VERSION.txt)
}

# Get latest version on origin/main
git fetch || exit 1
MAIN_VERSION=$(git show origin/main:VERSION.txt)
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "VERSION.txt does not exist in origin/main yet so we skip the test"
    exit 0
fi

# Get current version in staging area from VERSION.txt
set -e
STAGINGAREA_VERSION="$(git show :VERSION.txt)"

update_cargo_toml_and_lock # Updates Cargo.tml and Cargo.lock

# Compare :VERSION.txt to origin/main:VERSION.txt
COMPARISON=$(pysemver compare "${STAGINGAREA_VERSION}" "${MAIN_VERSION}")
if [ "${COMPARISON}" = "1" ]; then
  # no need to bump the version, the staging area version is already higher than the one in origin/main
  # 1 if the first version is greater than the second version.
  echo "Version ${STAGINGAREA_VERSION} in :VERSION.txt is already higher than the version ${MAIN_VERSION} in origin/main:VERSION.txt"
  exit 0
fi
pysemver bump patch "${MAIN_VERSION}" >VERSION.txt

update_cargo_toml_and_lock # Updates Cargo.tml and Cargo.lock

echo "Current VERSION.txt is ${STAGINGAREA_VERSION}"
echo "The PR can't be merged if the VERSION.txt (${STAGINGAREA_VERSION}) is not bumped to be higher that origin/main version ${MAIN_VERSION}"
exit 1


