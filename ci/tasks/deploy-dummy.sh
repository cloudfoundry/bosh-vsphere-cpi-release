#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"

source ${release_dir}/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

check_param director_password
check_param director_username
check_param stemcell_name
check_param delete_deployment_when_done
check_param BOSH_VSPHERE_VCENTER_VLAN

cpi_release_name="bosh-vsphere-cpi"

env_name=$(cat ${workspace_dir}/vsphere-5.1-environment/name)
metadata=$(cat ${workspace_dir}/vsphere-5.1-environment/metadata)
network1=$(env_attr "${metadata}" "network1")
echo Using environment: \'${env_name}\'
export DIRECTOR_IP=$(                  env_attr "${metadata}" "directorIP")
export BOSH_VSPHERE_VCENTER_CIDR=$(    env_attr "${network1}" "vCenterCIDR")
export BOSH_VSPHERE_VCENTER_GATEWAY=$( env_attr "${network1}" "vCenterGateway")
export BOSH_VSPHERE_DNS=$(             env_attr "${metadata}" "DNS")
export STATIC_IP=$(                    env_attr "${network1}" "staticIP-1")
export RESERVED_RANGE=$(               env_attr "${network1}" "reservedRange")
export STATIC_RANGE=$(                 env_attr "${network1}" "staticRange")

bosh -n target ${DIRECTOR_IP}
bosh login ${director_username} ${director_password}

cat > dummy-manifest.yml <<EOF
---
name: dummy
director_uuid: $(bosh status --uuid)

releases:
  - name: dummy
    version: latest

compilation:
  reuse_compilation_vms: true
  workers: 1
  network: private
  cloud_properties:
    cpu: 2
    ram: 1024
    disk: 10240

update:
  canaries: 1
  canary_watch_time: 30000-240000
  update_watch_time: 30000-600000
  max_in_flight: 3

resource_pools:
  - name: default
    stemcell:
      name: ${stemcell_name}
      version: latest
    network: private
    cloud_properties:
      cpu: 2
      ram: 1024
      disk: 10240

networks:
  - name: private
    type: manual
    subnets:
      - range: ${BOSH_VSPHERE_VCENTER_CIDR}
        gateway: ${BOSH_VSPHERE_VCENTER_GATEWAY}
        dns: [${BOSH_VSPHERE_DNS}]
        cloud_properties: {name: ${BOSH_VSPHERE_VCENTER_VLAN}}
        reserved: [${RESERVED_RANGE}]
        static: [${STATIC_RANGE}]

jobs:
  - name: dummy
    template: dummy
    instances: 1
    resource_pool: default
    networks:
      - name: private
        default: [dns, gateway]
        static_ips: [${STATIC_IP}]
EOF

git clone https://github.com/pivotal-cf-experimental/dummy-boshrelease.git

pushd dummy-boshrelease
  bosh -n create release --force
  bosh -n upload release --skip-if-exists
popd

bosh -n upload stemcell stemcell/stemcell.tgz --skip-if-exists

bosh -d dummy-manifest.yml -n deploy

if [ "${delete_deployment_when_done}" = "true" ]; then
  bosh -n delete deployment dummy
fi

bosh -n cleanup --all
