#!/usr/bin/env bash

set -e

source bosh-cpi-release/ci/tasks/utils.sh

check_param base_os
check_param network_type_to_test
check_param BAT_STEMCELL_NAME
check_param BAT_VLAN
check_param BAT_VCAP_PASSWORD
check_param BAT_SECOND_NETWORK_VLAN

metadata=$(cat vsphere-5.1-environment/metadata)
network1=$(env_attr "${metadata}" "network1")
network2=$(env_attr "${metadata}" "network2")
export BAT_DIRECTOR=$(                      env_attr "${metadata}" "directorIP")
export BAT_DNS_HOST=$(                      env_attr "${metadata}" "directorIP")
export BAT_STATIC_IP=$(                     env_attr "${network1}" "staticIP-1")
export BAT_SECOND_STATIC_IP=$(              env_attr "${network1}" "staticIP-2")
export BAT_CIDR=$(                          env_attr "${network1}" "vCenterCIDR")
export BAT_RESERVED_RANGE=$(                env_attr "${network1}" "reservedRange")
export BAT_STATIC_RANGE=$(                  env_attr "${network1}" "staticRange")
export BAT_GATEWAY=$(                       env_attr "${network1}" "vCenterGateway")
export BAT_SECOND_NETWORK_STATIC_IP=$(      env_attr "${network2}" "staticIP-1")
export BAT_SECOND_NETWORK_CIDR=$(           env_attr "${network2}" "vCenterCIDR")
export BAT_SECOND_NETWORK_RESERVED_RANGE=$( env_attr "${network2}" "reservedRange")
export BAT_SECOND_NETWORK_STATIC_RANGE=$(   env_attr "${network2}" "staticRange")
export BAT_SECOND_NETWORK_GATEWAY=$(        env_attr "${network2}" "vCenterGateway")

source /etc/profile.d/chruby.sh
chruby 2.1.2

working_dir=$PWD

cpi_release_name=bosh-vsphere-cpi
bosh_ssh_key="$working_dir/keys/bats.pem"
export BAT_STEMCELL="$working_dir/stemcell/stemcell.tgz"
export BAT_DEPLOYMENT_SPEC="$working_dir/${base_os}-${network_type_to_test}-bats-config.yml"
export BAT_INFRASTRUCTURE=vsphere
export BAT_NETWORKING=$network_type_to_test

# vsphere uses user/pass and the cdrom drive, not a reverse ssh tunnel
# the SSH key is required for the` bosh ssh` command to work properly
mkdir -p $PWD/keys
eval $(ssh-agent)
ssh-keygen -N "" -t rsa -b 4096 -f $bosh_ssh_key
chmod go-r $bosh_ssh_key
ssh-add $bosh_ssh_key

echo "using bosh CLI version..."
bosh version

bosh -n target $BAT_DIRECTOR

BOSH_UUID=`bosh status --uuid`

# disable host key checking for deployed VMs
mkdir -p $HOME/.ssh

cat > $HOME/.ssh/config << EOF
Host ${BAT_STATIC_IP}
    StrictHostKeyChecking no
Host ${BAT_SECOND_STATIC_IP}
    StrictHostKeyChecking no
EOF


cat > "${BAT_DEPLOYMENT_SPEC}" <<EOF
---
cpi: vsphere
properties:
  uuid: ${BOSH_UUID}
  pool_size: 1
  instances: 1
  second_static_ip: ${BAT_SECOND_STATIC_IP}
  stemcell:
    name: ${BAT_STEMCELL_NAME}
    version: latest
  networks:
    - name: static
      type: manual
      static_ip: ${BAT_STATIC_IP}
      cidr: ${BAT_CIDR}
      reserved: [${BAT_RESERVED_RANGE}]
      static: [${BAT_STATIC_RANGE}]
      gateway: ${BAT_GATEWAY}
      vlan: ${BAT_VLAN}
    - name: second
      type: manual
      static_ip: ${BAT_SECOND_NETWORK_STATIC_IP}
      cidr: ${BAT_SECOND_NETWORK_CIDR}
      reserved: [${BAT_SECOND_NETWORK_RESERVED_RANGE}]
      static: [${BAT_SECOND_NETWORK_STATIC_RANGE}]
      gateway: ${BAT_SECOND_NETWORK_GATEWAY}
      vlan: ${BAT_SECOND_NETWORK_VLAN}
EOF

cd bats
./write_gemfile

echo "verifying no BOSH deployed VM exists at target IP: $BAT_STATIC_IP"
check_for_rogue_vm $BAT_STATIC_IP

echo "verifying no BOSH deployed VM exists at target IP: $BAT_SECOND_STATIC_IP"
check_for_rogue_vm $BAT_SECOND_STATIC_IP

bundle install
bundle exec rspec spec

#kill the SSH agent we started earlier
ssh-agent -k
