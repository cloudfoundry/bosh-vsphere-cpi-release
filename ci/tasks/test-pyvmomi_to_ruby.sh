#!/usr/bin/env bash

set -e

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"

pushd "${release_dir}/scripts/pyvmomi_to_ruby"
  python -m unittest discover . -v
popd
