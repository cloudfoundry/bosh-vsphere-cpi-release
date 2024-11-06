#! /usr/bin/env bash

set -e

echo Creating BOSH vSphere CPI release ... 1>&2
bosh create-release \
  --dir bosh-cpi-src \
  --name bosh-vsphere-cpi \
  --tarball "cpi-release/bosh-vsphere-cpi-dev.tgz"
