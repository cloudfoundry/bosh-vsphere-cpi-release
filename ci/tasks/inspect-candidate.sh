#! /usr/bin/env bash

set -e

# The project ID of the BOSH vSphere CPI's public Pivotal tracker project
PROJECT_ID=2110693

# The root URL of the Pivotal Tracker API
API_ROOT='https://www.pivotaltracker.com/services/v5'

GIT=(git -C bosh-cpi-src)

# Create an integer version number from the semantic version format. May be
# changed when we decide to fully use semantic versions for releases.
integer_version="$(cut -d . -f1 release-version-semver/number)"

printf '\e[32;01m=== BOSH vSphere CPI release %s ===\e[0m\n' $integer_version

# Get the last referenced story number in a commit message body
id=$("${GIT[@]}" log --format=%b | sed -En 's/^\[#([0-9]*)\].*/\1/p' | head -1)

# Show the last merged story with its URL
story_url="https://www.pivotaltracker.com/story/show/$id"
printf '\n\e[33;01mLast merged story\e[0m (%s):\n' "$story_url"

# Show the story name if available
api_url="$API_ROOT/projects/$PROJECT_ID/stories/$id"
if name="$(curl -sS "$api_url" | jq -r .name)"; then
  printf '%s\n' "$name"
else
  echo -e '\e[31;01mUnable to retrieve story from Pivotal Tracker\e[0m'
fi

# Show the last commit in detail
echo -e '\n\e[33;01mLast commit\e[0m:'
# Concourse can't handle `git log` even with a TERM override
"${GIT[@]}" log -1 | cat

# Unpack the release tarball
mkdir -p unpack-release
tar -C unpack-release -xzf bosh-cpi-artifacts/*.tgz

date=$(date -r unpack-release/release.MF +'%B %d, %Y at %H:%M:%S %Z')

# Show the manifest in the release tarball
printf '\n\e[33;01mRelease manifest\e[0m (from %s):\n' "$date"
cat unpack-release/release.MF
