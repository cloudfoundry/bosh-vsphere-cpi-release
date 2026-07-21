#!/usr/bin/env bash

source environment/metadata
export HTTP_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export HTTPS_PROXY="http://$BOSH_VSPHERE_JUMPER_HOST:80"
export NO_PROXY=localhost,127.0.0.1,30.0.1.1,.amazonaws.com,rubygems.org,gcr.io
export no_proxy="$NO_PROXY"

private_key_path=$(mktemp)
echo -e "${JUMPBOX_PRIVATE_KEY}" > ${private_key_path}

export BOSH_ALL_PROXY="ssh+socks5://vcpi@${BOSH_VSPHERE_JUMPER_HOST}:22?private-key=${private_key_path}"
