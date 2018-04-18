#!/usr/bin/env bash

set -eu

unambiguous_ds=isc-cl1-ds-1

source environment/metadata
source director-state/director.env

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

bosh -n update-cloud-config bosh-deployment/vsphere/cloud-config.yml \
    -v bosh_release_uri="file://$(echo bosh-release/*.tgz)" \
    -v cpi_release_uri="file://$(echo cpi-release/*.tgz)" \
    -v stemcell_uri="file://$(echo stemcell/*.tgz)" \
    -v director_name=bosh \
    -v internal_cidr=192.168.111.0/24 \
    -v internal_gw=192.168.111.1 \
    -v internal_ip=192.168.111.152 \
    -v reserved_range=192.168.111.2-192.168.111.152 \
    -v network_name="$BOSH_VSPHERE_VLAN" \
    -v vcenter_dc="$BOSH_VSPHERE_CPI_DATACENTER" \
    -v vcenter_ds="$unambiguous_ds" \
    -v vcenter_ip="$BOSH_VSPHERE_CPI_HOST" \
    -v vcenter_user="$BOSH_VSPHERE_CPI_USER" \
    -v vcenter_password="$BOSH_VSPHERE_CPI_PASSWORD" \
    -v vcenter_templates=bosh-stemcell \
    -v vcenter_vms=bosh-vm \
    -v vcenter_disks=bosh-disk \
    -v vcenter_cluster="$BOSH_VSPHERE_CPI_CLUSTER" \
    -v vcenter_rp="$BOSH_VSPHERE_CPI_RESOURCE_POOL" \
    -v dns_recursor_ip="192.168.111.1" \
    -v http_proxy="http://$BOSH_VSPHERE_JUMPER_HOST:80" \
    -v https_proxy="http://$BOSH_VSPHERE_JUMPER_HOST:80" \
    -v no_proxy="localhost,127.0.0.1" \
    -v second_network_name="$BOSH_VSPHERE_VLAN" \
    -v second_internal_cidr=2013:930:0:0:0:0:0:0/64 \
    -v second_internal_gw=2013:930:0:0:0:0:0:1 \
    -v second_internal_ip=2013:930:0:0:0:0:0:98 \
    -v DNS=2013:930:0:0:0:0:0:1 \
    -v reserved_range_ipv6=2013:930:0:0:0:0:0:1-2013:930:0:0:0:0:0:98 \
    $( echo ${OPTIONAL_OPS_FILE} )