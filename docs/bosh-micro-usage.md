## Experimental `bosh-micro` usage

#### Caveats: the vSphere cpi release currently only works on Linux, and bosh-micro is still under development.

To start experimenting with vsphere-cpi-release and bosh-micro-cli:

1. [Install the bosh-micro-cli](https://github.com/cloudfoundry/bosh-micro-cli#set-up-a-workstation-for-development)

1. Create a deployment directory

```
mkdir my-micro-deployment
```

1. Create a deployment manifest `manifest.yml` inside the deployment directory with following properties, replacing the <values>.

```
---
# replace all values between angle brackets! < ... >
name: my-micro-deployment

networks:
- name: default
  type: manual
  ip: <vm ip>
  netmask: <netmask>
  gateway: <gateway>
  dns: [<dns server ip>]
  cloud_properties:
    name: <vCenter configured network name>

resource_pools:
- name: default
  network: default
  cloud_properties: {"ram":1024,"cpu":1,"disk":10_000}

# bosh job properties go here

cloud_provider:
  template: {name: cpi, release: bosh-vsphere-cpi}

  # Tells bosh-micro how to contact remote agent
  mbus: https://<mbus-user>:<mbus-password>@<vm ip>:<agent-mbus-port>

  properties:
    agent: # Tells CPI how agent should listen for requests
      mbus: "https://<mbus-user>:<mbus-password>@0.0.0.0:<agent-mbus-port>"
    blobstore:
      provider: local
      path: /var/vcap/micro_bosh/data/cache
    director:
      db:
        adapter: sqlite
        database: ':memory:'
    ntp: [<ntp ip>]
    vcenter: # these will match jobs[bosh].properties.vcenter properties
      address: <vcenter ip>
      user: <user>
      password: <pass>
      datacenters:
        - name: <datacenter name>
          vm_folder: <vm folder name>
          template_folder: <tempalte folder name>
          disk_path: <disk path folder name>
          datastore_pattern: '<ephemeral datastores regex>'
          persistent_datastore_pattern: '<persistent datastores regex>'
          clusters:
            - <cluster name>:
                resource_pool: <resource pool name>
```

1. Set the micro deployment

```
bosh-micro deployment my-micro-deployment/manifest.yml
```

1. Create the vsphere-cpi-release tarball

```
git clone git@github.com:cloudfoundry/bosh.git ~/workspace/bosh
cd ~/workspace/bosh/vsphere-cpi-release
bundle
bundle exec rake release:create_vsphere_cpi_release
bundle exec bosh create release --with-tarball $(ls -tr dev_releases/vsphere_cpi/vsphere_cpi-0+dev.*.yml | tail -1)
```

1. Download a vSphere stemcell from the [BOSH Artifacts Page](http://boshartifacts.cloudfoundry.org/file_collections?type=stemcells)

1. Deploy the micro with the downloaded stemcell

```
bosh-micro deploy $(ls -tr dev_releases/vsphere_cpi/vsphere_cpi-0+dev.*.tgz | tail -1) ~/Downloads/stemcell.tgz
```

