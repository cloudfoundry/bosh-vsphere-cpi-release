#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"
deployment_dir="$( cd ${workspace_dir}/old-deployment && pwd )"

source bosh-cpi-src/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

check_param BOSH_VSPHERE_VCENTER
check_param BOSH_VSPHERE_VCENTER_USER
check_param BOSH_VSPHERE_VCENTER_PASSWORD
check_param BOSH_VSPHERE_VERSION
check_param BOSH_VSPHERE_VCENTER_DC
check_param BOSH_VSPHERE_VCENTER_CLUSTER
check_param BOSH_VSPHERE_VCENTER_VM_FOLDER
check_param BOSH_VSPHERE_VCENTER_TEMPLATE_FOLDER
check_param BOSH_VSPHERE_VCENTER_DATASTORE_PATTERN
check_param BOSH_VSPHERE_VCENTER_DISK_PATH
check_param BOSH_VSPHERE_VCENTER_VLAN
check_param BOSH_DIRECTOR_USERNAME
check_param BOSH_DIRECTOR_PASSWORD

: ${old_bosh_release_version:?must be set}
: ${old_bosh_release_sha1:?must be set}
: ${old_vsphere_cpi_release_version:?must be set}
: ${old_vsphere_cpi_release_sha1:?must be set}
: ${old_bosh_stemcell_name:?must be set}
: ${old_bosh_stemcell_version:?must be set}
: ${old_bosh_stemcell_sha1:?must be set}
: ${old_bosh_init_version:?must be set}
: ${old_bosh_init_sha1:?must be set}

env_name=$(cat ${workspace_dir}/vsphere-5.1-environment/name)
metadata=$(cat ${workspace_dir}/vsphere-5.1-environment/metadata)
network1=$(env_attr "${metadata}" "network1")
echo Using environment: \'${env_name}\'
export DIRECTOR_IP=$(                  env_attr "${metadata}" "directorIP")
export BOSH_VSPHERE_VCENTER_CIDR=$(    env_attr "${network1}" "vCenterCIDR")
export BOSH_VSPHERE_VCENTER_GATEWAY=$( env_attr "${network1}" "vCenterGateway")
export BOSH_VSPHERE_DNS=$(             env_attr "${metadata}" "DNS")

echo "verifying no BOSH deployed VM exists at target IP: $DIRECTOR_IP"
check_for_rogue_vm $DIRECTOR_IP

echo "verifying target vSphere version matches $BOSH_VSPHERE_VERSION"

pushd ${release_dir}/src/vsphere_cpi
  bundle install
  bundle exec rspec spec/integration/bats_env_spec.rb
popd

