#!/usr/bin/env bash

set -e

source bosh-cpi-src/.envrc

source source-ci/ci/shared/tasks/setup-env-proxy.sh

install_iso9660wrap() {
  pushd bosh-cpi-src
    pushd src/iso9660wrap
      go build ./...
      export PATH="$PATH:$PWD"
    popd
  popd
}

install_iso9660wrap

stemcell_dir="$( cd stemcell && pwd )"
export BOSH_VSPHERE_STEMCELL=${stemcell_dir}/stemcell.tgz
export NSXT_SKIP_SSL_VERIFY=true

pushd bosh-cpi-src/src/vsphere_cpi
  bundle install
  bundle exec rspec spec/integration/ --tag ~nsx_vsphere --tag ~disk_migration --tag ~host_maintenance
popd