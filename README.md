##### vSphere-CPI CI pipeline Status 

| Job | Status |
| :--- | :--- |
| Unit | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/unit-test/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|
| Lifecycle-6.0 with NSXV | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/lifecycle-6.0-NSXV/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|
| Lifecycle-6.5 with NSXT-21 | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/lifecycle-6.5-NSXT21/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|
| Lifecycle-6.5 with NSXT-22 | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/lifecycle-6.5-NSXT22/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|
| Lifecycle-6.7 with NSXT-22 | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/lifecycle-6.7-NSXT22/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|
| Lifecycle-6.7 with NSXT-23 | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/lifecycle-6.7-NSXT23/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|
| BATS | [![ci.vcna.io](https://ci.vcna.io/api/v1/teams/vcpi/pipelines/vSphere-CPI/jobs/bats/badge)](https://ci.vcna.io/teams/vcpi/pipelines/vSphere-CPI?groups=Complete-View)|

# BOSH vSphere CPI Release

The `vsphere` CPI can be used with [VMware vSphere](https://www.vmware.com/products/vsphere.html).

* Documentation: [bosh.io/docs](https://bosh.io/docs) and [bosh.io/docs/vsphere-cpi](https://bosh.io/docs/vsphere-cpi.html)
* Slack: #bosh on <https://slack.cloudfoundry.org>
* Release: [cloudfoundry-incubator/bosh-vsphere-cpi-release](https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release)
* Issues: [GitHub Issues](https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release/issues)
* Mailing list: [cf-bosh](https://lists.cloudfoundry.org/pipermail/cf-bosh)
* Roadmap: [Pivotal Tracker](https://www.pivotaltracker.com/n/projects/2110693)

This is a BOSH release for the vSphere CPI.

See [Initializing a BOSH environment on vSphere](https://bosh.io/docs/init-vsphere.html) for example usage.

## Development

See [development doc](docs/development.md).

See [vSphere API Docs](http://pubs.vmware.com/vsphere-60/topic/com.vmware.wssdk.apiref.doc/right-pane.html).

## Requirements

An environment running one of the following supported releases:

  * [vSphere 6.0](https://docs.vmware.com/en/VMware-vSphere/6.0/rn/vsphere-esxi-vcenter-server-60-release-notes.html) (actively tested)
  * [vSphere 6.5](https://docs.vmware.com/en/VMware-vSphere/6.5/rn/vsphere-esxi-vcenter-server-65-release-notes.html) (actively tested)
  * [vSphere 6.7](https://docs.vmware.com/en/VMware-vSphere/6.7/rn/vsphere-esxi-vcenter-server-67-release-notes.html) (actively tested)

NSX Support:

  * [NSX](https://docs.vmware.com/en/VMware-NSX-for-vSphere/index.html)
  * [NSX-T](https://docs.vmware.com/en/VMware-NSX-T/index.html)

## Concepts

The following table maps BOSH concepts to their vSphere-native equivalents.

| BOSH | vSphere |
| ---- | ------- |
| Availability Zone | [Clusters](https://docs.vmware.com/en/VMware-vSphere/6.0/com.vmware.vsphere.monitoring.doc/GUID-A47D16C9-0B07-4DB8-BB79-D67DD97D5194.html?hWord=N4IghgNiBcIMYQK4GcAuBTATskBfIA)/[Resource Pools](https://docs.vmware.com/en/VMware-vSphere/6.0/com.vmware.vsphere.monitoring.doc/GUID-74D23242-B353-4267-8CC3-7800DD9BB92A.html) |
| Virtual Machine | [Virtual Machine](https://docs.vmware.com/en/VMware-vSphere/6.5/com.vmware.vsphere.vm_admin.doc/GUID-55238059-912E-411F-A0E9-A7A536972A91.html) |
| VM Config Metadata | Virtual Device ISO |
| Network Subnet | [Networking](https://docs.vmware.com/en/VMware-vSphere/6.0/com.vmware.vsphere.networking.doc/GUID-35B40B0B-0C13-43B2-BC85-18C9C91BE2D4.html) |
| Persistent Disk | [Virtual Hard Disk](https://docs.vmware.com/en/VMware-vSphere/6.5/com.vmware.vsphere.vm_admin.doc/GUID-79116E5D-22B3-4E84-86DF-49A8D16E7AF2.html) |
| Stemcell | [Virtual Machine](https://docs.vmware.com/en/VMware-vSphere/6.5/com.vmware.vsphere.vm_admin.doc/GUID-55238059-912E-411F-A0E9-A7A536972A91.html) |


## Feature Support

The following sections describe some specific BOSH features supported by the CPI.


### Network

The CPI supports multiple NICs being attached to a single VM.

| Network Type | Support |
| ------------ | ------- |
| Manual | Multiple networks per instance |
| Dynamic | Not Supported |
| VIP | Not Supported |


### Encryption

vSphere supports disk encryption and customer-managed keys when managed through policy configuration within the vCenter 6.5+ ([learn more](https://docs.vmware.com/en/VMware-vSphere/6.7/com.vmware.vsphere.security.doc/GUID-A29066CD-8EF8-4A4E-9FC9-8628E05FC859.html)). For this functionality, encryption occurs at the hypervisor level which is transparent to the VM. Once enabled within vCenter, no additional configuration is required for the CPI.

| Disk Type | Encryption |
| --------- | ---------- |
| Root Disk | Supported |
| Ephemeral Disk | Supported |
| Persistent Disk | Supported |


### Miscellaneous

| Feature | Support |
| ------- | ------- |
| Multi-CPI | Supported, [v34](https://github.com/cloudfoundry-incubator/bosh-vsphere-cpi-release/releases/tag/v34)+ |
| Native Disk Resize | Not Supported |