pushd "${workspace_dir}"
  cpi_release_name="bosh-vsphere-cpi"

  curl -L http://bosh.io/d/github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release?v=${old_vsphere_cpi_release_version} > ${cpi_release_name}.tgz
  echo "${old_vsphere_cpi_release_sha1} ${cpi_release_name}.tgz" | sha1sum -c -

  curl -L https://bosh.cloudfoundry.org/d/github.com/cloudfoundry/bosh?v=${old_bosh_release_version} > bosh-release.tgz
  echo "${old_bosh_release_sha1} bosh-release.tgz" | sha1sum -c -

  stemcell_url=$(curl http://bosh.io/api/v1/stemcells/${old_bosh_stemcell_name} | jq 'map(select(.version == $version))[0].regular.url' --raw-output --arg version ${old_bosh_stemcell_version})
  curl -L ${stemcell_url} > stemcell.tgz
  echo "${old_bosh_stemcell_sha1} stemcell.tgz" | sha1sum -c -

  curl -L https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-${old_bosh_init_version}-linux-amd64 > bosh-init
  echo "${old_bosh_init_sha1} bosh-init" | sha1sum -c -
  chmod +x bosh-init
  mv bosh-init /bin

  cat > "director-manifest.yml" <<EOF
---
name: bosh

releases:
  - name: bosh
    url: file://bosh-release.tgz
  - name: ${cpi_release_name}
    url: file://${cpi_release_name}.tgz

resource_pools:
  - name: vms
    network: private
    stemcell:
      url: file://stemcell.tgz
    cloud_properties:
      cpu: 2
      ram: 4_096
      disk: 20_000

disk_pools:
  - name: disks
    disk_size: 20_000

networks:
  - name: private
    type: manual
    subnets:
      - range: ${BOSH_VSPHERE_VCENTER_CIDR}
        gateway: ${BOSH_VSPHERE_VCENTER_GATEWAY}
        dns: [${BOSH_VSPHERE_DNS}]
        cloud_properties: {name: ${BOSH_VSPHERE_VCENTER_VLAN}}

jobs:
  - name: bosh
    instances: 1

    templates:
      - {name: nats, release: bosh}
      - {name: redis, release: bosh}
      - {name: postgres, release: bosh}
      - {name: blobstore, release: bosh}
      - {name: director, release: bosh}
      - {name: health_monitor, release: bosh}
      - {name: powerdns, release: bosh}
      - {name: vsphere_cpi, release: ${cpi_release_name}}

    resource_pool: vms
    persistent_disk_pool: disks

    networks:
      - {name: private, static_ips: [${DIRECTOR_IP}]}

    properties:
      nats:
        address: 127.0.0.1
        user: nats
        password: nats-password

      redis:
        listen_addresss: 127.0.0.1
        address: 127.0.0.1
        password: redis-password

      postgres: &db
        host: 127.0.0.1
        user: postgres
        password: postgres-password
        database: bosh
        adapter: postgres

      blobstore:
        address: ${DIRECTOR_IP}
        port: 25250
        provider: dav
        director: {user: director, password: director-password}
        agent: {user: agent, password: agent-password}

      director:
        address: 127.0.0.1
        name: my-bosh
        db: *db
        cpi_job: vsphere_cpi
        user_management:
          provider: local
          local:
            users:
              - {name: ${BOSH_DIRECTOR_USERNAME}, password: ${BOSH_DIRECTOR_PASSWORD}}

      hm:
        http: {user: hm, password: hm-password}
        director_account: {user: ${BOSH_DIRECTOR_USERNAME}, password: ${BOSH_DIRECTOR_PASSWORD}}
        resurrector_enabled: true

      agent: {mbus: "nats://nats:nats-password@${DIRECTOR_IP}:4222"}

      dns:
        address: 127.0.0.1
        db: *db

      vcenter: &vcenter
        address: ${BOSH_VSPHERE_VCENTER}
        user: ${BOSH_VSPHERE_VCENTER_USER}
        password: ${BOSH_VSPHERE_VCENTER_PASSWORD}
        datacenters:
          - name: ${BOSH_VSPHERE_VCENTER_DC}
            vm_folder: ${BOSH_VSPHERE_VCENTER_VM_FOLDER}
            template_folder: ${BOSH_VSPHERE_VCENTER_TEMPLATE_FOLDER}
            datastore_pattern: ${BOSH_VSPHERE_VCENTER_DATASTORE_PATTERN}
            persistent_datastore_pattern: ${BOSH_VSPHERE_VCENTER_DATASTORE_PATTERN}
            disk_path: ${BOSH_VSPHERE_VCENTER_DISK_PATH}
            clusters: [${BOSH_VSPHERE_VCENTER_CLUSTER}]

cloud_provider:
  template: {name: vsphere_cpi, release: ${cpi_release_name}}

  mbus: "https://mbus:mbus-password@${DIRECTOR_IP}:6868"

  properties:
    vcenter: *vcenter
    agent: {mbus: "https://mbus:mbus-password@0.0.0.0:6868"}
    blobstore: {provider: local, path: /var/vcap/micro_bosh/data/cache}
    ntp: [0.pool.ntp.org, 1.pool.ntp.org]
EOF

  function finish {
    echo "Final state of director deployment:"
    echo "=========================================="
    cat director-manifest-state.json
    echo "=========================================="

    cp director-manifest* $deployment_dir
  }
  trap finish ERR

  echo "deploying BOSH..."
  bosh-init deploy director-manifest.yml

  trap - ERR
  finish
popd
