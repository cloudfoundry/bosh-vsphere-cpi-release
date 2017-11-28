#!/usr/bin/env bash

set -e

pushd bosh-cpi-src/scripts/pyvmomi_to_ruby
  python -m unittest discover . -v
popd
