#!/usr/bin/env bash

set -e

: ${DEPLOYMENT_NAME:?}
: ${RELEASE_NAME:?}
: ${STEMCELL_NAME:?}

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


bosh int certification/shared/assets/certification-release/certification.yml \
  -v "deployment_name=${DEPLOYMENT_NAME}" \
  -v "release_name=${RELEASE_NAME}" \
  -v "stemcell_name=${STEMCELL_NAME}" \
  -v "gateway=192.168.111.1" \
  -v "DNS=192.168.111.1" \
  -v network_name="$BOSH_VSPHERE_VLAN" > /tmp/deployment.yml

source director-state/director.env

pushd certification/shared/assets/certification-release
  if [[ -n "${bosh_input}" ]]; then
    export bosh_cli="/usr/local/bin/bosh"
    cp "${bosh_input}" "${bosh_cli}"
    chmod +x "${bosh_cli}"
  fi
  time bosh -n create-release --force --name ${RELEASE_NAME}
  time bosh -n upload-release
popd

time bosh -n upload-stemcell $( realpath stemcell/*.tgz )
time bosh -n deploy -d ${DEPLOYMENT_NAME} /tmp/deployment.yml
