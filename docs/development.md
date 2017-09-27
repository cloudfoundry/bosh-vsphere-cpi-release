## Development

The release requires the Ruby gem Bundler (used by the vendoring script):

```
gem install bundler
```

With bundler installed, run the vendoring script:

```bash
$SRC_DIR/vendor_gems
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
