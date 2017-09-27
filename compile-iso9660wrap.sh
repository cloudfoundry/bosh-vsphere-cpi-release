#!/usr/bin/env bash

pushd src/iso9660wrap
  for platform in linux darwin; do
    echo "building iso9660wrap-${platform}-amd64"
    GOOS=${platform} GOARCH=amd64 CGO_ENABLED=0 go build \
      -o iso9660wrap-${platform}-amd64 ./...
  done
popd
