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
  bosh create-release --force --tarball vsphere-cpi.tgz
popd
```

## Running tests

Unit tests:
```bash
$SRC_DIR/bin/test-unit
```

Integration tests:
Create the lifecycle.env file with the following [environment variables](https://github.com/cloudfoundry/bosh-vsphere-cpi-release/blob/bc88e607b08cf89bc359d69688567e1def093391/src/vsphere_cpi/spec/support/lifecycle_helpers.rb#L8-L32):

```bash
source lifecycle.env
$SRC_DIR/bin/test-integration
```

## CI Pipeline Management (for VMware internal development)

We use vane-provided environments in bosh-vsphere-cpi tests. Vane deploys nimbus testbeds using the **svc.tas-anycloud** service account. These tests are run on the [BOSH Ecosystem CI](https://ci.bosh-ecosystem.cf-app.com/teams/vsphere-cpi/pipelines/vsphere-cpi). 

Vane environments are created by [this pipeline](https://ci.bosh-ecosystem.cf-app.com/teams/vsphere-cpi/pipelines/vcpi-nimbus) and freed up by [this one](https://ci.bosh-ecosystem.cf-app.com/teams/vsphere-cpi/pipelines/vcpi-testbed-cleanup).

This pipeline was set up with [vane CLI](https://gitlab.eng.vmware.com/tas-vcf-vmc-anycloud/vane). We forked the original [vane CLI](https://gitlab.eng.vmware.com/PKS/vane) and broke its re-usability in order to make it work more easily for our use case.

Vane is using a recipe for the environments that is defined in the `Vanefile` and runs a bunch of scripts in the provided directory. We store our recipe and scripts here: [https://gitlab.eng.vmware.com/tas-vcf-vmc-anycloud/vcpi-nimbus](https://gitlab.eng.vmware.com/tas-vcf-vmc-anycloud/vcpi-nimbus)

**To set the vcpi-nimbus (pool management) pipeline** 

- make sure that you have a concourse target that targets the vsphere-cpi team in the bosh-ecosystem concourse
- in the `vcpi-nimbus` repository:
  - `vane pipeline --target=vsphere-cpi --pipeline=vcpi-nimbus`

> **Note:** this script relies on `fly targets` to work without specifying a target, so if you are using the clever fly-version wrapper script from @ystros, you will likely have to either undo it, or add a hack to it to pick a default target when none is specified.

**To set the vsphere-cpi test pipeline**

- make sure that you have a concourse target that targets the vsphere-cpi team in the bosh-ecosystem concourse
- in the `ci` folder of this repository:
  - `CONCOURSE=vsphere-cpi rake pipeline[vsphere-cpi]`

## To use a pooled testbed for development testing (for VMware internal development)

The pool of testbeds managed by vcpi-nimbus is here: [https://gitlab.eng.vmware.com/tas-vcf-vmc-anycloud/vcpi-pool](https://gitlab.eng.vmware.com/tas-vcf-vmc-anycloud/vcpi-pool)

Get the jumpbox, vcenter and NSX-T manager IPs and access credentials in the pool lock files.

Use sshuttle to bridge into the private network
```
$ sshuttle -r vcpi@<BOSH_VSPHERE_JUMPER_HOST> 192.168.111.0/24 30.0.0.0/16 --dns
Password: vcpi
```

If trying to install the bosh cpi on a vane jumpbox, you’ll need the following installed
```
sudo apt install vim git gcc libcurl4-openssl-dev libc6-dev make libssl-dev ruby
```

## Generating Ruby client libraries

### NSX-T manager client

NSX-T manager client is generated with [swagger-codegen](https://github.com/swagger-api/swagger-codegen) of major version `2`. To install `swagger-codegen` version `2.x.x` run the following:

```
brew install swagger-codegen@2

export PATH="/usr/local/opt/swagger-codegen@2/bin:$PATH"

cd src/vsphere_cpi
bundle exec rake swagger:nsxt_manager_client
```

## Cutting New Releases

To cut a new release, once everything has passed the `pre-release-fan-in` job:

* Decide whether to cut a major, minor, or patch release depending on the changes.
* Trigger the corresponding `release-new-<VERSION>` job to bump the version. For example, for major jobs, trigger **[release-new-major](https://ci.bosh-ecosystem.cf-app.com/teams/vsphere-cpi/pipelines/vsphere-cpi/jobs/release-new-major)**.
* The **[promote-candidate](https://ci.bosh-ecosystem.cf-app.com/teams/vsphere-cpi/pipelines/vsphere-cpi/jobs/promote-candidate)** job will automatically trigger based on the new version. This will finalize the release and publish a release on GitHub.
* Go to [https://github.com/cloudfoundry/bosh-vsphere-cpi-release/releases](https://github.com/cloudfoundry/bosh-vsphere-cpi-release/releases)
* Edit the automatically generated release to add any details not included in the auto-generated release notes.
