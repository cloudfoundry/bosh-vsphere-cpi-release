#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"
stemcell_dir="$( cd ${workspace_dir}/stemcell && pwd )"

source /etc/profile.d/chruby.sh
chruby 2.1.2

# required
: ${BOSH_VSPHERE_VERSION:?}
: ${BOSH_VSPHERE_CPI_HOST:?}
: ${BOSH_VSPHERE_CPI_USER:?}
: ${BOSH_VSPHERE_CPI_PASSWORD:?}
: ${BOSH_VSPHERE_VLAN:?}
: ${BOSH_VSPHERE_CPI_DATACENTER:?}
: ${BOSH_VSPHERE_CPI_CLUSTER:?}
: ${BOSH_VSPHERE_CPI_DATASTORE_PATTERN:?}
: ${BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN:?}
: ${BOSH_VSPHERE_CPI_SECOND_DATASTORE:?}
: ${BOSH_VSPHERE_CPI_RESOURCE_POOL:?}
: ${BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL:?}
: ${BOSH_VSPHERE_CPI_SECOND_CLUSTER:?}
: ${BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE:?}
: ${BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL:?}
: ${BOSH_VSPHERE_CPI_VM_FOLDER:?}
: ${BOSH_VSPHERE_CPI_TEMPLATE_FOLDER:?}
: ${BOSH_VSPHERE_CPI_DISK_PATH:?}
: ${BOSH_VSPHERE_CPI_NESTED_DATACENTER:?}
: ${BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN:?}
: ${BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER:?}
: ${BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL:?}
: ${BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN:?}

# optional
: ${BOSH_VSPHERE_CPI_SINGLE_LOCAL_DATASTORE_PATTERN:=""}
: ${BOSH_VSPHERE_CPI_MULTI_LOCAL_DATASTORE_PATTERN:=""}
: ${RSPEC_FLAGS:=""}


pushd "${release_dir}"
  echo "using bosh CLI version..."
  bosh version
  bosh create release --name local --version 0.0.0 --with-tarball --force
popd

iso_tmp_dir="$(mktemp -d /tmp/iso_image.XXXXXXXXXX)"
pushd "${iso_tmp_dir}"
  tar -xf ${release_dir}/dev_releases/local/local-0.0.0.tgz
  tar -xf packages/vsphere_cpi_mkisofs.tgz
  chmod +x packaging
  BOSH_INSTALL_TARGET=${iso_tmp_dir} ./packaging &> mkisofs_compilation.log
  export PATH=${iso_tmp_dir}/bin:$PATH
popd
echo "installed mkisofs at:"
which mkisofs

export BOSH_VSPHERE_STEMCELL=${stemcell_dir}/stemcell.tgz
export BOSH_VSPHERE_VCENTER=${BOSH_VSPHERE_CPI_HOST}
export BOSH_VSPHERE_VCENTER_USER=${BOSH_VSPHERE_CPI_USER}
export BOSH_VSPHERE_VCENTER_PASSWORD=${BOSH_VSPHERE_CPI_PASSWORD}

pushd "${release_dir}/src/vsphere_cpi"
  bundle install
  bundle exec rspec spec/integration ${RSPEC_FLAGS}
popd
