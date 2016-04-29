#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"

source /etc/profile.d/chruby.sh
chruby 2.1.2

semver=$(cat ${workspace_dir}/version-semver/number)

output_dir="${workspace_dir}/dev-artifacts/"

pushd "${release_dir}"
  echo "running unit tests"
  pushd src/vsphere_cpi
    bundle install
    bundle exec rspec spec/unit
  popd

  echo "installing the latest bosh_cli"
  gem install bosh_cli --no-ri --no-rdoc

  echo "using bosh CLI version..."
  bosh version

  cpi_release_name="bosh-vsphere-cpi"

  echo "building CPI release..."
  bosh create release --name $cpi_release_name --version $semver --with-tarball

  mv dev_releases/$cpi_release_name/$cpi_release_name-$semver.tgz ${output_dir}
popd
