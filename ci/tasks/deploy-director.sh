#!/usr/bin/env bash

# DO NOT REMOVE!!!
# Proxy env variables refer to squid proxy on Nimbus testbed Jumpbox.
# We need these proxy environment variables because CPI needs to talk to agent on the
# VM it has deployed. Communication to agent will fails in absence of these proxy environment
# variables.
#
# In prepare director script, we use proxy ops file to provide same variables. In that
# particular case, those variables are use to configure environment for bosh cli,
# which rejects  other environment configurations.
#
# Due to the different design philosophies of CLI and CPI,
# proxy environment variables are needed at both places.
source environment/metadata
export HTTP_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export HTTPS_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"

# inputs
input_dir=$(realpath director-config/)
stemcell_dir=$(realpath stemcell/)
bosh_dir=$(realpath bosh-release/)
cpi_dir=$(realpath cpi-release/)

# outputs
output_dir=$(realpath director-state/)
cp ${input_dir}/* ${output_dir}

# deployment manifest references releases and stemcells relative to itself...make it true
# these resources are also used in the teardown step
mkdir -p ${output_dir}/{stemcell,bosh-release,cpi-release}
cp ${stemcell_dir}/*.tgz ${output_dir}/stemcell/
cp ${bosh_dir}/*.tgz ${output_dir}/bosh-release/
cp ${cpi_dir}/*.tgz ${output_dir}/cpi-release/


logfile="$(mktemp /tmp/bosh-cli-log.XXXXXX)"

finish() {
  echo "Final state of director deployment:"
  echo "=========================================="
  cat "director-state/director-state.json"
  echo "=========================================="

  cp -r $HOME/.bosh director-state
  rm -f $logfile
}
trap finish EXIT

echo Deploying BOSH... 1>&2

BOSH_LOG_PATH=$logfile bosh create-env \
--vars-store director-state/creds.yml \
director-state/director.yml

bosh_cli_exit_code=$?

if [ $bosh_cli_exit_code -ne 0 ]; then
  echo "bosh-cli deploy failed!" 1>&2
  cat $logfile 1>&2
  exit $bosh_cli_exit_code
fi

cat > director-state/director.env <<EOF
export BOSH_ENVIRONMENT="$(
  bosh int director-state/director.yml --path=/instance_groups/name=bosh/networks/name=default/static_ips/0 2>/dev/null
)"
export BOSH_CLIENT="admin"
export BOSH_CLIENT_SECRET="$(bosh int director-state/creds.yml --path=/admin_password)"
export BOSH_CA_CERT="$(bosh int director-state/creds.yml --path=/director_ssl/ca)"
export BOSH_GW_HOST="\$BOSH_ENVIRONMENT"
export BOSH_GW_USER="jumpbox"
EOF