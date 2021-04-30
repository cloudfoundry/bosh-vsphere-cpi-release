#! /bin/bash

set -e

source bosh-cpi-src/.envrc
source environment/metadata

if [ "$BOSH_VSPHERE_CPI_NSXT_HOST" != "null" ]; then
  export BOSH_NSXT_CA_CERT_FILE=$(realpath $PWD/nsxt-manager-cert.pem)
  # To get the cert from nsxt-manager, we run openssl on the jump box, and then pipe that result into a local openssl command that reformats it into PEM
  sshpass -p "vcpi" ssh -o StrictHostKeyChecking=no "vcpi@${BOSH_VSPHERE_JUMPER_HOST}" -C "openssl s_client -showcerts -connect $BOSH_VSPHERE_CPI_NSXT_HOST:443 </dev/null 2>/dev/null" | openssl x509 -outform PEM > $BOSH_NSXT_CA_CERT_FILE
  # The certificate's subject name is nsxt-manager so SSL validation fails when using the IP address
  echo "${BOSH_VSPHERE_CPI_NSXT_HOST} nsxt-manager" >> /etc/hosts
  sshpass -p "vcpi" sshuttle -r "vcpi@${BOSH_VSPHERE_JUMPER_HOST}" 192.168.111.0/22 --no-latency-control 2>&1 &
  export BOSH_VSPHERE_CPI_NSXT_HOST="https://nsxt-manager"
else
  source source-ci/ci/shared/tasks/setup-env-proxy.sh
fi

stemcell_dir="$( cd stemcell && pwd )"
export BOSH_VSPHERE_STEMCELL=${stemcell_dir}/stemcell.tgz

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
