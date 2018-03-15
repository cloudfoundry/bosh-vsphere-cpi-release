#!/usr/bin/env bash

set -e

: ${STEMCELL_NAME:?}
: ${BAT_RSPEC_FLAGS:?}
: ${BAT_INFRASTRUCTURE:?}
: ${BAT_NETWORKING:?}


source environment/metadata
export HTTP_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export HTTPS_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"

# Be compatible with both BSD and GNU mktemp
tmpdir="$(mktemp -dt master 2> /dev/null || mktemp -dt master.XXXX)"

jumpbox_remote="vcpi@$BOSH_VSPHERE_JUMPER_HOST"
sockpath="$tmpdir/master.sock"

# set a tunnel
# -D : local SOCKS port
# -f : forks the process in the background
# -C : compresses data before sending
# -N : tells SSH that no command will be sent once the tunnel is up
# -4 : force SSH to use IPv4 to avoid the dreaded `bind: Cannot assign requested address` error
sshpass -p 'vcpi' ssh -o StrictHostKeyChecking=no -M -S $sockpath -4 -D 5000 -fNC $jumpbox_remote

# Ensure tmpdir and control socket are cleaned up on exit
master_exit() {
  ssh -S "$sockpath" -O exit "$jumpbox_remote"s &> /dev/null
  rm -rf "$tmpdir"
}
trap master_exit EXIT


# let CLI know via environment variable
export BOSH_ALL_PROXY=socks5://localhost:5000

mkdir -p bats-config

bosh int source-ci/ci/bats-spec.yml \
  -v "stemcell_name=${STEMCELL_NAME}" \
  -v network1-staticIP-2=192.168.111.154 \
  -v network1-staticIP-1=192.168.111.153 \
  -v network1-vCenterCIDR=192.168.111.0/24 \
  -v network1-staticRange=[192.168.111.153-192.168.111.163] \
  -v network1-reservedRange="['192.168.111.0-192.168.111.152' , '192.168.111.164-192.168.111.174']" \
  -v network1-vCenterGateway=192.168.111.1 \
  -v network1-vCenterVLAN="VM Network" \
  -v network2-staticIP-1=192.168.111.164 \
  -v network2-vCenterCIDR=192.168.111.0/24 \
  -v network2-staticRange=[192.168.111.164-192.168.111.174] \
  -v network2-reservedRange="['192.168.111.0-192.168.111.152' , '192.168.111.153-192.168.111.163']" \
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
