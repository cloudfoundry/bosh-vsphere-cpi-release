#!/usr/bin/env bash

set -x -e

source bosh-cpi-release/ci/tasks/utils.sh

check_param BOSH_VSPHERE_VCENTER
check_param BOSH_VSPHERE_VCENTER_USER
check_param BOSH_VSPHERE_VCENTER_PASSWORD
check_param BOSH_VSPHERE_VERSION

source /etc/profile.d/chruby.sh
chruby 2.1.2

pushd bosh-cpi-release/src/vsphere_cpi
  bundle install
  bundle exec rspec spec/integration/bats_env_spec.rb
popd
