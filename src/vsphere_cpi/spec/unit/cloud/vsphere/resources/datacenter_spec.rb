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

  describe '#pick_datastore' do
    let(:datastore_properties) do
      bytes_in_mb = VSphereCloud::Resources::BYTES_IN_MB
      disk_threshold = VSphereCloud::Resources::Datastore::DISK_HEADROOM
      {
        'ds-with-enough-space' => { 'name' => 'ds1', 'summary.freeSpace' => (1024 + disk_threshold) * bytes_in_mb, 'summary.capacity' => 20000 * bytes_in_mb },
        'another-ds-with-enough-space' => { 'name' => 'ds2', 'summary.freeSpace' => (2048 + disk_threshold) * bytes_in_mb, 'summary.capacity' => 20000 * bytes_in_mb  },
        'ds-without-enough-space' => { 'name' => 'ds3', 'summary.freeSpace' => (512 + disk_threshold) * bytes_in_mb, 'summary.capacity' => 20000 * bytes_in_mb  },
        'ephemeral-ds-with-enough-space' => { 'name' => 'es1', 'summary.freeSpace' => (2048 + disk_threshold) * bytes_in_mb, 'summary.capacity' => 20000 * bytes_in_mb  },
      }
    end
    let(:persistent_pattern) { /ds/ }
    let(:ephemeral_pattern) { /es/ }

    context '#pick_persistent_datastore' do
      context 'without filter' do
        it 'returns datastore with weighted random from datastores with enough space' do
          first_datastore = nil
          expect(VSphereCloud::Resources::Util).to receive(:weighted_random) do |weighted_datastores|
            expect(weighted_datastores.size).to eq(2)
            first_datastore, first_weight = weighted_datastores.first
            expect(first_datastore.name).to eq('ds1')
            expect(first_weight).to eq(1024 + VSphereCloud::Resources::Datastore::DISK_HEADROOM)

            second_datastore, second_weight = weighted_datastores[1]
            expect(second_datastore.name).to eq('ds2')
            expect(second_weight).to eq(2048 + VSphereCloud::Resources::Datastore::DISK_HEADROOM)

            first_datastore
          end
          expect(datacenter.pick_persistent_datastore(1024)).to eq(first_datastore)
        end

        it 'logs debug info about all persistent datastores' do
          datacenter.pick_persistent_datastore(1024)

          expect(log_output.string).to include "Looking for a 'persistent' datastore with 1024MB free space."
          expect(log_output.string).to include 'All datastores being considered within datacenter ' + datacenter.name + ': ["ds1 (2048MB free of 20000MB capacity)", "ds2 (3072MB free of 20000MB capacity)", "ds3 (1536MB free of 20000MB capacity)"]'
          expect(log_output.string).to include 'Datastores with enough space: ["ds1 (2048MB free of 20000MB capacity)", "ds2 (3072MB free of 20000MB capacity)"]'
        end

        context 'and there is less persistent free space than the disk threshold' do
          it 'raises a Bosh::Clouds::NoDiskSpace' do
            expect {
              datacenter.pick_persistent_datastore(10000)
            }.to raise_error do |error|
              expect(error).to be_an_instance_of(Bosh::Clouds::NoDiskSpace)
              expect(error.ok_to_retry).to be(true)
              expect(error.message).to eq(<<-MSG)
Couldn't find a 'persistent' datastore with 10000MB of free space. Found:
 ds1 (2048MB free of 20000MB capacity)
 ds2 (3072MB free of 20000MB capacity)
 ds3 (1536MB free of 20000MB capacity)
              MSG
            end
          end
        end
      end

      context 'with empty filter' do
        let(:filter) { [] }

        it 'returns datastore with weighted random from datastores with enough space' do
          first_datastore = nil
          expect(VSphereCloud::Resources::Util).to receive(:weighted_random) do |weighted_datastores|
            expect(weighted_datastores.size).to eq(2)
            first_datastore, first_weight = weighted_datastores.first
            expect(first_datastore.name).to eq('ds1')
            expect(first_weight).to eq(1024 + VSphereCloud::Resources::Datastore::DISK_HEADROOM)

            second_datastore, second_weight = weighted_datastores[1]
            expect(second_datastore.name).to eq('ds2')
            expect(second_weight).to eq(2048 + VSphereCloud::Resources::Datastore::DISK_HEADROOM)

            first_datastore
          end
          expect(datacenter.pick_persistent_datastore(1024, filter)).to eq(first_datastore)
        end

        it 'logs debug info about all persistent datastores' do
          datacenter.pick_persistent_datastore(1024)

          expect(log_output.string).to include "Looking for a 'persistent' datastore with 1024MB free space."
          expect(log_output.string).to include 'All datastores being considered within datacenter ' + datacenter.name + ': ["ds1 (2048MB free of 20000MB capacity)", "ds2 (3072MB free of 20000MB capacity)", "ds3 (1536MB free of 20000MB capacity)"]'
          expect(log_output.string).to include 'Datastores with enough space: ["ds1 (2048MB free of 20000MB capacity)", "ds2 (3072MB free of 20000MB capacity)"]'
        end

        context 'and there is less persistent free space than the disk threshold' do
          it 'raises a Bosh::Clouds::NoDiskSpace' do
            expect {
              datacenter.pick_persistent_datastore(10000)
            }.to raise_error do |error|
              expect(error).to be_an_instance_of(Bosh::Clouds::NoDiskSpace)
              expect(error.ok_to_retry).to be(true)
              expect(error.message).to eq(<<-MSG)
