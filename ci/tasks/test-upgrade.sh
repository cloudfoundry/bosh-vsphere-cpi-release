#!/usr/bin/env bash

set -e

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

cp ./bosh-cpi-artifacts/*.tgz ${cpi_release_name}.tgz
cp ./bosh-release/release.tgz bosh-release.tgz
cp ./stemcell/stemcell.tgz stemcell.tgz
cp $old_deployment_dir/director-manifest* .

initver=$(cat bosh-init/version)
initexe="bosh-init/bosh-init-${initver}-linux-amd64"
chmod +x ${initexe}

log "using bosh-init CLI version..."
$initexe version

log "upgrading existing BOSH Director VM..."
$initexe deploy director-manifest.yml
log "finished upgrading director"

cp director-manifest* $deployment_dir
cp -r $HOME/.bosh_init $deployment_dir

bosh -n target ${DIRECTOR_IP}
bosh login ${director_username} ${director_password}
bosh download manifest ${test_deployment_name} ${test_deployment_name}-manifest
bosh deployment ${test_deployment_name}-manifest

log "recreating existing BOSH Deployment..."
bosh -n deploy --recreate
log "finished recreating deployment"

log "deleting deployment..."
bosh -n delete deployment ${test_deployment_name}
log "finished deleting deployment"

log "cleaning up director..."
bosh -n cleanup --all
log "done cleaning up director"
