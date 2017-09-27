#!/usr/bin/env bash
source .envrc

pushd $ISO9660WRAP_SRC_DIR
  for platform in linux darwin; do
    echo "building iso9660wrap-${platform}-amd64"
    GOOS=${platform} GOARCH=amd64 CGO_ENABLED=0 go build \
      -o iso9660wrap-${platform}-amd64 ./...
  done
popd
