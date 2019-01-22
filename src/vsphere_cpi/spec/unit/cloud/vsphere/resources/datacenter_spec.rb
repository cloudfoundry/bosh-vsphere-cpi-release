require 'spec_helper'

describe VSphereCloud::Resources::Datacenter, fake_logger: true do
  subject(:datacenter) do
    described_class.new(
      client: client,
      name: datacenter_name,
      vm_folder: 'fake-vm-folder',
      template_folder: 'fake-template-folder',
      clusters: {
        'first-cluster' => cluster_config1,
        'second-cluster' => cluster_config2
      },
      cluster_provider: cluster_provider,
      disk_path: 'fake-disk-path',
      ephemeral_pattern: ephemeral_pattern,
      persistent_pattern: persistent_pattern,
      use_sub_folder: datacenter_use_sub_folder
    )
  end
  let(:client) { instance_double('VSphereCloud::VCenterClient') }

  let(:vm_folder) { instance_double('VSphereCloud::Resources::Folder') }
  let(:vm_subfolder) { instance_double('VSphereCloud::Resources::Folder') }

  let(:datacenter_use_sub_folder) { false }

  let(:template_folder) { instance_double('VSphereCloud::Resources::Folder') }
  let(:template_subfolder) { instance_double('VSphereCloud::Resources::Folder') }
  let(:datacenter_mob) { instance_double('VimSdk::Vim::Datacenter') }
  let(:cluster_provider) { instance_double('VSphereCloud::Resources::ClusterProvider') }

  let(:small_datastore) do
    instance_double(
      'VSphereCloud::Resources::Datastore',
      name: 'small-datastore',
      free_space: 4000
    )
  end
  let(:large_datastore) do
    instance_double(
      'VSphereCloud::Resources::Datastore',
      name: 'large-datastore',
      free_space: 8000
    )
  end
  let(:inaccessible_datastore) do
    instance_double(
      'VSphereCloud::Resources::Datastore',
      name: 'inaccessible-datastore',
      free_space: 16000
    )

  end
  let(:first_cluster) do
    instance_double(
      'VSphereCloud::Resources::Cluster',
      free_memory: 1024,
      accessible_datastores: {
        small_datastore.name => small_datastore,
      }
    )
  end
  let(:second_cluster) do
    instance_double(
      'VSphereCloud::Resources::Cluster',
      free_memory: 2048,
      accessible_datastores: {
        small_datastore.name => small_datastore,
        large_datastore.name => large_datastore
      }
    )
  end
  let(:cluster_mob1) { instance_double('VimSdk::Vim::Cluster') }
  let(:cluster_mob2) { instance_double('VimSdk::Vim::Cluster') }
  let(:cluster_config1) { instance_double('VSphereCloud::ClusterConfig', resource_pool: nil, name: 'first-cluster') }
  let(:cluster_config2) { instance_double('VSphereCloud::ClusterConfig', resource_pool: nil, name: 'second-cluster') }

  let(:ephemeral_pattern) {instance_double('Regexp')}
  let(:persistent_pattern) { 'persistent.*' }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:datastore_properties) { {} }
  let(:datastore) { instance_double('VSphereCloud::Resources::Datastore', name: 'fake-datastore') }
  let(:disk) { instance_double('VSphereCloud::Resources::PersistentDisk', path: 'fake-disk-path') }

  let(:datacenter_name) { 'fake-datacenter-name' }
  before do
    allow(client).to receive(:find_by_inventory_path).with(datacenter_name).and_return(datacenter_mob)
    allow(client).to receive(:cloud_searcher).and_return(cloud_searcher)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-vm-folder', client, datacenter_name
    ).and_return(vm_folder)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-vm-folder/fake-uuid', client, datacenter_name
    ).and_return(vm_subfolder)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-template-folder', client, datacenter_name
    ).and_return(template_folder)

    allow(VSphereCloud::Resources::Folder).to receive(:new).with(
      'fake-template-folder/fake-uuid', client, datacenter_name
    ).and_return(template_subfolder)

    allow(cloud_searcher).to receive(:get_managed_objects).with(
      VimSdk::Vim::ClusterComputeResource,
      root: datacenter_mob, include_name: true
    ).and_return(
      [
        ['first-cluster', cluster_mob1],
        ['second-cluster', cluster_mob2]
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

  describe '#inspect' do
    it 'includes the mob and the name of the datacenter' do
      expect(datacenter.inspect).to eq("<Datacenter: #{datacenter_mob} / fake-datacenter-name>")
    end
  end

  describe '#clusters' do
    it 'returns a list of cluster object' do
      expect(datacenter.clusters).to eq([ first_cluster, second_cluster ])
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

  describe '#find_datastore' do
    context 'when datastore exists' do
      it 'return the datastore' do
        small_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'small-datastore')
        large_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'large-datastore')
        inaccessible_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'inaccessible-datastore')

        allow(datacenter).to receive(:clusters).and_return(
          [
            instance_double(
              'VSphereCloud::Resources::Cluster',
              accessible_datastores: {
                small_datastore.name => small_datastore,
                inaccessible_datastore.name => inaccessible_datastore
              }
            ),
            instance_double(
              'VSphereCloud::Resources::Cluster',
              accessible_datastores: {
                small_datastore.name => small_datastore,
                large_datastore.name => large_datastore
              }
            )
          ]
        )

        datastore = datacenter.find_datastore('large-datastore')
        expect(datastore).to eq(large_datastore)
      end
    end

    context 'when datastore does not exist' do
      it 'raises an exception' do
        allow(datacenter).to receive(:clusters).and_return([])

        expect{
          datacenter.find_datastore('large-datastore')
        }.to raise_error(/Can't find datastore 'large-datastore'/)
      end
    end
  end

  describe '#accessible_datastores' do
    it 'returns a unique set of persistent datastores across all clusters' do
      small_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'small-datastore')
      large_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'large-datastore')
      inaccessible_datastore = instance_double('VSphereCloud::Resources::Datastore', name: 'inaccessible-datastore')

      allow(datacenter).to receive(:clusters).and_return(
        [
          instance_double(
            'VSphereCloud::Resources::Cluster',
            accessible_datastores: {
              small_datastore.name => small_datastore,
              inaccessible_datastore.name => inaccessible_datastore
            },
          ),
          instance_double(
            'VSphereCloud::Resources::Cluster',
            accessible_datastores: {
              small_datastore.name => small_datastore,
              large_datastore.name => large_datastore
            }
          )
        ]
      )

      expect(datacenter.accessible_datastores).to eq(
        small_datastore.name => small_datastore,
        large_datastore.name => large_datastore,
        inaccessible_datastore.name => inaccessible_datastore
      )
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
    let(:persistent_datastore) { instance_double(VSphereCloud::Resources::Datastore, name: 'persistent-ds') }
    let(:other_datastore_1) { instance_double(VSphereCloud::Resources::Datastore, name: 'other_datastore_1') }
    let(:other_datastore_2) { instance_double(VSphereCloud::Resources::Datastore, name: 'other_datastore_2') }
    let(:datastore_with_disk) { instance_double(VSphereCloud::Resources::Datastore, name: 'datastore-with-disk') }
    let(:encoded_disk_cid) { 'disk-cid' }
    let(:director_disk_cid) {
      VSphereCloud::DirectorDiskCID.new(encoded_disk_cid)
    }

    before do
      allow(datacenter).to receive(:accessible_datastores).and_return(
        'persistent-ds' => persistent_datastore,
        'other_datastore_1' => other_datastore_1,
        'other_datastore_2' => other_datastore_2
      )
    end

    context 'when disk exists in specified datastores' do
      let(:encoded_disk_cid) do
        metadata = {
          target_datastore_pattern: '^(other_datastore_2)$'
        }
        "disk-cid.#{Base64.urlsafe_encode64(metadata.to_json)}"
      end

      it 'returns disk without searching in persistent datastore nor other datastores' do
        expect(client).to receive(:find_disk).with('disk-cid', other_datastore_2, 'fake-disk-path').and_return(disk)
        expect(client).not_to receive(:find_disk).with('disk-cid', persistent_datastore, 'fake-disk-path')
        expect(client).not_to receive(:find_disk).with('disk-cid', other_datastore_1, 'fake-disk-path')

        expect(datacenter.find_disk(director_disk_cid)).to eq(disk)
      end
    end

    context 'when disk exists in persistent datastore' do
      it 'returns disk without searching in other datastores' do
        expect(client).to receive(:find_disk).with('disk-cid', persistent_datastore, 'fake-disk-path').and_return(disk)
        expect(client).not_to receive(:find_disk).with('disk-cid', other_datastore_1, 'fake-disk-path')
        expect(client).not_to receive(:find_disk).with('disk-cid', other_datastore_2, 'fake-disk-path')

        expect(datacenter.find_disk(director_disk_cid)).to eq(disk)
      end
    end

    context 'when disk exists in other datastores' do
      it 'returns disk' do
        expect(client).to receive(:find_disk).with('disk-cid', persistent_datastore, 'fake-disk-path').and_return(nil)
        expect(client).to receive(:find_disk).with('disk-cid', other_datastore_1, 'fake-disk-path').and_return(disk)
        allow(client).to receive(:find_disk).with('disk-cid', other_datastore_2, 'fake-disk-path').and_return(nil)

        expect(datacenter.find_disk(director_disk_cid)).to eq(disk)
      end
    end

    context 'when disk exists in datastore accessible to vm' do
      let(:vm) { instance_double('VSphereCloud::Resources::VM', mob: vm_mob, reload: nil, cid: 'vm-id') }
      let(:vm_mob) { instance_double('VimSdk::Vim::VirtualMachine') }

      it 'returns disk' do
        expect(client).to receive(:find_disk).with('disk-cid', persistent_datastore, 'fake-disk-path').and_return(nil)
        expect(client).to receive(:find_disk).with('disk-cid', other_datastore_1, 'fake-disk-path').and_return(nil)
        allow(client).to receive(:find_disk).with('disk-cid', other_datastore_2, 'fake-disk-path').and_return(nil)
        allow(client).to receive(:find_disk).with('disk-cid', datastore_with_disk, 'fake-disk-path').and_return(disk)
        allow(vm).to receive(:accessible_datastores).and_return('datastore-with-disk' => datastore_with_disk)
        expect(datacenter.find_disk(director_disk_cid, vm)).to eq(disk)
      end
    end

    context 'when disk exists but cannot be found in any of the datastores' do
      before do
        expect(client).to receive(:find_disk).with('disk-cid', persistent_datastore, 'fake-disk-path').and_return(nil)
        expect(client).to receive(:find_disk).with('disk-cid', other_datastore_1, 'fake-disk-path').and_return(nil)
        expect(client).to receive(:find_disk).with('disk-cid', other_datastore_2, 'fake-disk-path').and_return(nil)
      end

      context 'and VM with disk is found' do
        let(:vm) { instance_double(VSphereCloud::Resources::VM) }
        let(:vm_mob) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-vm-name') }

        before do
          expect(client).to receive(:find_vm_by_disk_cid).with(datacenter_mob, 'disk-cid').and_return(vm_mob)
          expect(VSphereCloud::Resources::VM).to receive(:new).with('fake-vm-name', vm_mob, client).and_return(vm)
        end

        # unexpected event has destroyed the disk
        context 'but disk_path does NOT exist' do
          it 'raises DiskNotFound' do
            expect(vm).to receive(:disk_path_by_cid).with('disk-cid').and_return(nil)

            expect { datacenter.find_disk(director_disk_cid) }.to raise_error do |error|
              expect(error).to be_a(Bosh::Clouds::DiskNotFound)
              expect(error.ok_to_retry).to eq(false)
              expect(error.message).to match(/Could not find disk with id 'disk-cid'/)
            end
          end
        end

        context 'and disk_path exists' do
          it 'returns the disk searching by VM attachments' do
            expect(vm).to receive(:disk_path_by_cid).with('disk-cid').and_return('[persistent-ds] fake-disk-path/fake-file_name.vmdk')
            expect(client).to receive(:find_disk).with('fake-file_name', persistent_datastore, 'fake-disk-path').and_return(disk)

            expect(datacenter.find_disk(director_disk_cid)).to eq(disk)
          end

          context 'but datastore is not accessible' do
            it 'raises DatastoreNotAccessible' do
              expect(vm).to receive(:disk_path_by_cid).with('disk-cid').and_return('[not-accessible-ds] fake-disk-path/fake-file_name.vmdk')
              expect(client).not_to receive(:find_disk)

              expect {datacenter.find_disk(director_disk_cid) }.to raise_error do |error|
                expect(error).to be_a(Bosh::Clouds::DiskNotFound)
                expect(error.ok_to_retry).to eq(false)
                expect(error.message).to match(/Could not find disk with id 'disk-cid'. Datastore 'not-accessible-ds' is not accessible./)
              end
            end
          end
        end
      end

      context 'and VM with disk is NOT found' do
        it 'raises DiskNotFound' do
          expect(client).to receive(:find_vm_by_disk_cid).with(datacenter_mob, 'disk-cid').and_return(nil)

          expect { datacenter.find_disk(director_disk_cid) }.to raise_error do |error|
            expect(error).to be_a(Bosh::Clouds::DiskNotFound)
            expect(error.ok_to_retry).to eq(false)
            expect(error.message).to match(/Could not find disk with id 'disk-cid'/)
          end
        end
      end
    end
  end

  describe '#move_disk_to_datastore' do
    let(:disk) do
      instance_double(
        VSphereCloud::Resources::PersistentDisk,
        path: '[old-datastore] fake-disk-path/fake-disk-cid.vmdk',
        cid: 'fake-disk-cid',
        size_in_mb: 1024,
      )
    end
    let(:vm_cid) {'vm-fake-vm'}
    it 'forwards the call to the client with the correct args' do
      target_path = "[#{datastore.name}] #{vm_cid}/fake-disk-cid.vmdk"
      expect(client).to receive(:move_disk).with(datacenter_mob, disk.path, datacenter_mob, target_path)
      expect(VSphereCloud::Resources::PersistentDisk).to receive(:new).with(
        cid: 'fake-disk-cid',
        size_in_mb: 1024,
        datastore: datastore,
        folder: "#{vm_cid}"
      ).and_call_original
      new_disk = datacenter.move_disk_to_datastore(disk, datastore, vm_cid)
      expect(new_disk.path).to eq(target_path)
    end
  end
end
