require 'spec_helper'
require 'cloud/vsphere/drs_rules/drs_rule'

module VSphereCloud
  describe VmCreator , fake_logger: true do
    subject(:creator) {
      VmCreator.new(
        client: ,
        cloud_searcher: cloud_searcher,
        cpi:,
        datacenter: datacenter_mob,
        agent_env:,
        tagging_tagger:,
        default_disk_type:,
        enable_auto_anti_affinity_drs_rules: false,
        stemcell:,
        upgrade_hw_version: false,
        pbm:,
        ip_conflict_detector: ip_conflict_detector,
        ensure_no_ip_conflicts: ensure_no_ip_conflicts,
      )
    }
    let(:agent_env) { instance_double('VSphereCloud::AgentEnv')  }
    let(:config) {  [ 'default_disk_type'=> default_disk_type, 'resource_pool' => 'test',  'datacenters'=> [ datacenter ],'host' => 'localhost', 'user' => 'admin', 'password' => 'password' ] }
    let(:cpi_config) do
      instance_double(
        'VSphereCloud::Config',
        logger: logger,
      ).as_null_object
    end

    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
    let(:cpi) {
      Cloud.new({ 'vcenters' => config , 'agent' => {}})
    }
    let(:custom_fields_manager) { instance_double('VimSdk::Vim::CustomFieldsManager') }
    let(:datacenter) { {  mob: datacenter_mob , name: 'dc-1', 'name' => 'dc-1', 'persistent_datastore_pattern' => 'ds-ps-*', 'datastore_pattern'=> 'ds-*', 'vm_folder'=> 'bosh_vms', 'template_folder'=> 'stemcells', 'disk_path' => 'disks', 'clusters' => [] } }
    let(:datacenter_mob) { instance_double('VimSdk::Vim::Datacenter', name: 'dc-1') }
    let(:default_disk_type) { 'preallocated' }
    let(:ip_conflict_detector) { instance_double(IPConflictDetector, ensure_no_conflicts: nil) }
    let(:ensure_no_ip_conflicts) { true }
    let(:fake_ephemeral_disk) {
      instance_double(VSphereCloud::DiskConfig,
        size: 4096,
        ephemeral?: true,
        target_datastore_pattern: 'ds-*',
      )
    }
    let(:cloud_config) do
      instance_double(
        'VSphereCloud::Config',
        logger: logger,
        memory_reservation_locked_to_max: false,
        vcenter_host: 'localhost',
        vcenter_api_uri: vcenter_api_uri,
        vcenter_user: 'fake-user',
        vcenter_password: 'fake-password',
        vcenter_default_disk_type: default_disk_type,
        soap_log: 'fake-log-file',
        vcenter_enable_auto_anti_affinity_drs_rules: false,
        upgrade_hw_version: false,
        vcenter_http_logging: true,
        nsxt_enabled?: false,
        human_readable_name_enabled?: true
      ).as_null_object
    end
    let(:http_client) { instance_double('VSphereCloud::CpiHttpClient') }
    let(:pbm) { instance_double('VSphereCloud::Pbm') }
    let(:stemcell_vm) { instance_double(VSphereCloud::Resources::VM , system_disk: fake_ephemeral_disk ) }
    let(:vm) { instance_double(VSphereCloud::Resources::VM , system_disk: fake_ephemeral_disk ) }
    let(:cloned_vm_mob) { instance_double('VimSdk::Vim::VirtualMachine' ) }
    let(:cloned_vm) { instance_double(VSphereCloud::Resources::VM, devices: []  ) }
    let(:tagging_tagger) { instance_double(TaggingTag::AttachTagToVm) }
    let(:tag_client) { instance_double(TaggingTag::AttachTagToVm) }

    let(:option_manager) { instance_double('VimSdk::Vim::Option::OptionManager') }
    let(:service_content) {
      instance_double('VimSdk::Vim::ServiceInstanceContent',
        virtual_disk_manager: virtual_disk_manager,
        setting: option_manager,
        custom_fields_manager: custom_fields_manager
      )
    }
    let(:soap_stub) { instance_double(VSphereCloud::SdkHelpers::RetryableStubAdapter, vc_cookie: 'somerandomcookie') }
    let(:stemcell) { { cid: 'fake-stemcell-cid', size: 1024 } }
    let(:vcenter_api_uri) { URI.parse("https://localhost/sdk/vimService") }
    let(:client) { instance_double('VSphereCloud::VCenterClient', login: nil, service_content: service_content, soap_stub: soap_stub ) }
    let(:virtual_disk_manager) { instance_double('VimSdk::Vim::VirtualDiskManager') }

    before do
      allow_any_instance_of(Cloud).to receive(:at_exit)
      allow(Config).to receive(:build).and_return(cloud_config)
      allow(CpiHttpClient).to receive(:new)
                                .and_return(http_client)
      allow(VCenterClient).to receive(:new).with(
        vcenter_api_uri: vcenter_api_uri,
        http_client: http_client
      ).and_return(client)
      allow(Pbm).to receive(:new).and_return(pbm)
      allow(TaggingTag::AttachTagToVm).to receive(:new).with(any_args).and_return(tagging_tagger)
      allow(TaggingTag::AttachTagToVm).to receive(:InitializeConnection).with(any_args).and_return(tag_client)
      allow(stemcell).to receive(:replicate).and_return(stemcell_vm)
      allow(cloud_searcher).to receive(:get_properties).with(
        stemcell_vm,
        VimSdk::Vim::VirtualMachine,
        ["snapshot", "datastore"],
        ensure_all: true
      ).and_return({'snapshot'=> 'value'})
      allow(cloud_searcher).to receive(:get_properties).with(
        stemcell_vm,
        VimSdk::Vim::VirtualMachine,
        :ensure=>["config.hardware.device", "runtime", "config.extraConfig"]
      ).and_return(cloned_vm)
      allow(client).to receive(:cloud_searcher).and_return(cloud_searcher)
      allow_any_instance_of(Resources::EphemeralDisk).to receive(:create_disk_attachment_spec).and_return([])
      allow_any_instance_of(Resources::VM).to receive_message_chain(:system_disk, :controller_key).and_return(1)
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
      allow_any_instance_of(Resources::VM).to receive(:devices).and_return([])
      allow_any_instance_of(Resources::VM).to receive(:fix_device_key).and_return(nil)
      allow(cpi).to receive(:generate_network_env).and_return({})
      allow(cpi).to receive(:generate_disk_env).and_return({})
      allow(cpi).to receive(:generate_agent_env).and_return({})
      allow(client).to receive(:find_by_inventory_path).with("dc-1").and_return(datacenter)
      allow(client).to receive(:find_vm_by_name).and_return(cloned_vm)
      allow(agent_env).to receive(:set_env)
      allow(subject).to receive(:create_drs_rules).and_return(nil)
      allow(subject).to receive(:add_vm_to_vm_group).and_return(nil)
      allow(subject).to receive(:apply_storage_policy).and_return(nil)
      allow(vm_config).to receive(:upgrade_hw_version?).and_return(false)
      allow_any_instance_of(Resources::VM).to receive(:power_on).and_raise(VSphereCloud::VCenterClient::GenericVmConfigFault)
      allow(cpi).to receive(:delete_vm)

      allow(vm_config).to receive(:validate_drs_rules).and_return(true)
      allow_any_instance_of(Resources::VM).to receive(:power_on)
    end
    let(:vm_config) { instance_double(VmConfig,
                                      name: 'norbo',
                                      agent_id: 'meow',
                                      agent_env: {},
                                      vmx_options: {},
                                      drs_rule: nil,
                                      vm_type: instance_double(VmType, vm_group: {}, upgrade_hw_version: false, tags: {}, disable_drs: false ),
                                      config_spec_params: {},
                                      networks_spec: {},
                                      ephemeral_disk_size: 1024,
                                      pci_passthroughs: [],
                                      vgpus: [],

                                      cluster_placements: [
                                        instance_double(VmPlacement,
                                                                                 cluster: instance_double(Resources::Cluster, host_group: nil, mob: nil,  accessible_datastores: {"ds-1": {}, "ds-2": {}}),
                                                        fallback_disk_placements: [instance_double(Resources::Datastore, name: "ds-2")],
                                                        disk_placement: instance_double(Resources::Datastore, name: "ds-1")
                                                       )
                                      ],
                                      stemcell_cid: 'here-stemcell-cid'

                                     )
    }

    context 'with vGPU devices' do
      before do
        allow(vm_config).to receive(:vgpus).and_return(['grid_t4-16q'])
      end
      it 'upgrades the vm hardware and reconfigures the VM with the vGPU device' do
        expect(Resources::PCIPassthrough).to receive(:create_vgpu)
                                               .with('grid_t4-16q').and_return(nil)
        expect(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob)
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
        expect(client).to receive(:upgrade_vm_virtual_hardware).with(cloned_vm_mob)
        expect(client).to receive(:reconfig_vm).with(cloned_vm_mob, anything)
        subject.create(vm_config)
        # expect{subject.create(vm_config)}.not_to raise_exception
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

                                          cluster_placements: [
                                            instance_double(VmPlacement,
                                                            cluster: instance_double(Resources::Cluster, host_group: nil, mob: nil,  accessible_datastores: {"ds-1": {}, "ds-2": {}}),
                                                            fallback_disk_placements: [],
                                                            disk_placement: instance_double(Resources::Datastore, name: "ds-1")
                                                           )
                                          ],
                                          stemcell_cid: 'here-stemcell-cid'

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
end
