#! /usr/bin/env bash

cd bosh-cpi-src/src/vsphere_cpi
bundle install
bundle exec rspec spec/unit
