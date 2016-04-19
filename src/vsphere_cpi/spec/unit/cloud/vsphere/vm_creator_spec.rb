require 'spec_helper'
require 'cloud/vsphere/drs_rules/drs_rule'

describe VSphereCloud::VmCreator do
  subject(:creator) do
    described_class.new(1024, 1024, 3, cpu_hot_add_enabled, mem_hot_add_enabled, nested_hardware_virtualization, [], vsphere_client, cloud_searcher, logger, cpi, agent_env, file_provider, datacenter, cluster)
  end
  let(:cpu_hot_add_enabled) {false}
  let(:mem_hot_add_enabled) {false}
  let(:nested_hardware_virtualization) { false }
  let(:vsphere_client) { instance_double('VSphereCloud::VCenterClient', cloud_searcher: cloud_searcher) }
  let(:logger) { double('logger', debug: nil, info: nil) }
  let(:cpi) { instance_double('VSphereCloud::Cloud') }
  let(:agent_env) { instance_double('VSphereCloud::AgentEnv') }
  let(:file_provider) { instance_double('VSphereCloud::FileProvider') }
  let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
  let(:datacenter) { instance_double(VSphereCloud::Resources::Datacenter) }

  describe '#create' do
    let(:networks) do
      {
        'network_name' => {
          'cloud_properties' => {
            'name' => 'network_name',
          },
        },
      }
    end

    let(:persistent_disk_cids) { ['disk1_cid'] }
    let(:persistent_disks) { [VSphereCloud::Resources::PersistentDisk.new('disk1_cid', 1024, 'disk1_datastore', 'fake-folder')] }
    let(:disk_spec) { double('disk spec') }
    let(:folder_mob) { double('folder managed object') }
    let(:datacenter_mob) { double('datacenter mob') }
    let(:resource_pool_mob) { double('resource pool managed object') }
    let(:cluster_mob) { double(:cluster_mob) }

    let(:cluster) do
      datacenter = double('datacenter', :name => 'datacenter name', :vm_folder => double('vm_folder', :mob => folder_mob), mob: datacenter_mob)

      double('cluster', :datacenter => datacenter, :resource_pool => double('resource pool', :mob => resource_pool_mob), mob: cluster_mob, ephemeral_datastores: {datastore.name => datastore})
    end

    let(:datastore) { double('datastore', mob: datastore_mob, name: 'fake-datastore-name') }
    let(:datastore_mob) { instance_double('VimSdk::Vim::Datastore') }

    let(:vm_double) { double('cloned vm') }

    let(:ephemeral_disk) { instance_double('VSphereCloud::Resources::EphemeralDisk') }
    let(:replicated_stemcell_mob) { instance_double('VimSdk::Vim::VirtualMachine') }
    let(:current_snapshot) { double('current snapshot') }
    let(:ephemeral_disk_config) { double('ephemeral disk config', :device => disk_device) }
    let(:disk_device) { double('disk device') }
    let(:add_nic_spec) { double('add virtual nic spec') }
    let(:delete_nic_spec) { double('delete virtual nic spec') }

    before do
      stemcell_vm = instance_double('VimSdk::Vim::VirtualMachine')
      allow(cpi).to receive(:stemcell_vm).with('stemcell_cid').and_return(stemcell_vm)
      allow(cloud_searcher).to receive(:get_property).with(
        stemcell_vm,
        VimSdk::Vim::VirtualMachine,
        'summary.storage.committed',
        ensure_all: true
      ).and_return(1024*1024)
      persistent_disks.each do |disk|
        allow(datacenter).to receive(:find_disk).with(disk.cid) { disk }
      end

      allow(cpi).to receive(:replicate_stemcell).with(cluster, datastore, 'stemcell_cid').and_return(replicated_stemcell_mob)

      snapshot = double('snapshot', :current_snapshot => current_snapshot)
      stemcell_properties = { 'snapshot' => snapshot }
      allow(cloud_searcher).to receive(:get_properties).with(
        replicated_stemcell_mob,
        VimSdk::Vim::VirtualMachine,
        ['snapshot'],
        ensure_all: true
      ).and_return(stemcell_properties)

      system_disk = double(:system_disk, controller_key: 'fake-controller-key')
      allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:system_disk).and_return(system_disk)
      allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:pci_controller).and_return(double(:pci_controller, key: 'fake-pci-key'))
      allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:fix_device_unit_numbers)

      network_mob = double('standard network managed object')
      allow(network_mob).to receive(:name).and_return('standard network managed object')
      allow(vsphere_client).to receive(:find_by_inventory_path).
        with(['datacenter name', 'network', 'network_name']).
        and_return(network_mob)

      allow_any_instance_of(VSphereCloud::Resources::Nic).to receive(:create_virtual_nic).with(
        cloud_searcher,
        'network_name',
        network_mob,
        'fake-pci-key',
        {},
      ).and_return(add_nic_spec)

      virtual_nic = VimSdk::Vim::Vm::Device::VirtualEthernetCard.new
      allow(VSphereCloud::Resources::VM).to receive(:create_delete_device_spec).with(virtual_nic).and_return(delete_nic_spec)
      allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:nics).and_return([virtual_nic])

      clone_vm_task = double('cloned vm task')
      allow(cpi).to receive(:clone_vm).and_return(clone_vm_task)
      allow(vsphere_client).to receive(:wait_for_task).with(clone_vm_task).and_return(vm_double)
      allow(ephemeral_disk).to receive(:create_disk_attachment_spec).with('fake-controller-key').and_return(ephemeral_disk_config)
      allow(VSphereCloud::Resources::EphemeralDisk).to receive(:new).with(
        VSphereCloud::Resources::EphemeralDisk::DISK_NAME,
        1024,
        datastore,
        'vm-fake-uuid'
      ).and_return(ephemeral_disk)

      devices = double(:devices)
      allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:devices).and_return(devices)
      network_env = double(:network_env)
      allow(cpi).to receive(:generate_network_env).with(devices, networks, {}).and_return(network_env)
      disk_env = double(:disk_env)
      allow(cpi).to receive(:generate_disk_env).with(system_disk, disk_device).and_return(disk_env)
      allow(cpi).to receive(:generate_agent_env).with('vm-fake-uuid', vm_double, 'agent_id', network_env, disk_env).and_return({})
      vm_location = double('vm location')
      allow(cpi).to receive(:get_vm_location).with(
        vm_double,
        datacenter: 'datacenter name',
        datastore: 'fake-datastore-name',
        vm: 'vm-fake-uuid',
      ).and_return(vm_location)
      allow(agent_env).to receive(:set_env).with(vm_double, vm_location, {'env' => {}})

      allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:power_on)

      allow(datacenter).to receive(:pick_cluster_for_vm).with(1024, 2049, persistent_disks).and_return(cluster)
      allow(datacenter).to receive(:pick_ephemeral_datastore).with(2049, [datastore.name]).and_return(datastore)

      allow(SecureRandom).to receive(:uuid).and_return('fake-uuid')
    end

    context 'when the stemcell vm does not exist' do
      before do
        allow(cpi).to receive(:stemcell_vm).with('sc-beef').and_return(nil)
      end

      it 'raises an error' do
        expect {
          creator.create(nil, 'sc-beef', [], [], {})
        }.to raise_error("Could not find VM for stemcell 'sc-beef'")
      end
    end

    context 'when a network for the vm does not exist' do
      before do
        allow(cpi).to receive(:generate_network_env).and_raise(VSphereCloud::Cloud::NetworkException, "Could not find network 'network_name'")
        allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:devices).and_return([])
        allow(vsphere_client).to receive(:delete_vm)
      end

      it 'raises an error' do
        expect {
          creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
        }.to raise_error(VSphereCloud::Cloud::NetworkException, "Could not find network 'network_name' for VM 'vm-fake-uuid'")
      end
    end

    context 'when vm fails to power on' do
      before(:each) do
        allow_any_instance_of(VSphereCloud::Resources::VM).to receive(:power_on).and_raise("power_on error")
        allow(vsphere_client).to receive(:delete_vm)
      end

      it 'deletes the vm and raises an error' do
        expect_any_instance_of(VSphereCloud::Resources::VM).to receive(:delete)
        expect {
          creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
        }.to raise_error("power_on error")
      end

      context 'when delete vm fails' do
        before { allow(vsphere_client).to receive(:delete_vm).and_raise("delete error") }
        it 'properly bubbles up the original error message' do
          expect {
            creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
          }.to raise_error("power_on error")
        end
      end
    end

    context 'with predetermined cluster' do
      it 'chooses the placement based on memory, ephemeral and persistent disks' do
        expect(datacenter).to_not receive(:pick_cluster_for_vm)
        expect(datacenter).to receive(:pick_ephemeral_datastore).with(2049, [datastore.name]).and_return(datastore)
        creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
      end

      context 'when selected cluster has no ephemeral datastores' do
        let(:cluster) do
          datacenter = double('datacenter', :name => 'datacenter name', :vm_folder => double('vm_folder', :mob => folder_mob), mob: datacenter_mob)

          double('cluster', datacenter: datacenter, resource_pool: double('resource pool', mob: resource_pool_mob), mob: cluster_mob, ephemeral_datastores: {}, name: 'some-cluster')
        end

        it 'chooses the placement based on memory, ephemeral and persistent disks' do
          expect(datacenter).to_not receive(:pick_cluster_for_vm)
          expect(datacenter).to_not receive(:pick_ephemeral_datastore)
          expect {
            creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
          }.to raise_error("Cluster 'some-cluster' has no ephemeral datastores")
        end
      end
    end

    context 'without predetermined cluster' do
      subject(:creator) do
        described_class.new(1024, 1024, 3, cpu_hot_add_enabled, mem_hot_add_enabled, nested_hardware_virtualization, [], vsphere_client, cloud_searcher, logger, cpi, agent_env, file_provider, datacenter, nil)
      end
      it 'chooses the placement based on memory, ephemeral and persistent disks' do
        expect(datacenter).to receive(:pick_cluster_for_vm).with(1024, 2049, persistent_disks).and_return(cluster)
        expect(datacenter).to receive(:pick_ephemeral_datastore).with(2049, [datastore.name]).and_return(datastore)
        creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
      end
    end

    it 'clones the vm with the correct attributes set' do
      allow(VimSdk::Vim::Vm::ConfigSpec).to receive(:new).and_call_original
      allow(VSphereCloud::Resources::VM)
        .to receive(:create_add_device_spec)
        .and_return(add_nic_spec)

      creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})

      expect(VimSdk::Vim::Vm::ConfigSpec).to have_received(:new).with({memory_mb: 1024, num_cpus: 3})
      expect(cpi).to have_received(:clone_vm) do |r_s_mob, vm_id, f_mob, rp_mob, config|
        expect(r_s_mob).to eq(replicated_stemcell_mob)
        expect(vm_id).to eq('vm-fake-uuid')
        expect(f_mob).to eq(folder_mob)
        expect(rp_mob).to eq(resource_pool_mob)
        expect(config[:datastore]).to eq(datastore_mob)
        expect(config[:linked]).to eq(true)
        expect(config[:snapshot]).to eq(current_snapshot)
        expect(config[:config].memory_mb).to eq(1024)
        expect(config[:config].num_cpus).to eq(3)
        expect(config[:config].device_change).to match_array([ephemeral_disk_config, add_nic_spec, delete_nic_spec])
      end
    end

    context 'when nested hardware virtualization is enabled' do
      let(:nested_hardware_virtualization) { true }
      it 'clones the vm with the enabled' do
        expect(VimSdk::Vim::Vm::ConfigSpec).to receive(:new).with(
            {memory_mb: 1024, num_cpus: 3, nested_hv_enabled: true}).and_call_original

        creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
      end
    end

    describe 'DRS rules' do
      subject(:creator) do
        described_class.new(1024, 1024, 3, cpu_hot_add_enabled, mem_hot_add_enabled, nested_hardware_virtualization, drs_rules, vsphere_client, cloud_searcher, logger, cpi, agent_env, file_provider, datacenter, nil)
      end
      context 'when several DRS rules are specified in cloud properties' do
        let(:drs_rules) do
          [
            { 'name' => 'fake-drs-rule-1', 'type' => 'separate_vms' },
            { 'name' => 'fake-drs-rule-2', 'type' => 'separate_vms' },
          ]
        end

        it 'raises an error' do
          expect_any_instance_of(VSphereCloud::Resources::VM).to receive(:delete)
          expect {
            creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
          }.to raise_error /vSphere CPI supports only one DRS rule per resource pool/
        end
      end

      context 'when one DRS rule is specified' do
        let(:drs_rules) do
          [
            { 'name' => 'fake-drs-rule-1', 'type' => drs_rule_type },
          ]
        end

        let(:drs_rule_type) { 'separate_vms' }

        context 'when DRS rule type is separate_vms' do
          it 'adds VM to specified drs rules' do
            drs_rule_1 = instance_double('VSphereCloud::DrsRule')
            expect(VSphereCloud::DrsRule).to receive(:new).
              with('fake-drs-rule-1', vsphere_client, cloud_searcher, cluster_mob, logger).
              and_return(drs_rule_1)
            expect(drs_rule_1).to receive(:add_vm).with(vm_double)

            creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
          end
        end

        context 'when DRS rule type is not separate_vms' do
          let(:drs_rule_type) { 'bad_type' }

          it 'raises an error' do
            expect_any_instance_of(VSphereCloud::Resources::VM).to receive(:delete)
            expect {
              creator.create('agent_id', 'stemcell_cid', networks, persistent_disk_cids, {})
            }.to raise_error /vSphere CPI only supports DRS rule of 'separate_vms' type/
          end
        end
      end
    end
  end
end
