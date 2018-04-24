#!/usr/bin/env bash

set -e

: ${DEPLOYMENT_NAME:?}
: ${RELEASE_NAME:?}
: ${STEMCELL_NAME:?}

source source-ci/ci/shared/tasks/setup-env-proxy.sh

bosh int certification/shared/assets/certification-release/certification.yml \
  -v "deployment_name=${DEPLOYMENT_NAME}" \
  -v "release_name=${RELEASE_NAME}" \
  -v "stemcell_name=${STEMCELL_NAME}" \
  -v "gateway=192.168.111.1" \
  -v "DNS=192.168.111.1" \
  -v network_name="$BOSH_VSPHERE_VLAN" > /tmp/deployment.yml

source director-state/director.env

pushd certification/shared/assets/certification-release
  if [[ -n "${bosh_input}" ]]; then
    export bosh_cli="/usr/local/bin/bosh"
    cp "${bosh_input}" "${bosh_cli}"
    chmod +x "${bosh_cli}"
  fi
  time bosh -n create-release --force --name ${RELEASE_NAME}
  time bosh -n upload-release
popd

time bosh -n upload-stemcell $( realpath stemcell/*.tgz )
time bosh -n deploy -d ${DEPLOYMENT_NAME} /tmp/deployment.yml
