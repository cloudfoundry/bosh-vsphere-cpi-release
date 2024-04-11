#! /bin/bash -ex

# to run this script:
# - create an "environment" directory in your bosh-vsphere-cpi-release folder and put a "metadata" file in it that sets all the environment.
#   (normally we get this file from the nimbus pool created by vane)
# - create a "stemcell" folder and put your stem cell in it, naming it "stemcell.tgz"
#   **OR** if you already have an uploaded stemcell, set BOSH_VSPHERE_STEMCELL_ID in your `metadata` file and the tests will use that instead.
# - run the script.
# - to run a particular test, add the following arguments when invoking the script (for example):
#   `-e RSPEC_FLAGS=spec/integration/nsxt_spec.rb:360`

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

pushd "${SCRIPTPATH}/.."

  docker run -it $@ -v $PWD:/source-ci -v $PWD:/bosh-cpi-src -v $PWD/environment:/environment -v $PWD/stemcell:/stemcell bosh/vsphere-vcpi source-ci/ci/tasks/run-lifecycle.sh

popd
