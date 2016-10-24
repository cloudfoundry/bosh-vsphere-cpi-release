require 'spec_helper'

describe VSphereCloud::Resources::Datacenter do
  subject(:datacenter) {
    described_class.new({
      client: client,
      name: datacenter_name,
      vm_folder: 'fake-vm-folder',
      template_folder: 'fake-template-folder',
      clusters: {'first-cluster' => cluster_config1, 'second-cluster' => cluster_config2},
      cluster_provider: cluster_provider,
      disk_path: 'fake-disk-path',
      ephemeral_pattern: ephemeral_pattern,
      persistent_pattern: persistent_pattern,
      use_sub_folder: datacenter_use_sub_folder,
      logger: logger,
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
  let(:cluster_provider) { instance_double('VSphereCloud::Resources::ClusterProvider') }

  let(:small_datastore) do
    instance_double('VSphereCloud::Resources::Datastore',
      name: 'small-datastore',
      free_space: 4000
    )
  end
  let(:large_datastore) do
    instance_double('VSphereCloud::Resources::Datastore',
      name: 'large-datastore',
      free_space: 8000
    )
  end
  let(:inaccessible_datastore) do
    instance_double('VSphereCloud::Resources::Datastore',
      name: 'inaccessible-datastore',
      free_space: 16000
    )

  end
  let(:first_cluster) do
    instance_double('VSphereCloud::Resources::Cluster',
      free_memory: 1024,
      accessible_datastores: {
        small_datastore.name => small_datastore,
      },
    )
  end
  let(:second_cluster) do
    instance_double('VSphereCloud::Resources::Cluster',
      free_memory: 2048,
      accessible_datastores: {
        small_datastore.name => small_datastore,
        large_datastore.name => large_datastore
      },
    )
  end
  let(:cluster_mob1) { instance_double('VimSdk::Vim::Cluster') }
  let(:cluster_mob2) { instance_double('VimSdk::Vim::Cluster') }
  let(:cluster_config1) { instance_double('VSphereCloud::ClusterConfig', resource_pool: nil, name: 'first-cluster') }
  let(:cluster_config2) { instance_double('VSphereCloud::ClusterConfig', resource_pool: nil, name: 'second-cluster') }

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
        ['first-cluster', cluster_mob1],
        ['second-cluster', cluster_mob2],
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

    allow(cluster_provider).to receive(:find)
      .with('first-cluster', cluster_config1)
      .and_return(first_cluster)
    allow(cluster_provider).to receive(:find)
      .with('second-cluster', cluster_config2)
      .and_return(second_cluster)
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
      expect(datacenter.clusters).to eq({
        'first-cluster' => first_cluster,
        'second-cluster' => second_cluster,
      })
    end
  end

  describe '#clusters_hash' do
    it 'returns a hash mapping from cluster name to a lightweight hash' do
      expect(datacenter.clusters_hash).to eq({
        'first-cluster' => {
          memory: 1024,
          datastores: {
            'small-datastore' => {
              free_space: 4000,
            },
          }
        },
        'second-cluster' => {
          memory: 2048,
          datastores: {
            'small-datastore' => {
              free_space: 4000,
            },
            'large-datastore' => {
              free_space: 8000,
            },
          }
        }
      })
    end
  end

  describe '#find_cluster' do
    context 'when cluster exists' do
      it 'return the cluster' do
        cluster = datacenter.find_cluster('first-cluster')
        expect(cluster).to eq(first_cluster)
      end
    end

    context 'when cluster does not exist' do
      before do
        allow(cluster_provider).to receive(:find)
          .and_raise('fake-error')
      end

      it 'raises an exception' do
        expect {
          datacenter.find_cluster('first-cluster')
        }.to raise_error('fake-error')
      end
    end
  end

  describe '#accessible_datastores_hash' do
    it 'returns a hash mapping from accessible datastore name to free space' do
      expect(datacenter.accessible_datastores_hash).to eq({
        'small-datastore' => {
          free_space: 4000,
        },
        'large-datastore' => {
          free_space: 8000,
        },
      })
    end
  end

  describe '#find_datastore' do
    context 'when datastore exists' do
      it 'return the datastore' do
        small_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'small-datastore')
        large_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'large-datastore')
        inaccessible_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'inaccessible-datastore')

        allow(datacenter).to receive(:clusters).and_return({
          'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
            accessible_datastores: {
              small_datastore.name => small_datastore,
              inaccessible_datastore.name => inaccessible_datastore
            },
          ),
          'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
            accessible_datastores: {
              small_datastore.name => small_datastore,
              large_datastore.name => large_datastore
            }
          ),
        })

        datastore = datacenter.find_datastore('large-datastore')
        expect(datastore).to eq(large_datastore)
      end
    end

    context 'when datastore does not exist' do
      it 'raises an exception' do
        allow(datacenter).to receive(:clusters).and_return({})

        expect{
          datacenter.find_datastore('large-datastore')
        }.to raise_error(/Can't find datastore 'large-datastore'/)
      end
    end
  end

  describe '#select_datastores' do
    let(:datastoreA) { instance_double('VSphereCloud::Resources::Datastore', name: 'matching-datastore-A') }
    let(:datastoreB) { instance_double('VSphereCloud::Resources::Datastore', name: 'matching-datastore-B') }
    let(:datastoreC) { instance_double('VSphereCloud::Resources::Datastore', name: 'nonmatching-datastore') }

    before do
      allow(datacenter).to receive(:clusters).and_return({
        'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          accessible_datastores: {
            datastoreA.name => datastoreA,
            datastoreC.name => datastoreC
          },
        ),
        'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          accessible_datastores: {
            datastoreA.name => datastoreA,
            datastoreB.name => datastoreB
          }
        ),
      })
    end

    context 'when datastores exist that match the provided pattern' do
      it 'returns a map of the matching datastores' do
        datastores = datacenter.select_datastores(/^matching\-datastore.*$/)
        expect(datastores.keys).to eq(['matching-datastore-A', 'matching-datastore-B'])
        expect(datastores['matching-datastore-A']).to eq(datastoreA)
        expect(datastores['matching-datastore-B']).to eq(datastoreB)
      end
    end

    context 'when no datastores exist that match the provided pattern' do
      it 'returns an empty map' do
        datastores = datacenter.select_datastores(/^invalid\-pattern.*$/)
        expect(datastores).to be_empty
      end
    end
  end

  describe '#accessible_datastores' do
    it 'returns a unique set of persistent datastores across all clusters' do
      small_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'small-datastore')
      large_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'large-datastore')
      inaccessible_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'inaccessible-datastore')

      allow(datacenter).to receive(:clusters).and_return({
        'first-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          accessible_datastores: {
            small_datastore.name => small_datastore,
            inaccessible_datastore.name => inaccessible_datastore
          },
        ),
        'second-cluster' => instance_double('VSphereCloud::Resources::Cluster',
          accessible_datastores: {
            small_datastore.name => small_datastore,
            large_datastore.name => large_datastore
          }
        ),
      })

      expect(datacenter.accessible_datastores).to eq({
        small_datastore.name => small_datastore,
        large_datastore.name => large_datastore,
        inaccessible_datastore.name => inaccessible_datastore
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
      allow(datacenter).to receive(:accessible_datastores).and_return({
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

    context 'when an unexpected event has destroyed the disk' do
      before do
        allow(client).to receive(:find_disk).and_return(nil)

        vm_mob = instance_double('VimSdk::Vim::VirtualMachine', name: 'fake-vm-name')
        allow(client).to receive(:find_vm_by_disk_cid).with(datacenter_mob, 'disk-cid').and_return(vm_mob)

        vm = instance_double(
          'VSphereCloud::Resources::VM',
        )
        allow(vm).to receive(:disk_path_by_cid).with('disk-cid')
          .and_return(nil)
        allow(VSphereCloud::Resources::VM).to receive(:new)
          .with('fake-vm-name', vm_mob, client, logger)
          .and_return(vm)
      end

      it 'raises DiskNotFound' do
        expect {
          datacenter.find_disk('disk-cid')
        }.to raise_error(Bosh::Clouds::DiskNotFound)
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
      expect(VSphereCloud::Resources::PersistentDisk).to receive(:new).with(
        cid: 'fake-disk-cid',
        size_in_mb: 1024,
        datastore: datastore,
        folder: 'fake-disk-path'
      ).and_call_original
      new_disk = datacenter.move_disk_to_datastore(disk, datastore)
      expect(new_disk.path).to eq(target_path)
    end
  end
end
