#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"
stemcell_dir="$( cd ${workspace_dir}/stemcell && pwd )"

source ${release_dir}/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

check_param BOSH_VSPHERE_VERSION
check_param BOSH_VSPHERE_CPI_HOST
check_param BOSH_VSPHERE_CPI_USER
check_param BOSH_VSPHERE_CPI_PASSWORD
check_param BOSH_VSPHERE_VLAN
check_param BOSH_VSPHERE_CPI_DATACENTER
check_param BOSH_VSPHERE_CPI_CLUSTER
check_param BOSH_VSPHERE_CPI_DATASTORE_PATTERN
check_param BOSH_VSPHERE_CPI_PERSISTENT_DATASTORE_PATTERN
check_param BOSH_VSPHERE_CPI_SECOND_DATASTORE
check_param BOSH_VSPHERE_CPI_LOCAL_DATASTORE_PATTERN
check_param BOSH_VSPHERE_CPI_RESOURCE_POOL
check_param BOSH_VSPHERE_CPI_SECOND_RESOURCE_POOL
check_param BOSH_VSPHERE_CPI_SECOND_CLUSTER
check_param BOSH_VSPHERE_CPI_SECOND_CLUSTER_DATASTORE
check_param BOSH_VSPHERE_CPI_SECOND_CLUSTER_RESOURCE_POOL
check_param BOSH_VSPHERE_CPI_VM_FOLDER
check_param BOSH_VSPHERE_CPI_TEMPLATE_FOLDER
check_param BOSH_VSPHERE_CPI_DISK_PATH
check_param BOSH_VSPHERE_CPI_NESTED_DATACENTER
check_param BOSH_VSPHERE_CPI_NESTED_DATACENTER_DATASTORE_PATTERN
check_param BOSH_VSPHERE_CPI_NESTED_DATACENTER_CLUSTER
check_param BOSH_VSPHERE_CPI_NESTED_DATACENTER_RESOURCE_POOL
check_param BOSH_VSPHERE_CPI_NESTED_DATACENTER_VLAN

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
  bundle exec rspec spec/integration
popd
