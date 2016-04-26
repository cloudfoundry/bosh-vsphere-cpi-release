require 'spec_helper'

describe VSphereCloud::Resources::Datacenter do
  subject(:datacenter) {
    described_class.new({
      client: client,
      name: datacenter_name,
      vm_folder: 'fake-vm-folder',
      template_folder: 'fake-template-folder',
      clusters: {'cluster1' => cluster_config1, 'cluster2' => cluster_config2},
      disk_path: 'fake-disk-path',
      ephemeral_pattern: ephemeral_pattern,
      persistent_pattern: persistent_pattern,
      use_sub_folder: datacenter_use_sub_folder,
      logger: logger,
      mem_overcommit: 0.5,
    })
  }
  let(:log_output) { StringIO.new("") }
  let(:logger) { Logger.new(log_output) }
  let(:client) { instance_double('VSphereCloud::VCenterClient') }

  let(:vm_folder) { instance_double('VSphereCloud::Resources::Folder') }
  let(:vm_subfolder) { instance_double('VSphereCloud::Resources::Folder') }

  let(:datacenter_use_sub_folder) { false }

  let(:template_folder) { instance_double('VSphereCloud::Resources::Folder') }
  let(:template_subfolder) { instance_double('VSphereCloud::Resources::Folder') }
  let(:datacenter_mob) { instance_double('VimSdk::Vim::Datacenter') }
  let(:cluster_mob1) { instance_double('VimSdk::Vim::Cluster') }
  let(:cluster_mob2) { instance_double('VimSdk::Vim::Cluster') }
  let(:cluster_config1) { instance_double('VSphereCloud::ClusterConfig', resource_pool: nil, name: 'cluster1') }
  let(:cluster_config2) { instance_double('VSphereCloud::ClusterConfig', resource_pool: nil, name: 'cluster2') }
  let(:ephemeral_pattern) {instance_double('Regexp')}
  let(:persistent_pattern) {instance_double('Regexp')}
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:datastore_properties) { {} }
  let(:datastore) { instance_double('VSphereCloud::Resources::Datastore', name: 'fake-datastore') }
  let(:disk) { instance_double('VSphereCloud::Resources::PersistentDisk', path: 'fake-disk-path') }

  let(:datacenter_name) { 'fake-datacenter-name' }
  before do
    allow(client).to receive(:find_by_inventory_path).with(datacenter_name).and_return(datacenter_mob)
    allow(client).to receive(:cloud_searcher).and_return(cloud_searcher)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-vm-folder', logger, client, datacenter_name
    ).and_return(vm_folder)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-vm-folder/fake-uuid', logger, client, datacenter_name
    ).and_return(vm_subfolder)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-template-folder', logger, client, datacenter_name
    ).and_return(template_folder)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-template-folder/fake-uuid', logger, client, datacenter_name
    ).and_return(template_subfolder)

    allow(cloud_searcher).to receive(:get_managed_objects).with(
      VimSdk::Vim::ClusterComputeResource,
      root: datacenter_mob, include_name: true
    ).and_return(
      [
        ['cluster1', cluster_mob1],
        ['cluster2', cluster_mob2],
      ]
    )

    allow(cloud_searcher).to receive(:get_properties).with(
      cluster_mob1,
      VimSdk::Vim::ClusterComputeResource,
      VSphereCloud::Resources::Cluster::PROPERTIES,
      ensure_all: true
    ).and_return({ cluster_mob1 => {} })
    allow(cloud_searcher).to receive(:get_properties).with(
        cluster_mob2,
        VimSdk::Vim::ClusterComputeResource,
        VSphereCloud::Resources::Cluster::PROPERTIES,
        ensure_all: true
      ).and_return({ cluster_mob2 => {} })

    allow(cloud_searcher).to receive(:get_properties).with(
      nil, VimSdk::Vim::Datastore, VSphereCloud::Resources::Datastore::PROPERTIES
    ).and_return(datastore_properties)
    allow(Bosh::Clouds::Config).to receive(:uuid).and_return('fake-uuid')
  end

  describe '#mob' do
    context 'when mob is found' do
      it 'returns the datacenter mob' do
        expect(datacenter.mob).to eq(datacenter_mob)
      end
    end
    context 'when mob is not found' do
      before { allow(client).to receive(:find_by_inventory_path).with('fake-datacenter-name').and_return(nil) }
      it 'raises' do
        expect { datacenter.mob }.to raise_error(RuntimeError, "Datacenter 'fake-datacenter-name' not found")
      end

    end
  end

  describe '#vm_folder' do
    context 'when datacenter does not use subfolders' do
      let(:datacenter_use_sub_folder) { false }

      it "returns a folder object using the datacenter's vm folder" do
        expect(datacenter.vm_folder).to eq(vm_folder)
      end
    end

    context 'when datacenter uses subfolders' do
      let(:datacenter_use_sub_folder) { true }

      it 'returns multi-tenant folder' do
        expect(datacenter.vm_folder).to eq(vm_subfolder)
      end
    end
  end

  describe '#master_vm_folder' do
    it "returns a folder object using the datacenter's vm folder" do
      expect(datacenter.master_vm_folder).to eq(vm_folder)
    end
  end

  describe '#template_folder' do
    context 'when datacenter does not use subfolders' do
      let(:datacenter_use_sub_folder) { false }

      it "returns a folder object using the datacenter's vm folder" do
        expect(datacenter.template_folder).to eq(template_folder)
      end
    end

    context 'when datacenter uses subfolders' do
      let(:datacenter_use_sub_folder) { true }

      it 'returns subfolder' do
        expect(datacenter.template_folder).to eq(template_subfolder)
      end
    end
  end

  describe '#master_template_folder' do
    it "returns a folder object using the datacenter's template folder" do
      expect(datacenter.master_template_folder).to eq(template_folder)
    end
  end

  describe '#name' do
    it 'returns the datacenter name' do
      expect(datacenter.name).to eq('fake-datacenter-name')
    end
  end

  describe '#disk_path' do
    it ' returns the datastore disk path' do
      expect(datacenter.disk_path).to eq('fake-disk-path')
    end
  end

  describe '#ephemeral_pattern' do
    it 'returns a Regexp object defined by the configuration' do
      expect(datacenter.ephemeral_pattern).to eq(ephemeral_pattern)
    end
  end

  describe '#persistent_pattern' do
    it 'returns a Regexp object defined by the configuration' do
      expect(datacenter.persistent_pattern).to eq(persistent_pattern)
    end
  end

  describe '#inspect' do
    it 'includes the mob and the name of the datacenter' do
      expect(datacenter.inspect).to eq("<Datacenter: #{datacenter_mob} / fake-datacenter-name>")
    end
  end

  describe '#clusters' do
    it 'returns a hash mapping from cluster name to a configured cluster object' do
      clusters = datacenter.clusters
      expect(clusters.keys).to match_array(['cluster1', 'cluster2'])
      expect(clusters['cluster1'].name).to eq('cluster1')
      expect(clusters['cluster1'].datacenter).to eq(datacenter)
      expect(clusters['cluster2'].name).to eq('cluster2')
      expect(clusters['cluster2'].datacenter).to eq(datacenter)
    end

    context 'when a cluster mob cannot be found' do
      it 'raises an exception' do
        allow(cloud_searcher).to receive(:get_managed_objects).with(
                           VimSdk::Vim::ClusterComputeResource,
                           root: datacenter_mob, include_name: true).and_return(
                           {
                             'cluster2' => cluster_mob2,
                           }
                         )

        allow(cloud_searcher).to receive(:get_properties).with(
                           [cluster_mob2],
                           VimSdk::Vim::ClusterComputeResource,
                           VSphereCloud::Resources::Cluster::PROPERTIES,
                           ensure_all: true).and_return({ cluster_mob2 => {} })


        expect { datacenter.clusters }.to raise_error(/Can't find cluster 'cluster1'/)
      end
    end
  end

  describe '#clusters_hash' do
    it 'returns a hash mapping from cluster name to a lightweight hash' do
      first_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'first-datastore',
        free_space: 4000
      )
      second_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'second-datastore',
        free_space: 8000
      )
      third_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'third-datastore',
        free_space: 16000
      )

      allow(datacenter).to receive(:clusters).and_return({
        'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          free_memory: 1024,
          all_datastores: {
            first_datastore.name => first_datastore,
            third_datastore.name => third_datastore
          },
        ),
        'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          free_memory: 2048,
          all_datastores: {
            first_datastore.name => first_datastore,
            second_datastore.name => second_datastore
          }
        ),
      })

      expect(datacenter.clusters_hash).to eq({
        'first-cluster' => {
          memory: 1024,
          datastores: {
            'first-datastore' => 4000,
            'third-datastore' => 16000
          }
        },
        'second-cluster' => {
          memory: 2048,
          datastores: {
            'first-datastore' => 4000,
            'second-datastore' => 8000
          }
        }
      })
    end
  end

  describe '#find_cluster' do
    context 'when cluster exists' do
      it 'return the cluster' do
        cluster = datacenter.find_cluster('cluster1')
        expect(cluster.name).to eq('cluster1')
      end
    end

    context 'when cluster does not exist' do
      it 'raises an exception' do
        allow(cloud_searcher).to receive(:get_managed_objects).with(
          VimSdk::Vim::ClusterComputeResource,
          root: datacenter_mob, include_name: true
        ).and_return({'cluster2' => cluster_mob2})

        allow(cloud_searcher).to receive(:get_properties).with(
          [cluster_mob2],
          VimSdk::Vim::ClusterComputeResource,
          VSphereCloud::Resources::Cluster::PROPERTIES,
          ensure_all: true
        ).and_return({ cluster_mob2 => {} })

        expect {datacenter.find_cluster('cluster1')}.to raise_error(/Can't find cluster 'cluster1'/)
      end
    end
  end

  describe '#datastores_hash' do
    it 'returns a hash mapping from datastore name to free space' do
      first_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'first-datastore',
        free_space: 4000
      )
      second_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'second-datastore',
        free_space: 8000
      )
      third_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'third-datastore',
        free_space: 16000
      )

      allow(datacenter).to receive(:clusters).and_return({
        'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          all_datastores: {
            first_datastore.name => first_datastore,
            third_datastore.name => third_datastore
          },
        ),
        'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          all_datastores: {
            first_datastore.name => first_datastore,
            second_datastore.name => second_datastore
          }
        ),
      })

      expect(datacenter.datastores_hash).to eq({
        'first-datastore' => 4000,
        'second-datastore' => 8000,
        'third-datastore' => 16000,
      })
    end
  end

  describe '#find_datastore' do
    context 'when datastore exists' do
      it 'return the datastore' do
        first_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'first-datastore')
        second_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'second-datastore')
        third_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'third-datastore')

        allow(datacenter).to receive(:clusters).and_return({
          'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
            all_datastores: {
              first_datastore.name => first_datastore,
              third_datastore.name => third_datastore
            },
          ),
          'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
            all_datastores: {
              first_datastore.name => first_datastore,
              second_datastore.name => second_datastore
            }
          ),
        })

        datastore = datacenter.find_datastore('second-datastore')
        expect(datastore).to eq(second_datastore)
      end
    end

    context 'when datastore does not exist' do
      it 'raises an exception' do
        allow(datacenter).to receive(:clusters).and_return({})

        expect{
          datacenter.find_datastore('second-datastore')
        }.to raise_error(/Can't find datastore 'second-datastore'/)
      end
    end
  end

  describe '#persistent_datastores' do
    it 'returns a unique set of persistent datastores across all clusters' do
      first_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'first-datastore')
      second_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'second-datastore')
      third_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'third-datastore')

      allow(datacenter).to receive(:clusters).and_return({
        'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          persistent_datastores: {
            first_datastore.name => first_datastore,
            third_datastore.name => third_datastore
          },
        ),
        'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          persistent_datastores: {
            first_datastore.name => first_datastore,
            second_datastore.name => second_datastore
          }
        ),
      })

      expect(datacenter.persistent_datastores).to eq({
        first_datastore.name => first_datastore,
        second_datastore.name => second_datastore,
        third_datastore.name => third_datastore
      })
    end
  end

  describe '#all_datastores' do
    it 'returns a unique set of persistent datastores across all clusters' do
      first_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'first-datastore')
      second_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'second-datastore')
      third_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'third-datastore')

      allow(datacenter).to receive(:clusters).and_return({
        'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          all_datastores: {
            first_datastore.name => first_datastore,
            third_datastore.name => third_datastore
          },
        ),
        'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          all_datastores: {
            first_datastore.name => first_datastore,
            second_datastore.name => second_datastore
          }
        ),
      })

      expect(datacenter.all_datastores).to eq({
        first_datastore.name => first_datastore,
        second_datastore.name => second_datastore,
        third_datastore.name => third_datastore
      })
    end
  end

  describe '#disks_hash' do
    it 'returns a hash mapping from disk cid to free space on disks grouped under datastores' do
      first_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'first-datastore'
      )
      second_datastore = instance_double(
        'VSphereCloud::Resources::Datastore',
        name: 'second-datastore'
      )

      first_disk = instance_double(
        VSphereCloud::Resources::Disk,
        datastore: first_datastore,
        size_in_mb: 1000
      )
      second_disk = instance_double(
        VSphereCloud::Resources::Disk,
        datastore: second_datastore,
        size_in_mb: 2000
      )
      third_disk = instance_double(
        VSphereCloud::Resources::Disk,
        datastore: second_datastore,
        size_in_mb: 4000
      )

      disk_cids = ['disk1', 'disk2', 'disk3']
      allow(datacenter).to receive(:find_disk)
        .with('disk1')
        .and_return(first_disk)
      allow(datacenter).to receive(:find_disk)
        .with('disk2')
        .and_return(second_disk)
      allow(datacenter).to receive(:find_disk)
        .with('disk3')
        .and_return(third_disk)

      expect(datacenter.disks_hash(disk_cids)).to eq({
        'first-datastore' => {
          'disk1' => 1000
        },
        'second-datastore' => {
          'disk2' => 2000,
          'disk3' => 4000
        }
      })
    end
  end

  describe '#vm_path' do
    it 'builds the vm path' do
      allow(vm_folder).to receive(:path_components) { ['vm-folder', 'path-components'] }
      expect(datacenter.vm_path('fake-vm-cid')).to eq('fake-datacenter-name/vm/vm-folder/path-components/fake-vm-cid')
    end
  end

  describe '#to_s' do
    it 'show relevant info' do
      expect(subject.to_s).to eq("(#{subject.class.name} (name=\"fake-datacenter-name\"))")
    end
  end

  describe '#create_disk' do
    let(:virtual_disk_manager) { instance_double('VimSdk::Vim::VirtualDiskManager') }

    before do
      allow(SecureRandom).to receive(:uuid).and_return('cid')
      allow(virtual_disk_manager).to receive(:create_virtual_disk)
    end

    context 'when disk type is nil' do
      it 'creates disk using VirtualDiskManager with default disk type' do
        allow(client).to receive(:create_disk)
                            .with(datacenter_mob, datastore, 'disk-cid', 'fake-disk-path', 24, 'preallocated')
                            .and_return(disk)
        expect(datacenter.create_disk(datastore, 24, nil)).to eq(disk)
      end
    end

    context 'when disk type is invalid' do
      it 'raises an error' do
        expect {
          datacenter.create_disk(datastore, 24, 'invalid-type')
        }.to raise_error("Disk type: 'invalid-type' is not supported")
      end
    end

    context 'when disk type is valid' do
      it 'creates disk using VirtualDiskManager with specified disk type' do
        allow(client).to receive(:create_disk)
                            .with(datacenter_mob, datastore, 'disk-cid', 'fake-disk-path', 24, 'thin')
                            .and_return(disk)

        expect(datacenter.create_disk(datastore, 24, 'thin')).to eq(disk)
      end
    end
  end

  describe '#find_disk' do
    let(:other_datastore) { instance_double(VSphereCloud::Resources::Datastore) }

    before do
      allow(datacenter).to receive(:persistent_datastores).and_return({
            'datastore1' => datastore,
            'datastore2' => other_datastore,
          })
      allow(datacenter).to receive(:all_datastores).and_return({
            'datastore1' => datastore,
            'datastore2' => other_datastore,
          })
    end

    context 'when disk exists in persistent datastore' do
      before do
        allow(client).to receive(:find_disk).with('disk-cid', datastore, 'fake-disk-path') { disk }
        allow(client).to receive(:find_disk).with('disk-cid', other_datastore, 'fake-disk-path') { nil }
      end

      it 'returns disk' do
        expect(datacenter.find_disk('disk-cid')).to eq(disk)
      end
    end

    context 'when disk exists in some other datastore' do
      before do
        allow(client).to receive(:find_disk).with('disk-cid', datastore, 'fake-disk-path') { nil }
        allow(client).to receive(:find_disk).with('disk-cid', other_datastore, 'fake-disk-path') { disk }
      end

      it 'returns disk' do
        expect(datacenter.find_disk('disk-cid')).to eq(disk)
      end
    end

    context 'when disk exists but cannot be found in datastores' do
      before do
        allow(client).to receive(:find_disk).with('disk-cid', datastore, 'fake-disk-path') { nil }
        allow(client).to receive(:find_disk).with('disk-cid', other_datastore, 'fake-disk-path') { nil }

        vm_mob = instance_double('VimSdk::Vim::VirtualMachine', name: 'fake-vm-name')
        allow(client).to receive(:find_vm_by_disk_cid).with(datacenter_mob, 'disk-cid').and_return(vm_mob)

        vm = instance_double(
          'VSphereCloud::Resources::VM',
        )
        allow(vm).to receive(:disk_path_by_cid).with('disk-cid')
          .and_return("[datastore1] fake-disk-path/fake-file_name.vmdk")
        allow(VSphereCloud::Resources::VM).to receive(:new)
          .with('fake-vm-name', vm_mob, client, logger)
          .and_return(vm)

        allow(client).to receive(:find_disk)
          .with('fake-file_name', datastore, 'fake-disk-path')
          .and_return(disk)
      end

      it 'returns the disk' do
        expect(datacenter.find_disk('disk-cid')).to eq(disk)
      end
    end

    context 'when disk does not exist' do
      before do
        allow(client).to receive(:find_disk).with('disk-cid', datastore, 'fake-disk-path') { nil }
        allow(client).to receive(:find_disk).with('disk-cid', other_datastore, 'fake-disk-path') { nil }

        allow(client).to receive(:find_vm_by_disk_cid).with(datacenter_mob, 'disk-cid').and_return(nil)
      end

      it 'raises DiskNotFound' do
        expect {
          datacenter.find_disk('disk-cid')
        }.to raise_error { |error|
            expect(error).to be_a(Bosh::Clouds::DiskNotFound)
            expect(error.ok_to_retry).to eq(false)
            expect(error.message).to match(/Could not find disk with id 'disk-cid'/)
          }
      end
    end
  end

  describe '#move_disk_to_datastore' do
    let(:disk) do
      instance_double(
        VSphereCloud::Resources::PersistentDisk,
        path: "[old-datastore] fake-disk-path/fake-disk-cid.vmdk",
        cid: 'fake-disk-cid',
        size_in_mb: 1024,
      )
    end
    it 'forwards the call to the client with the correct args' do
      target_path = "[#{datastore.name}] fake-disk-path/fake-disk-cid.vmdk"
      expect(client).to receive(:move_disk).with(datacenter_mob, disk.path, datacenter_mob, target_path)
      new_disk = datacenter.move_disk_to_datastore(disk, datastore)
      expect(new_disk.path).to eq(target_path)
    end
  end
end
