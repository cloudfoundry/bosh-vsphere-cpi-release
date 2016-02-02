#!/usr/bin/env bash

set -e -x

release_dir="$( cd $(dirname $0) && cd ../.. && pwd )"
workspace_dir="$( cd ${release_dir} && cd .. && pwd )"
dev_artifacts_dir="$( cd ${workspace_dir}/bosh-cpi-artifacts && pwd )"

source ${release_dir}/ci/tasks/utils.sh
source /etc/profile.d/chruby.sh
chruby 2.1.2

check_param aws_access_key_id
check_param aws_secret_access_key

# Creates an integer version number from the semantic version format
# May be changed when we decide to fully use semantic versions for releases
integer_version="$(cut -d "." -f1 ${workspace_dir}/release-version-semver/number)"
echo $integer_version > ${workspace_dir}/integer_version

pushd "${release_dir}"
  set +x
  echo creating config/private.yml with blobstore secrets
  cat > config/private.yml << EOF
  ---
  blobstore:
    s3:
      access_key_id: $aws_access_key_id
      secret_access_key: $aws_secret_access_key
  EOF
  set -x

  echo "using bosh CLI version..."
  bosh version

  echo "finalizing CPI release..."
  bosh finalize release ${dev_artifacts_dir}/*.tgz --version $integer_version

  rm config/private.yml

  git diff | cat
  git add .

  git config --global user.email cf-bosh-eng@pivotal.io
  git config --global user.name CI
  git commit -m ":airplane: New final release v $integer_version" -m "[ci skip]"
popd
