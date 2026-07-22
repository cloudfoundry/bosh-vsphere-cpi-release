#!/usr/bin/env bash

source environment/metadata
export HTTP_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export HTTPS_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export NO_PROXY=.amazonaws.com,rubygems.org,gcr.io

private_key_path=$(mktemp)
echo -e "${JUMPBOX_PRIVATE_KEY}" > ${private_key_path}

export BOSH_ALL_PROXY="ssh+socks5://vcpi@${BOSH_VSPHERE_JUMPER_HOST}:22?private-key=${private_key_path}"
