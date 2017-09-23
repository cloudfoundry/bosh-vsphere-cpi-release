#!/usr/bin/env bash

set -e

source bosh-cpi-src/.envrc
source bosh-cpi-src/ci/utils.sh
source /etc/profile.d/chruby.sh
chruby $PROJECT_RUBY_VERSION

semver=$(cat version-semver/number)

output_dir="dev-artifacts/"

pushd bosh-cpi-src
  echo "building iso9660wrap"
  pushd src/iso9660wrap
    for platform in linux darwin; do
      GOOS=${platform} GOARCH=amd64 CGO_ENABLED=0 go build \
        -o iso9660wrap-${platform}-amd64 ./...
    done
  popd

  echo "running unit tests"
  pushd src/vsphere_cpi
    bundle install
    bundle exec rspec spec/unit
  popd
  cpi_release_name="bosh-vsphere-cpi"

  echo "building CPI release..."
  bosh2 create-release --name $cpi_release_name --version $semver --tarball ${output_dir}/$cpi_release_name-$semver.tgz
popd
