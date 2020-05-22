#!/usr/bin/env bash

set -e

: ${STEMCELL_NAME:?}
: ${BAT_RSPEC_FLAGS:?}
: ${BAT_INFRASTRUCTURE:?}
: ${BAT_NETWORKING:?}
: ${NETWORK_STATIC_IP_2:NETWORK_STATIC_IP_2}
: ${NETWORK_STATIC_IP_1:NETWORK_STATIC_IP_1}
: ${NETWORK_VCENTER_CIDR:NETWORK_VCENTER_CIDR}
: ${NETWORK_STATIC_RANGE:NETWORK_STATIC_RANGE}
: ${NETWORK_RESERVED_RANGE:NETWORK_STATIC_RANGE}
: ${NETWORK_VCENTER_GATEWAY:NETWORK_VCENTER_GATEWAY}
: ${NETWORK_VCENTER_LAN:NETWORK_VCENTER_LAN}
: ${NETWORK_STATIC_IP_1?NETWORK_STATIC_IP_1}
: ${NETWORK_VCENTERCIDR:NETWORK_VCENTERCIDR}
: ${NETWORK2_STATIC_RANGE:NETWORK2_STATIC_RANGE}
: ${NETWORK2_RESERVED_RANGE:NETWORK2_RESERVED_RANGE}
: ${NETWORK2_VCENTER_GATEWAY:NETWORK2_VCENTER_GATEWAY}
: ${NETWORK2_VCENTER_VLAN:NETWORK2_VCENTER_VLAN}


source source-ci/ci/shared/tasks/setup-env-proxy.sh

mkdir -p bats-config

bosh int source-ci/ci/shared/bats-spec.yml \
  -v "stemcell_name=${STEMCELL_NAME}" \
  -v network1-staticIP-2=192.168.111.156 \
  -v network1-staticIP-1=192.168.111.157 \
  -v network1-vCenterCIDR=192.168.111.0/24 \
  -v network1-staticRange=[192.168.111.156-192.168.111.163] \
  -v network1-reservedRange="['192.168.111.0-192.168.111.155' , '192.168.111.164-192.168.111.174']" \
  -v network1-vCenterGateway=192.168.111.1 \
  -v network1-vCenterVLAN="VM Network" \
  -v network2-staticIP-1=192.168.111.164 \
  -v network2-vCenterCIDR=192.168.111.0/24 \
  -v network2-staticRange=[192.168.111.164-192.168.111.174] \
  -v network2-reservedRange="['192.168.111.0-192.168.111.163']" \
  -v network2-vCenterGateway=192.168.111.1 \
  -v network2-vCenterVLAN="VM Network" > bats-config/bats-config.yml

source director-state/director.env
export BAT_PRIVATE_KEY="$(bosh int director-state/creds.yml --path=/jumpbox_ssh/private_key)"
export BAT_DNS_HOST="${BOSH_ENVIRONMENT}"
export BAT_STEMCELL=$(realpath stemcell/*.tgz)
export BAT_DEPLOYMENT_SPEC=$(realpath bats-config/bats-config.yml)
export BAT_BOSH_CLI=$(which bosh)

ssh_key_path=/tmp/bat_private_key
echo "$BAT_PRIVATE_KEY" > $ssh_key_path
chmod 600 $ssh_key_path
export BOSH_GW_PRIVATE_KEY=$ssh_key_path

bosh_input="$(realpath bosh-cli/*bosh-cli-* 2>/dev/null || true)"

pushd bats
  bundle install
  if [[ -n "${bosh_input}" ]]; then
    export bosh_cli="/usr/local/bin/bosh"
    cp "${bosh_input}" "${bosh_cli}"
    chmod +x "${bosh_cli}"
  fi
  bundle exec rspec spec $BAT_RSPEC_FLAGS
popd
