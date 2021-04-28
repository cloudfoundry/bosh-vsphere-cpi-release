## Development

The release requires the Ruby gem Bundler (used by the vendoring script):

```
gem install bundler
```

With bundler installed, run the vendoring script:

```bash
scripts/vendor_gems
```

To create a dev release:

```bash
pushd $RELEASE_DIR
  ./compile-iso9660wrap.sh
  bosh create-release --force --tarball vsphere-cpi.tgz
popd
```

## Running tests

Unit tests:
```bash
$SRC_DIR/bin/test-unit
```

Integration tests:
Create the lifecycle.env file with the following [environment variables](https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release/blob/bc88e607b08cf89bc359d69688567e1def093391/src/vsphere_cpi/spec/support/lifecycle_helpers.rb#L8-L32):

```bash
source lifecycle.env
$SRC_DIR/bin/test-integration
```

## Generating clients

### NSX-T manager client

NSX-T manager client is generated with [swagger-codegen](https://github.com/swagger-api/swagger-codegen) of major version `2`. To install `swagger-codegen` version `2.x.x` run the following:

```
brew install swagger-codegen@2

export PATH="/usr/local/opt/swagger-codegen@2/bin:$PATH"

cd src/vsphere_cpi
bundle exec rake swagger:nsxt_manager_client
```