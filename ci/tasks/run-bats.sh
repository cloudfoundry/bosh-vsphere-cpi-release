#!/usr/bin/env bash

set -e

source bosh-cpi-release/ci/tasks/utils.sh

check_param base_os
check_param network_type_to_test

source /etc/profile.d/chruby.sh
chruby 2.1.2

cpi_release_name=bosh-vsphere-cpi

source bosh-concourse-ci/pipelines/$cpi_release_name/$base_os-$network_type_to_test-exports.sh

#vsphere uses user/pass and the cdrom drive, not a reverse ssh tunnel
eval $(ssh-agent)
chmod go-r $BOSH_SSH_PRIVATE_KEY
ssh-add $BOSH_SSH_PRIVATE_KEY

echo "using bosh CLI version..."
bosh version

bosh -n target $BAT_DIRECTOR

sed -i.bak s/"uuid: replace-me"/"uuid: $(bosh status --uuid)"/ $BAT_DEPLOYMENT_SPEC

cd bats
bundle install
bundle exec rspec spec

#kill the SSH agent we started earlier
ssh-agent -k
