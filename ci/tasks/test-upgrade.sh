#!/usr/bin/env bash

set -e

: ${DEPLOYMENT_NAME:?}

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

# let CLI know via environment variable
export BOSH_ALL_PROXY=socks5://localhost:5000

# outputs
output_dir=$(realpath new-director-state/)

cp -r new-director-config/director.yml ${output_dir}
cp -r old-director-state/*-state.json ${output_dir}
cp old-director-state/creds.yml ${output_dir}
cp old-director-state/director.env ${output_dir}
source old-director-state/director.env

# deployment manifest references releases and stemcells relative to itself...make it true
# these resources are also used in the teardown step
mkdir -p ${output_dir}/{stemcell,bosh-release,cpi-release}
cp stemcell/*.tgz ${output_dir}/stemcell/
cp bosh-release/*.tgz ${output_dir}/bosh-release/
cp cpi-release/*.tgz ${output_dir}/cpi-release/

function finish {
  echo "Final state of director deployment:"
  echo "=========================================="
  cat "${output_dir}/director-state.json"
  echo "=========================================="

  cp -r $HOME/.bosh ${output_dir}
  master_exit
}
trap finish EXIT

bosh_input="$(realpath bosh-cli/*bosh-cli-* 2>/dev/null || true)"


echo "upgrading existing BOSH Director VM..."
pushd ${output_dir} > /dev/null
  if [[ -n "${bosh_input}" ]]; then
    export bosh_cli="/usr/local/bin/bosh"
    cp "${bosh_input}" "${bosh_cli}"
    chmod +x "${bosh_cli}"
  fi
  time bosh create-env --state "${output_dir}/director-state.json" \
    --vars-store "${output_dir}/creds.yml" -v director_name=bosh \
    director.yml
popd > /dev/null

echo "recreating existing BOSH Deployment..."
time bosh -n -d ${DEPLOYMENT_NAME} recreate