#!/usr/bin/env bash

set -e

: ${bosh_release_name:?must be set}
: ${cpi_release_name:?must be set}
: ${stemcell_name:?must be set}

timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
bosh_release_version=$(cat bosh-release/version)
cpi_release_version=$(cat bosh-cpi-artifacts/version)
stemcell_version=$(cat stemcell/version)

certify-artifacts --release $bosh_release_name/$bosh_release_version \
                  --release $cpi_release_name/$cpi_release_version \
                  --stemcell $stemcell_name/$stemcell_version \
                  > certification-receipt/$timestamp-receipt.json
