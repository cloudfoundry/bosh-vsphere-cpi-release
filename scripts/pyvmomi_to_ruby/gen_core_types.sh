#!/bin/sh

curl \
  --remote-name \
  https://raw.githubusercontent.com/vmware/pyvmomi/master/pyVmomi/CoreTypes.py

./gen_core_types.py
