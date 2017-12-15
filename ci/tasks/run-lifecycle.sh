#! /bin/bash

set -e

source bosh-cpi-src/ci/utils.sh
source bosh-cpi-src/.envrc

# Required to run and spawn nimbus testbed
sudo apt-get -y update
sudo apt-get -y install jq rsync ssh

# Spawn the test environment on nimbus
pushd vcpi-nimbus
  echo "$DBC_SSH_KEY" > ./dbc_ssh_key
  chmod 400 dbc_ssh_key
  ./launch -s 'ssh -i dbc_ssh_key -o StrictHostKeyChecking=no'
  source environment.sh
popd

# Sleep for 10 minutes to allow system to start collecting stats
# Perf Manager provides wrong stats if this is not there and most test will fail.
# DO NOT REMOVE OR CHANGE WITHOUT THOROUGH INVESTIGATION.
# From vsphere documentation : VirtualCenter Server 2.5 (and subsequent vCenter Server) systems initially collect statistics data 10 minutes after system startup, and then hourly thereafter.
# Sleeping for 600 seconds.
sleep 600

stemcell_dir="$( cd stemcell && pwd )"
export BOSH_VSPHERE_STEMCELL=${stemcell_dir}/stemcell.tgz
export HTTP_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:3128"

if [ -f /etc/profile.d/chruby.sh ]; then
  source /etc/profile.d/chruby.sh
  chruby $PROJECT_RUBY_VERSION
fi

: ${RSPEC_FLAGS:=""}
: ${BOSH_VSPHERE_STEMCELL:=""}

# allow user to pass paths to spec files relative to src/vsphere_cpi
# e.g. ./run-lifecycle.sh spec/integration/core_spec.rb
if [ "$#" -ne 0 ]; then
  RSPEC_ARGS="$@"
fi

install_iso9660wrap() {
  pushd bosh-cpi-src
    pushd src/iso9660wrap
      go build ./...
      export PATH="$PATH:$PWD"
    popd
  popd
}

install_iso9660wrap

pushd bosh-cpi-src/src/vsphere_cpi
  bundle install
  bundle exec rspec ${RSPEC_FLAGS} --require ./spec/support/verbose_formatter.rb --format VerboseFormatter spec/integration
popd
