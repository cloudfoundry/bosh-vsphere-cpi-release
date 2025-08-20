require 'spec_helper'
require 'cloud/vsphere/drs_rules/drs_rule'

module VSphereCloud
  describe VmCreator, fake_logger: true do
    subject(:creator) do
      VmCreator.new(
        client:,
        cloud_searcher: cloud_searcher,
        cpi:,
        datacenter: datacenter,
        agent_env_client: agent_env,
        additional_agent_env: config['agent'],
        tagging_tagger:,
        default_disk_type:,
        enable_auto_anti_affinity_drs_rules: false,
        stemcell:,
        upgrade_hw_version: upgrade_hw_version,
        default_hw_version: default_hw_version,
        pbm:,
        ip_conflict_detector: ip_conflict_detector,
        ensure_no_ip_conflicts: ensure_no_ip_conflicts,
      )
    end
    let(:vmx_options) { {} }
    let(:disk_uuid_is_enabled) { vmx_options.dig('disk.enableUUID') == 1 }
    let(:datacenter_config) do
      {
        'name' => 'dc-1',
        'persistent_datastore_pattern' => 'ds-ps-*',
        'datastore_pattern' => 'ds-*',
        'vm_folder' => 'bosh_vms',
        'template_folder' => 'stemcells',
        'disk_path' => 'disks',
        'clusters' => []
      }
    end
    let(:default_disk_type) { 'preallocated' }
    let(:ensure_no_ip_conflicts) { true }
    let(:upgrade_hw_version) { false }
    let(:default_hw_version) { 17 }

    let(:config) do
      {
        'agent' => {
          'some' => 'stuff'
        },
        'vcenters' => [
          {
            'http_logging' => true,
            'host' => 'localhost',
            'user' => 'admin',
            'password' => 'password',
            'datacenters' => [datacenter_config],
            'default_disk_type' => default_disk_type,
            'memory_reservation_locked_to_max' => false,
            'enable_auto_anti_affinity_drs_rules' => false,
            'enable_human_readable_name' => true,
            'upgrade_hw_version' => upgrade_hw_version,
            'default_hw_version' => default_hw_version,
            'vmx_options' => vmx_options,
            'nsxt' => {
              'host' => 'localhost',
              'user' => 'admin',
              'password' => 'password',
            }
          }
        ],
        'soap_log' => 'fake-log-file',
        'perform_ip_conflict_detection' => ensure_no_ip_conflicts,
      }
    end
    let(:cpi) { instance_double(Cloud) }

    let(:agent_env) { instance_double('VSphereCloud::AgentEnv')  }
    let(:pbm) { instance_double('VSphereCloud::Pbm') }
    let(:tagging_tagger) { instance_double(TaggingTag::AttachTagToVm) }
    let(:tag_client) { instance_double(TaggingTag::AttachTagToVm) }

    let(:http_client) { instance_double('VSphereCloud::CpiHttpClient') }
    let(:custom_fields_manager) { instance_double('VimSdk::Vim::CustomFieldsManager') }
    let(:option_manager) { instance_double('VimSdk::Vim::Option::OptionManager') }
    let(:virtual_disk_manager) { instance_double('VimSdk::Vim::VirtualDiskManager') }
    let(:vcenter_api_uri) { URI.parse("https://localhost/sdk/vimService") }
    let(:service_content) {
      instance_double('VimSdk::Vim::ServiceInstanceContent',
                      virtual_disk_manager: virtual_disk_manager,
                      setting: option_manager,
                      custom_fields_manager: custom_fields_manager
      )
    }
    let(:soap_stub) { instance_double(VSphereCloud::SdkHelpers::RetryableStubAdapter, vc_cookie: 'somerandomcookie') }
    let(:client) { instance_double('VSphereCloud::VCenterClient', login: nil, service_content: service_content, soap_stub: soap_stub ) }
    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }

    let(:vm_folder) { instance_double(Resources::Folder, mob: instance_double(VimSdk::Vim::Folder)) }
    let(:datacenter_mob) { instance_double('VimSdk::Vim::Datacenter', name: datacenter_config['name']) }
    let(:datacenter) { instance_double(Resources::Datacenter,  mob: datacenter_mob, name: datacenter_config['name'], vm_folder: vm_folder) }
    let(:cluster) { instance_double(Resources::Cluster, mob: cluster_mob, resource_pool: resource_pool, host_group: nil, accessible_datastores: { "ds-1": {}, "ds-2": {} }) }
    let(:cluster_mob) { instance_double('VimSdk::Vim::ClusterComputeResource') }
    let(:resource_pool) { instance_double(Resources::ResourcePool, mob: resource_pool_mob) }
    let(:resource_pool_mob) { instance_double(VimSdk::Vim::ResourcePool) }
    let(:datastore) { instance_double(Resources::Datastore, name: 'ds-1', mob: datastore_mob) }
    let(:datastore_mob) { instance_double(VimSdk::Vim::Datastore) }
    let(:paravirtual_controller_device) { instance_double(VimSdk::Vim::Vm::Device::ParaVirtualSCSIController) }
    let(:system_disk_device) do
      instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, unit_number: 1, controller_key: 2)
    end
    let(:ephemeral_disk_device_backing) do
      instance_double(VimSdk::Vim::Vm::Device::VirtualDisk::FlatVer2BackingInfo, uuid: 'TESTGENERATEDISKENV')
    end
    let(:ephemeral_disk_device) do
      instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, backing: ephemeral_disk_device_backing, unit_number: 2)
    end
    let(:stemcell) { { cid: 'fake-stemcell-cid', size: 1024 } }
    let(:stemcell_vm) { instance_double(VSphereCloud::Resources::VM, system_disk: ephemeral_disk_device ) }
    let(:cloned_vm_devices) { [paravirtual_controller_device, system_disk_device, ephemeral_disk_device] }
    let(:cloned_vm_mob) { instance_double('VimSdk::Vim::VirtualMachine' ) }
    let(:cloned_vm) { instance_double(VSphereCloud::Resources::VM, devices: cloned_vm_devices) }
    let(:ip_conflict_detector) { instance_double(IPConflictDetector, ensure_no_conflicts: nil) }

    before do
      allow_any_instance_of(Cloud).to receive(:at_exit)
      allow_any_instance_of(Config).to receive(:logger).and_return(logger)

      allow(CpiHttpClient).to receive(:new).and_return(http_client)
      allow(VCenterClient).to receive(:new).with(
        vcenter_api_uri: vcenter_api_uri,
        http_client: http_client
      ).and_return(client)

      allow(Pbm).to receive(:new).and_return(pbm)
      allow(TaggingTag::AttachTagToVm).to receive(:new).with(any_args).and_return(tagging_tagger)
      allow(TaggingTag::AttachTagToVm).to receive(:InitializeConnection).with(any_args).and_return(tag_client)
    end

    context '#create' do
      let(:vm_config) do
        instance_double(
          VmConfig,
          name: 'norbo',
          agent_id: 'meow',
          agent_env: {},
          vmx_options: vmx_options,
          drs_rule: nil,
          vm_type: instance_double(VmType, vm_group: {}, upgrade_hw_version: false, tags: {}, disable_drs: false),
          config_spec_params: {},
          networks_spec: {},
          ephemeral_disk_size: 1024,
          pci_passthroughs: [],
          vgpus: [],
          calculate_cpu_reservation: nil,
          cluster_placements: [
            instance_double(VmPlacement,
                            cluster: cluster,
                            disk_placement: datastore,
                            fallback_disk_placements: [instance_double(Resources::Datastore, name: "ds-2")]
            )
          ],
          stemcell_cid: 'here-stemcell-cid',
          root_disk_size_gb: 0,
          disk_uuid_is_enabled?: disk_uuid_is_enabled
        )
      end

      before do
        allow(stemcell).to receive(:replicate).and_return(stemcell_vm)
        allow(cloud_searcher).to receive(:get_properties).with(
          stemcell_vm,
          VimSdk::Vim::VirtualMachine,
          ["snapshot", "datastore"],
          ensure_all: true
        ).and_return({'snapshot'=> instance_double(VimSdk::Vim::Vm::SnapshotInfo, current_snapshot: instance_double(VimSdk::Vim::Vm::SnapshotInfo))})
        allow(cloud_searcher).to receive(:get_properties).with(
          stemcell_vm,
          VimSdk::Vim::VirtualMachine,
          :ensure=>["config.hardware.device", "runtime", "config.extraConfig"]
        ).and_return(cloned_vm)
        allow(client).to receive(:cloud_searcher).and_return(cloud_searcher)
        allow_any_instance_of(Resources::EphemeralDisk).to receive(:create_disk_attachment_spec).and_return([])
        # allow_any_instance_of(Resources::VM).to receive_message_chain(:system_disk, :controller_key).and_return(1)
        allow(service_content).to receive_message_chain(:extension_manager, :find_extension).and_return(false)
        allow(vm_config).to receive(:vsphere_networks).and_return([])
        allow_any_instance_of(Resources::VM).to receive(:nics).and_return([])
        allow_any_instance_of(Resources::VM).to receive(:pci_passthroughs).and_return([])
        allow_any_instance_of(Resources::VM).to receive(:vgpus).and_return([])
        allow_any_instance_of(Resources::VM).to receive(:fix_device_unit_numbers).and_return(nil)
        allow_any_instance_of(Resources::VM).to receive(:fix_device_key).and_return(nil)
        allow(client).to receive(:wait_for_task).and_return(cloned_vm_mob)

        allow(cloud_searcher).to receive(:get_properties).with(
          cloned_vm_mob,
          VimSdk::Vim::VirtualMachine,
          ["runtime.powerState", "runtime.question", "config.hardware.device", "name", "runtime", "resourcePool", "config.extraConfig"],
          :ensure=>["config.hardware.device", "runtime", "config.extraConfig"]
        )
        allow_any_instance_of(Resources::VM).to receive(:devices).and_return(cloned_vm_mob)
        allow_any_instance_of(Resources::VM).to receive(:fix_device_key).and_return(nil)
        allow_any_instance_of(Resources::VM).to receive(:system_disk).and_return(system_disk_device)
        allow_any_instance_of(Resources::VM).to receive(:ephemeral_disk).and_return(ephemeral_disk_device)
        allow_any_instance_of(Resources::VM).to receive('__mo_id__').and_return('1234')
        allow(client).to receive(:find_by_inventory_path).with("dc-1").and_return(datacenter_config)
        allow(client).to receive(:find_vm_by_name).and_return(cloned_vm)
        allow(agent_env).to receive(:set_env)
        allow(subject).to receive(:create_drs_rules).and_return(nil)
        allow(subject).to receive(:add_vm_to_vm_group).and_return(nil)
        allow(subject).to receive(:apply_storage_policy).and_return(nil)
        allow(vm_config).to receive(:upgrade_hw_version?).and_return(upgrade_hw_version)
        allow(vm_config).to receive(:disk_uuid_is_enabled?).and_return(disk_uuid_is_enabled)
        allow(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob, default_hw_version)
        allow_any_instance_of(Resources::VM).to receive(:power_on).and_raise(VSphereCloud::VCenterClient::GenericVmConfigFault)
        allow(cpi).to receive(:delete_vm)

        allow(vm_config).to receive(:validate_drs_rules).and_return(true)
        allow_any_instance_of(Resources::VM).to receive(:power_on)
        allow(StoragePicker).to receive(:choose_ephemeral_storage).and_return(datastore)
        allow_any_instance_of(Resources::VM).to receive(:create_paravirtual_scsi_controller_spec).and_return(paravirtual_controller_device)

        allow(subject).to receive(:generate_network_env).and_return({'from': 'network env'})
        allow(subject).to receive(:generate_disk_env).with(
          system_disk_device,
          ephemeral_disk_device,
          disk_uuid_is_enabled
        ).and_return({'from': 'disk env'})
        allow(subject).to receive(:generate_agent_env).with(
          vm_config.name,
          cloned_vm_mob,
          vm_config.agent_id,
          config['agent'],
          {'from': 'network env'},
          {'from': 'disk env'},
        ).and_return({'from': 'agent env'})
      end

      context 'hardware version' do
        context 'when upgrade_hw_version is set to true' do
          let(:upgrade_hw_version) { true }

          it 'will upgrade to the latest version' do
            # calling with no version will upgrade to the latest version
            expect(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob, nil)
            subject.create(vm_config)
          end
        end

        context 'when upgrade_hw_version is set to false' do
          let(:upgrade_hw_version) { false }

          it 'will upgrades to default_hw_version' do
            expect(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob, 17)
            subject.create(vm_config)
          end
        end
      end

      context 'disk uuid' do
        context 'is disabled' do
          let(:vmx_options) { {'disk.enableUUID' => 0} }
          it 'will use bus id' do
            expect(subject).to receive(:generate_disk_env).with(system_disk_device, ephemeral_disk_device, false)
            subject.create(vm_config)
          end
        end

        context 'is enabled' do
          let(:vmx_options) { {'disk.enableUUID' => 1} }
          it 'will use bus id' do
            expect(subject).to receive(:generate_disk_env).with(system_disk_device, ephemeral_disk_device, true)
            subject.create(vm_config)
          end
        end
      end

      context 'with vGPU devices' do
        before do
          allow(vm_config).to receive(:vgpus).and_return(['grid_t4-16q'])
        end

        it 'upgrades the vm hardware and reconfigures the VM with the vGPU device' do
          expect(Resources::PCIPassthrough).to receive(:create_vgpu)
                                                 .with('grid_t4-16q').and_return(nil)
          expect(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob, nil)
          expect(client).to receive(:reconfig_vm).with(cloned_vm_mob, anything)
          subject.create(vm_config)
        end
      end

      context 'with PCI passthrough devices' do
        before do
          allow(vm_config).to receive(:pci_passthroughs).and_return([{
            'vendor_id' => '1234',
            'device_id' => 'abcd',
          }])
        end

        it 'reconfigures the VM with the PCI passthrough device' do
          # because of the setup we will still fail with the same error on the 2nd attempt, but we know there is a 2nd attempt..
          expect(Resources::PCIPassthrough).to receive(:create_pci_passthrough)
                                                        .with(vendor_id: '1234', device_id: 'abcd').and_return(nil)
          expect(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob, nil)
          expect(client).to receive(:reconfig_vm).with(cloned_vm_mob, anything)
          subject.create(vm_config)
        end
      end

      context 'with root_disk_size_gb set to 15 GiB' do
        let(:device_spec_system_disk) { instance_double('VimSdk::Vim::Vm::Device::VirtualDisk') }
        let(:device_spec) { instance_double(VimSdk::Vim::Vm::Device::VirtualDeviceSpec, device: device_spec_system_disk) }
        let(:new_disk_size_gb) { 15 }
        before do
          allow(vm_config).to receive(:root_disk_size_gb).and_return(new_disk_size_gb)
          allow(Resources::VM).to receive(:create_edit_device_spec).and_return(device_spec)
        end
        it "reconfigures the VM with a larger root disk and we don't check linked clones because the mocking is already too much" do
          expect(device_spec_system_disk).to receive(:capacity_in_kb=).with(new_disk_size_gb * 2 ** 20) # convert kiB → GiB
          expect(client).to receive(:reconfig_vm).with(cloned_vm_mob, anything)
          subject.create(vm_config)
        end
      end

      context 'paravirtual SCSI controller' do
        it "changes default SCSI controller to paravirtual SCSI controller to allow more disks to be attached" do
          expect(client).to receive(:wait_for_task).and_yield

          expect(cpi).to receive(:clone_vm) do |_vm, _name, _folder, _resource_pool, options|
            expect(options[:config].device_change).to include(have_attributes(
                                                                class: VimSdk::Vim::Vm::Device::VirtualDeviceSpec,
                                                                device: paravirtual_controller_device,
                                                                operation: VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::EDIT
                                                              ))
            cloned_vm_mob
          end
          subject.create(vm_config)
        end
      end

      context 'extra config' do
        context 'vmx config has values' do
          let(:vmx_options) do
            {
              'something' => 'very very boring',
              'nothing' => 'to see',
              'super secret' => 'bWFkZSB5b3UgbG9vay4gQWxzbyBoaSB0aGVyZQo='
            }
          end

          it "the vm's vmx config should be copied into the extra_config" do
            expect(client).to receive(:wait_for_task).and_yield

            expect(cpi).to receive(:clone_vm) do |_vm, _name, _folder, _resource_pool, options|
              expect(options[:config].extra_config).to include(*vmx_options.map {|k, v| have_attributes(key: k, value: v)})
              cloned_vm_mob
            end

            subject.create(vm_config)
          end
        end

        context 'vmx config has disk.enableUUID' do
          let(:vmx_options) { { 'disk.enableUUID' => '2' } }

          it "the vm's vmx config should be copied into the extra_config" do
            expect(client).to receive(:wait_for_task).and_yield

            expect(cpi).to receive(:clone_vm) do |_vm, _name, _folder, _resource_pool, options|
              expect(options[:config].extra_config).to(
                include(have_attributes(key: 'disk.enableUUID', value: '2'))
              )
              cloned_vm_mob
            end

            subject.create(vm_config)
          end
        end
      end

      context 'with alternative placements' do
        before do
          allow_any_instance_of(Resources::VM).to receive(:power_on).and_raise(VSphereCloud::VCenterClient::GenericVmConfigFault)
          allow(cpi).to receive(:delete_vm)
          allow(vm_config).to receive(:validate_drs_rules).and_return(false)
        end

        it 'retries creating a vm on another viable datastore if the first attempt to power on fails with a GenericVmConfigFault and there are alternative placements' do
          # because of the setup we will still fail with the same error on the 2nd attempt, but we know there is a 2nd attempt..
          expect(logger).to receive(:debug).with("VM start failed with datastore issues, retrying on next ds").at_least(1)
          expect(logger).to receive(:debug).with("Retrying to create vm on ds-2")
          expect{subject.create(vm_config)}.to raise_error(VSphereCloud::VCenterClient::GenericVmConfigFault)
        end

        context 'when there are alternative placements but the error is not GenericVmConfigFault' do
          before do
            allow_any_instance_of(Resources::VM).to receive(:power_on).and_raise(VSphereCloud::VCenterClient::InvalidPowerState)
          end
          it 'doesn\'t retry creating a vm on another viable datastore if the first attempt to power on fails with a GenericVmConfigFault and there are alternative placements' do
            expect(logger).not_to receive(:debug).with("Retrying to create vm on ds-2")
            expect{subject.create(vm_config)}.to raise_error(VSphereCloud::VCenterClient::InvalidPowerState)
          end
        end

        context 'without alternative placements' do
          let(:vm_config) { instance_double(VmConfig,
                                            name: 'norbo',
                                            agent_id: 'meow',
                                            agent_env: {},
                                            vmx_options: {},
                                            drs_rule: nil,
                                            vm_type: instance_double(VmType, vm_group: {}, upgrade_hw_version: false, tags: {} ),
                                            config_spec_params: {},
                                            networks_spec: {},
                                            ephemeral_disk_size: 1024,
                                            pci_passthroughs: [],
                                            vgpus: [],
                                            calculate_cpu_reservation: nil,
                                            cluster_placements: [
                                              instance_double(VmPlacement,
                                                              cluster: cluster,
                                                              fallback_disk_placements: [],
                                                              disk_placement: instance_double(Resources::Datastore, name: "ds-1")
                                                             )
                                            ],
                                            stemcell_cid: 'here-stemcell-cid',
                                            root_disk_size_gb: 0
                                           )
          }
          it 'still fails if there are no viable fallback_disk_placements' do
            expect(logger).not_to receive(:debug).with("VM start failed with datastore issues, retrying on next ds")
            expect(logger).not_to receive(:debug).with("Retrying to create vm on ds-2")
            expect{subject.create(vm_config)}.to raise_error(VSphereCloud::VCenterClient::GenericVmConfigFault)
          end
        end
      end

      context 'ip conflict detection' do
        context 'activated' do
          context 'no conflicts' do
            it 'does not raise' do
              expect {
                subject.create(vm_config)
              }.not_to raise_error
            end
          end

          context 'conflicts exist' do
            before do
              allow(ip_conflict_detector).to receive(:ensure_no_conflicts).and_raise('Hey')
            end

            it 'raises' do
              expect {
                subject.create(vm_config)
              }.to raise_error(/Hey/)
            end
          end
        end

        context 'deactivated' do
          let(:ensure_no_ip_conflicts) { false }

          it 'does not check' do
            expect(ip_conflict_detector).not_to receive(:ensure_no_conflicts)
            subject.create(vm_config)
          end
        end
      end
    end

    describe '#generate_agent_env' do
      let(:name) { 'abc123' }
      let(:vm_mob_id) { 'mob 123' }
      let(:agent_id) { 'meow' }
      let(:network_env) { {'from' => 'network'} }
      let(:disk_env) { {'from' => 'disk'} }
      let(:extra_env) { {'something' => 'cool'} }

      it 'generates the agent env' do
        expect(cloned_vm_mob).to receive('__mo_id__').and_return(vm_mob_id)

        env = subject.generate_agent_env(name, cloned_vm_mob, agent_id, extra_env, network_env, disk_env)
        expect(env).to eq({
                            'vm' => {
                              'name' => name,
                              'id' => vm_mob_id,
                            },
                            'agent_id' => agent_id,
                            'networks' => network_env,
                            'disks' => disk_env,
                            'something' => 'cool'
                          })
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
          expect(subject.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
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
          expect(subject.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
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
          expect(subject.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'using a standard switch' do
        let(:backing) { VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new }

        it 'generates the network env' do
          expect(subject.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
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
          expect(subject.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
        end
      end

      context 'not passing any device that is a VirtualEthernetCard' do
        let(:devices) { [] }
        let(:backing) { double }

        it 'responds with an appropriate error message' do
          expect {
            subject.generate_network_env(devices, networks, dvs_index)
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

            expect(subject.generate_network_env(devices, networks, dvs_index)).to eq(expected_output)
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
        instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, backing: ephemeral_backing, unit_number: ephemeral_disk_unit_number)
      end
      let(:vm_config) { instance_double(VmConfig) }
      context 'when disk uuid is disabled on VM' do
        it 'returns disk env with unit numbers' do
          disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, false)
          expect(disk_env['ephemeral']). to eq(ephemeral_disk_unit_number.to_s)
          expect(disk_env['system']). to eq(system_disk_unit_number.to_s)
        end
      end
      context 'when disk uuid is enabled on VM' do
        it 'returns disk env with unit numbers and ephemeral disk with UUID set to id key' do
          disk_env = subject.generate_disk_env(system_disk, ephemeral_disk, true)
          expect(disk_env['ephemeral']). to eq({'id' => ephemeral_uuid.downcase})
          expect(disk_env['system']). to eq(system_disk_unit_number.to_s)
        end
      end
    end
  end
end
