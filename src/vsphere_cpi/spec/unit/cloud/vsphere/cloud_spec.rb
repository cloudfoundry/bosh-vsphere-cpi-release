require 'spec_helper'
require 'ostruct'
require 'nsxt_manager_client/nsxt_manager_client/models/lb_pool'
require 'nsxt_manager_client/nsxt_manager_client/models/ns_group'
require 'nsxt_manager_client/nsxt_manager_client/api_client'
require 'nsxt_manager_client/nsxt_manager_client/api_error'
require 'nsxt_policy_client/nsxt_policy_client/api_client'
require 'nsxt_policy_client/nsxt_policy_client/api_error'
require 'nsxt_policy_client/nsxt_policy_client/models/lb_pool'
require 'nsxt_policy_client/nsxt_policy_client/models/lb_pool_member_group'
require 'nsxt_policy_client/nsxt_policy_client/models/group'

module VSphereCloud
  describe Cloud, fake_logger: true do
    subject(:vsphere_cloud) { Cloud.new(config) }
    let(:vm_type_storage_policy) { 'vcpi-vm-type-fake-policy' }
    let(:global_storage_policy) { 'vcpi-global-fake-policy' }
    let(:custom_fields_manager) { instance_double('VimSdk::Vim::CustomFieldsManager') }
    let(:config) { { 'vcenters' => [fake: 'config'] } }
    let(:cloud_config) do
      instance_double(
        'VSphereCloud::Config',
        logger: logger,
        memory_reservation_locked_to_max: memory_reservation_locked_to_max,
        vcenter_host: vcenter_host,
        vcenter_api_uri: vcenter_api_uri,
        vcenter_user: 'fake-user',
        vcenter_password: 'fake-password',
        vcenter_default_disk_type: default_disk_type,
        vcenter_connection_options: 'fake-connection-options',
        soap_log: 'fake-log-file',
        vcenter_enable_auto_anti_affinity_drs_rules: false,
        upgrade_hw_version: true,
        vcenter_http_logging: true,
        nsxt_enabled?: nsxt_enabled,
        nsxt: nsxt,
        vm_storage_policy_name: global_storage_policy,
        human_readable_name_enabled?: true
      ).as_null_object
    end
    let(:custom_fields_manager) { instance_double('VimSdk::Vim::CustomFieldsManager') }
    let(:nsxt_enabled) { false }
    let(:nsxt) { instance_double(VSphereCloud::NSXTConfig, default_vif_type: 'vif_type')}
    let(:default_disk_type) { 'preallocated' }
    let(:soap_stub) { instance_double(VSphereCloud::SdkHelpers::RetryableStubAdapter, vc_cookie: 'somerandomcookie') }
    let(:vcenter_client) { instance_double('VSphereCloud::VCenterClient', login: nil, service_content: service_content, soap_stub: soap_stub ) }
    let(:http_basic_auth_client) { instance_double('VSphereCloud::NsxHttpClient') }
    let(:http_client) { instance_double('VSphereCloud::CpiHttpClient') }
    let(:service_content) do
      instance_double('VimSdk::Vim::ServiceInstanceContent',
        virtual_disk_manager: virtual_disk_manager,
        setting: option_manager,
        custom_fields_manager: custom_fields_manager
      )
    end
    let(:virtual_disk_manager) { instance_double('VimSdk::Vim::VirtualDiskManager') }
    let(:option_manager) { instance_double('VimSdk::Vim::Option::OptionManager') }
    let(:agent_env) { instance_double('VSphereCloud::AgentEnv') }
    let(:memory_reservation_locked_to_max) { nil }
    let(:vcenter_host) { 'fake-host' }
    let(:vcenter_api_uri) { URI.parse("https://#{vcenter_host}") }
    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
    let(:pbm) { instance_double('VSphereCloud::Pbm') }
    let(:datacenter) do
      instance_double('VSphereCloud::Resources::Datacenter', name: 'fake-datacenter', clusters: [])
    end
    let(:vm_provider) { instance_double('VSphereCloud::VMProvider') }
    let(:vm) { instance_double('VSphereCloud::Resources::VM', mob: vm_mob, reload: nil, cid: 'vm-id') }
    let(:vm_mob) { instance_double('VimSdk::Vim::VirtualMachine') }
    let(:cluster_provider) { instance_double(VSphereCloud::Resources::ClusterProvider) }
    let(:tag_client) { instance_double(TaggingTag::AttachTagToVm) }
    let(:tagging_tagger) { instance_double(TaggingTag::AttachTagToVm) }
    let(:cpi_metadata_version){1}

    before do |example|
      allow(Config).to receive(:build).with(config).and_return(cloud_config)
      unless example.metadata[:skip_before]
        allow(CpiHttpClient).to receive(:new)
          .with(connection_options: 'fake-connection-options', http_log: 'fake-log-file')
          .and_return(http_client)
        allow(VCenterClient).to receive(:new)
                                  .with(
                                    vcenter_api_uri: vcenter_api_uri,
                                    http_client: http_client
                                  )
                                  .and_return(vcenter_client)
      end
      allow_any_instance_of(Cloud).to receive(:at_exit)
    end
    before do
      allow(TaggingTag::AttachTagToVm).to receive(:new).with(any_args).and_return(tagging_tagger)
      allow(TaggingTag::AttachTagToVm).to receive(:InitializeConnection).with(any_args).and_return(tag_client)
      allow(Resources::ClusterProvider).to receive(:new).and_return(cluster_provider)
      allow(Resources::Datacenter).to receive(:new).and_return(datacenter)
      allow(VSphereCloud::VMProvider).to receive(:new).and_return(vm_provider)
      allow(vm_provider).to receive(:find).with('vm-id').and_return(vm)
      allow(Pbm).to receive(:new).and_return(pbm)
      allow(CloudSearcher).to receive(:new).and_return(cloud_searcher)
      allow(VSphereCloud::AgentEnv).to receive(:new).and_return(agent_env)
    end


    describe '#enable_telemetry' do
      before do
        allow(CpiHttpClient).to receive(:new)
                                  .and_return(http_client)
        allow(VCenterClient).to receive(:new)
                                  .with(
                                    vcenter_api_uri: vcenter_api_uri,
                                    http_client: http_client,
                                  )
                                  .and_return(vcenter_client)
        allow(VCenterClient).to receive(:new)
                                  .with(
                                    vcenter_api_uri: vcenter_api_uri,
                                    http_client: http_client,
                                    logger: an_instance_of(::Logger)
                                  )
                                  .and_return(vcenter_client)
        allow(vcenter_client).to receive(:logout)
      end

      context 'when advanced config option is not present' do
        it 'calls update option once', :skip_before  do
          allow(option_manager).to receive(:query_view).with(any_args).
            and_raise(VimSdk::SoapError.new('message', VimSdk::Vim::Fault::InvalidName.new))
          expect(option_manager).to receive(:update_values).once
          vsphere_cloud.enable_telemetry
        end
      end
      context 'when advanced config option is  present' do
        it 'calls update option once', :skip_before do
          allow(option_manager).to receive(:query_view).with(any_args).
            and_return ([VimSdk::Vim::Option::OptionValue.new])
          expect(option_manager).not_to receive(:update_values)
          vsphere_cloud.enable_telemetry
        end
      end
    end

    describe '#has_vm?' do
      context 'the vm is found' do
        it 'returns true' do
          expect(vsphere_cloud.has_vm?('vm-id')).to be(true)
        end
      end

      context 'the vm is not found' do
        it 'returns false' do
          allow(vm_provider).to receive(:find).with('vm-id').and_raise(Bosh::Clouds::VMNotFound)
          expect(vsphere_cloud.has_vm?('vm-id')).to be(false)
        end
      end
    end

    describe '#has disk?' do
      let(:disk_cid) { 'disk-1234-5667-1242-1233' }
      let(:encoded_disk_cid) do
        metadata = {target_datastore_pattern: '^(fake\\-ds)$'}
        expected_pattern = Base64.urlsafe_encode64(metadata.to_json)
        "#{disk_cid}.#{expected_pattern}"
      end
      let(:director_disk_cid) do
        VSphereCloud::DirectorDiskCID.new(encoded_disk_cid)
      end

      before do
        allow(VSphereCloud::DirectorDiskCID).to receive(:new).with(encoded_disk_cid).and_return(director_disk_cid)
      end

      context 'when disk exists' do
        before do
          allow(datacenter).to receive(:find_disk).with(director_disk_cid).and_return('fake disk')
        end

        context 'when disk_cid contains metadata' do
          it 'returns true' do
            expect(vsphere_cloud.has_disk?(encoded_disk_cid)).to be(true)
          end
        end

        context 'when disk_cid does not contain metadata' do
          let(:encoded_disk_cid) { disk_cid }
          it 'returns true' do
            expect(vsphere_cloud.has_disk?(encoded_disk_cid)).to be(true)
          end
        end
      end

      context 'when disk does not exist' do
        before do
          allow(datacenter).to receive(:find_disk)
            .with(director_disk_cid)
            .and_raise(Bosh::Clouds::DiskNotFound.new(false), "Could not find disk with id '#{disk_cid}'")
        end

        context 'when disk_cid contains metadata' do
          it 'returns false' do
            expect(vsphere_cloud.has_disk?(encoded_disk_cid)).to be(false)
          end
        end

        context 'when disk_cid does not contain metadata' do
          let(:encoded_disk_cid) { disk_cid }
          it 'returns false' do
            expect(vsphere_cloud.has_disk?(encoded_disk_cid)).to be(false)
          end
        end
      end
    end

    describe '#snapshot_disk' do
      it 'raises not implemented exception when called' do
        expect { vsphere_cloud.snapshot_disk('123', {}) }.to raise_error(Bosh::Clouds::NotImplemented)
      end
    end

    describe '#resize_disk' do
      it 'raises not implemented exception when called' do
        expect { vsphere_cloud.resize_disk('123', 23) }.to raise_error(Bosh::Clouds::NotImplemented)
      end
    end

    describe '#generate_network_env' do
      let(:device) { instance_double('VimSdk::Vim::Vm::Device::VirtualEthernetCard', backing: backing, mac_address: '00:00:00:00:00:00') }
      let(:devices) { [device] }
      let(:network1) {
        {
          'cloud_properties' => {
            'name' => 'fake_network1'
          }
        }
      }
      let(:networks) { { 'fake_network1' => network1 } }
      let(:dvs_index) { {} }
      let(:expected_output) { {
        'fake_network1' => {
          'cloud_properties' => {
            'name' => 'fake_network1'
          },
          'mac' => '00:00:00:00:00:00'
        }
      } }
      let(:path_finder) { instance_double('VSphereCloud::PathFinder') }

      before do
        allow(device).to receive(:kind_of?).with(VimSdk::Vim::Vm::Device::VirtualEthernetCard) { true }
        allow(PathFinder).to receive(:new).and_return(path_finder)
        allow(path_finder).to receive(:path).with(any_args).and_return('fake_network1')
      end

      context 'using a distributed switch' do
        let(:backing) do
          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo.new
          backing_info.port = double(:port, portgroup_key: 'fake_pgkey1')
          backing_info
        end

        let(:dvs_index) { { 'fake_pgkey1' => 'fake_network1' } }

        it 'generates the network env' do

          allow(datacenter).to receive_message_chain(:mob, :network, :detect).and_return(nil)
          allow(cloud_searcher).to receive(:find_resources_by_property_path).and_return([])
          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'using a NSX on a distributed switch' do
        let(:opaque_network_id) { 'some_id' }
        let(:backing) do
          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo.new
          backing_info.port = double(:port, portgroup_key: 'fake_pgkey1')
          backing_info
        end
        let(:dvpg) do
          VimSdk::Vim::Dvs::DistributedVirtualPortgroup.new(
            name: "fake_network1", config: dvpg_config)

        end
        let(:dvpg_config) { double(:config, backing_type: "nsx", logical_switch_uuid: opaque_network_id) }

        let(:dvs_index) { { opaque_network_id => 'fake_network1' } }

        it 'generates the network env' do
          allow(datacenter).to receive(:mob)
          allow(cloud_searcher).to receive(:find_resources_by_property_path).and_return([dvpg])
          allow(dvpg).to receive(:config).and_return(dvpg_config)
          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'using an NSX opaque network' do
        let(:opaque_network_id) { 'some_id' }
        let(:backing) do
          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new
          backing_info.opaque_network_id = opaque_network_id
          backing_info
        end

        let(:dvs_index) { { opaque_network_id => 'fake_network1' } }

        it 'generates the network env' do
          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'using a standard switch' do
        let(:backing) { VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new }

        it 'generates the network env' do
          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'passing in device that is not a VirtualEthernetCard' do
        let(:devices) { [device, double()] }
        let(:backing) do
          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new
          backing_info.network = 'fake_network1'
          backing_info
        end

        it 'ignores non VirtualEthernetCard devices' do
          expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'not passing any device that is a VirtualEthernetCard' do
        let(:devices) { [] }
        let(:backing) { double }

        it 'responds with an appropriate error message' do
          expect {
            vsphere_cloud.generate_network_env(devices, networks, dvs_index)
          }.to raise_error(Cloud::NetworkException, "Could not find network 'fake_network1'")
        end
      end

      context 'when the network is in a folder' do

        context 'using a standard switch' do
          let(:path_finder) { instance_double('VSphereCloud::PathFinder') }
          let(:fake_network_object) { double() }
          let(:backing) do
            backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new
            backing_info.network = fake_network_object
            backing_info
          end
          let(:network1) {
            {
              'cloud_properties' => {
                'name' => 'networks/fake_network1'
              }
            }
          }
          let(:networks) { { 'networks/fake_network1' => network1 } }
          let(:expected_output) { {
            'networks/fake_network1' => {
              'cloud_properties' => {
                'name' => 'networks/fake_network1'
              },
              'mac' => '00:00:00:00:00:00'
            }
          } }

          it 'generates the network env' do
            allow(PathFinder).to receive(:new).and_return(path_finder)
            allow(path_finder).to receive(:path).with(fake_network_object).and_return('networks/fake_network1')

            expect(vsphere_cloud.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
          end
        end

      end

    end

    describe '#generate_disk_env' do
      let(:system_disk_unit_number) { 1 }
      let(:system_disk) do
        instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, unit_number: system_disk_unit_number)
      end
      let(:ephemeral_disk_unit_number) { 2 }
      let(:ephemeral_uuid) { 'TESTGENERATEDISKENV' }
      let(:ephemeral_backing) do
        instance_double(VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo, uuid: ephemeral_uuid)
      end
      let(:ephemeral_disk) do
        instance_double(VimSdk::Vim::Vm::Device::VirtualDisk,
                        backing: ephemeral_backing,
                        unit_number: ephemeral_disk_unit_number
        )
      end
      let(:vm_config) { instance_double(VmConfig) }
      context 'when disk uuid is disabled on VM' do
        it 'returns disk env with unit numbers' do
          allow(vm_config).to receive(:vmx_options).and_return({})
          disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, vm_config)
          expect(disk_env['ephemeral']). to eq(ephemeral_disk_unit_number.to_s)
          expect(disk_env['system']). to eq(system_disk_unit_number.to_s)
        end
      end
      context 'when disk uuid is enabled on VM' do
        it 'returns disk env with unit numbers and ephemeral disk with UUID set to id key' do
          allow(vm_config).to receive(:vmx_options).and_return({'disk.enableUUID' => '1'})
          disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, vm_config)
          expect(disk_env['ephemeral']). to eq({'id' => ephemeral_uuid.downcase})
          expect(disk_env['system']). to eq(system_disk_unit_number.to_s)
        end
      end
    end

    describe '#get_vms' do
      before do
        allow(datacenter).to receive(:master_vm_folder).and_return(master_vm_folder)
        allow(datacenter).to receive(:master_template_folder).and_return(master_template_folder)
      end

      let(:master_vm_folder) do
        instance_double('VSphereCloud::Resources::Folder',
          path: 'fake-vm-folder-path',
          mob: vm_folder_mob
        )
      end
      let(:vm_folder_mob) { double('fake folder mob', child_entity: [subfolder]) }
      let(:subfolder) { double('fake subfolder', child_entity: [vm_mob1, vm_mob2]) }
      let(:vm_mob1) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-vm-1') }
      let(:vm_mob2) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-vm-2') }

      let(:master_template_folder) do
        instance_double('VSphereCloud::Resources::Folder',
          path: 'fake-template-folder-path',
          mob: template_folder_mob
        )
      end
      let(:template_folder_mob) { double('fake template folder mob', child_entity: [template_subfolder_mob]) }
      let(:template_subfolder_mob) { double('fake template subfolder', child_entity: [stemcell_mob1, stemcell_mob2]) }
      let(:stemcell_mob1) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-stemcell-1') }
      let(:stemcell_mob2) { instance_double(VimSdk::Vim::VirtualMachine, name: 'fake-stemcell-2') }

      it 'returns all vms in vm_folder of datacenter and all stemcells in template_folder' do
        vms = vsphere_cloud.get_vms
        expect(vms.map(&:cid)).to eq(['fake-vm-1', 'fake-vm-2', 'fake-stemcell-1', 'fake-stemcell-2'])
        expect(vms.map(&:mob)).to eq([vm_mob1, vm_mob2, stemcell_mob1, stemcell_mob2])
      end
    end

    describe '#create_stemcell' do
      let(:target_datastore_cluster_pattern) { nil }
      let(:target_datastore_ephemeral_pattern) { 'fake-ephemeral-pattern' }
      let(:vm_config) { instance_double(VmConfig) }
      let(:fake_datastore) { instance_double(Resources::Datastore, name: 'fake-datastore') }
      let(:fake_cluster) { instance_double(VSphereCloud::Resources::Cluster, name: 'fake-cluster') }
      let(:fake_placement) { instance_double(VmPlacement, cluster: fake_cluster, datastores: [fake_datastore], hosts: nil)}
      let(:fake_disk_placement) { double('Object', name: 'fake-datastore') }
      let(:fake_import_result) { double('Object') }
      let(:fake_failed_import_result) { double('Object') }
      let(:fake_find_result) { double('Object') }
      let(:fake_system_disk) { instance_double(VimSdk::Vim::Vm::Device::VirtualDisk) }

      before do
        expect(VCPIExtension).to receive(:create_cpi_extension) # .with(config).and_return(cloud_config)
        allow(vsphere_cloud).to receive(:`).and_return(`true`)
        allow(vsphere_cloud).to receive(:enable_telemetry)
        allow(Dir).to receive(:entries).and_return(["foo.ovf"])
        allow(File).to receive(:size).and_return(1024 * 1024 * 2)
        expect(StoragePicker).to receive(:choose_global_ephemeral_pattern).and_return(target_datastore_ephemeral_pattern)
        allow(VmConfig).to receive(:new).and_return(vm_config)
        expect(vm_config).to receive(:cluster_placements).and_return([fake_placement])
        expect(fake_placement).to receive(:disk_placement).and_return(fake_disk_placement)
        allow(datacenter).to receive(:find_datastore).and_return(fake_datastore)
        allow(datacenter).to receive(:template_folder)
        allow(fake_cluster).to receive(:mob)
        allow(fake_datastore).to receive(:mob)
        allow(fake_cluster).to receive_message_chain(:resource_pool, :mob)
        allow(vsphere_cloud).to receive(:import_ovf).and_return(fake_import_result)
        allow(fake_import_result).to receive_message_chain(:import_spec, :config_spec, :device_change, :find).and_return(fake_find_result)
        allow(fake_failed_import_result).to receive(:import_spec).and_return(nil)
        allow(fake_failed_import_result).to receive(:error).and_return(VimSdk::Vim::Fault::OvfXmlFormat.new)
        allow(fake_find_result).to receive(:device).and_return(fake_system_disk)
        allow(fake_system_disk).to receive_message_chain(:backing, :thin_provisioned=)
        allow_any_instance_of(LeaseObtainer).to receive(:obtain)
        allow(fake_import_result).to receive(:file_item)
        allow(vsphere_cloud).to receive(:upload_ovf).and_return("foo")
        allow(cloud_searcher).to receive(:get_property).and_return([])
        allow(service_content).to receive_message_chain(:extension_manager, :find_extension)
        allow(vcenter_client).to receive(:reconfig_vm)
        allow(vcenter_client).to receive(:wait_for_task)
      end
      it 'creates the stemcell and returns the VM ID for the stemcell' do
        expect(vsphere_cloud.create_stemcell('fake_image', nil)).to match(/^sc-[0-9a-f\-]+$/)
      end

      context "when the stemcell contains a poorly formatted ovf file" do
        before do
          allow(vsphere_cloud).to receive(:import_ovf).and_return(fake_failed_import_result)
        end
        it 'raises an error' do
          expect {
            vsphere_cloud.create_stemcell('fake_image', nil)
          }.to raise_error(/Corrupt image.*OvfXmlFormat/)
        end

      end
    end

    describe '#create_vm' do
      let(:stemcell_vm) { instance_double(Resources::VM) }
      let(:vm_creator) { instance_double(VmCreator) }
      let(:vm_config) { instance_double(VmConfig) }
      let(:existing_disk_cids) { ['fake-disk-cid'] }
      let(:fake_disk) do
        instance_double(Resources::PersistentDisk,
          cid: 'fake-disk-cid',
          size_in_mb: 1234,
          datastore: fake_datastore,
        )
      end
      let(:fake_datastore) { instance_double(Resources::Datastore, name: 'fake-datastore') }
      let(:fake_vm) { instance_double(Resources::VM, cid: 'fake-cloud-id', mob_id: 'fake-mob-id', mob: stemcell_vm) }
      let(:vm_type) do
        {
          'cpu' => 1,
          'ram' => 1024,
          'disk' => 4096,
        }
      end
      let(:nsx) { instance_double(NSX) }
      let(:fake_cluster) { instance_double(VSphereCloud::Resources::Cluster, name: 'fake-cluster') }
      let(:target_datastore_pattern) { 'fake-persistent-pattern' }
      let(:target_datastore_cluster_pattern) { nil }
      let(:target_datastore_ephemeral_pattern) { 'fake-ephemeral-pattern' }
      let(:fake_persistent_disk) do
        instance_double(VSphereCloud::DiskConfig,
          cid: fake_disk.cid,
          size: fake_disk.size_in_mb,
          existing_datastore_name: fake_datastore.name,
          target_datastore_pattern: target_datastore_pattern,
        )
      end
      let(:fake_ephemeral_disk) do
        instance_double(VSphereCloud::DiskConfig,
          size: 4096,
          ephemeral?: true,
          target_datastore_pattern: 'fake-ephemeral-pattern',
        )
      end
      let(:encoded_disk_cid) { 'fake-disk-cid' }
      let(:director_disk_cid) { VSphereCloud::DirectorDiskCID.new(encoded_disk_cid) }
      let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
      let(:nsxt_policy_provider) { instance_double(VSphereCloud::NSXTPolicyProvider) }
      let(:stemcell) { VSphereCloud::Stemcell.new('fake-stemcell-cid') }
      let(:disk_pool) { VSphereCloud::DiskPool.new(datacenter,vm_type['datastores']) }
      let(:disk_configurations) { [fake_persistent_disk, fake_ephemeral_disk] }
      before do
        allow(VSphereCloud::NSXTProvider).to receive(:new).with(any_args).and_return(nsxt_provider)
        allow(VSphereCloud::NSXTPolicyProvider).to receive(:new).with(any_args).and_return(nsxt_policy_provider)
        allow(vsphere_cloud).to receive(:stemcell_vm).with('fake-stemcell-cid').and_return(stemcell_vm)
        allow(cloud_searcher).to receive(:get_property).with(
            stemcell_vm,
            VimSdk::Vim::VirtualMachine,
            'summary.storage.committed',
            ensure_all: true
          ).and_return(1024 * 1024 * 1024)
        allow(datacenter).to receive(:clusters).and_return([fake_cluster])
        allow(datacenter).to receive(:ephemeral_pattern).and_return(target_datastore_ephemeral_pattern)
        allow(datacenter).to receive(:persistent_pattern).and_return(target_datastore_pattern)
        allow(datacenter).to receive(:persistent_datastore_cluster_pattern).and_return(target_datastore_cluster_pattern)
        allow(datacenter).to receive(:find_disk).with(director_disk_cid).and_return(fake_disk)
        allow(vcenter_client).to receive(:set_custom_field)
        allow(VSphereCloud::DirectorDiskCID).to receive(:new).with(encoded_disk_cid).and_return(director_disk_cid)
        allow(DiskConfig).to receive(:new)
          .with(
            cid: fake_disk.cid,
            size: fake_disk.size_in_mb,
            existing_datastore_name: fake_datastore.name,
            target_datastore_pattern: target_datastore_pattern
          ).and_return(fake_persistent_disk)
        allow(DiskConfig).to receive(:new)
          .with(
            size: 4096,
            ephemeral: true,
            target_datastore_pattern: target_datastore_ephemeral_pattern
          ).and_return(fake_ephemeral_disk)
        allow(StoragePicker).to receive(:choose_ephemeral_pattern).and_return(
            [target_datastore_ephemeral_pattern, nil])
      end

      it 'creates a new VM with provided manifest properties' do
        expected_manifest_params = {
          vm_type: an_instance_of(VSphereCloud::VmType),
          networks_spec: 'fake-networks-hash',
          agent_id: 'fake-agent-id',
          agent_env:     {},
          stemcell: {
            cid: 'fake-stemcell-cid',
            size: 1024
          },
          global_clusters: [fake_cluster],
          disk_configurations: disk_configurations,
          storage_policy: nil,
          human_readable_name_info: nil,
          enable_human_readable_name: true,
        }

        expect(VmConfig).to receive(:new)
          .with(
            manifest_params: expected_manifest_params,
            cluster_provider: cluster_provider
          ).and_return(vm_config)

        expect(VmCreator).to receive(:new)
          .with(
            client: vcenter_client,
            cloud_searcher: cloud_searcher,
            cpi: vsphere_cloud,
            datacenter: datacenter,
            agent_env: agent_env,
            tagging_tagger: tagging_tagger,
            default_disk_type: default_disk_type,
            enable_auto_anti_affinity_drs_rules: false,
            stemcell: stemcell,
            upgrade_hw_version: true,
            pbm: pbm,
          ).and_return(vm_creator)
        expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
        vsphere_cloud.create_vm(
          'fake-agent-id',
          'fake-stemcell-cid',
          vm_type,
          'fake-networks-hash',
          existing_disk_cids,
          {}
        )
        expect(vcenter_client).to have_received(:set_custom_field)
      end

      it 'creates a new VM with no existing disks and default environment' do
        expected_manifest_params = {
          vm_type: an_instance_of(VSphereCloud::VmType),
          networks_spec: 'fake-networks-hash',
          agent_id: 'fake-agent-id',
          agent_env:     nil,
          stemcell: {
            cid: 'fake-stemcell-cid',
            size: 1024
          },
          global_clusters: [fake_cluster],
          disk_configurations: [fake_ephemeral_disk],
          storage_policy: nil,
          human_readable_name_info: nil,
          enable_human_readable_name: true,
        }
        expect(VmConfig).to receive(:new)
          .with(
            manifest_params: expected_manifest_params,
            cluster_provider: cluster_provider
          )
          .and_return(vm_config)

        expect(VmCreator).to receive(:new)
          .with(
            client: vcenter_client,
            cloud_searcher: cloud_searcher,
            cpi: vsphere_cloud,
            datacenter: datacenter,
            agent_env: agent_env,
            tagging_tagger: tagging_tagger,
            default_disk_type: default_disk_type,
            enable_auto_anti_affinity_drs_rules: false,
            upgrade_hw_version: true,
            stemcell: stemcell,
            pbm: pbm,
        ).and_return(vm_creator)

        expect(vm_creator).to receive(:create)
          .with(vm_config)
          .and_return(fake_vm)

        vsphere_cloud.create_vm(
          'fake-agent-id',
          'fake-stemcell-cid',
          vm_type,
          'fake-networks-hash',
        )
      end

      context 'when `cpu` is NOT set' do
        let(:vm_type) do
          {
            'ram' => 2048,
            'disk' => 4096,
          }
        end

        it 'should raise error' do
          expect {
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              {},
            )
          }.to raise_error(/Must specify 'cpu' in VM cloud properties/)
        end
      end

      context 'when `ram` is NOT set' do
        let(:vm_type) do
          {
            'cpu' => 1,
            'disk' => 4096,
          }
        end

        it 'should raise error' do
          expect {
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              {},
            )
          }.to raise_error(/Must specify 'ram' in VM cloud properties/)
        end
      end

      context 'when `disk` is NOT set' do
        let(:vm_type) do
          {
            'cpu' => 1,
            'ram' => 2048,
          }
        end

        it 'should raise error' do
          expect {
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              {},
            )
          }.to raise_error(/Must specify 'disk' in VM cloud properties/)
        end
      end

      context 'when existing_disk_cids contains encoded metadata' do
        let(:target_datastore_pattern) { '^(fake\-datastore)$' }
        let(:disk_metadata) do
          {
            target_datastore_pattern: target_datastore_pattern,
          }
        end
        let(:existing_disk_cids) { [encoded_disk_cid] }
        let(:fake_persistent_disk) do
          instance_double(
            VSphereCloud::DiskConfig,
            cid: fake_disk.cid,
            size: fake_disk.size_in_mb,
            existing_datastore_name: fake_datastore.name,
            target_datastore_pattern: target_datastore_pattern
          )
        end
        let(:encoded_disk_cid) { "fake-disk-cid.#{Base64.urlsafe_encode64(disk_metadata.to_json)}" }

        before do
          allow(VmCreator).to receive(:new).and_return(vm_creator)
          allow(vm_creator).to receive(:create).and_return(fake_vm)
          allow(DiskConfig).to receive(:new)
           .with(
             cid: fake_disk.cid,
             size: fake_disk.size_in_mb,
             existing_datastore_name: fake_datastore.name,
             target_datastore_pattern: target_datastore_pattern
           ).and_return(fake_persistent_disk)
        end

        it 'creates the VM with disk cid parsed from the metadata-encoded director disk cid' do
          expect(VmConfig).to receive(:new) do |options|
            expect(options[:manifest_params][:disk_configurations]).to eq([fake_persistent_disk, fake_ephemeral_disk])
            vm_config
          end

          vsphere_cloud.create_vm(
            'fake-agent-id',
            'fake-stemcell-cid',
            vm_type,
            'fake-networks-hash',
            existing_disk_cids,
            {}
          )
        end
      end

      context 'when default_disk_type is set to "thin"' do
        let(:default_disk_type) { 'thin' }

        it 'creates a new VM with a thinly-provisioned ephemeral disk' do
          expected_manifest_params = {
            vm_type: an_instance_of(VSphereCloud::VmType),
            networks_spec: 'fake-networks-hash',
            agent_id: 'fake-agent-id',
            agent_env:     {},
            stemcell: {
              cid: 'fake-stemcell-cid',
              size: 1024
            },
            global_clusters: [fake_cluster],
            disk_configurations: disk_configurations,
            storage_policy: nil,
            human_readable_name_info: nil,
            enable_human_readable_name: true
          }

          allow(VmConfig).to receive(:new)
                               .with({
                                 manifest_params: expected_manifest_params,
                                 cluster_provider: cluster_provider
                               })
                               .and_return(vm_config)

          expect(VmCreator).to receive(:new)
                                 .with(
                                   client: vcenter_client,
                                   cloud_searcher: cloud_searcher,
                                   cpi: vsphere_cloud,
                                   datacenter: datacenter,
                                   agent_env: agent_env,
                                   tagging_tagger: tagging_tagger,
                                   default_disk_type: 'thin',
                                   enable_auto_anti_affinity_drs_rules: false,
                                   upgrade_hw_version: true,
                                   stemcell: stemcell,
                                   pbm: pbm,
                                 )
                                 .and_return(vm_creator)
          expect(vm_creator).to receive(:create)
                                  .with(vm_config)
                                  .and_return(fake_vm)

          vsphere_cloud.create_vm(
            'fake-agent-id',
            'fake-stemcell-cid',
            vm_type,
            'fake-networks-hash',
            existing_disk_cids,
            {},
          )
        end
      end

      context 'when the VM should have security tags' do
        let(:fake_duplicate_sg) {'fake-security-tag'}
        let(:another_fake_duplicate_sg) {'another-fake-security-tag'}
        let(:fake_unique_bosh_group) {'fake-unique-bosh-group'}
        let(:cloud_config) do
          instance_double(
            'VSphereCloud::Config',
            logger: logger,
            vcenter_host: vcenter_host,
            vcenter_api_uri: vcenter_api_uri,
            vcenter_user: 'fake-user',
            vcenter_password: 'fake-password',
            vcenter_default_disk_type: default_disk_type,
            vcenter_connection_options: 'fake-connection-options',
            soap_log: 'fake-log-file',
            nsx_user: 'fake-nsx-user',
            nsx_password: 'fake-nsx-password',
            nsx_ca_cert_file: 'fake-nsx-ca-cert-file',
            nsxt_enabled?: false
          ).as_null_object
        end
        let(:vm_type) do
          {
            'cpu' => 1,
            'ram' => 1024,
            'disk' => 4096,
            'nsx' => {
              'security_groups' => %w(fake-security-tag another-fake-security-tag)
            }
          }
        end
        let(:environment) do
          {
            'bosh' => {
              'groups' => [
                'my-fake-environment-group',
              ]
            }
          }
        end

        before do
          allow(DiskConfig).to receive(:new)
            .with(
              size: nil,
              ephemeral: true,
              target_datastore_pattern: 'fake-ephemeral-pattern')
            .and_return(fake_ephemeral_disk)
        end

        it 'should create the security tags and attach them to the VM' do
          allow(VmConfig).to receive(:new).and_return(vm_config)
          allow(NsxHttpClient).to receive(:new)
                            .with('fake-nsx-user', 'fake-nsx-password', 'fake-nsx-ca-cert-file', 'fake-log-file')
                            .and_return(http_basic_auth_client)
          allow(NSX).to receive(:new).and_return(nsx)

          expect(VmCreator).to receive(:new).and_return(vm_creator)
          expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
          expect(cloud_config).to receive(:validate_nsx_options)
          expect(nsx).to receive(:add_vm_to_security_group).with('fake-security-tag', 'fake-mob-id')
          expect(nsx).to receive(:add_vm_to_security_group).with('another-fake-security-tag', 'fake-mob-id')
          expect(nsx).to receive(:add_vm_to_security_group).with('my-fake-environment-group', 'fake-mob-id')
          vsphere_cloud.create_vm(
            'fake-agent-id',
            'fake-stemcell-cid',
            vm_type,
            'fake-networks-hash',
            [],
            environment
          )
        end

        context 'when VM has duplicate security groups specified in vm_type, lbs and BOSH Groups' do
          let(:vm_type) do
            {
              'cpu' => 1,
              'ram' => 1024,
              'disk' => 4096,
              'nsx' => {
                'security_groups' => [fake_duplicate_sg, another_fake_duplicate_sg, another_fake_duplicate_sg],
                'lbs' => [
                  {
                    'edge_name' => 'fake-edge',
                    'pool_name' => 'fake-pool',
                    'security_group' => fake_duplicate_sg,
                    'port' => 443,
                    'monitor_port' => 443,
                  },
                  {
                    'edge_name' => 'fake-edge-2',
                    'pool_name' => 'fake-pool-2',
                    'security_group' => fake_duplicate_sg,
                    'port' => 443,
                    'monitor_port' => 443,
                  }
                ]
              }
            }
          end
          let(:environment) do
            {
              'bosh' => {
                'groups' => [
                  fake_duplicate_sg,
                  another_fake_duplicate_sg,
                  fake_unique_bosh_group,
                ]
              }
            }
          end
          it 'should de-duplicate the security tags and attach them to the VM' do
            allow(VmConfig).to receive(:new).and_return(vm_config)
            allow(NsxHttpClient).to receive(:new)
              .with('fake-nsx-user', 'fake-nsx-password', 'fake-nsx-ca-cert-file', 'fake-log-file')
              .and_return(http_basic_auth_client)
            allow(NSX).to receive(:new).and_return(nsx)

            expect(VmCreator).to receive(:new).and_return(vm_creator)
            expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
            expect(cloud_config).to receive(:validate_nsx_options)
            allow(nsx).to receive(:add_members_to_lbs)
            expect(nsx).to receive(:add_vm_to_security_group).with('fake-security-tag', 'fake-mob-id')
            expect(nsx).to receive(:add_vm_to_security_group).with('another-fake-security-tag', 'fake-mob-id')
            expect(nsx).to receive(:add_vm_to_security_group).with('fake-unique-bosh-group', 'fake-mob-id')
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              environment
            )
          end
        end

        context 'when VM has duplicate security groups specified in vm_type, and none in lbs or bosh groups' do
          let(:vm_type) do
            {
              'cpu' => 1,
              'ram' => 1024,
              'disk' => 4096,
              'nsx' => {
                'security_groups' => [fake_duplicate_sg, another_fake_duplicate_sg, another_fake_duplicate_sg],
                'lbs' => [
                  {
                    'edge_name' => 'fake-edge',
                    'pool_name' => 'fake-pool',
                    'port' => 443,
                    'monitor_port' => 443,
                  },
                  {
                    'edge_name' => 'fake-edge-2',
                    'pool_name' => 'fake-pool-2',
                    'port' => 443,
                    'monitor_port' => 443,
                  }
                ]
              }
            }
          end
          let(:environment) do
            {
              'bosh' => {
                'groups' => [
                ]
              }
            }
          end
          it 'should de-duplicate the security tags and attach them to the VM' do
            allow(VmConfig).to receive(:new).and_return(vm_config)
            allow(NsxHttpClient).to receive(:new)
              .with('fake-nsx-user', 'fake-nsx-password', 'fake-nsx-ca-cert-file', 'fake-log-file')
              .and_return(http_basic_auth_client)
            allow(NSX).to receive(:new).and_return(nsx)

            expect(VmCreator).to receive(:new).and_return(vm_creator)
            expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
            expect(cloud_config).to receive(:validate_nsx_options)
            expect(nsx).to receive(:add_vm_to_security_group).exactly(2).times
            allow(nsx).to receive(:add_members_to_lbs)
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              environment
            )
          end
        end

        context 'when VM has duplicate security groups specified lbs but none in vm_type or bosh groups' do
          let(:vm_type) do
            {
              'cpu' => 1,
              'ram' => 1024,
              'disk' => 4096,
              'nsx' => {
                'lbs' => [
                  {
                    'edge_name' => 'fake-edge',
                    'pool_name' => 'fake-pool',
                    'security_group' => fake_duplicate_sg,
                    'port' => 443,
                    'monitor_port' => 443,
                  },
                  {
                    'edge_name' => 'fake-edge-2',
                    'pool_name' => 'fake-pool-2',
                    'security_group' => fake_duplicate_sg,
                    'port' => 443,
                    'monitor_port' => 443,
                  }
                ]
              }
            }
          end
          let(:environment) do
            {
              'bosh' => {
              }
            }
          end
          it 'should de-duplicate the security tags and attach them to the VM' do
            allow(VmConfig).to receive(:new).and_return(vm_config)
            allow(NsxHttpClient).to receive(:new)
              .with('fake-nsx-user', 'fake-nsx-password', 'fake-nsx-ca-cert-file', 'fake-log-file')
              .and_return(http_basic_auth_client)
            allow(NSX).to receive(:new).and_return(nsx)

            expect(VmCreator).to receive(:new).and_return(vm_creator)
            expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
            expect(cloud_config).to receive(:validate_nsx_options)
            expect(nsx).to receive(:add_vm_to_security_group).once
            allow(nsx).to receive(:add_members_to_lbs)
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              environment
            )
          end
        end

        context 'when VM has duplicate security groups specified in bosh groups env but none in lbs and vm_type' do
          let(:vm_type) do
            {
              'cpu' => 1,
              'ram' => 1024,
              'disk' => 4096,
              'nsx' => {
                'security_groups' => [],
                'lbs' => []
              }
            }
          end
          let(:environment) do
            {
              'bosh' => {
                'groups' => [
                  fake_duplicate_sg,
                  fake_duplicate_sg,
                  another_fake_duplicate_sg,
                  another_fake_duplicate_sg,
                  another_fake_duplicate_sg,
                  fake_unique_bosh_group,
                  fake_unique_bosh_group,
                ]
              }
            }
          end
          it 'should de-duplicate the security tags and attach them to the VM' do
            allow(VmConfig).to receive(:new).and_return(vm_config)
            allow(NsxHttpClient).to receive(:new)
              .with('fake-nsx-user', 'fake-nsx-password', 'fake-nsx-ca-cert-file', 'fake-log-file')
              .and_return(http_basic_auth_client)
            allow(NSX).to receive(:new).and_return(nsx)

            expect(VmCreator).to receive(:new).and_return(vm_creator)
            expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
            expect(cloud_config).to receive(:validate_nsx_options)
            expect(nsx).to receive(:add_vm_to_security_group).exactly(3).times
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              environment
            )
          end
        end

        context 'when VM has no security groups specified in bosh groups env , lbs and vm_type' do
          let(:vm_type) do
            {
              'cpu' => 1,
              'ram' => 1024,
              'disk' => 4096,
              'nsx' => {
                'security_groups' => [],
                'lbs' => []
              }
            }
          end
          let(:environment) do
            {
              'bosh' => {
                'groups' => []
              }
            }
          end
          it 'should not call add_vm_to_security_group VM' do
            allow(VmConfig).to receive(:new).and_return(vm_config)
            allow(NsxHttpClient).to receive(:new)
              .with('fake-nsx-user', 'fake-nsx-password', 'fake-nsx-ca-cert-file', 'fake-log-file')
              .and_return(http_basic_auth_client)
            allow(NSX).to receive(:new).and_return(nsx)

            expect(VmCreator).to receive(:new).and_return(vm_creator)
            expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
            expect(nsx).to_not receive(:add_vm_to_security_group)
            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              environment
            )
          end
        end
      end

      context 'when NSX-T is enabled' do
        let(:nsxt_config) { VSphereCloud::NSXTConfig.new('fake-host', 'fake-username', 'fake-password') }
        let(:cloud_config) do
          instance_double(
            'VSphereCloud::Config',
            logger: logger,
            vcenter_host: vcenter_host,
            vcenter_api_uri: vcenter_api_uri,
            vcenter_user: 'fake-user',
            vcenter_password: 'fake-password',
            vcenter_default_disk_type: default_disk_type,
            vcenter_connection_options: 'fake-connection-options',
            soap_log: 'fake-log-file',
            nsxt_enabled?: true,
            nsxt: nsxt_config
          ).as_null_object
        end
        let(:vm_type) do
          {
            'cpu' => 1,
            'ram' => 1024,
            'disk' => 4096,
            'nsxt' => vm_type_nsxt_config
          }
        end

        before do
          allow(VmConfig).to receive(:new).and_return(vm_config)
          expect(VmCreator).to receive(:new).and_return(vm_creator)
          expect(vm_creator).to receive(:create).with(vm_config).and_return(fake_vm)
        end

        context "in Policy API Migration Mode" do
          before do
            allow(nsxt_config).to receive(:use_policy_api?).and_return(false)
            allow(nsxt_config).to receive(:policy_api_migration_mode?).and_return(true)
            allow(nsxt_provider).to receive(:set_vif_type)
          end

          context "regardless of resources set in nsxt_config pools/groups" do
            let(:vm_type_nsxt_config) { {} }
            it "always sets vif_type in management mode" do
              expect(nsxt_provider).to receive(:set_vif_type).with(fake_vm, {})
              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end
          end

          context "when ns_groups are set" do
            let(:group_1) { double(NSXTPolicy::Group, id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1") }
            let(:group_2) { double(NSXTPolicy::Group, id: 'fake-nsgroup-2-id', display_name: "fake nsgroup 2") }
            let(:vm_type_nsxt_config) do
              { 'ns_groups' => [group_1.display_name, group_2.display_name] }
            end

            before do
              allow(nsxt_policy_provider).to receive(:retrieve_groups_by_name).with(["fake nsgroup 1", "fake nsgroup 2"]).and_return([group_1, group_2])
            end

            it "calls policy_provider#add_vm_to_groups AND provider#add_vm_to_nsgroups with the vm and ns_groups values" do
              expect(nsxt_policy_provider).to receive(:add_vm_to_groups).with(fake_vm, [group_1, group_2])
              expect(nsxt_provider).to receive(:add_vm_to_nsgroups).with(fake_vm, [group_1.display_name, group_2.display_name])


              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end

            it "adds _just_ to found groups if not all groups are found." do
              allow(nsxt_policy_provider).to receive(:retrieve_groups_by_name).with(["fake nsgroup 1", "fake nsgroup 2"]).and_return([group_1])
              expect(logger).to receive(:info).with("Not all specified groups found, missing fake nsgroup 2. VM will still be added to found groups (fake nsgroup 1)")
              expect(nsxt_policy_provider).to receive(:add_vm_to_groups).with(fake_vm, [group_1])
              expect(nsxt_provider).to receive(:add_vm_to_nsgroups).with(fake_vm, [group_1.display_name, group_2.display_name])

              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end

            it 'deletes created VM and raises error if an error occurs when calling #add_vm_to_groups on the management side' do
              nsxt_error = NSGroupsNotFound.new('fake-nsgroup-name')
              allow(nsxt_policy_provider).to receive(:add_vm_to_groups).with(fake_vm, [group_1, group_2])
              allow(nsxt_provider).to receive(:add_vm_to_nsgroups).with(any_args).and_raise(nsxt_error)
              expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)
              expect do
                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end.to raise_error(nsxt_error)
            end
          end

          context 'and server pool(s) are specified in the nsxt configuration' do
            let(:vm_type_nsxt_config) do
              { 'ns_groups' => [], 'lb' => { 'server_pools' => [server_pool.display_name] } }
            end
            let(:server_pool) { NSXT::LbPool.new(:id => 'id-1', :display_name => 'test-serverpool-1') }
            let(:server_pools) { [server_pool] }

            it 'adds vm to both Management AND Policy server pool(s)' do
              expect(nsxt_policy_provider).to receive(:retrieve_server_pools).with([server_pool.display_name], true).and_return([server_pools, []])
              expect(nsxt_policy_provider).to receive(:add_vm_to_server_pools).with(fake_vm, server_pools)
              expect(nsxt_provider).to receive(:retrieve_server_pools).with([server_pool.display_name]).and_return([server_pools, []])
              expect(nsxt_provider).to receive(:add_vm_to_server_pools).with(fake_vm, server_pools)

              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end

            context 'when the server pool is dynamic' do

              let(:dynamic_policy_pool) { NSXTPolicy::LBPool.new(:id => 'id-1', :display_name => 'test-serverpool-1', member_group: member_group) }
              let(:dynamic_management_pool) { NSXT::LbPool.new(:id => 'id-1', :display_name => 'test-serverpool-1', member_group: double("", grouping_object: double("", target_display_name: management_group_1.display_name))) }
              let(:policy_group_1) { double(NSXTPolicy::Group, id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1") }
              let(:management_group_1) { double(NSXT::NSGroup, id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1") }
              let(:member_group) { double(NSXTPolicy::LBPoolMemberGroup, group_path: "some/group/path/#{policy_group_1.id}") }

              it 'adds the vm to the group(s) associated with the server pool(s) on both the Policy and Management side' do
                allow(nsxt_policy_provider).to receive(:retrieve_server_pools).with([server_pool.display_name], true).and_return([nil, [dynamic_policy_pool]])
                allow(nsxt_policy_provider).to receive(:retrieve_groups_by_id).with([policy_group_1.id]).and_return([policy_group_1])
                allow(nsxt_provider).to receive(:retrieve_server_pools).with([server_pool.display_name]).and_return([nil, [dynamic_management_pool]])
                expect(nsxt_policy_provider).to receive(:add_vm_to_groups).with(fake_vm, [policy_group_1])
                expect(nsxt_provider).to receive(:add_vm_to_nsgroups).with(fake_vm, [management_group_1.display_name])

                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end
            end

            it 'deletes created VM and raises error if an error occurs when adding VM to server pools on the management side' do
              nsxt_error = NSXT::ApiCallError.new
              allow(nsxt_policy_provider).to receive(:retrieve_server_pools).with([server_pool.display_name], true).and_return([server_pools, []])
              allow(nsxt_policy_provider).to receive(:add_vm_to_server_pools).with(fake_vm, server_pools)
              allow(nsxt_provider).to receive(:retrieve_server_pools).with([server_pool.display_name]).and_return([server_pools, []])
              allow(nsxt_provider).to receive(:add_vm_to_server_pools).and_raise(nsxt_error)

              expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)
              expect do
                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end.to raise_error(nsxt_error)
            end
          end

        end

        context "and the Policy API is used" do
          before do
            allow(nsxt_config).to receive(:use_policy_api?).and_return(true)
          end

          context "when ns_groups are set" do
            let(:group_1) { double(NSXTPolicy::Group, id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1") }
            let(:group_2) { double(NSXTPolicy::Group, id: 'fake-nsgroup-2-id', display_name: "fake nsgroup 2") }
            let(:vm_type_nsxt_config) do
              { 'ns_groups' => ['fake nsgroup 1', 'fake nsgroup 2'] }
            end

            before do
              allow(nsxt_policy_provider).to receive(:retrieve_groups_by_name).with(["fake nsgroup 1", "fake nsgroup 2"]).and_return([group_1, group_2])
            end

            it "calls policy_provider#add_vm_to_nsgroups with the vm and ns_groups values" do
              expect(nsxt_policy_provider).to receive(:add_vm_to_groups).with(fake_vm, [group_1, group_2])
              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end

            context "when not all groups specified in ns_groups can be found" do
              it "rolls back vm creation" do
                allow(nsxt_policy_provider).to receive(:retrieve_groups_by_name).with(["fake nsgroup 1", "fake nsgroup 2"]).and_return([group_1])
                expect(nsxt_policy_provider).not_to receive(:add_vm_to_groups)
                expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)

                expect do
                  vsphere_cloud.create_vm(
                    'fake-agent-id',
                    'fake-stemcell-cid',
                    vm_type,
                    'fake-networks-hash',
                    [],
                    {}
                  )
                end.to raise_error(Cloud::MissingNSXTGroups)
              end
            end

            it 'deletes created VM and raises error if an error occurs when calling #add_vm_to_groups' do
              nsxt_error = NSGroupsNotFound.new('fake-nsgroup-name')
              allow(nsxt_policy_provider).to receive(:add_vm_to_groups).with(any_args).and_raise(nsxt_error)
              expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)
              expect do
                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end.to raise_error(nsxt_error)
            end
          end

          context 'and server pool(s) are specified in the nsxt configuration' do
            let(:vm_type_nsxt_config) do
              {
                'ns_groups' => groups,
                'lb' => {
                  'server_pools' => server_pools.map { |sp| {"name" => sp.display_name, "port" => "dont-care"} }
                  }
                }
            end

            let(:groups) { [] }

            before do
              allow(nsxt_policy_provider).to receive(:retrieve_server_pools).with(vm_type_nsxt_config['lb']['server_pools'], false).and_return([static_pools, dynamic_pools])
            end

            context 'when the server pool is static' do
              let(:server_pool) { NSXTPolicy::LBPool.new(:id => 'id-1', :display_name => 'test-serverpool-1', member_group: nil) }
              let(:server_pools) { [server_pool] }
              let(:static_pools) { [server_pool, 'dont-care'] }
              let(:dynamic_pools) { nil }

              it 'adds vm to server pool(s)' do
                expect(nsxt_policy_provider).to receive(:add_vm_to_server_pools).with(fake_vm, static_pools)

                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end

              it 'deletes created VM and raises error if an error occurs when adding VM to server pools' do
                nsxt_error = NSXTPolicy::ApiCallError.new
                allow(nsxt_policy_provider).to receive(:add_vm_to_server_pools).and_raise(nsxt_error)

                expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)
                expect do
                  vsphere_cloud.create_vm(
                    'fake-agent-id',
                    'fake-stemcell-cid',
                    vm_type,
                    'fake-networks-hash',
                    [],
                    {}
                  )
                end.to raise_error(nsxt_error)
              end
            end

            context 'when the server pool is dynamic' do

              let(:server_pool) { NSXTPolicy::LBPool.new(:id => 'id-1', :display_name => 'test-serverpool-1', member_group: member_group) }
              let(:group_1) { double(NSXTPolicy::Group, id: 'fake-nsgroup-1-id', display_name: "fake nsgroup 1") }
              let(:member_group) { double(NSXTPolicy::LBPoolMemberGroup, group_path: "some/group/path/#{group_1.id}") }

              let(:server_pools) { [server_pool] }
              let(:dynamic_pools) { server_pools }
              let(:static_pools) { nil }

              it 'adds the vm to the group(s) associated with the server pool(s)' do
                allow(nsxt_policy_provider).to receive(:retrieve_groups_by_id).with([group_1.id]).and_return([group_1])

                expect(nsxt_policy_provider).to receive(:add_vm_to_groups).with(fake_vm, [group_1])

                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end

            end
          end

        end
        context "and the Management API is used" do
          let(:vm_type_nsxt_config) { {} }
          before do
            allow(nsxt_provider).to receive(:set_vif_type)
          end

          it "always calls set_vif_type with the vm and nsxt configuration" do
            #TODO: the provider interface here is a little odd, imo it should take the vm and vif_type vs. the configuration object (which couples the provider to the config)
            expect(nsxt_provider).to receive(:set_vif_type).with(fake_vm, vm_type['nsxt'])

            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              [],
              {}
            )
          end

          it 'deletes created VM and raises error if an error occurs when calling provider#set_vif_type' do
            nsxt_error = NSXT::ApiCallError.new
            allow(nsxt_provider).to receive(:set_vif_type).and_raise(nsxt_error)
            expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)

            expect do
              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end.to raise_error(nsxt_error)
          end

          it 're-raises error if an error occurs when calling delete_vm after an error' do
            nsxt_error = NSXT::ApiCallError.new
            delete_vm_error = StandardError.new
            allow(nsxt_provider).to receive(:set_vif_type).and_raise(nsxt_error)
            allow(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid).and_raise(delete_vm_error)

            expect do
              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end.to raise_error(delete_vm_error)
          end


          context "when ns_groups are set" do
            let(:vm_type_nsxt_config) do
              { 'ns_groups' => ['fake-nsgroup-1', 'fake-nsgroup-2'] }
            end

            it "calls provider#add_vm_to_nsgroups with the vm and ns_groups values" do
              expect(nsxt_provider).to receive(:add_vm_to_nsgroups).with(fake_vm, ['fake-nsgroup-1', 'fake-nsgroup-2'])

              vsphere_cloud.create_vm(
                'fake-agent-id',
                'fake-stemcell-cid',
                vm_type,
                'fake-networks-hash',
                [],
                {}
              )
            end

            it 'deletes created VM and raises error if an error occurs when calling #add_vm_to_nsgroups' do
              nsxt_error = NSGroupsNotFound.new('fake-nsgroup-name')
              allow(nsxt_provider).to receive(:add_vm_to_nsgroups).with(any_args).and_raise(nsxt_error)
              expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)
              expect do
                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end.to raise_error(nsxt_error)
            end
          end

          context 'and server pool(s) are specified in the nsxt configuration' do
            let(:vm_type_nsxt_config) do
              {
                'ns_groups' => [],
                'lb' => {
                  'server_pools' => [server_pool].map { |sp| {"name" => sp.display_name, "port": "dont-care"} }
                }
              }
            end
            let(:server_pool) { NSXT::LbPool.new(:id => 'id-1', :display_name => 'test-serverpool-1') }

            before do
              allow(nsxt_provider).to receive(:retrieve_server_pools).with(vm_type['nsxt']['lb']['server_pools']).and_return([static_pools, dynamic_pools])
            end


            context "and the specified server pool is static" do
              let(:static_pools) { [server_pool] }
              let(:dynamic_pools) { nil }


              it 'adds vm to server pool' do
                expect(nsxt_provider).to receive(:add_vm_to_server_pools).with(fake_vm, [server_pool])

                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end

              it 'deletes created VM and raises error if an error occurs when adding VM to server pools' do
                nsxt_error = NSXT::ApiCallError.new
                allow(nsxt_provider).to receive(:add_vm_to_server_pools).and_raise(nsxt_error)

                expect(vsphere_cloud).to receive(:delete_vm).with(fake_vm.cid)
                expect do
                  vsphere_cloud.create_vm(
                    'fake-agent-id',
                    'fake-stemcell-cid',
                    vm_type,
                    'fake-networks-hash',
                    [],
                    {}
                  )
                end.to raise_error(nsxt_error)
              end
            end

            context "and the specified server pool is dynamic" do
              let(:static_pools) { nil }
              let(:dynamic_pools) { [server_pool]  }

              it "adds vm to dynamic server pool's nsgroups" do
                allow(server_pool).to receive_message_chain(:member_group,:grouping_object, :target_display_name).and_return('test-nsgroup1')
                expect(nsxt_provider).to receive(:add_vm_to_nsgroups).with(fake_vm, ['test-nsgroup1'])

                vsphere_cloud.create_vm(
                  'fake-agent-id',
                  'fake-stemcell-cid',
                  vm_type,
                  'fake-networks-hash',
                  [],
                  {}
                )
              end
            end
          end
        end
      end

      context 'when memory_reservation_locked_to_max is specified at the cpi config level' do
        let(:memory_reservation_locked_to_max) { true }
        before do
          expect(VmCreator).to receive(:new)
                                 .with(
                                   client: vcenter_client,
                                   cloud_searcher: cloud_searcher,
                                   cpi: vsphere_cloud,
                                   datacenter: datacenter,
                                   agent_env: agent_env,
                                   tagging_tagger: tagging_tagger,
                                   default_disk_type: 'preallocated',
                                   enable_auto_anti_affinity_drs_rules: false,
                                   upgrade_hw_version: true,
                                   stemcell: stemcell,
                                   pbm: pbm,
                                 )
                                 .and_return(vm_creator)
          expect(vm_creator).to receive(:create)
                                  .with(vm_config)
                                  .and_return(fake_vm)
        end

        it 'creates the VM with the configured memory_reservation_locked_to_max' do
          expect(VmConfig).to receive(:new) do |options|
            expect(options[:manifest_params][:vm_type].memory_reservation_locked_to_max).to be_truthy
            vm_config
          end

          vsphere_cloud.create_vm(
            'fake-agent-id',
            'fake-stemcell-cid',
            vm_type,
            'fake-networks-hash',
            existing_disk_cids,
            {}
          )
        end

        context 'when memory_reservation_locked_to_max is also specified in the cloud properties' do
          before do
            vm_type['memory_reservation_locked_to_max'] = false
          end

          it 'creates the VM using the cloud_properties memory_reservation_locked_to_max value' do
            expect(VmConfig).to receive(:new) do |options|
              expect(options[:manifest_params][:vm_type].memory_reservation_locked_to_max).to be_falsey
              vm_config
            end

            vsphere_cloud.create_vm(
              'fake-agent-id',
              'fake-stemcell-cid',
              vm_type,
              'fake-networks-hash',
              existing_disk_cids,
              {}
            )
          end
        end
      end
    end

    describe '#clone_vm' do
      let(:vm_config) { double('VmConfig', name: 'vm-123456') }
      let(:config_spec) { instance_double(VimSdk::Vim::Vm::ConfigSpec) }
      let(:vm_folder_mob) { double('fake folder mob') }
      let(:resource_pool) { double(:resource_pool, mob: 'fake_resource_pool_mob') }
      let(:fake_vm) { instance_double(Resources::VM, cid: 'fake-cloud-id', mob_id: 'fake-mob-id') }
      let(:datastore) { instance_double('VSphereCloud::Resources::Datastore')}
      let(:relocation_spec) { VimSdk::Vim::Vm::RelocateSpec.new }
      let(:datastore_cluster) {instance_double(Resources::StoragePod, mob: 'fake_storage_pod_mob')}
      let(:recommendation) { double('Recommendation', key: 'first_recommendation') }
      let(:srm) { instance_double(VimSdk::Vim::StorageResourceManager) }
      let(:storage_placement_result) { instance_double(VimSdk::Vim::StorageDrs::StoragePlacementResult, drs_fault: nil) }

      before do
        allow(VimSdk::Vim::Vm::RelocateSpec).to receive(:new).and_return(relocation_spec)
        allow(relocation_spec).to receive(:pool=).with(resource_pool.mob).and_return(resource_pool.mob)
        allow(relocation_spec).to receive(:disk_move_type=).with('createNewChildDiskBacking').and_return('createNewChildDiskBacking')
      end

      context 'when datastore option is not supplied' do
        it 'clones the vm' do
          expect(relocation_spec).to receive(:datastore=).never
          expect(vm_mob).to receive(:clone).with(vm_folder_mob, vm_config.name, an_instance_of(VimSdk::Vim::Vm::CloneSpec)).and_return(fake_vm)
          vsphere_cloud.clone_vm(
            vm_mob,
            vm_config.name,
            vm_folder_mob,
            resource_pool.mob,
            linked: true,
            config: config_spec
          )
        end
      end
      context 'with datastore option' do
        it 'clones vm on to supplied datastore' do
          allow(relocation_spec).to receive(:datastore=).with(datastore).and_return(datastore)
          expect(vm_mob).to receive(:clone).with(vm_folder_mob, vm_config.name, an_instance_of(VimSdk::Vim::Vm::CloneSpec)).and_return(fake_vm)
          vsphere_cloud.clone_vm(
            vm_mob,
            vm_config.name,
            vm_folder_mob,
            resource_pool.mob,
            linked: true,
            config: config_spec,
            datastore: datastore
          )
        end
      end
    end

    describe '#calculate_vm_cloud_properties' do
      context 'when ram, cpu, and ephemeral_disk are specified' do
        let(:vm_properties) { {
          'ram' => 512,
          'cpu' => 2,
          'ephemeral_disk_size' => 2048
        } }
        it 'returns a vSphere-specific set of cloud_properties' do
          expect(vsphere_cloud.calculate_vm_cloud_properties(vm_properties)).to eq({
            'ram' => 512,
            'cpu' => 2,
            'disk' => 2048
          })
        end
      end
      context 'when one of the three keys is missing' do
        let(:vm_properties) { {
          'ram' => 512,
          'cpu' => 2,
        } }
        it 'raises an error' do
          expect{vsphere_cloud.calculate_vm_cloud_properties(vm_properties)}.to raise_error(
            /Missing VM cloud properties: 'ephemeral_disk_size'/)
        end
      end
      context 'when two of the three keys is missing' do
        let(:vm_properties) { {
          'cpu' => 2,
        } }
        it 'raises an error' do
          expect{vsphere_cloud.calculate_vm_cloud_properties(vm_properties)}.to raise_error(
            /Missing VM cloud properties: 'ram', 'ephemeral_disk_size'/)
        end
      end
    end

    describe '#attach_disk' do
      before do
        allow(ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
      end
      let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
      let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
      let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
      let(:ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
      let(:datastore_with_disk) { Resources::Datastore.new('datastore-with-disk', ds_mob, true, 4096, 2048) }
      let(:datastore_without_disk) { Resources::Datastore.new('datastore-without-disk', ds_mob, true, 4096, 4096) }
      let(:inaccessible_datastore) { Resources::Datastore.new('datastore-inaccessible', ds_mob, true, 4096, 4096) }
      let(:disk) { Resources::PersistentDisk.new(cid: 'disk-cid', size_in_mb: 1024, datastore: datastore_with_disk, folder: 'fake-folder') }
      let(:director_disk_cid) { VSphereCloud::DirectorDiskCID.new('disk-cid') }
      let(:vm_location) do
        {
          datacenter: 'fake-datacenter',
          datastore: datastore_with_disk,
          vm: 'vm-id'
        }
      end
      let(:cdrom) { instance_double(VimSdk::Vim::Vm::Device::VirtualCdrom) }


      before do
        allow(datacenter).to receive(:persistent_pattern).and_return(/datastore\-.*/)
        allow(datacenter).to receive(:persistent_datastore_cluster_pattern).and_return('')
        allow(vm_provider).to receive(:find).with('fake-vm-cid').and_return(vm)
        allow(cdrom).to receive_message_chain(:backing, :datastore, :name) { 'datastore-with-disk' }
        allow(vcenter_client).to receive(:get_cdrom_device).with(vm_mob).and_return(cdrom)
      end

      context 'when disk is in a datastore accessible to VM' do
        before do
          allow(vm).to receive(:accessible_datastores).and_return('datastore-with-disk' => datastore_with_disk)
        end

        it 'attaches the existing persistent disk without uuid' do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with('disk-cid').and_return(director_disk_cid)
          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(false)
          expect(vm).to receive(:attach_disk) do |disk|
            expect(disk.cid).to eq('disk-cid')
            OpenStruct.new(device: OpenStruct.new(unit_number: 2))
          end
          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
          expect(disk_hint).to match('2')
        end

        it 'attaches the existing persistent disk with uuid' do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with('disk-cid').and_return(director_disk_cid)

          expect(vm).to receive(:attach_disk) do |disk|
            expect(disk.cid).to eq('disk-cid')
            OpenStruct.new(device: OpenStruct.new(backing: OpenStruct.new(uuid: 'SOME-UUID')))
          end
          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(true)

          expect(vm).to receive(:disk_by_cid) do |disk_cid|
            expect(disk_cid).to eq('disk-cid')
            OpenStruct.new(backing: OpenStruct.new(uuid: 'SOME-UUID'))
          end

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
          expect(disk_hint).to eq({ 'id' => 'some-uuid'})
        end

        it 'attaches the existing persistent disk with encoded metadata and without uuid' do
          metadata_hash = {
            target_datastore_pattern: '.*'
          }
          encoded_metadata = Base64.urlsafe_encode64(metadata_hash.to_json)
          disk_cid_with_metadata = "disk-cid.#{encoded_metadata}"

          director_disk_cid = VSphereCloud::DirectorDiskCID.new(disk_cid_with_metadata)
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with(disk_cid_with_metadata).and_return(director_disk_cid)

          expect(vm).to receive(:attach_disk) do |disk|
            expect(disk.cid).to eq('disk-cid')
            OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number'))
          end
          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(false)

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', disk_cid_with_metadata)
          expect(disk_hint).to eq('some-unit-number')
        end

        it 'attaches the existing persistent disk with encoded metadata and with uuid' do
          metadata_hash = {
            target_datastore_pattern: '.*'
          }
          encoded_metadata = Base64.urlsafe_encode64(metadata_hash.to_json)
          disk_cid_with_metadata = "disk-cid.#{encoded_metadata}"

          director_disk_cid = VSphereCloud::DirectorDiskCID.new(disk_cid_with_metadata)
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with(disk_cid_with_metadata).and_return(director_disk_cid)

          expect(vm).to receive(:attach_disk) do |disk|
            expect(disk.cid).to eq('disk-cid')
            OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number', backing: OpenStruct.new(uuid: 'SOME-UUID')))
          end
          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(true)

          expect(vm).to receive(:disk_by_cid) do |disk_cid|
            expect(disk_cid).to eq('disk-cid')
            OpenStruct.new(backing: OpenStruct.new(uuid: 'SOME-UUID'))
          end

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', disk_cid_with_metadata)
          expect(disk_hint).to eq({'id' => 'some-uuid'})
        end
      end

      context 'when disk is not in a datastore accessible to VM' do
        let(:moved_disk) do
          Resources::PersistentDisk.new(
            cid: 'disk-cid',
            size_in_mb: 1024,
            datastore: datastore_without_disk,
            folder: 'fake-folder')
        end

        let(:vm_location) do
          {
            datacenter: 'fake-datacenter',
            datastore: datastore_without_disk,
            vm: 'vm-id'
          }
        end

        before do
          datastores = { 'datastore-without-disk' => datastore_without_disk, 'inaccessible_datastore' => inaccessible_datastore }
          allow(vm).to receive(:accessible_datastores).and_return(datastores)
          allow(datacenter).to receive(:find_datastore).with('datastore-without-disk').and_return(datastore_without_disk)
          allow(cdrom).to receive_message_chain(:backing, :datastore, :name) { 'datastore-without-disk' }
          expect(inaccessible_datastore).to receive(:accessible?).and_return(false)
        end

        it 'moves the non-UUID disk to an accessible datastore and attaches it' do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with('disk-cid').and_return(director_disk_cid)
          expect(datacenter).to receive(:move_disk_to_datastore).with(disk, datastore_without_disk)
            .and_return(moved_disk)

          expect(vm).to receive(:attach_disk).with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number', backing: OpenStruct.new(uuid: 'some-uuid'))))

          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(false)

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
          expect(disk_hint).to eq('some-unit-number')
        end

        it 'moves the UUID disk to an accessible datastore and attaches it' do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with('disk-cid').and_return(director_disk_cid)
          expect(datacenter).to receive(:move_disk_to_datastore).with(disk, datastore_without_disk)
            .and_return(moved_disk)

          expect(vm).to receive(:attach_disk).with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number', backing: OpenStruct.new(uuid: 'SOME-UUID'))))

          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(true)

          expect(vm).to receive(:disk_by_cid) do |disk_cid|
            expect(disk_cid).to eq('disk-cid')
            OpenStruct.new(backing: OpenStruct.new(uuid: 'SOME-UUID'))
          end

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
          expect(disk_hint).to eq({'id' => 'some-uuid'})
        end
      end

      context 'when disk is not in a persistent datastore' do
        let(:moved_disk) { Resources::PersistentDisk.new(cid: 'disk-cid', size_in_mb: 1024, datastore: datastore_without_disk, folder: 'fake-folder') }

        before do
          allow(datacenter).to receive(:persistent_pattern).and_return(/datastore\-without\-disk/)
          allow(datacenter).to receive(:find_datastore).with('datastore-without-disk').and_return(datastore_without_disk)
          allow(vm).to receive(:accessible_datastores)
            .and_return(
             'datastore-with-disk' => datastore_with_disk,
             'datastore-without-disk'=> datastore_without_disk,
            )
        end

        it 'moves the non-UUID disk to a persistent datastore and attaches it' do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with('disk-cid').and_return(director_disk_cid)

          expect(datacenter).to receive(:move_disk_to_datastore).with(disk, datastore_without_disk)
            .and_return(moved_disk)

          expect(vm).to receive(:attach_disk).with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number', backing: OpenStruct.new(uuid: 'SOME-UUID'))))

          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(false)

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
          expect(disk_hint).to eq('some-unit-number')
        end

        it 'moves the UUID disk to a persistent datastore and attaches it' do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with('disk-cid').and_return(director_disk_cid)

          expect(datacenter).to receive(:move_disk_to_datastore).with(disk, datastore_without_disk)
            .and_return(moved_disk)

          expect(vm).to receive(:attach_disk).with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number', backing: OpenStruct.new(uuid: 'SOME-UUID'))))

          expect(vm).to receive(:disk_uuid_is_enabled?).and_return(true)

          expect(vm).to receive(:disk_by_cid) do |disk_cid|
            expect(disk_cid).to eq('disk-cid')
            OpenStruct.new(backing: OpenStruct.new(uuid: 'SOME-UUID'))
          end

          disk_hint = vsphere_cloud.attach_disk('fake-vm-cid', 'disk-cid')
          expect(disk_hint).to eq({'id' => 'some-uuid'})
        end
      end

      context 'when a persistent disk pattern is encoded into the disk cid' do
        let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
        let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
        let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
        let(:ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
        let(:target_datastore) { Resources::Datastore.new('target-datastore', ds_mob, true, 4096, 4096) }
        let(:current_datastore) { Resources::Datastore.new('current-datastore', ds_mob, true, 4096, 4096) }
        let(:moved_disk) do
          Resources::PersistentDisk.new(
            cid: 'disk-cid',
            size_in_mb: 1024,
            datastore: target_datastore,
            folder: 'fake-folder')
        end
        let(:encoded_disk_cid) do
          metadata_hash = {
            target_datastore_pattern: "^(target\\-datastore)$"
          }
          expected_pattern = Base64.urlsafe_encode64(metadata_hash.to_json)

          "disk-cid.#{expected_pattern}"
        end
        let(:director_disk_cid) { VSphereCloud::DirectorDiskCID.new(encoded_disk_cid) }

        before do
          allow(vm).to receive(:accessible_datastores)
            .and_return(
             'target-datastore' => target_datastore,
             'current-datastore' => current_datastore,
            )
          expect(datacenter).to receive(:find_disk).with(director_disk_cid, vm).and_return(disk)
          expect(VSphereCloud::DirectorDiskCID).to receive(:new).with(encoded_disk_cid).and_return(director_disk_cid)
        end

        it 'extracts the pattern and uses it for datastore picking' do
          expect(datacenter).to receive(:find_datastore).with('target-datastore').and_return(target_datastore)

          expect(datacenter).to receive(:move_disk_to_datastore).with(disk, target_datastore)
            .and_return(moved_disk)

          allow(vm).to receive(:disk_uuid_is_enabled?).and_return(true)
          allow(vm).to receive(:disk_by_cid).and_return(OpenStruct.new(backing: OpenStruct.new(uuid: 'SOME-UUID')))

          allow(vm).to receive(:attach_disk).with(moved_disk)
            .and_return(OpenStruct.new(device: OpenStruct.new(unit_number: 'some-unit-number', backing: OpenStruct.new(uuid: 'SOME-UUID'))))
          allow(agent_env).to receive(:set_env)

          vsphere_cloud.attach_disk('fake-vm-cid', encoded_disk_cid)
        end
      end
    end

    describe '#delete_vm' do
      let(:ip_address) {'192.168.111.5'}
      let(:configuration_ex) { instance_double('VimSdk::Vim::Cluster::ConfigInfoEx', group: group) }
      let(:fake_cluster) { instance_double('VimSdk::Vim::ClusterComputeResource', configuration_ex: configuration_ex) }
      let(:group) { [] }
      before do
        allow(vm_mob).to receive_message_chain(:resource_pool, :owner, :configuration, :das_config, :enabled).and_return(false)
        allow(vm).to receive(:persistent_disks).and_return([])
        allow(vm).to receive(:cdrom).and_return(nil)
        allow(vm_mob).to receive_message_chain(:guest, :ip_address).and_return(ip_address)
        allow(vm_mob).to receive_message_chain(:runtime, :host, :parent).and_return(fake_cluster)
        allow(vcenter_client).to receive(:get_custom_field).and_return(cpi_metadata_version)
      end

      it 'deletes vm' do
        expect(vm).to receive(:power_off)
        expect(vm).to receive(:delete)
        vsphere_cloud.delete_vm('vm-id')
      end

      context 'when vm has persistent disks' do
        let(:disk) { instance_double('VimSdk::Vim::Vm::Device::VirtualDisk', backing: double(:backing, file_name: '[datastore] fake-file_name')) }
        before {
          allow(vm).to receive(:persistent_disks).and_return([disk])
        }

        it 'detaches persistent disks' do
          expect(vm).to receive(:detach_disks).with([disk])
          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)
          vsphere_cloud.delete_vm('vm-id')
        end
      end

      context 'vm has cdrom' do
        let(:cdrom) { instance_double('VimSdk::Vim::Vm::Device::VirtualCdrom') }
        before { allow(vm).to receive(:cdrom).and_return(cdrom) }

        it 'cleans the agent environment, before deleting the vm' do
          expect(agent_env).to receive(:clean_env).with(vm_mob).ordered

          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)

          vsphere_cloud.delete_vm('vm-id')
        end
      end

      context 'when NSX-T is enabled' do
        let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
        let(:nsxt_config) { VSphereCloud::NSXTConfig.new('fake-host', 'fake-username', 'fake-password') }
        # let(:vm) { instance_double(VSphereCloud::Resources::VM, cid: ' vm-id') }

        before do
          allow(cloud_config).to receive(:nsxt_enabled?).and_return(true)
          allow(cloud_config).to receive(:nsxt).and_return(nsxt_config)
          expect(VSphereCloud::NSXTProvider).to receive(:new).with(any_args).and_return(nsxt_provider)
        end

        it "removes the VM's logical port from NSGroups and vm's ip from server-pool" do
          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)
          expect(nsxt_provider).to receive(:remove_vm_from_nsgroups).with(vm)
          expect(nsxt_provider).to receive(:remove_vm_from_server_pools).with(ip_address, 'vm-id', cpi_metadata_version)
          vsphere_cloud.delete_vm('vm-id')
        end

        context 'and NSXTProvider fails to remove member from nsgroups' do
          it 'deletes the VM' do
            expect(vm).to receive(:power_off)
            expect(vm).to receive(:delete)
            expect(nsxt_provider).to receive(:remove_vm_from_nsgroups).with(vm).and_raise(
              VIFNotFound.new('vm-id', 'fake-external-id')
            )
            expect(nsxt_provider).to receive(:remove_vm_from_server_pools).with(ip_address, 'vm-id', cpi_metadata_version)

            vsphere_cloud.delete_vm('vm-id')
          end
        end
        context 'and NSXTProvider fails to remove vm from server pool' do
          it 'deletes the VM' do
            expect(vm).to receive(:power_off)
            expect(vm).to receive(:delete)
            expect(nsxt_provider).to receive(:remove_vm_from_nsgroups).with(vm)
            expect(nsxt_provider).to receive(:remove_vm_from_server_pools).with(ip_address, 'vm-id', cpi_metadata_version).and_raise(
              NSXT::ApiCallError.new('NSX=T API error')
            )
            vsphere_cloud.delete_vm('vm-id')
          end
        end
      end

      context 'when vm belongs to vm groups' do
        let(:cluster_vm_group){ VimSdk::Vim::Cluster::VmGroup.new(name: 'vm-group', vm: [vm_mob]) }
        let(:group) { [cluster_vm_group] }
        let(:vm_group) { instance_double('VSphereCloud::VmGroup')}
        it 'deletes vm groups' do
          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)
          expect(vm_group).to receive(:delete_vm_groups).with([cluster_vm_group.name])
          expect(VSphereCloud::VmGroup).to receive(:new).and_return(vm_group)
          vsphere_cloud.delete_vm('vm-id')
        end
      end

      context 'when HA is enabled and the VM uses a vsan datastore' do
        let(:datastore) { double('Object')}
        before do
          expect(vm_mob).to receive_message_chain(:resource_pool, :owner, :configuration, :das_config, :enabled).and_return(true)
          expect(vm_mob).to receive(:datastore).and_return([datastore])
          expect(vm).to receive(:power_off)
          expect(vm).to receive(:delete)
        end

        context 'when the VM uses a vsan datastore' do
          before do
            expect(datastore).to receive_message_chain(:summary, :type).and_return("vsan")
          end
          it 'sleeps before deleting the VM' do
            expect(vsphere_cloud).to receive(:sleep).with(15)
            vsphere_cloud.delete_vm('vm-id')
          end
        end

        context 'when the VM uses a VMFS datastore' do
          before do
            expect(datastore).to receive_message_chain(:summary, :type).and_return("VMFS")
          end
          it 'does not sleep before deleting the VM' do
            expect(vsphere_cloud).to_not receive(:sleep)
            vsphere_cloud.delete_vm('vm-id')
          end
        end
      end
    end

    describe '#detach_disk' do
      context 'disk is attached' do
        let(:attached_disk) { instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, key: 'disk-key') }
        let(:fake_datastore) { VSphereCloud::Resources::Datastore.new('fake-datastore-name', nil, true, 4096, 2048) }
        let(:vm_location) do
          {
            datacenter: 'fake-datacenter',
            datastore: fake_datastore,
            vm: 'vm-id'
          }
        end
        let(:cdrom) { instance_double(VimSdk::Vim::Vm::Device::VirtualCdrom) }
        before do
          allow(datacenter).to receive(:disk_path).and_return("fake-disk-path")
          allow(cdrom).to receive_message_chain(:backing, :datastore, :name) { 'fake-datastore-name' }
          allow(vcenter_client).to receive(:get_cdrom_device).with(vm_mob).and_return(cdrom)
          allow(vm).to receive(:disk_by_cid).with('disk-cid').and_return(attached_disk)
          allow(vm).to receive(:accessible_datastores).and_return({'fake-datastore-name'=>fake_datastore})
        end

        it 'updates VM with new settings' do
          expect(vm).to receive(:detach_disks).with([attached_disk], 'fake-disk-path')
          vsphere_cloud.detach_disk('vm-id', 'disk-cid')
        end

        context 'when old settings do not contain disk to be detached' do
          let(:env) do
            {'disks' => {'persistent' => {}}}
          end

          it 'does not update VM with new setting' do
            expect(agent_env).to_not receive(:set_env)
            expect(vm).to receive(:detach_disks).with([attached_disk], 'fake-disk-path')
            vsphere_cloud.detach_disk('vm-id', 'disk-cid')
          end
        end

        context 'when director disk cid contains metadata' do
          let(:disk_cid_with_metadata) do
            metadata_hash = {target_datastore_pattern:'^(target\\-datastore)$'}
            encoded_data = Base64.urlsafe_encode64(metadata_hash.to_json)
            "disk-cid.#{encoded_data}"
          end
          let(:env) do
            {'disks' => {'persistent' => { disk_cid_with_metadata => 'fake-device-number' }}}
          end

          it 'extracts the vSphere cid from the director disk cid and uses it' do
            allow(vm).to receive(:disk_by_cid).and_return(attached_disk)
            allow(vm).to receive(:detach_disks)

            vsphere_cloud.detach_disk('vm-id', disk_cid_with_metadata)

            expect(vm).to have_received(:disk_by_cid).with('disk-cid')
          end
        end

      end

      context 'disk is not attached' do
        before do
          allow(vm).to receive(:disk_by_cid).with('disk-cid').and_return(nil)
        end
        it 'raises an error' do
          expect{
            vsphere_cloud.detach_disk('vm-id', 'disk-cid')
          }.to raise_error Bosh::Clouds::DiskNotAttached
        end
      end
    end

    describe '#configure_networks' do
      it 'raises a NotSupported exception' do
        expect {
          vsphere_cloud.configure_networks('i-foobar', {})
        }.to raise_error Bosh::Clouds::NotSupported
      end
    end

    describe '#delete_disk' do
      let(:encoded_disk_cid) { 'fake-disk-uuid' }
      let(:director_disk_cid) { VSphereCloud::DirectorDiskCID.new(encoded_disk_cid) }

      before do
        expect(VSphereCloud::DirectorDiskCID).to receive(:new).with(encoded_disk_cid).and_return(director_disk_cid)
      end

      context 'when disk is found' do
        let(:disk) { instance_double('VSphereCloud::Resources::PersistentDisk', path: 'disk-path') }

        before do
          expect(datacenter).to receive(:mob).and_return('datacenter-mob')
          expect(datacenter).to receive(:find_disk).with(director_disk_cid).and_return(disk)
          expect(vcenter_client).to receive(:delete_disk).with('datacenter-mob', 'disk-path')
        end

        it 'deletes disk' do
          vsphere_cloud.delete_disk('fake-disk-uuid')
        end

        context 'when a persistent disk pattern is encoded into the director disk cid' do
          let(:encoded_disk_cid) do
            metadata_hash = {
              target_datastore_pattern:'^(target\\-datastore)$'
            }
            expected_pattern = Base64.urlsafe_encode64(metadata_hash.to_json)

            "disk-cid.#{expected_pattern}"
          end

          it 'removes the suffix before searching the disk' do
            vsphere_cloud.delete_disk(encoded_disk_cid)
          end
        end
      end

      context 'when disk is not found' do
        before do
          expect(datacenter).to receive(:find_disk).with(director_disk_cid)
            .and_raise Bosh::Clouds::DiskNotFound.new(false)
        end

        it 'raises an error' do
          expect {
            vsphere_cloud.delete_disk(encoded_disk_cid)
          }.to raise_error Bosh::Clouds::DiskNotFound
        end
      end
    end

    describe '#create_disk' do
      before do
        allow(ds_mob).to receive_message_chain('summary.maintenance_mode').and_return("normal")
      end
      let(:accessible) { true }
      let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
      let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
      let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
      let(:ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
      let(:small_ds) { VSphereCloud::Resources::Datastore.new('small-ds', ds_mob, true, 4096, 3048) }
      let(:large_ds) { VSphereCloud::Resources::Datastore.new('large-ds', ds_mob, true, 8192, 4096) }
      let(:accessible_datastores) do
        {
          'small-ds' => small_ds,
          'large-ds' => large_ds,
        }
      end
      let(:datastore) { double(:datastore, name: 'fake-datastore', mob: ds_mob) }
      let(:disk) do
        Resources::PersistentDisk.new(
          cid: 'fake-disk-cid',
          size_in_mb: 1024*1024,
          datastore: datastore,
          folder: 'fake-folder',
        )
      end

      before do
        allow(small_ds).to receive(:accessible?).and_return(accessible)
        allow(large_ds).to receive(:accessible?).and_return(accessible)
        allow(datacenter).to receive(:persistent_pattern).and_return('small-ds')
        allow(datacenter).to receive(:persistent_datastore_cluster_pattern).and_return(nil)
        allow(datacenter).to receive(:accessible_datastores).and_return(accessible_datastores)
        allow(datacenter).to receive(:find_datastore).with('small-ds').and_return(datastore)
      end

      it 'creates disk via datacenter' do
        expect(datacenter).to receive(:create_disk)
          .with(VSphereCloud::Resources::Datastore, 1024, default_disk_type)
          .and_return(disk)

        disk_cid = vsphere_cloud.create_disk(1024, {})
        expect(disk_cid).to eq('fake-disk-cid')
      end

      context 'when global default_disk_type is set and no disk_pool type is set' do
        let(:default_disk_type) { 'fake-global-type' }
        it 'creates disk with the specified default type' do
          expect(datacenter).to receive(:create_disk)
                                  .with(VSphereCloud::Resources::Datastore, 1024, 'fake-global-type')
                                  .and_return(disk)

          disk_cid = vsphere_cloud.create_disk(1024, {})
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end
      context 'when global vmx_options are set' do
        let(:vm_config) { instance_double(VmConfig) }
        let(:system_disk_unit_number) { 1 }
        let(:system_disk) do
          instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, unit_number: system_disk_unit_number)
        end
        let(:ephemeral_disk_unit_number) { 2 }
        let(:ephemeral_uuid) { 'TESTGENERATEDISKENV' }
        let(:ephemeral_backing) do
          instance_double(VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo, uuid: ephemeral_uuid)
        end
        let(:ephemeral_disk) do
          instance_double(VimSdk::Vim::Vm::Device::VirtualDisk,
                          backing: ephemeral_backing,
                          unit_number: ephemeral_disk_unit_number
          )
        end
        let(:vm_vmx_options) do
          {
            'disk.enableUUID' => 0
          }
        end
        context 'when no config was provided on vm level nor global' do
          it 'uses the global value' do
            allow(cloud_config).to receive(:disk_enable_uuid).and_return(nil)
            allow(vm_config).to receive(:vmx_options).and_return({})
            disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, vm_config)
            expect(disk_env['ephemeral']).to eq(ephemeral_disk_unit_number.to_s)
            expect(disk_env['system']).to eq(system_disk_unit_number.to_s)
          end
        end
        context 'when no config was provided on vm level' do
          it 'uses the global value' do
            allow(cloud_config).to receive(:disk_enable_uuid).and_return(1)
            allow(vm_config).to receive(:vmx_options).and_return({})
            disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, vm_config)
            expect(disk_env['ephemeral']). to eq({'id' => ephemeral_uuid.downcase})
            expect(disk_env['system']).to eq(system_disk_unit_number.to_s)
          end
        end
        context 'when vm_options override global vmx_options' do
          it 'uses the vm_options value' do
            allow(cloud_config).to receive(:disk_enable_uuid).and_return(1)
            allow(vm_config).to receive(:vmx_options).and_return(vm_vmx_options)
            disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, vm_config)
            expect(disk_env['ephemeral']).to eq(ephemeral_disk_unit_number.to_s)
            expect(disk_env['system']).to eq(system_disk_unit_number.to_s)
          end
        end
      end
      context 'when both global default_disk_type is set and disk_pool type is set' do
        let(:default_disk_type) { 'fake-global-type' }
        it 'create disk with the specified disk_pool type' do
          expect(datacenter).to receive(:create_disk)
                                  .with(VSphereCloud::Resources::Datastore, 1024, 'fake-disk-pool-type')
                                  .and_return(disk)
          disk_cid = vsphere_cloud.create_disk(1024, {'type' => 'fake-disk-pool-type'})
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when no global default_disk_type is set and disk_pool type is set' do
        it 'creates disk with the specified disk_pool type' do
          expect(datacenter).to receive(:create_disk)
            .with(VSphereCloud::Resources::Datastore, 1024, 'fake-disk-pool-type')
            .and_return(disk)

          disk_cid = vsphere_cloud.create_disk(1024, {'type' => 'fake-disk-pool-type'})
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when vm_cid is provided' do
        let(:host_runtime_info) { instance_double(VimSdk::Vim::Host::RuntimeInfo, in_maintenance_mode: false) }
        let(:host_system) {instance_double(VimSdk::Vim::HostSystem, runtime: host_runtime_info)}
        let(:datastore_host_mount) { [instance_double('VimSdk::Vim::Datastore::HostMount', key: host_system)]}
        let(:ds_mob) { instance_double('VimSdk::Vim::Datastore', host: datastore_host_mount) }
        let(:datastore) { VSphereCloud::Resources::Datastore.new('small-ds', ds_mob, true, 2048, 4096) }
        let(:accessible_datastores) { {  'small-ds' => datastore} }
        before do
          allow(datastore).to receive(:accessible?).and_return(true)
          allow(vm_provider).to receive(:find)
            .with('fake-vm-cid')
            .and_return(vm)
          allow(vm).to receive(:accessible_datastores)
            .and_return(accessible_datastores)
        end

        it 'creates disk in vm cluster' do
          expect(datacenter).to receive(:create_disk)
            .with(datastore, 1024, default_disk_type)
            .and_return(disk)

          disk_cid = vsphere_cloud.create_disk(1024, {}, 'fake-vm-cid')
          expect(disk_cid).to eq('fake-disk-cid')
        end
      end

      context 'when disk_pools.cloud_properties.datastores is provided' do
        let(:small_datastore) { double(:datastore, name: 'small-ds') }
        let(:large_datastore) { double(:datastore, name: 'large-ds') }
        let(:cloud_properties) { { 'datastores' => ['small-ds', 'large-ds'] } }

        before(:each) do
          allow(datacenter).to receive(:find_datastore)
            .with('small-ds')
            .and_return(small_datastore)
          allow(datacenter).to receive(:find_datastore)
            .with('large-ds')
            .and_return(large_datastore)
          allow(datacenter).to receive(:create_disk)
            .with(VSphereCloud::Resources::Datastore, 1024, default_disk_type)
            .and_return(disk)
          allow(datacenter).to receive(:create_disk)
            .with(VSphereCloud::Resources::Datastore, 1024, default_disk_type)
            .and_return(disk)
        end

        it 'creates the disk in the picked datastore' do
          disk_cid = vsphere_cloud.create_disk(1024, cloud_properties)
          expect(disk_cid).to start_with('fake-disk-cid')
        end

        it 'appends the datastores as base64 encoded metadata to the cid' do
          metadata_hash = {target_datastore_pattern: '^(small\\-ds|large\\-ds)$'}
          expected_pattern = Base64.urlsafe_encode64(metadata_hash.to_json)

          disk_cid = vsphere_cloud.create_disk(1024, cloud_properties)

          expect(disk_cid).to eq("fake-disk-cid.#{expected_pattern}")
        end
      end

      context 'when datastores are not accessible from any host' do
        let(:accessible) { false }
        it 'raises an error' do
          expect {
            vsphere_cloud.create_disk(1024, {})
          }.to raise_error(/Unable to create disk on any storage entity provided. Possible errors can be/)
        end
      end
    end

    describe '#reboot_vm' do
      it 'logs the powerstate if the machine was not powered on' do
        allow(vm).to receive(:powered_on?).and_return(false)
        allow(vm).to receive(:power_state).and_return('foo')
        allow(vm).to receive(:reboot)
        vsphere_cloud.reboot_vm('vm-id')
      end

      context 'when the soft reboot fails' do
        before do
          allow(vm).to receive(:reboot).and_raise(StandardError.new('my custom reboot error'))
          expect(logger).to receive(:error).with(/my custom reboot error/)
        end

        context 'when the machine was powered on' do
          before{ allow(vm).to receive(:powered_on?).and_return(true) }

          it 'attempts to shut down the machine before re-powering it on' do
            expect(vm).to receive(:power_off).ordered
            expect(vm).to receive(:power_on).ordered
            vsphere_cloud.reboot_vm('vm-id')
          end
        end

        context 'when the machine was powered off' do
          before do
            allow(vm).to receive(:powered_on?).and_return(false)
            allow(vm).to receive(:power_state)
          end

          it 'attempts to start the machine if it is not powered on' do
            expect(vm).to_not receive(:power_off)
            expect(vm).to receive(:power_on).ordered
            vsphere_cloud.reboot_vm('vm-id')
          end
        end
      end
    end

    describe '#set_vm_metadata' do
      it 'sets the metadata as custom fields on the VM' do
        expect(vcenter_client).to receive(:set_custom_field).with(vm_mob, 'key', 'value')
        expect(vcenter_client).to receive(:set_custom_field).with(vm_mob, 'key', 'other-value')
        expect(vcenter_client).to receive(:set_custom_field).with(vm_mob, 'other-key', 'value')
        vsphere_cloud.set_vm_metadata(vm.cid, {'key' => 'value'})
        vsphere_cloud.set_vm_metadata(vm.cid, {'key' => 'other-value', 'other-key' => 'value'})
      end
    end

    describe '#set_disk_metadata' do
      let(:disk_metadata) { { 'a' => 'b' } }
      let(:disk_id) { 'fake-disk-cid' }
      it 'does nothing because it has not been implemented' do
        expect(vsphere_cloud.set_disk_metadata(disk_id, disk_metadata)).to be_nil
      end
    end

    describe '#terminate_threads_and_logout' do
      it 'terminates the thread and logs out the client' do
        expect(vsphere_cloud.heartbeat_thread).to receive(:terminate).once.and_call_original
        expect(vsphere_cloud.client).to receive(:logout).once
        vsphere_cloud.cleanup
      end

      it 'does not raise an error when it\'s called twice in a row' do
        expect(vsphere_cloud.heartbeat_thread).to receive(:terminate).once.and_call_original
        expect(vsphere_cloud.client).to receive(:logout).once
        vsphere_cloud.cleanup
        expect(vsphere_cloud.heartbeat_thread).to receive(:terminate).once.and_call_original
        expect(vsphere_cloud.client).to receive(:logout).once.and_raise(VSphereCloud::VCenterClient::NotLoggedInException)
        vsphere_cloud.cleanup
      end
    end

    # NOT NEEDED - FEATURE DISCONTINUED
    xdescribe '#create_network' do
      let(:network_definition) { {
                                 'range' => '192.168.111.0/24',
                                 'gateway' => '192.168.111.1',
                                 'cloud_properties' => {
                                     't0_router_id' => 't0-router-id',
                                     't1_name' => 'router-name',
                                     'transport_zone_id' => 'zone-id',
                                     'switch_name' => 'switch-name',
                                 } } }
      let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
      let(:switch_provider) { instance_double(VSphereCloud::NSXTSwitchProvider) }
      let(:router_provider) { instance_double(VSphereCloud::NSXTRouterProvider) }
      let(:ip_block_provider) { instance_double(VSphereCloud::NSXTIpBlockProvider) }
      let(:nsxt_enabled) { true }
      let(:network_result) { instance_double(VSphereCloud::ManagedNetwork) }
      let(:network) { instance_double(VSphereCloud::Network) }
      let(:nsxt_client) { instance_double(NSXT::ApiClient) }

      before do
        allow(VSphereCloud::NSXTApiClientBuilder).to receive(:build_api_client)
          .with(any_args).and_return(nsxt_client)
        allow(VSphereCloud::NSXTProvider).to receive(:new)
          .with(any_args).and_return(nsxt_provider)
        allow(VSphereCloud::NSXTSwitchProvider).to receive(:new)
          .with(any_args).and_return(switch_provider)
        allow(VSphereCloud::NSXTRouterProvider).to receive(:new)
          .with(any_args).and_return(router_provider)
        allow(VSphereCloud::NSXTIpBlockProvider).to receive(:new)
           .with(any_args).and_return(ip_block_provider)
      end

      context 'when nsxt disabled' do
        let(:nsxt_enabled) { false }

        it 'raises an error' do
          expect{
            vsphere_cloud.create_network(network_definition)
          }.to raise_error('NSXT must be enabled in CPI to use create_network')
        end
      end

      context 'when nsxt enabled' do
        let(:network_model) { instance_double(VSphereCloud::NetworkDefinition) }
        it 'creates a network' do
          expect(VSphereCloud::NetworkDefinition).to receive(:new)
            .with(network_definition).and_return(network_model)
          expect(VSphereCloud::Network).to receive(:new)
            .with(switch_provider, router_provider, ip_block_provider).and_return(network)
          expect(network).to receive(:create)
            .with(network_model).and_return(network_result)
          expect(vsphere_cloud.create_network(network_definition)).to eq(network_result)
        end
      end
    end

    # TEST ERROR RETURNS ON DISCONTINUED FEATURE
    describe '#create_network errors' do
      let(:network_definition) { {
        'range' => '192.168.111.0/24',
        'gateway' => '192.168.111.1',
        'cloud_properties' => {
          't0_router_id' => 't0-router-id',
          't1_name' => 'router-name',
          'transport_zone_id' => 'zone-id',
          'switch_name' => 'switch-name',
        } } }
      let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
      let(:switch_provider) { instance_double(VSphereCloud::NSXTSwitchProvider) }
      let(:router_provider) { instance_double(VSphereCloud::NSXTRouterProvider) }
      let(:ip_block_provider) { instance_double(VSphereCloud::NSXTIpBlockProvider) }
      let(:nsxt_enabled) { true }
      let(:network_result) { instance_double(VSphereCloud::ManagedNetwork) }
      let(:network) { instance_double(VSphereCloud::Network) }
      let(:nsxt_client) { instance_double(NSXT::ApiClient) }
      let(:nsxt_policy_client) { instance_double(NSXTPolicy::ApiClient) }

      before do
        allow(VSphereCloud::NSXTApiClientBuilder).to receive(:build_api_client)
                                                       .with(any_args).and_return(nsxt_client)
        allow(VSphereCloud::NSXTPolicyApiClientBuilder).to receive(:build_policy_api_client)
                                                       .with(any_args).and_return(nsxt_policy_client)
        allow(VSphereCloud::NSXTProvider).to receive(:new)
                                               .with(any_args).and_return(nsxt_provider)
        allow(VSphereCloud::NSXTSwitchProvider).to receive(:new)
                                                     .with(any_args).and_return(switch_provider)
        allow(VSphereCloud::NSXTRouterProvider).to receive(:new)
                                                     .with(any_args).and_return(router_provider)
        allow(VSphereCloud::NSXTIpBlockProvider).to receive(:new)
                                                      .with(any_args).and_return(ip_block_provider)
      end

      context 'when nsxt disabled' do
        let(:nsxt_enabled) { false }

        it 'raises an error' do
          expect{
            vsphere_cloud.create_network(network_definition)
          }.to raise_error('NSXT must be enabled in CPI to use create_network')
        end
      end

      context 'when nsxt enabled with policy API' do
        let(:nsxt) { instance_double(VSphereCloud::NSXTConfig, default_vif_type: 'vif_type', use_policy_api?: true, auth_private_key: nil)}

        it 'raises an error' do
          expect{
            vsphere_cloud.create_network(network_definition)
          }.to raise_error('create_network is not supported for the NSXT Policy API')
        end
      end
    end

    # NOT NEEDED - FEATURE DISCONTINUED
    xdescribe '#delete_network' do
      let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
      let(:nsxt_manager_client) { instance_double(NSXT::ApiClient) }
      let(:switch_provider) { instance_double(VSphereCloud::NSXTSwitchProvider) }
      let(:router_provider) { instance_double(VSphereCloud::NSXTRouterProvider) }
      let(:ip_block_provider) { instance_double(VSphereCloud::NSXTIpBlockProvider) }
      let(:network) { instance_double(VSphereCloud::Network) }

      before do
        allow(VSphereCloud::NSXTApiClientBuilder).to receive(:build_api_client)
         .with(any_args).and_return(nsxt_manager_client)
        allow(VSphereCloud::NSXTProvider).to receive(:new)
         .with(any_args).and_return(nsxt_provider)
        allow(VSphereCloud::NSXTIpBlockProvider).to receive(:new)
          .with(any_args).and_return(ip_block_provider)
      end

      context 'when nsxt disabled' do
        let(:nsxt_enabled) { false }

        it 'raises an error' do
          expect{
            vsphere_cloud.delete_network('switch-id')
          }.to raise_error('NSXT must be enabled in CPI to use delete_network')
        end
      end

      context 'when nsxt enabled with policy API' do
        let(:nsxt_enabled) { true }
        let(:nsxt) { instance_double(VSphereCloud::NSXTConfig, default_vif_type: 'vif_type', use_policy_api?: true, auth_private_key: nil)}

        it 'raises an error' do
          expect{
            vsphere_cloud.delete_network(network_definition)
          }.to raise_error('create_network is not supported for the NSXT Policy API')
        end
      end

      context 'when nsxt enabled' do
        let(:nsxt_enabled) { true }
        let(:switch_provider) { instance_double(VSphereCloud::NSXTSwitchProvider) }

        before do
          allow(NSXTSwitchProvider).to receive(:new)
            .and_return(switch_provider)
          allow(VSphereCloud::NSXTRouterProvider).to receive(:new)
            .with(any_args).and_return(router_provider)
        end

        it 'deletes a network' do
          expect(VSphereCloud::Network).to receive(:new)
            .with(switch_provider, router_provider, ip_block_provider).and_return(network)
          expect(network).to receive(:destroy)
            .with('switch-id')
          vsphere_cloud.delete_network('switch-id')
        end
      end
    end

    describe '#update_name_info_from_bosh_env' do
      context "when environment is nil" do
        let(:environment){ nil }
        it "returns nil " do
          expect( vsphere_cloud.send(:update_name_info_from_bosh_env, environment) ).to be_nil
        end
      end

      context "when environment is empty" do
        let(:environment) { {} }
        it "returns nil " do
          expect( vsphere_cloud.send(:update_name_info_from_bosh_env, environment) ).to be_nil
        end
      end

      context "when environment has no deployment name" do
        let(:environment) do
          {
            'bosh' => {
              'group' => 'fake-group',
              'groups' => ['fake-director-name', 'fake-instance-group-name']
            }
          }
        end
        it "returns nil " do
          expect( vsphere_cloud.send(:update_name_info_from_bosh_env, environment) ).to be_nil
        end
      end

      context "When environment has no instance group name" do
        let(:environment) do
          {
            'bosh' => {
              'group' => 'fake-group',
              'groups' => ['fake-director-name', 'fake-deployment-name']
            }
          }
        end
        it "returns nil" do
          expect( vsphere_cloud.send(:update_name_info_from_bosh_env, environment) ).to be_nil
        end
      end

      context "When environment has deployment and instance group name" do
        let(:key1) {"instance_group_name"}
        let(:key2) {"deployment_name"}
        let(:environment) do
          {
            'bosh' => {
                'group' => 'fake-group',
                'groups' => ['fake-director-name', 'fake-deployment-name', 'fake-instance-group-name']
            }
          }
        end
        it "returns an struct " do
          result = vsphere_cloud.send(:update_name_info_from_bosh_env, environment)
          expect(result).to_not be_nil
          expect(result.inst_grp).to eq('fake-instance-group-name')
          expect(result.deployment).to eq('fake-deployment-name')
        end
      end
    end

    describe '#replace_certs_keys_with_temp_files' do
      let(:nsxt_config) do
        VSphereCloud::NSXTConfig.new(
          'host', 'user', 'password', 'ca-cert', 'true', 'cert', 'key', 'BARE_METAL'
        )
      end
      it 'replaces certs and keys with their tempfile locations' do
        subject.replace_certs_keys_with_temp_files(nsxt_config)
        expect(nsxt_config.auth_private_key).to_not eq('key')
        expect(File.read(nsxt_config.auth_private_key)).to eq('key')
        expect(nsxt_config.auth_certificate).to_not eq('cert')
        expect(File.read(nsxt_config.auth_certificate)).to eq('cert')
      end

      context 'when auth key is not provided' do
        let(:nsxt_config) do
          VSphereCloud::NSXTConfig.new(
              'host', 'user', 'password', 'ca-cert', 'true', 'cert', nil, 'BARE_METAL'
          )
        end
        it 'does not do anything on passed nsxt config' do
          subject.replace_certs_keys_with_temp_files(nsxt_config)
          expect(nsxt_config.auth_private_key).to be_nil
          expect(nsxt_config.auth_certificate).to eq('cert')
        end
      end
    end
  end
end
