#!/usr/bin/env bash

set -e -x

working_dir=$PWD
old_deployment_dir=${working_dir}/old-deployment
deployment_dir=${working_dir}/deployment
release_dir=${working_dir}/bosh-cpi-src

source ${release_dir}/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

: ${director_username:?must be set}
: ${director_password:?must be set}
: ${test_deployment_name:?must be set}

cpi_release_name="bosh-vsphere-cpi"

env_name=$(cat ${working_dir}/vsphere-5.1-environment/name)
metadata=$(cat ${working_dir}/vsphere-5.1-environment/metadata)
network1=$(env_attr "${metadata}" "network1")
echo Using environment: \'${env_name}\'
export DIRECTOR_IP=$(env_attr "${metadata}" "directorIP")

cp ./bosh-cpi-artifacts/*.tgz ${cpi_release_name}.tgz
cp ./bosh-release/release.tgz bosh-release.tgz
cp ./stemcell/stemcell.tgz stemcell.tgz
cp $old_deployment_dir/director-manifest* .

initver=$(cat bosh-init/version)
initexe="bosh-init/bosh-init-${initver}-linux-amd64"
chmod +x ${initexe}

echo "using bosh-init CLI version..."
$initexe version

director_manifest_file=director-manifest.yml
echo "upgrading existing BOSH Director VM..."
$initexe deploy ${director_manifest_file}

cp director-manifest* $deployment_dir
cp -r $HOME/.bosh_init $deployment_dir

echo "recreating existing BOSH Deployment..."
bosh -n target ${DIRECTOR_IP}
bosh login ${director_username} ${director_password}
bosh download manifest ${test_deployment_name} ${test_deployment_name}-manifest
bosh deployment ${test_deployment_name}-manifest
bosh -n deploy --recreate

bosh -n delete deployment ${test_deployment_name}
bosh -n cleanup --all
