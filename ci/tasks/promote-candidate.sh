#!/usr/bin/env bash

set -e

source bosh-cpi-src/.envrc

: ${AWS_ACCESS_KEY_ID:?}
: ${AWS_SECRET_ACCESS_KEY:?}
: ${AWS_ASSUME_ROLE_ARN:?}


artifacts_dir=$(realpath bosh-cpi-artifacts)

version="$(cat release-version-semver/version)"
echo "v${version}" > final-release-tag/tag

# copy the input release repository into its output location
cp -a bosh-cpi-src/. updated-repo/

pushd updated-repo
  echo "creating config/private.yml with blobstore secrets"
  cat > config/private.yml << EOF
---
blobstore:
  provider: s3
  options:
    access_key_id: $AWS_ACCESS_KEY_ID
    secret_access_key: $AWS_SECRET_ACCESS_KEY
    assume_role_arn: $AWS_ASSUME_ROLE_ARN
EOF

  echo "finalizing CPI release..."
  bosh finalize-release ${artifacts_dir}/*.tgz --version $version

  rm config/private.yml

  git diff | cat
  git add .

  git config --global user.email cf-bosh-eng@pivotal.io
  git config --global user.name CI
  git commit -m ":airplane: New final release v $version"
popd
