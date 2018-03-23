#! /usr/bin/env bash

set -e

pushd bosh-cpi-src > /dev/null
  source .envrc
  ./compile-iso9660wrap.sh
popd > /dev/null

semver=$(cat version-semver/number)

echo Creating BOSH vSphere CPI release ... 1>&2
bosh create-release \
  --dir bosh-cpi-src \
  --name bosh-vsphere-cpi \
  --version "$semver" \
  --tarball "dev-artifacts/bosh-vsphere-cpi-$semver.tgz"
