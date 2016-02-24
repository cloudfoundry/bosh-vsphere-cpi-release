#!/usr/bin/env bash

set -e -x

source /etc/profile.d/chruby.sh
chruby 2.1.2

: ${aws_access_key_id:?must be set}
: ${aws_secret_access_key:?must be set}


release_dir=$(realpath bosh-cpi-src)
artifacts_dir=$(realpath bosh-cpi-artifacts)

# Creates an integer version number from the semantic version format
# May be changed when we decide to fully use semantic versions for releases
integer_version="$(cut -d "." -f1 release-version-semver/number)"
echo $integer_version > integer-version/tag-file

# copy the input release repository into its output location
cp -a bosh-cpi-src/. updated-repo/

pushd updated-repo
  echo creating config/private.yml with blobstore secrets
  cat > config/private.yml << EOF
---
blobstore:
  s3:
    access_key_id: $aws_access_key_id
    secret_access_key: $aws_secret_access_key
EOF

  echo "using bosh CLI version..."
  bosh version

  echo "finalizing CPI release..."
  bosh finalize release ${artifacts_dir}/*.tgz --version $integer_version

  rm config/private.yml

  git diff | cat
  git add .

  git config --global user.email cf-bosh-eng@pivotal.io
  git config --global user.name CI
  git commit -m ":airplane: New final release v $integer_version" -m "[ci skip]"
popd
