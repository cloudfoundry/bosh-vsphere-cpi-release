#!/usr/bin/env bash

set -e

source bosh-cpi-release/ci/tasks/utils.sh

check_param base_os
check_param network_type_to_test
check_param BAT_INFRASTRUCTURE
check_param BAT_VCAP_PASSWORD
check_param BAT_STEMCELL
check_param BOSH_SSH_PRIVATE_KEY
check_param BOSH_VSPHERE_NETMASK
check_param BOSH_VSPHERE_GATEWAY
check_param BOSH_VSPHERE_DNS
check_param BOSH_VSPHERE_NTP_SERVER
check_param BOSH_VSPHERE_NET_ID
check_param BOSH_VSPHERE_VCENTER
check_param BOSH_VSPHERE_VCENTER_USER
check_param BOSH_VSPHERE_VCENTER_PASSWORD
check_param BOSH_VSPHERE_VCENTER_DC
check_param BOSH_VSPHERE_VCENTER_CLUSTER
check_param BOSH_VSPHERE_VCENTER_RESOURCE_POOL
check_param BOSH_VSPHERE_VCENTER_DATASTORE_PATTERN
check_param BOSH_VSPHERE_VCENTER_UBOSH_DATASTORE_PATTERN
check_param BAT_NETWORKING
check_param BAT_DIRECTOR
check_param BAT_DNS_HOST
check_param BAT_DEPLOYMENT_SPEC
check_param BOSH_VSPHERE_MICROBOSH_IP
check_param BOSH_VSPHERE_VCENTER_FOLDER_PREFIX

source /etc/profile.d/chruby.sh
chruby 2.1.2

cpi_release_name=bosh-vsphere-cpi

BAT_STEMCELL="${PWD}${BAT_STEMCELL}"
BAT_VCAP_PRIVATE_KEY="${PWD}${BOSH_SSH_PRIVATE_KEY}"
BAT_DEPLOYMENT_SPEC="${PWD}${BAT_DEPLOYMENT_SPEC}"

#vsphere uses user/pass and the cdrom drive, not a reverse ssh tunnel
eval $(ssh-agent)
chmod go-r $BAT_VCAP_PRIVATE_KEY
ssh-add $BAT_VCAP_PRIVATE_KEY

echo "using bosh CLI version..."
bosh version

bosh -n target $BAT_DIRECTOR

sed -i.bak s/"uuid: replace-me"/"uuid: $(bosh status --uuid)"/ $BAT_DEPLOYMENT_SPEC

cd bats
bundle install
bundle exec rspec spec

#kill the SSH agent we started earlier
ssh-agent -k
