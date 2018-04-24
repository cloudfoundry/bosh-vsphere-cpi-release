#!/usr/bin/env bash

set -e

: ${DEPLOYMENT_NAME:?}

source source-ci/ci/shared/tasks/setup-env-proxy.sh

# outputs
output_dir=$(realpath new-director-state/)

cp -r new-director-config/director.yml ${output_dir}
cp -r old-director-state/*-state.json ${output_dir}
cp old-director-state/creds.yml ${output_dir}
cp old-director-state/director.env ${output_dir}
source old-director-state/director.env

# deployment manifest references releases and stemcells relative to itself...make it true
# these resources are also used in the teardown step
mkdir -p ${output_dir}/{stemcell,bosh-release,cpi-release}
cp stemcell/*.tgz ${output_dir}/stemcell/
cp bosh-release/*.tgz ${output_dir}/bosh-release/
cp cpi-release/*.tgz ${output_dir}/cpi-release/

function finish {
  echo "Final state of director deployment:"
  echo "=========================================="
  cat "${output_dir}/director-state.json"
  echo "=========================================="

  cp -r $HOME/.bosh ${output_dir}
  master_exit
}
trap finish EXIT

bosh_input="$(realpath bosh-cli/*bosh-cli-* 2>/dev/null || true)"


echo "upgrading existing BOSH Director VM..."
pushd ${output_dir} > /dev/null
  if [[ -n "${bosh_input}" ]]; then
    export bosh_cli="/usr/local/bin/bosh"
    cp "${bosh_input}" "${bosh_cli}"
    chmod +x "${bosh_cli}"
  fi
  time bosh create-env --state "${output_dir}/director-state.json" \
    --vars-store "${output_dir}/creds.yml" -v director_name=bosh \
    director.yml
popd > /dev/null

echo "recreating existing BOSH Deployment..."
time bosh -n -d ${DEPLOYMENT_NAME} recreate