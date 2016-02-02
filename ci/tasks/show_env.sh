#!/usr/bin/env bash

set -x -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"

echo "Current lock:"

pushd "${workspace_dir}"
  cat vsphere-5.1-environment/metadata
  cat vsphere-5.1-environment/name
popd
