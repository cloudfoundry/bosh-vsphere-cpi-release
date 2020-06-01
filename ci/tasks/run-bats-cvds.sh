#!/usr/bin/env bash

set -e

: ${STEMCELL_NAME:?}
: ${BAT_RSPEC_FLAGS:?}
: ${BAT_INFRASTRUCTURE:?}
: ${BAT_NETWORKING:?}

source source-ci/ci/shared/tasks/setup-env-proxy.sh

mkdir -p bats-config

bosh int source-ci/ci/shared/bats-spec.yml \
  -v "stemcell_name=${STEMCELL_NAME}" \
  -v network1-staticIP-2='30.0.0.7' \
  -v network1-staticIP-1='30.0.0.6' \
  -v network1-vCenterCIDR='30.0.0.0/24' \
  -v network1-staticRange="['30.0.0.6-30.0.0.16']" \
  -v network1-reservedRange="['30.0.0.0-30.0.0.5','30.0.0.164-30.0.0.255']" \
  -v network1-vCenterGateway='30.0.0.1' \
  -v network1-vCenterVLAN="nsxt-switch1" \
  -v network2-staticIP-1='30.0.0.164' \
  -v network2-vCenterCIDR='30.0.0.0/24' \
  -v network2-staticRange="['30.0.0.164-30.0.0.174']" \
  -v network2-reservedRange="['30.0.0.0-30.0.0.163']" \
  -v network2-vCenterGateway='30.0.0.1' \
  -v network2-vCenterVLAN="nsxt-switch1" > bats-config/bats-config.yml

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
