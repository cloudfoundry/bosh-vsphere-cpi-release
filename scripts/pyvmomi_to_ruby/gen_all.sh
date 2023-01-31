#!/usr/bin/env bash

ruby_vim_sdk_path="${SRC_DIR}/lib/ruby_vim_sdk"

version_tag=$1
: ${version_tag:=?}

tag="$( curl -L https://api.github.com/repos/vmware/pyvmomi/tags | jq --arg version "${version_tag}" '.[] | select(.name==$version) | .name' )"
if [[ -z "${tag}" ]]; then
  echo "Version tag '${version_tag}' not found!"
  exit 1
fi

echo "Fetching version '${tag}' ...'"
vmware_pyvmimu_url="https://raw.githubusercontent.com/vmware/pyvmomi"

# Datatype definition for following objects was added manually in ServerObjects.rb file
# Pbm.Profile.EntityAssociations, Pbm.Capability.AssociatedPolicyCapabilities, Pbm.Profile.PmemPolicyInfo

files_to_download="{_typeinfo_vim.py,_typeinfo_core.py,_typeinfo_query.py,_typeinfo_pbm.py,_typeinfo_sms.py}"

curl --remote-name "${vmware_pyvmimu_url}/${version_tag}/pyVmomi/${files_to_download}"

sed -i '' 's/from .VmomiSupport/from pyVmomi.VmomiSupport/g' _typeinfo_vim.py
sed -i '' 's/from .VmomiSupport/from pyVmomi.VmomiSupport/g' _typeinfo_pbm.py

./gen_server_objects.py > "${ruby_vim_sdk_path}/server_objects_80.rb"
./gen_core_types.py > "${ruby_vim_sdk_path}/core_types_80.rb"
