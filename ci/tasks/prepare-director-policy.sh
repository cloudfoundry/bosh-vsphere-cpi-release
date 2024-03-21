#!/usr/bin/env bash

set -e

# A regular expression matching the names of potential datastores the director
# will use for storing VMs and associated persistent disks. Note that the name
# of each datastore matched by this regular expression must correspond to a
# unique managed object across the entire vCenter (it is not sufficient for the
# datastore name to be unique across a single datacenter). Otherwise this error
# occurs during the create-env:
#   Found more than one VimSdk::Vim::Datastore: name: "isc-cl1-ds-0"
# For example in vcpi-nimbus the nfs-server serving the nfs0-1 datastore is
# attached to all hosts including those in the nested datacenter
# vcpi-dc-nested. Because managed objects are scoped to a single datacenter the
# managed object representing the nfs0-1 datastore inside *vcpi-dc* is distinct
# from the managed object representing the nfs0-1 datastore inside
# *vcpi-dc-nested*. In this case a regular expression matching nfs0-1 will
# resolve to both managed objects thus causing the aforementioned error.
unambiguous_ds=nfs0-1

source environment/metadata

# Hack for old CPI versions which do not support restricted permissions users
current_cpi_version=$(cat cpi-release/version)
new_user_cpi_version=51

if [ $current_cpi_version -lt $new_user_cpi_version ]; then
  export BOSH_VSPHERE_CPI_USER='administrator@vsphere.local'
  echo "Setting vSphere user to administrator for old CPI version (<45)" 1>&2
fi

# To get the cert from nsxt-manager, we run openssl on the jump box, and then pipe that result into a local openssl command that reformats it into PEM
sshpass -p $BOSH_VSPHERE_JUMPER_PASSWORD ssh -o StrictHostKeyChecking=no "vcpi@${BOSH_VSPHERE_JUMPER_HOST}" -C "openssl s_client -showcerts -connect $BOSH_VSPHERE_CPI_NSXT_HOST:443 </dev/null 2>/dev/null" | openssl x509 -outform PEM > nsxt-manager-cert.pem

# Bosh is give internal ip of 192.168.111.152
# This is because on Nimbus
# The IP range 192.168.111.151 ~ 192.168.111.254 has been reserved for static IP.
# Nimbus never uses DHCP to assign these IPs to any of the testbed component.
bosh int \
  -o bosh-deployment/vsphere/cpi.yml \
  -o bosh-deployment/jumpbox-user.yml \
  -o source-ci/ci/shared/ops/proxy.yml \
  -o source-ci/ci/shared/ops/ntp.yml \
  -o source-ci/ci/shared/ops/use_nsxt_policy_api.yml \
  $OPTIONAL_OPS_FILE \
  -o certification/shared/assets/ops/custom-releases.yml \
  -o certification/vsphere/assets/ops/custom-cpi-release.yml \
  -v bosh_release_uri="file://$(echo bosh-release/*.tgz)" \
  -v cpi_release_uri="file://$(echo cpi-release/*.tgz)" \
  -v stemcell_uri="file://$(echo stemcell/*.tgz)" \
  -v director_name=bosh \
  -v internal_cidr=30.0.0.0/16 \
  -v internal_gw=30.0.0.1 \
  -v internal_ip=30.0.1.1 \
  -v reserved_range=30.0.0.0-30.0.1.0 \
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
  -v http_proxy="http://$BOSH_VSPHERE_JUMPER_HOST:80" \
  -v https_proxy="http://$BOSH_VSPHERE_JUMPER_HOST:80" \
  -v no_proxy="localhost,127.0.0.1,30.0.1.1" \
  -v second_network_name="$BOSH_VSPHERE_VLAN" \
  -v second_internal_cidr=2013:930:0:0:0:0:0:0/64 \
  -v second_internal_gw=2013:930:0:0:0:0:0:1 \
  -v second_internal_ip=2013:930:0:0:0:0:0:98 \
  -v DNS=2013:930:0:0:0:0:0:1 \
  -v reserved_range_ipv6=2013:930:0:0:0:0:0:1-2013:930:0:0:0:0:0:98 \
  -v nsxt_host="$BOSH_VSPHERE_CPI_NSXT_HOST" \
  -v nsxt_username="$BOSH_VSPHERE_CPI_NSXT_USERNAME" \
  -v nsxt_password="$BOSH_VSPHERE_CPI_NSXT_PASSWORD" \
  -v nsxt_segment="$BOSH_VSPHERE_CPI_NSXT_SEGMENT" \
  -v nsxt_second_segment="$BOSH_VSPHERE_CPI_NSXT_SEGMENT" \
  --var-file=nsxt_ca_cert=nsxt-manager-cert.pem \
  -v nsxt_group="$BOSH_VSPHERE_CPI_NSXT_GROUP" \
  bosh-deployment/bosh.yml > director-config/director.yml