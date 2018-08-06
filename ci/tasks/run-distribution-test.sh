#!/usr/bin/env bash

set -e

# Setup connection on proxy
source source-ci/ci/shared/tasks/setup-env-proxy.sh

# Setup bosh director connection environment and aliases
source director-state/director.env
export BOSH_PRIVATE_KEY="$(bosh int director-state/creds.yml --path=/jumpbox_ssh/private_key)"
export BOSH_STEMCELL=$(realpath stemcell/*.tgz)

ssh_key_path=/tmp/bat_private_key
echo "$BOSH_PRIVATE_KEY" > $ssh_key_path
chmod 600 $ssh_key_path
export BOSH_GW_PRIVATE_KEY=$ssh_key_path

# Deploy zookeeper release
bosh -n ucc source-ci/ci/shared/distribution-test-cloud-config.yml
bosh -n upload-stemcell $BOSH_STEMCELL
bosh -n -d zookeeper deploy source-ci/ci/shared/distribution-test-deployment-manifest.yml

# Filter out the vm names
bosh vms | grep 'vm-' | awk '{print $5}' > tmp_out.out

pushd bosh-cpi-src/src/vsphere_cpi
  bosh vms | grep 'vm-' | awk '{print $5}' > tmp_out.out
  bundle install
  bundle exec ruby ../../../source-ci/ci/shared/scripts/vm_stats.rb tmp_out.out
  rm tmp_out.out
popd

# Delete the deployment
bosh -n delete-deployment -d zookeeper