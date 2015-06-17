#!/usr/bin/env bash

set -e

source bosh-cpi-release/ci/tasks/utils.sh

check_param base_os
check_param network_type_to_test

cpi_release_name=bosh-vsphere-cpi

manifest_dir=bosh-concourse-ci/pipelines/$cpi_release_name

echo "checking in BOSH deployment state"
cd deploy/$manifest_dir
git add $base_os-$network_type_to_test-director-manifest-state.json
git config --global user.email "cf-bosh-eng+bosh-ci@pivotal.io"
git config --global user.name "bosh-ci"
git commit -m ":airplane: Concourse auto-updating deployment state for bats pipeline, on $base_os/$network_type_to_test"
