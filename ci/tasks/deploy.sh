#!/usr/bin/env bash

set -e

ensure_not_replace_value() {
  local name=$1
  local value=$(eval echo '$'$name)
  if [ "$value" == 'replace-me' ]; then
    echo "environment variable $name must be set"
    exit 1
  fi
}

ensure_not_replace_value base_os
ensure_not_replace_value network_type_to_test

cpi_release_name=bosh-vsphere-cpi

source /etc/profile.d/chruby-with-ruby-2.1.2.sh

semver=`cat version-semver/number`
manifest_dir=bosh-concourse-ci/pipelines/$cpi_release_name
manifest_filename=$manifest_dir/$base_os-$network_type_to_test-director-manifest.yml
manifest_artifacts=$manifest_dir/tmp

echo "normalizing paths to match values referenced in $manifest_filename"
mkdir $manifest_artifacts
mv ./bosh-cpi-dev-artifacts/$cpi_release_name-$semver.tgz $manifest_artifacts/$cpi_release_name.tgz
mv ./bosh-release/release.tgz $manifest_artifacts/bosh-release.tgz
mv ./stemcell/stemcell.tgz $manifest_artifacts/stemcell.tgz

initver=$(cat bosh-init/version)
initexe="$PWD/bosh-init/bosh-init-${initver}-linux-amd64"
chmod +x $initexe

echo "deleting existing BOSH Director VM..."
$initexe delete $manifest_filename

echo "deploying BOSH..."
$initexe deploy $manifest_filename
