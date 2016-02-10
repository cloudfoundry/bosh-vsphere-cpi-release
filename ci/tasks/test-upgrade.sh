#!/usr/bin/env bash

set -e -x

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"
deployment_dir="$( cd ${workspace_dir}/deployment && pwd )"
old_deployment_dir="$( cd ${workspace_dir}/old-deployment && pwd )"

source ${release_dir}/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

: ${director_username:?must be set}
: ${director_password:?must be set}
: ${test_deployment_name:?must be set}

cpi_release_name="bosh-vsphere-cpi"

env_name=$(cat ${workspace_dir}/vsphere-5.1-environment/name)
metadata=$(cat ${workspace_dir}/vsphere-5.1-environment/metadata)
network1=$(env_attr "${metadata}" "network1")

log "Using environment: \'${env_name}\'"
export DIRECTOR_IP=$(env_attr "${metadata}" "directorIP")

time cp ./bosh-cpi-artifacts/*.tgz ${cpi_release_name}.tgz
time cp ./bosh-release/release.tgz bosh-release.tgz
time cp ./stemcell/stemcell.tgz stemcell.tgz
time cp $old_deployment_dir/director-manifest* .

initver=$(cat bosh-init/version)
initexe="bosh-init/bosh-init-${initver}-linux-amd64"
chmod +x ${initexe}

log "using bosh-init CLI version..."
$initexe version

log "upgrading existing BOSH Director VM..."
time $initexe deploy director-manifest.yml

time cp director-manifest* $deployment_dir
time cp -r $HOME/.bosh_init $deployment_dir

time bosh -n target ${DIRECTOR_IP}
time bosh login ${director_username} ${director_password}
time bosh download manifest ${test_deployment_name} ${test_deployment_name}-manifest
time bosh deployment ${test_deployment_name}-manifest

log "recreating existing BOSH Deployment..."
time bosh -n deploy --recreate

log "deleting deployment..."
time bosh -n delete deployment ${test_deployment_name}

log "cleaning up director..."
time bosh -n cleanup --all
