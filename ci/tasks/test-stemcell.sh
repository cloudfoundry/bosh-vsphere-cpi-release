#!/usr/bin/env bash

set -e

: ${BOSH_os_name:?}
: ${package:?}

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


source director-state/director.env
export BOSH_BINARY_PATH=$(which bosh)
export SYSLOG_RELEASE_PATH=$(realpath syslog-release/*.tgz)
export OS_CONF_RELEASE_PATH=$(realpath os-conf-release/*.tgz)
export STEMCELL_PATH=$(realpath stemcell/*.tgz)
export BOSH_stemcell_version=\"$(realpath stemcell/version | xargs -n 1 cat)\"

ssh_key_path=/tmp/bat_private_key
echo "$BAT_PRIVATE_KEY" > $ssh_key_path
chmod 600 $ssh_key_path
export BOSH_GW_PRIVATE_KEY=$ssh_key_path

pushd bosh-linux-stemcell-builder
  export PATH=/usr/local/go/bin:$PATH
  export GOPATH=$(pwd)

  if [[ -n "${bosh_input}" ]]; then
    export bosh_cli="/usr/local/bin/bosh"
    cp "${bosh_input}" "${bosh_cli}"
    chmod +x "${bosh_cli}"
  fi

  pushd src/github.com/cloudfoundry/stemcell-acceptance-tests
    ./bin/test-smoke $package
  popd
popd