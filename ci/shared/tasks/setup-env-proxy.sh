#!/usr/bin/env bash

source environment/metadata
export HTTP_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export HTTPS_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"


export BOSH_VSPHERE_CPI_USER='administrator@vsphere.local'

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
sshpass -p 'vcpi' ssh -o StrictHostKeyChecking=no -M -S "$sockpath" -4 -D 5000 -fNC $jumpbox_remote

# Ensure tmpdir and control socket are cleaned up on exit
master_exit() {
  ssh -S "$sockpath" -O exit "$jumpbox_remote" &> /dev/null
  rm -rf "$tmpdir"
}
trap master_exit EXIT

# let CLI know via environment variable
export BOSH_ALL_PROXY=socks5://localhost:5000
