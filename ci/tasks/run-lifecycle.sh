#! /bin/bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"

if [ -f /etc/profile.d/chruby.sh ]; then
  source /etc/profile.d/chruby.sh
  chruby 2.2.6
fi

: ${RSPEC_FLAGS:=""}
: ${BOSH_VSPHERE_STEMCELL:=""}

# allow user to pass paths to spec files relative to src/vsphere_cpi
# e.g. ./run-lifecycle.sh spec/integration/core_spec.rb
if [ "$#" -ne 0 ]; then
  RSPEC_ARGS="$@"
fi

if [ -z "${BOSH_VSPHERE_STEMCELL}" ]; then
  stemcell_dir="$( cd ${workspace_dir}/stemcell && pwd )"
  export BOSH_VSPHERE_STEMCELL=${stemcell_dir}/stemcell.tgz
fi

install_mkisofs() {
  pushd "${release_dir}"
    echo "using bosh CLI version..."
    bosh version
    rm -rf ./dev_releases/lifecycle-test
    bosh create release --name lifecycle-test --version 0.0.0 --with-tarball --force
  popd

  echo "Extracting mkisofs from bosh release..."
  iso_tmp_dir="$(mktemp -d /tmp/iso_image.XXXXXXXXXX)"
  pushd "${iso_tmp_dir}"
    tar -xf "${release_dir}/dev_releases/lifecycle-test/lifecycle-test-0.0.0.tgz"
    tar -xf packages/vsphere_cpi_mkisofs.tgz
    chmod +x packaging
    BOSH_INSTALL_TARGET="${iso_tmp_dir}" ./packaging &> mkisofs_compilation.log
    export PATH="${iso_tmp_dir}/bin:$PATH"
  popd
  echo "installed mkisofs at:"
  which mkisofs
}

command -v mkisofs > /dev/null 2>&1 || install_mkisofs

pushd "${release_dir}/src/vsphere_cpi"
  bundle install
  bundle exec rspec ${RSPEC_FLAGS} --require ./spec/support/verbose_formatter.rb --format VerboseFormatter spec/integration
popd
