#!/usr/bin/env bash

source /etc/profile.d/chruby.sh
chruby 2.1.2

export BOSH_INSTALL_TARGET=/usr/local

cd /tmp/cpi-release

# Remove old/sync'd releases
rm -f dev_releases/bosh-vsphere-cpi/*.tgz

# Create a CPI dev release, which we use to install mkisofs packages.
bosh create release --with-tarball

cd packages/vsphere_cpi_mkisofs
tar zxf ../../dev_releases/bosh-vsphere-cpi/*.tgz
tar zxf packages/vsphere_cpi_mkisofs.tgz

# Share the packaging script used by the CPI release.
chmod +x ./packaging
./packaging

rm -rf /tmp/cpi-release