Couldn't find a 'persistent' datastore with 10000MB of free space. Found:
 ds1 (2048MB free of 20000MB capacity)
 ds2 (3072MB free of 20000MB capacity)
 ds3 (1536MB free of 20000MB capacity)
              MSG
            end
          end
        end
      end

      context 'with filter' do
        let(:filter) { %w(ds1 ds3) }

        it 'returns datastore with weighted random from datastores with enough space' do
          first_datastore = nil
          expect(VSphereCloud::Resources::Util).to receive(:weighted_random) do |weighted_datastores|
            expect(weighted_datastores.size).to eq(1)
            first_datastore, first_weight = weighted_datastores.first
            expect(first_datastore.name).to eq('ds1')
            expect(first_weight).to eq(1024 + VSphereCloud::Resources::Datastore::DISK_HEADROOM)

            first_datastore
          end
          expect(datacenter.pick_persistent_datastore(1024, filter)).to eq(first_datastore)
        end

        it 'logs debug info about all filtered datastores' do
          datacenter.pick_persistent_datastore(1024, filter)

          expect(log_output.string).to include "Looking for a 'persistent' datastore with 1024MB free space."
          expect(log_output.string).to include 'All datastores being considered within datacenter ' + datacenter.name + ': ["ds1 (2048MB free of 20000MB capacity)", "ds3 (1536MB free of 20000MB capacity)"]'
          expect(log_output.string).to include 'Datastores with enough space: ["ds1 (2048MB free of 20000MB capacity)"]'
        end

        context 'and there is less persistent free space than the disk threshold' do
          it 'raises a Bosh::Clouds::NoDiskSpace' do
            expect {
              datacenter.pick_persistent_datastore(10000, filter)
            }.to raise_error do |error|
              expect(error).to be_an_instance_of(Bosh::Clouds::NoDiskSpace)
              expect(error.ok_to_retry).to be(true)
              expect(error.message).to eq(<<-MSG)
Couldn't find a 'persistent' datastore with 10000MB of free space. Found:
 ds1 (2048MB free of 20000MB capacity)
 ds3 (1536MB free of 20000MB capacity)
              MSG
            end
          end
        end
      end
    end

    context '#pick_ephemeral_datastore' do
      it 'logs debug info about all filtered datastores' do
        datacenter.pick_ephemeral_datastore(1024, nil)

        expect(log_output.string).to include "Looking for a 'ephemeral' datastore with 1024MB free space."
        expect(log_output.string).to include 'All datastores being considered within datacenter ' + datacenter.name + ': ["es1 (3072MB free of 20000MB capacity)"]'
        expect(log_output.string).to include 'Datastores with enough space: ["es1 (3072MB free of 20000MB capacity)"]'
      end

      context 'with empty filter' do
        let(:filter) { [] }

        it 'returns datastore with weighted random from datastores with enough space' do
          first_datastore = nil
          expect(VSphereCloud::Resources::Util).to receive(:weighted_random) do |weighted_datastores|
            expect(weighted_datastores.size).to eq(1)
            first_datastore, first_weight = weighted_datastores.first
            expect(first_datastore.name).to eq('es1')
            expect(first_weight).to eq(2048 + VSphereCloud::Resources::Datastore::DISK_HEADROOM)

            first_datastore
          end
          expect(datacenter.pick_ephemeral_datastore(1024, filter)).to eq(first_datastore)
        end

        it 'logs debug info about all ephemeral datastores' do
          datacenter.pick_persistent_datastore(1024)

          expect(log_output.string).to include "Looking for a 'persistent' datastore with 1024MB free space."
          expect(log_output.string).to include 'All datastores being considered within datacenter ' + datacenter.name + ': ["ds1 (2048MB free of 20000MB capacity)", "ds2 (3072MB free of 20000MB capacity)", "ds3 (1536MB free of 20000MB capacity)"]'
          expect(log_output.string).to include 'Datastores with enough space: ["ds1 (2048MB free of 20000MB capacity)", "ds2 (3072MB free of 20000MB capacity)"]'
        end

        context 'and there is less ephemeral free space than the disk threshold' do
          it 'raises a Bosh::Clouds::NoDiskSpace' do
            expect {
              datacenter.pick_ephemeral_datastore(10000)
            }.to raise_error do |error|
              expect(error).to be_an_instance_of(Bosh::Clouds::NoDiskSpace)
              expect(error.ok_to_retry).to be(true)
              expect(error.message).to eq(<<-MSG)
