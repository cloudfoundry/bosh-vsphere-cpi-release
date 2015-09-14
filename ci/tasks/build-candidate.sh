#!/usr/bin/env bash

set -e

source bosh-cpi-release/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

semver=`cat version-semver/number`

mkdir out

cd bosh-cpi-release

echo "running unit tests"
pushd src/vsphere_cpi
  bundle install
  bundle exec rspec spec/unit/*
popd

echo "installing the latest bosh_cli"
gem install bosh_cli --no-ri --no-rdoc

echo "using bosh CLI version..."
bosh version

cpi_release_name="bosh-vsphere-cpi"

echo "building CPI release..."
bosh create release --name $cpi_release_name --version $semver --with-tarball

mv dev_releases/$cpi_release_name/$cpi_release_name-$semver.tgz ../out/
