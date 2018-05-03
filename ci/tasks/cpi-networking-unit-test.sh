#!/usr/bin/env bash

cd source-ci/src/vsphere_cpi
bundle install
bundle exec rspec spec/unit