Couldn't find a 'ephemeral' datastore with 10000MB of free space. Found:
 es1 (3072MB free of 20000MB capacity)
              MSG
            end
          end
        end
      end
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

  describe '#move_disk' do
    it 'forwards the call to the client with the correct args' do
      expect(client).to receive(:move_disk).with(datacenter_mob, 'source-path', datacenter_mob, 'dest-path')
      datacenter.move_disk('source-path', 'dest-path')
    end
  end

  describe '#ensure_disk_is_accessible_to_vm' do
    let(:disk) do
      instance_double(
        'VSphereCloud::Resources::PersistentDisk',
        cid: 'disk-cid', size_in_mb: 24, datastore: datastore, folder: 'fake-disk-path'
      )
    end

    context 'when disk is accessible' do
      let(:vm) { instance_double(VSphereCloud::Resources::VM, accessible_datastores: [datastore.name]) }
      before do
        allow(datacenter).to receive(:persistent_datastores) do
            {datastore.name => datastore}
        end
      end
      it 'returns disk' do
        expect(datacenter.ensure_disk_is_accessible_to_vm(disk, vm)).to eq(disk)
      end
    end

    context 'when disk is not accessible' do
      let(:accessible_datastore) do
        instance_double(
          'VSphereCloud::Resources::Datastore',
          name: 'accessible-datastore', free_space: 2000, debug_info: ''
        )
      end
      let(:vm) { instance_double(VSphereCloud::Resources::VM, accessible_datastores: [accessible_datastore.name]) }
      let(:disk) do
        instance_double(
          'VSphereCloud::Resources::PersistentDisk',
          cid: 'disk-cid', size_in_mb: 24, datastore: datastore, folder: 'fake-folder', path: 'fake-path'
        )
      end
      before do
        allow(datacenter).to receive(:persistent_datastores) do
          {
            datastore.name => datastore,
            accessible_datastore.name => accessible_datastore
          }
        end
      end

      it 'moves and returns disk' do
        expect(client).to receive(:move_disk).with(datacenter_mob, 'fake-path', datacenter_mob, '[accessible-datastore] fake-disk-path/disk-cid.vmdk')
        new_disk = datacenter.ensure_disk_is_accessible_to_vm(disk, vm)
        expect(new_disk.datastore.name).to eq('accessible-datastore')
      end
    end
  end

  describe '#pick_cluster_for_vm' do
    let(:datastore1) { VSphereCloud::Resources::Datastore.new('datastore1', nil, 0, 3000 + VSphereCloud::Resources::Datastore::DISK_HEADROOM) }
    let(:requested_memory) { 35 }
    let(:requested_ephemeral_disk) { 500 }
    let(:existing_persistent_disks) { [] }
    let(:cluster1) {
      instance_double(
        'VSphereCloud::Resources::Cluster',
        name: 'cluster1',
        all_datastores: {'datastore1' => datastore1},
        ephemeral_datastores: {'datastore1' => datastore1},
        persistent_datastores: {'datastore1' => datastore1},
        free_memory: 40 + VSphereCloud::Resources::Cluster::MEMORY_HEADROOM,
        describe: "cluster1 has 168mb/3gb/3gb"
      )
    }
    before do
      allow(subject).to receive(:clusters).and_return({
        'cluster1' => cluster1
      })
      allow(cluster1).to receive(:allocate)
    end

    it 'selects clusters that satisfy the requested memory and ephemeral disk size' do
      cluster = subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
      expect(cluster).to eq(cluster1)
    end

    context 'when no cluster satisfies the requested memory' do
      let(:requested_memory) { 41 }
      it 'raises' do
        expect {
          subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
        }.to raise_error("Unable to allocate vm with 41mb RAM, 0gb ephemeral disk, and 0gb persistent disk from any cluster.\ncluster1 has 168mb/3gb/3gb.")
      end
    end

    context 'when no cluster satisfies the requested ephemeral disk' do
      let(:requested_ephemeral_disk) { 3100 }

      it 'raises' do
        expect {
          subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
        }.to raise_error("Unable to allocate vm with 35mb RAM, 3gb ephemeral disk, and 0gb persistent disk from any cluster.\ncluster1 has 168mb/3gb/3gb.")
      end
    end

    context 'with an existing persistent disk' do
      let(:disk) { VSphereCloud::Resources::PersistentDisk.new('disk1', 20, datastore1, 'fake-folder') }
      let(:existing_persistent_disks) { [] }

      context 'when disk is in a cluster that satisfies requirements' do
        it 'returns cluster that has disk' do
          cluster = subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
          expect(cluster).to eq(cluster1)
        end
      end
    end

    context 'with multiple clusters' do
      let(:datastore2) { VSphereCloud::Resources::Datastore.new('datastore2', nil, 0, datastore2_free_space + VSphereCloud::Resources::Datastore::DISK_HEADROOM) }
      let(:datastore2_free_space) { 8000 }
      let(:cluster2) {
        instance_double(
          'VSphereCloud::Resources::Cluster',
          name: 'cluster2',
          all_datastores: {'datastore2' => datastore2},
          ephemeral_datastores: {'datastore2' => datastore2},
          persistent_datastores: {'datastore2' => datastore2},
          free_memory: 182 + VSphereCloud::Resources::Cluster::MEMORY_HEADROOM,
          describe: ''
        )
      }

      before do
        allow(subject).to receive(:clusters).and_return({
              'cluster1' => cluster1,
              'cluster2' => cluster2,
            })
        allow(cluster2).to receive(:allocate)
      end

      it 'selects randomly from the clusters that satisfy the requested memory and ephemeral disk size' do
        expect(VSphereCloud::Resources::Util).to receive(:weighted_random).with([
              [cluster2, 5],
              [cluster1, 1]
            ]).and_return(cluster2)
        cluster = subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
        expect(cluster).to eq(cluster2)
      end

      context 'with an existing persistent disks' do
        let(:disk1) { VSphereCloud::Resources::PersistentDisk.new('disk1', 10, datastore1,'fake-folder') }
        let(:disk2) { VSphereCloud::Resources::PersistentDisk.new('disk2', 20, datastore2, 'fake-folder-2') }
        let(:existing_persistent_disks) { [disk1, disk2] }

        before do
          allow(cluster1).to receive(:persistent).and_return(nil)
          allow(cluster2).to receive(:persistent).and_return(datastore1)
        end

        context 'when all clusters satisfy requirements' do
          it 'returns cluster that has more persistent disk sizes' do
            cluster = subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
            expect(cluster).to eq(cluster2)
          end
        end

        context 'when cluster with most disks does not satisfy requirements' do
          let(:requested_memory) { 11 }
          it 'returns next cluster with most disks that satisfy requirement' do
            cluster = subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
            expect(cluster).to eq(cluster2)
          end
        end

        context 'when disk belongs to two clusters' do
          let(:datastore3) { VSphereCloud::Resources::Datastore.new('datastore3', nil, 0, 5000 + VSphereCloud::Resources::Datastore::DISK_HEADROOM) }
          let(:cluster3) {
            instance_double(
              'VSphereCloud::Resources::Cluster',
              name: 'cluster3',
              all_datastores: {'datastore3' => datastore3},
              ephemeral_datastores: {'datastore3' => datastore3},
              persistent_datastores: {'datastore3' => datastore3},
              free_memory: 1000 + VSphereCloud::Resources::Cluster::MEMORY_HEADROOM,
              describe: ''
            )
          }
          let(:clusters) { [cluster1, cluster2, cluster3] }

          let(:disk1) { VSphereCloud::Resources::PersistentDisk.new('disk1', 1000, datastore1, 'fake-folder') }
          let(:disk2) { VSphereCloud::Resources::PersistentDisk.new('disk2', 5000, datastore2, 'fake-folder-2') }
          let(:disk3) { VSphereCloud::Resources::PersistentDisk.new('disk3', 3000, datastore3, 'fake-folder-3') }

          let(:existing_persistent_disks) { [disk1, disk2, disk3] }
          before do
            allow(subject).to receive(:clusters).and_return({
              'cluster1' => cluster1,
              'cluster2' => cluster2,
              'cluster3' => cluster3,
            })

            allow(cluster3).to receive(:persistent).and_return(datastore3)
            allow(cluster3).to receive(:allocate)
          end
          context 'when cluster with biggest disks size cannot fit other disks' do
            let(:datastore2_free_space) { 5 }

            context 'when next cluster with most disks can fit the disk that is not in that cluster' do
              it 'returns next cluster with most disks that satisfy requirement' do
                cluster = subject.pick_cluster_for_vm(requested_memory, requested_ephemeral_disk, existing_persistent_disks)
                expect(cluster).to eq(cluster3)
              end
            end
          end
        end
      end
    end
  end
end
