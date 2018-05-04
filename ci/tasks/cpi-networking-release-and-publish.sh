#!/usr/bin/env bash


mkdir  bosh-vsphere-cpi-networking-release

pushd bosh-cpi-src
    bosh create-release --tarball bosh-vsphere-cpi-networking-release.tgz --force
popd

mv bosh-cpi-src/bosh-vsphere-cpi-networking-release.tgz bosh-vsphere-cpi-networking-release