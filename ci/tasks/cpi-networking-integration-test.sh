#!/usr/bin/env bash

set -ex

source bosh-cpi-src/.envrc

source source-ci/ci/shared/tasks/setup-env-proxy.sh

install_iso9660wrap() {
  pushd cpi-networking
    pushd src/iso9660wrap
      go build ./...
      export PATH="$PATH:$PWD"
    popd
  popd
}

install_iso9660wrap

echo  "CHECK THAT FOLLOWING ENV VARIABLES ARE CORRECT:"
echo "BOSH_VSPHERE_EDGE_CLUSTER_ID=${BOSH_VSPHERE_EDGE_CLUSTER_ID}"
echo "BOSH_VSPHERE_T0_ROUTER_ID=${BOSH_VSPHERE_T0_ROUTER_ID}"
echo "BOSH_VSPHERE_TRANSPORT_ZONE_ID=${BOSH_VSPHERE_TRANSPORT_ZONE_ID}"
sleep 10

pushd source-ci/src/vsphere_cpi
  bundle install
  bundle exec rspec spec/integration/ --tag ~nsx_vsphere --tag ~disk_migration --exclude-pattern "**/host_maintenance_mode_spec.rb"
popd