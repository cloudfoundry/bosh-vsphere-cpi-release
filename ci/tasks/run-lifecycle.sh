#! /bin/bash
set -eu -o pipefail

set -x

source bosh-cpi-src/.envrc
source environment/metadata

# get the tun device; we need it to establish OpenVPN
mkdir -p /mnt/dev
mount -t devtmpfs devtmpfs /mnt/dev
ln -s /mnt/dev/net /dev/net

# configure password-less and sshpass-less ssh to VCPI jumpbox
mkdir -p ~/.ssh
ssh-keygen -t ed25519 -f ~/.ssh/vcpi -N ""
cat > ~/.ssh/config <<EOF
Host jumpbox
        HostName ${BOSH_VSPHERE_JUMPER_HOST}
        User vcpi
        IdentityFile ~/.ssh/vcpi
        StrictHostKeyChecking no
EOF
chmod -R go-rwx ~/.ssh
sshpass -p $BOSH_VSPHERE_JUMPER_PASSWORD ssh jumpbox "cat >> .ssh/authorized_keys" < ~/.ssh/vcpi.pub

# grab OpenVPN client configuration & update it with VCPI jumpbox IP
scp jumpbox:client.ovpn /etc/openvpn/
sed --in-place "s/jumper.vcpi-nimbus.local/${BOSH_VSPHERE_JUMPER_HOST}/" /etc/openvpn/client.ovpn
openvpn --cd /etc/openvpn --config /etc/openvpn/client.ovpn &
sleep 6 # OpenVPN needs ~3 secs to establish its connection

if [ "$BOSH_VSPHERE_CPI_NSXT_HOST" != "null" ]; then
  export BOSH_NSXT_CA_CERT_FILE
  BOSH_NSXT_CA_CERT_FILE="$(realpath "${PWD}/nsxt-manager-cert.pem")"
  # To get the cert from nsxt-manager, we run openssl on the jump box, and then pipe that result into a local openssl command that reformats it into PEM
  openssl s_client -showcerts -connect "${BOSH_VSPHERE_CPI_NSXT_HOST}":443 </dev/null 2>/dev/null | openssl x509 -outform PEM > $BOSH_NSXT_CA_CERT_FILE
  # The certificate's SAN contains the host name, so extract it because SSL validation fails when using the IP address
  # NOTE: Don't hard code the name as it is not guaranteed to be "nsxt-manager"
  BOSH_NSXT_CERT_HOST_NAME="$(openssl x509 -noout -text -in nsxt-manager-cert.pem | awk '/X509v3 Subject Alternative Name/ {getline;gsub(/ /, "", $0); print}' | tr -d "DNS:")"
  echo "${BOSH_VSPHERE_CPI_NSXT_HOST} ${BOSH_NSXT_CERT_HOST_NAME}" >> /etc/hosts
  export BOSH_VSPHERE_CPI_NSXT_HOST="https://${BOSH_NSXT_CERT_HOST_NAME}"
fi

BOSH_VSPHERE_STEMCELL="$(pwd)/stemcell/stemcell.tgz"
export BOSH_VSPHERE_STEMCELL

cleanup() {
  set +e # if you hit an error, continue; we're trying to clean up as much we can
  echo "Killing OpenVPN..."
  kill %openvpn
  fg %openvpn > /dev/null 2>&1 # make sure OpenVPN shutdown has completed
  rm /dev/net
  umount -l /mnt/dev
  set -e
}
trap cleanup EXIT

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
  bundle exec rspec \
    ${RSPEC_FLAGS:-''} \
    --require ./spec/support/verbose_formatter.rb \
    --format VerboseFormatter spec/integration
popd