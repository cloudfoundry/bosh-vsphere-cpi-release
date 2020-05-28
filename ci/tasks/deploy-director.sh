#!/usr/bin/env bash

# DO NOT REMOVE!!!
#
# Proxy environment variables refer to squid proxy on Nimbus testbed jumpbox. We
# need these proxy environment variables because the CPI needs to talk to the
# BOSH agent on the VM it has deployed. Communication to the agent will fail in
# the absence of these proxy environment variables.
#
# In prepare director script, we use a proxy ops file to provide same variables.
# In that particular case, those variables are used to configure the environment
# for the BOSH cli, which rejects other environment configurations.
#
# Due to the different design philosophies between the CLI and the CPI, proxy
# environment variables are needed in both places.
source source-ci/ci/shared/tasks/setup-env-proxy.sh

cp director-config/* director-state/

# The deployment manifest references releases and stemcells relative to itself
mkdir -p director-state/{stemcell,bosh-release,cpi-release}
cp stemcell/*.tgz director-state/stemcell/
cp bosh-release/*.tgz director-state/bosh-release/
cp cpi-release/*.tgz director-state/cpi-release/

export BOSH_LOG_PATH="$(mktemp /tmp/bosh-cli-log.XXXXXX)"

finish() {
  echo 'Final state of BOSH director deployment:' 1>&2
  echo '========================================' 1>&2
  cat director-state/director-state.json 1>&2
  echo 1>&2
  echo '========================================' 1>&2

  rm -f "$BOSH_LOG_PATH"

  cp -r ~/.bosh director-state
  master_exit
}
trap finish EXIT

echo Deploying BOSH director ... 1>&2
bosh create-env --vars-store director-state/creds.yml director-state/director.yml
status=$?
if [ $status -ne 0 ]; then
  echo "BOSH director deployment failed!" 1>&2
  cat "$BOSH_LOG_PATH" 1>&2
  exit $status
fi

BOSH_ENVIRONMENT="$(bosh int director-state/director.yml \
  --path=/instance_groups/name=bosh/networks/name=default/static_ips/0)"
BOSH_CLIENT=admin
BOSH_CLIENT_SECRET="$(bosh int director-state/creds.yml --path=/admin_password)"
BOSH_CA_CERT="$(bosh int director-state/creds.yml --path=/director_ssl/ca)"

cat > director-state/director.env <<EOF
export BOSH_ENVIRONMENT=$(printf %q "$BOSH_ENVIRONMENT")
export BOSH_CLIENT=$(printf %q "$BOSH_CLIENT")
export BOSH_CLIENT_SECRET=$(printf %q "$BOSH_CLIENT_SECRET")
export BOSH_CA_CERT=$(printf %q "$BOSH_CA_CERT")
export BOSH_GW_HOST="\$BOSH_ENVIRONMENT"
export BOSH_GW_USER=jumpbox
EOF