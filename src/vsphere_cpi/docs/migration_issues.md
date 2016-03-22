# Migration issues

This document lists different migration cases, symptoms and errors that can be observed in vSphere CPI.


## vMotion migrates VM (disks are in the shared datastore)

We triggered vMotion by migrating VM manually from one host to another.

### Symptoms

In VM `Events` there is an event called `Task: Migrate virtual machine` and the `User` is root if it was migrated by user or empty if it was migrated automatically.

### Tests

* Changing IP address succeeds and VM changes IP.

* Changing persistent disk size suceeds and disk changes size.

* Changing release succeeds.


## DRS migrates VM + disk

### Symptoms

* When disks are migrated by DRS they are getting migrated into VM folder on destination datastore.

* In datastore2 in `Events` there is `Migrating vm…` and `User` is empty.

### Tests

* Changing IP address succeeds

* Changing persistent disk size fails with error

```
E, [2014-08-05T17:00:21.733100 #10347] [task:35] ERROR -- : File [datastore1] SYSTEM_MICRO_VSPHERE_Disks/disk-91e434ae-c14c-4146-abfe-def5d57426f7.vmdk was not found
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/client.rb:273:in `block in wait_for_task'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/client.rb:246:in `loop'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/client.rb:246:in `wait_for_task'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/client.rb:196:in `block in delete_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/client.rb:196:in `each'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/client.rb:196:in `delete_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:570:in `block in delete_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_common-1.0000.0/lib/common/thread_formatter.rb:46:in `with_thread_name'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:562:in `delete_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:188:in `delete_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:292:in `update_persistent_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:72:in `block in update'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:37:in `step'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:72:in `update'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/job_updater.rb:74:in `block (2 levels) in update_canary_instance'
```

Old disk is present in the second (destination) datastore in VM folder

New disk was created in first datastore in SYSTEM_MICRO_VSPHERE_DISKS as specified in disk_path in manifest.

* Subsequent deploy fail with the same error. Since the first persistent disk update did not succeed BOSH keeps track of first disk and tries to delete it.

## VM was moved to different datastore by user

Exact same behavior was observed as with `DRS migrates VM`. The symptom would be that in `Tasks & Events` in Events section `Migrating of virtual machine …` would be initiated by `root`.


## DRS migrates disk (without migrating VM)

To turn disk only migration without VM itself we set DRS rules to not keep VMDKs together for our VM. After applying DRS migration only disks were migrated without VM itself.

### Symptoms

In datastore1 `Events` there is an event `Migrating vm-… from datastore 1` and `User` is empty.

### Tests

* After moving ephemeral disk back and leaving persistent disk on old datastore we still see the same error as above.


## User migrates disk

### Symptoms

In datastore1 `Events` there is an event `File … was moved` and `User` is `root`.

### Issues

If user only migrates the disk he will get the error `…vmdk is locked` so he has to manually power off VM to move the disk. After the disk is moved VM fails to start up in vSphere with the error `File [datastore1] SYSTEM_MICRO_VSPHERE_Disks/disk-…vmdk was not found`.

If we reattach the migrated disk in VM settings changing `bosh deploy` fails with error:

```
E, [2014-08-05T21:06:55.601512 #14766] [canary_update(dummy/0)] ERROR -- : Error updating canary instance: #<RuntimeError: Ephemeral disks should all be on the same datastore.>
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:726:in `block in get_primary_datastore'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:724:in `each'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:724:in `get_primary_datastore'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:711:in `get_vm_location'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:490:in `block in attach_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_common-1.0000.0/lib/common/thread_formatter.rb:46:in `with_thread_name'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh_vsphere_cpi-1.0000.0/lib/cloud/vsphere/cloud.rb:404:in `attach_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:257:in `update_persistent_disk'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:72:in `block in update'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:37:in `step'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/instance_updater.rb:72:in `update'
/var/vcap/packages/director/gem_home/ruby/1.9.1/gems/bosh-director-1.0000.0/lib/bosh/director/job_updater.rb:74:in `block (2 levels) in update_canary_instance'
```


## Disk was removed by user

Exactly the same issues as in `User migrates VM` which is not a supported behavior. In datastore1 in `Events` there is an event `File .. deleted from datastore1` and `User` is root.

If the disk is removed from VM settings `bosh deploy` fails with error:

```
 Started preparing deployment > Binding existing deployment. Failed: Timed out sending `get_state' to 5727b60e-cb08-4b0b-a074-4c01df483acd after 45 seconds (00:02:15)
 ```

Agent keeps restarting, in agent logs:

```
App setup Running bootstrap: Setting up epehmeral disk: Calculating partition sizes. Getting device size: Running command: 'sfdik -s /dev/sdb', stdout: '', stderr: '/dev/sdb: No such file or directory'
sfdisk: cannot open /dev/sdb for reading
': exit status 1
```


## VM was removed by user (without detaching disk)

When VM was removed the disk was removed with it. In `Events` of datastore one there is a record `File …vmdk deleted from datastore1` and `User` is root.

* Disk will be removed even if it's outside of the VM folder

---
## Local Storage
* Local storage configuration is possible but is not a recommended topology due to the single point of failure that can cause interruptions when a connection becomes unreliable or fails - [VMware documentation](https://pubs.vmware.com/vsphere-55/index.jsp?topic=%2Fcom.vmware.vsphere.storage.doc%2FGUID-5F08F7A7-6D8E-45A6-B408-278B3A4C7D4C.html).
* Local storage does not support sharing across multiple hosts. Only one host has access to a datastore on a local storage device. As a result, although you can use local storage to create virtual machines, it prevents you from using VMware features that require shared storage, such as HA and vMotion. However, if you use a cluster of hosts that have just local storage devices, you can implement Virtual SAN or vSphere Storage Appliance.
* Local storage is ideal for scenarios where persistence of data volumes and HA is not required. Some of the benefits include reduced disk I/O latency and cost reduction from using inexpensive local disks. [source](http://cloudstack-administration.readthedocs.org/en/latest/storage.html)

## vMotion migrates VM + disk (disks are in the local datastores)
We triggered vMotion by migrating VM manually from one host to another. User can only select compatible hosts/disks with each other.

### Symptoms
* When a deployment is deleted, an empty directory (vm-xxxxx) remains in the local datastore of the host it was deployed on (seems to be vmware side effect).
* The env.iso file (mentioned below in Issues) can be seen on the initial host's local datastore after migration. When the deployment is deleted, this file gets removed but an empty directory remains.

### Issues
In VM `Events` there is an event called `Task: Relocate virtual machine` and a warning is generated that states:
```
Event Type Description:
The virtual machine can be migrated but might lose some functionality after migration is complete

Possible Causes:
Migrating the virtual machine to the destination resource pool is likely to succeed but some functionality might not work correctly afterward because the virtual machine did not meet all the compatability criteria.
Action: Use the VSphere Client to check for the warnings at the time of the failure so that you can identify possible reasons for this problem.
```
The VSphere Client showed the following compability warning:
```
"Device" 'CD/DVD drive 1' uses backing '[local-ds] vm-xxxxxx/env.iso', which is not accessible.
```

### Tests
* Changing IP address succeeds and VM changes IP
* Changing root disk size succeeds and disk changes size.
* Deleting deployment after migration
* Migrating to another host and then back to the initial hosts succeeds

## vMotion migrates VM + local ephemeral disk, then adds persistent disk
We followed the same steps as stated in **vMotion migrates VM + disk (disks are in the local datastores)**. After the VM was manually moved, we added a persistent disk via the manifest. Then, via vMotion we attempted to manually migrate the VM + local disks again.

### Symptoms
When the persistent disk is attached, it recreates the env.iso in the current local disk and removes the env.iso from the previous local disk.
In VM `Events`, there is an event called `Task: Reconfigure virtual machine` without any warnings/errors.

### Issues
After attaching persistent disk, vMotion prevents the ability to manually migrate the VM + disk with the following **error**:
```
"Currently connected device" 'CD/DVD drive 1' uses backing '[local2-ds] vm-xxxxxx/env.iso', which is not accessible.
```
This occurs when selecting the compute resource.
