#!/usr/bin/env bash

check_param() {
  local name=$1
  local value=$(eval echo '$'$name)
  if [ "$value" == 'replace-me' ]; then
    echo "environment variable $name must be set"
    exit 1
  fi
}

print_git_state() {
  echo "--> last commit..."
  TERM=xterm-256color git log -1
  echo "---"
  echo "--> local changes (e.g., from 'fly execute')..."
  TERM=xterm-256color git status --verbose
  echo "---"
}

check_for_rogue_vm() {
  local ip=$1
  set +e
  nc -vz -w10 $ip 22
  status=$?
  set -e
  if [ "${status}" == "0" ]; then
    echo "aborting due to vm existing at ${ip}"
    exit 1
  fi
}

env_attr() {
  local json=$1
  echo $json | jq --raw-output --arg attribute $2 '.[$attribute]'
}

log() {
  local message="$1"
  echo "$(date +"%Y-%m-%d %H:%M:%S") ----- $message"
}
