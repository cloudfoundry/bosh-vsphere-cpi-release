#!/usr/bin/env bash
set -euo pipefail

fly="${FLY_CLI:-fly}"
concourse_target="${CONCOURSE_TARGET:-bosh-ecosystem}"
repo="${REPO:-https://github.com/cloudfoundry/bosh-vsphere-cpi-release.git}"
branch="${BRANCH:-$(git symbolic-ref -q --short HEAD 2>/dev/null || echo master)}"

if [[ -n "${PIPELINE:-}" ]]; then
  pipeline_name="$PIPELINE"
elif [[ "$branch" == "master" ]]; then
  pipeline_name="vsphere-cpi-oss"
else
  pipeline_name="vcpi-$branch"
fi

echo "Configuring pipeline '$pipeline_name' on target '$concourse_target'..."

until "${fly}" -t "${concourse_target}" status; do
  "${fly}" -t "${concourse_target}" login
  sleep 1
done

"${fly}" -t "${concourse_target}" set-pipeline \
  --team main \
  -p "${pipeline_name}" \
  -c "$(dirname "$0")/pipeline/pipeline.yml" \
  -v "vcpi_url=${repo}" \
  -v "vcpi_branch=${branch}"