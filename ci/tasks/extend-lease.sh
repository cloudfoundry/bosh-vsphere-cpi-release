#! /bin/bash

# Set remote from DBCUSER and DBCHOST
DBCUSER=${DBCUSER:-$(id -un)}
if [ -z "$DBCHOST" ]; then
  echo DBCHOST must be set to the unqualified hostname of your DBC host 1>&2
  exit 1
fi
remote=$DBCUSER@$DBCHOST.eng.vmware.com

echo "$DBC_SSH_KEY" > dbc_ssh_key
chmod 400 dbc_ssh_key

metadata_file=environment/metadata

SENTINEL='# Metadata used by vcpi-nimbus:'
while IFS= read -r text; do
  eval "${text#'# '}"
done < <(sed -e "1,/^$SENTINEL/d" $metadata_file | grep '^# VCPI_NIMBUS')

if [ -z "$VCPI_NIMBUS_LAUNCH_NAME" ]; then
  echo Unable to read Nimbus testbed launch name from "$metadata_file" 1>&2
  exit 1
fi

if [ -z "$VCPI_NIMBUS_LAUNCH_USER" ]; then
  echo Unable to read Nimbus testbed launch user from "$metadata_file" 1>&2
  echo "This step may fail if the testbed wasn't launched as $DBCUSER" 1>&2
  VCPI_NIMBUS_LAUNCH_USER="$DBCUSER"
fi

echo Extending lease on Nimbus testbed "$VCPI_NIMBUS_LAUNCH_NAME" ... 1>&2

ssh -i dbc_ssh_key -o StrictHostKeyChecking=no $remote \
  USER="$VCPI_NIMBUS_LAUNCH_USER" \
  /mts/git/bin/nimbus-ctl \
  --testbed --lease 1 extend-lease \
  "$VCPI_NIMBUS_LAUNCH_NAME"
