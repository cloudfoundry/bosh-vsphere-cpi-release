#!/usr/bin/env bash

set -e

source bosh-cpi-release/ci/tasks/utils.sh

check_param base_os
check_param network_type_to_test
check_param BAT_DIRECTOR
check_param BAT_DNS_HOST
check_param BAT_STEMCELL_NAME
check_param BAT_STATIC_IP
check_param BAT_SECOND_STATIC_IP
check_param BAT_CIDR
check_param BAT_RESERVED_RANGE
check_param BAT_STATIC_RANGE
check_param BAT_GATEWAY
check_param BAT_VLAN
check_param BAT_VCAP_PASSWORD
check_param BOSH_VSPHERE_NETMASK
check_param BOSH_VSPHERE_GATEWAY
check_param BOSH_VSPHERE_DNS
check_param BOSH_VSPHERE_NTP_SERVER
check_param BOSH_VSPHERE_NET_ID
check_param BOSH_VSPHERE_VCENTER
check_param BOSH_VSPHERE_VCENTER_USER
check_param BOSH_VSPHERE_VCENTER_PASSWORD
check_param BOSH_VSPHERE_VCENTER_DC
check_param BOSH_VSPHERE_VCENTER_CLUSTER
check_param BOSH_VSPHERE_VCENTER_RESOURCE_POOL
check_param BOSH_VSPHERE_VCENTER_DATASTORE_PATTERN
check_param BOSH_VSPHERE_VCENTER_UBOSH_DATASTORE_PATTERN
check_param BOSH_VSPHERE_MICROBOSH_IP
check_param BOSH_VSPHERE_VCENTER_FOLDER_PREFIX

source /etc/profile.d/chruby.sh
chruby 2.1.2

working_dir=$PWD

cpi_release_name=bosh-vsphere-cpi
bosh_ssh_key="$working_dir/keys/bats.pem"
export BAT_STEMCELL="$working_dir/stemcell/stemcell.tgz"
export BAT_DEPLOYMENT_SPEC="$working_dir/${base_os}-${network_type_to_test}-bats-config.yml"
export BAT_INFRASTRUCTURE=vsphere
export BAT_NETWORKING=$network_type_to_test

# vsphere uses user/pass and the cdrom drive, not a reverse ssh tunnel
# the SSH key is required for the` bosh ssh` command to work properly
mkdir -p $PWD/keys
eval $(ssh-agent)
ssh-keygen -N "" -t rsa -b 4096 -f $bosh_ssh_key
chmod go-r $bosh_ssh_key
ssh-add $bosh_ssh_key

echo "using bosh CLI version..."
bosh version

bosh -n target $BAT_DIRECTOR

BOSH_UUID=`bosh status --uuid`

# disable host key checking for deployed VMs
mkdir -p $HOME/.ssh

cat > $HOME/.ssh/config << EOF
Host ${BAT_STATIC_IP}
    StrictHostKeyChecking no
Host ${BAT_SECOND_STATIC_IP}
    StrictHostKeyChecking no
EOF


cat > "${BAT_DEPLOYMENT_SPEC}" <<EOF
---
cpi: vsphere
properties:
  uuid: ${BOSH_UUID}
  pool_size: 1
  instances: 1
  second_static_ip: ${BAT_SECOND_STATIC_IP}
  stemcell:
    name: ${BAT_STEMCELL_NAME}
    version: latest
  networks:
  - name: static
    type: manual
    static_ip: ${BAT_STATIC_IP}
    cidr: ${BAT_CIDR}
    reserved: [${BAT_RESERVED_RANGE}]
    static: [${BAT_STATIC_RANGE}]
    gateway: ${BAT_GATEWAY}
    vlan: ${BAT_VLAN}
EOF

cd bats

cat > "Gemfile" <<EOF
# encoding: UTF-8

source 'https://rubygems.org'

gem 'bosh_common'
gem 'bosh-core'
gem 'bosh_cpi'
gem 'bosh_cli'
gem 'rake', '~>10.0'
gem 'rspec', '~> 3.0.0'
gem 'rspec-its'
gem 'rspec-instafail'
EOF

