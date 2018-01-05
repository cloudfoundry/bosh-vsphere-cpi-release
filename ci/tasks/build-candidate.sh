#!/usr/bin/env bash

set -e

source bosh-cpi-src/.envrc

semver=$(cat version-semver/number)

output_dir="$( realpath dev-artifacts )"

pushd bosh-cpi-src
  ./compile-iso9660wrap.sh

  echo "running unit tests"
  pushd src/vsphere_cpi
    bundle install
    bundle exec rspec spec/unit
  popd
  cpi_release_name="bosh-vsphere-cpi"

  echo "building CPI release..."
  bosh create-release --name $cpi_release_name --version $semver --tarball $output_dir/$cpi_release_name-$semver.tgz
popd
