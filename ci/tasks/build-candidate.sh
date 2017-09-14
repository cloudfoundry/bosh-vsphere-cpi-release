#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"

source bosh-cpi-src/ci/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.2.6

semver=$(cat ${workspace_dir}/version-semver/number)

output_dir="${workspace_dir}/dev-artifacts/"

pushd bosh-cpi-src
  echo "running unit tests"
  pushd src/vsphere_cpi
    bundle install
    bundle exec rspec spec/unit
  popd
  cpi_release_name="bosh-vsphere-cpi"

  echo "building CPI release..."
  bosh2 create-release --name $cpi_release_name --version $semver --tarball ${output_dir}/$cpi_release_name-$semver.tgz
popd