cat > "Gemfile.lock" <<EOF
GEM
  remote: https://rubygems.org/
  specs:
    CFPropertyList (2.3.1)
    aws-sdk (1.60.2)
      aws-sdk-v1 (= 1.60.2)
    aws-sdk-v1 (1.60.2)
      json (~> 1.4)
      nokogiri (>= 1.4.4)
    blobstore_client (1.2957.0)
      aws-sdk (= 1.60.2)
      bosh_common (~> 1.2957.0)
      fog (~> 1.27.0)
      httpclient (= 2.4.0)
      multi_json (~> 1.1)
      ruby-atmos-pure (~> 1.0.5)
    bosh-core (1.2957.0)
      gibberish (~> 1.4.0)
      yajl-ruby (~> 1.2.0)
    bosh-template (1.2957.0)
      semi_semantic (~> 1.1.0)
    bosh_cli (1.2957.0)
      blobstore_client (~> 1.2957.0)
      bosh-template (~> 1.2957.0)
      bosh_common (~> 1.2957.0)
      cf-uaa-lib (~> 3.2.1)
      highline (~> 1.6.2)
      httpclient (= 2.4.0)
      json_pure (~> 1.7)
      minitar (~> 0.5.4)
      net-scp (~> 1.1.0)
      net-ssh (>= 2.2.1)
      net-ssh-gateway (~> 1.2.0)
      netaddr (~> 1.5.0)
      progressbar (~> 0.9.0)
      terminal-table (~> 1.4.3)
    bosh_common (1.2957.0)
      logging (~> 1.8.2)
      semi_semantic (~> 1.1.0)
    bosh_cpi (1.2957.0)
      bosh_common (~> 1.2957.0)
      logging (~> 1.8.2)
      membrane (~> 1.1.0)
    builder (3.2.2)
    cf-uaa-lib (3.2.1)
      multi_json
    diff-lcs (1.2.5)
    excon (0.45.3)
    fission (0.5.0)
      CFPropertyList (~> 2.2)
    fog (1.27.0)
      fog-atmos
      fog-aws (~> 0.0)
      fog-brightbox (~> 0.4)
      fog-core (~> 1.27, >= 1.27.3)
      fog-ecloud
      fog-json
      fog-profitbricks
      fog-radosgw (>= 0.0.2)
      fog-sakuracloud (>= 0.0.4)
      fog-serverlove
      fog-softlayer
      fog-storm_on_demand
      fog-terremark
      fog-vmfusion
      fog-voxel
      fog-xml (~> 0.1.1)
      ipaddress (~> 0.5)
      nokogiri (~> 1.5, >= 1.5.11)
    fog-atmos (0.1.0)
      fog-core
      fog-xml
    fog-aws (0.1.2)
      fog-core (~> 1.27)
      fog-json (~> 1.0)
      fog-xml (~> 0.1)
      ipaddress (~> 0.8)
    fog-brightbox (0.7.1)
      fog-core (~> 1.22)
      fog-json
      inflecto (~> 0.0.2)
    fog-core (1.30.0)
      builder
      excon (~> 0.45)
      formatador (~> 0.2)
      mime-types
      net-scp (~> 1.1)
      net-ssh (>= 2.1.3)
    fog-ecloud (0.1.1)
      fog-core
      fog-xml
    fog-json (1.0.1)
      fog-core (~> 1.0)
      multi_json (~> 1.0)
    fog-profitbricks (0.0.2)
      fog-core
      fog-xml
      nokogiri
    fog-radosgw (0.0.4)
      fog-core (>= 1.21.0)
      fog-json
      fog-xml (>= 0.0.1)
    fog-sakuracloud (1.0.1)
      fog-core
      fog-json
    fog-serverlove (0.1.2)
      fog-core
      fog-json
    fog-softlayer (0.4.5)
      fog-core
      fog-json
    fog-storm_on_demand (0.1.1)
      fog-core
      fog-json
    fog-terremark (0.1.0)
      fog-core
      fog-xml
    fog-vmfusion (0.1.0)
      fission
      fog-core
    fog-voxel (0.1.0)
      fog-core
      fog-xml
    fog-xml (0.1.2)
      fog-core
      nokogiri (~> 1.5, >= 1.5.11)
    formatador (0.2.5)
    gibberish (1.4.0)
    highline (1.6.21)
    httpclient (2.4.0)
    inflecto (0.0.2)
    ipaddress (0.8.0)
    json (1.8.2)
    json_pure (1.8.2)
    little-plugger (1.1.3)
    log4r (1.1.10)
    logging (1.8.2)
      little-plugger (>= 1.1.3)
      multi_json (>= 1.8.4)
    membrane (1.1.0)
    mime-types (2.5)
    mini_portile (0.6.2)
    minitar (0.5.4)
    multi_json (1.11.0)
    net-scp (1.1.2)
      net-ssh (>= 2.6.5)
    net-ssh (2.9.2)
    net-ssh-gateway (1.2.0)
      net-ssh (>= 2.6.5)
    netaddr (1.5.0)
    nokogiri (1.6.6.2)
      mini_portile (~> 0.6.0)
    progressbar (0.9.2)
    rake (10.4.2)
    rspec (3.0.0)
      rspec-core (~> 3.0.0)
      rspec-expectations (~> 3.0.0)
      rspec-mocks (~> 3.0.0)
    rspec-core (3.0.4)
      rspec-support (~> 3.0.0)
    rspec-expectations (3.0.4)
      diff-lcs (>= 1.2.0, < 2.0)
      rspec-support (~> 3.0.0)
    rspec-instafail (0.2.6)
      rspec
    rspec-its (1.2.0)
      rspec-core (>= 3.0.0)
      rspec-expectations (>= 3.0.0)
    rspec-mocks (3.0.4)
      rspec-support (~> 3.0.0)
    rspec-support (3.0.4)
    ruby-atmos-pure (1.0.5)
      log4r (>= 1.1.9)
      ruby-hmac (>= 0.4.0)
    ruby-hmac (0.4.0)
    semi_semantic (1.1.0)
    terminal-table (1.4.5)
    yajl-ruby (1.2.1)

PLATFORMS
  ruby

DEPENDENCIES
  bosh-core
  bosh_cli
  bosh_common
  bosh_cpi
  httpclient
  json
  minitar
  net-ssh
  rake (~> 10.0)
  rspec (~> 3.0.0)
  rspec-instafail
  rspec-its
EOF

echo "verifying no BOSH deployed VM exists at target IP: $BAT_STATIC_IP"
check_for_rogue_vm $BAT_STATIC_IP

echo "verifying no BOSH deployed VM exists at target IP: $BAT_SECOND_STATIC_IP"
check_for_rogue_vm $BAT_SECOND_STATIC_IP

bundle install
bundle exec rspec spec

#kill the SSH agent we started earlier
ssh-agent -k
