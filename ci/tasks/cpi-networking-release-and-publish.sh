#!/usr/bin/env bash


mkdir  bosh-vsphere-cpi-networking-release

install_iso9660wrap() {
  pushd bosh-cpi-src
    pushd src/iso9660wrap
      go build ./...
      export PATH="$PATH:$PWD"
    popd
  popd
}

install_iso9660wrap

pushd bosh-cpi-src
    bosh create-release --tarball bosh-vsphere-cpi-networking-release.tgz --force
popd

mv bosh-cpi-src/bosh-vsphere-cpi-networking-release.tgz bosh-vsphere-cpi-networking-release