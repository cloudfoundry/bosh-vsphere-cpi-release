#!/usr/bin/env bash

set -e

source /etc/profile.d/chruby.sh
chruby 2.1.2

initver=$(cat bosh-init/version)
initexe="bosh-init/bosh-init-${initver}-linux-amd64"
chmod +x ${initexe}

echo "using bosh-init CLI version..."
$initexe version

director_manifest_file=${PWD}/setup-director/deployment/director-manifest.yml
echo "deleting existing BOSH Director VM..."
$initexe delete ${director_manifest_file}
