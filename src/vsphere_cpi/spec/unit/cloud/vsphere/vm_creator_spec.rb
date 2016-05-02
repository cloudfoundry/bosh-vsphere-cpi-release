require 'spec_helper'
require 'cloud/vsphere/drs_rules/drs_rule'

module VSphereCloud
  describe VmCreator do
    let(:vsphere_client) { instance_double(VCenterClient, cloud_searcher: cloud_searcher) }
    let(:logger) { double('logger', debug: nil, info: nil) }
    let(:cpi) { instance_double(Cloud) }
    let(:cloud_searcher) { instance_double(CloudSearcher) }
    let(:datacenter) do
      instance_double(
        Resources::Datacenter,
        :name => 'fake-datacenter',
        :vm_folder => instance_double(Resources::Folder, :mob => folder_mob),
        mob: datacenter_mob
      )
    end
    let(:ip_conflict_detector) { instance_double(IPConflictDetector) }
    let(:folder_mob) { instance_double(VimSdk::Vim::Folder) }
    let(:datacenter_mob) { instance_double(VimSdk::Vim::Datacenter) }
    let(:agent_env) { instance_double(AgentEnv) }

    subject(:creator) do
      described_class.new(
        client: vsphere_client,
        cloud_searcher: cloud_searcher,
        logger: logger,
        cpi: cpi,
        datacenter: datacenter,
        agent_env: agent_env,
        ip_conflict_detector: ip_conflict_detector
      )
    end

    describe '#create' do
      let(:vm_config) do
        instance_double(VmConfig)
      end

      let(:config_spec_params) do
        {
          num_cpus: 2,
          memory_mb: 4096
        }
      end
      let(:networks) do
        {
          "fake-network-name" => ["1.2.3.4"]
        }
      end
      let(:networks_spec) { "fake-network-spec" }
      let(:cluster) do
        instance_double(
          Resources::Cluster,
          resource_pool: instance_double(Resources::ResourcePool, mob: resource_pool_mob),
          mob: cluster_mob
        )
      end
      let(:cluster_mob) { instance_double(VimSdk::Vim::Cluster) }
      let(:resource_pool_mob) { instance_double(VimSdk::Vim::ResourcePool) }
      let(:datastore) do
        instance_double(
          Resources::Datastore,
          mob: datastore_mob,
          name: 'fake-datastore-name'
        )
      end
      let(:datastore_mob) { instance_double(VimSdk::Vim::Datastore) }
      let(:replicated_stemcell_mob) { instance_double(VimSdk::Vim::VirtualMachine) }
      let(:replicated_stemcell_vm) do
        instance_double(
          Resources::VM,
          mob: replicated_stemcell_mob,
          system_disk: double("fake-disk", controller_key: "fake-controller-key"),
          pci_controller: double("fake-controller", key: "fake-pci-key"),
          nics: stemcell_nics
        )
      end
      let(:ephemeral_disk) { instance_double(Resources::EphemeralDisk) }
      let(:ephemeral_disk_config) { instance_double(VimSdk::Vim::Vm::Device::VirtualDeviceSpec, :device => "fake-device") }
      let(:network_mob) { instance_double(VimSdk::Vim::Network) }
      let(:virtual_nic) { double('fake-nic') }
      let(:stemcell_nics) { [double('stemcell-nic', key: 'fake-stemcell-nic')] }
      let(:config_spec) { instance_double(VimSdk::Vim::Vm::ConfigSpec) }
      let(:snapshot) { instance_double(VimSdk::Vim::Vm::SnapshotInfo, current_snapshot: "fake-snapshot") }
      let(:clone_vm_task) { double('fake-task') }
      let(:created_vm_mob) { instance_double(VimSdk::Vim::VirtualMachine) }
      let(:created_vm) do
        instance_double(
          Resources::VM,
          mob: created_vm_mob,
          system_disk: double("fake-disk", controller_key: "fake-controller-key"),
          devices: [double("fake-devices")]
        )
      end
      let(:drs_rule) { instance_double(DrsRule) }

      # Setup vm_config fake
      before do
        allow(vm_config).to receive(:name).and_return("fake-vm-name")
        allow(vm_config).to receive(:cluster_name).and_return("fake-cluster-name")
        allow(vm_config).to receive(:datastore_name).and_return("fake-datastore-name")
        allow(vm_config).to receive(:vsphere_networks).and_return(networks)
        allow(vm_config).to receive(:networks_spec).and_return(networks_spec)
        allow(vm_config).to receive(:stemcell_cid).and_return("fake-stemcell-cid")
        allow(vm_config).to receive(:ephemeral_disk_size).and_return(1024)
        allow(vm_config).to receive(:config_spec_params).and_return(config_spec_params)
        allow(vm_config).to receive(:agent_id).and_return("fake-agent-id")
        allow(vm_config).to receive(:agent_env).and_return("fake-agent-env")
        allow(vm_config).to receive(:drs_rule).and_return({ "name" => "fake-drs-rule" })

        device_change = []
        allow(config_spec).to receive(:device_change=) do |args|
          device_change = args
        end
        allow(config_spec).to receive(:device_change) do
          device_change
        end

        # TODO: Remove this once we handle placement resources better
        allow(vm_config).to receive(:is_top_level_cluster).and_return(false)
      end

      # Setup top-level dependency fakes
      before do
        allow(datacenter).to receive(:find_cluster)
          .with("fake-cluster-name")
          .and_return(cluster)
        allow(datacenter).to receive(:find_datastore)
          .with("fake-datastore-name")
          .and_return(datastore)

        allow(cpi).to receive(:replicate_stemcell)
          .with(cluster, datastore, "fake-stemcell-cid")
          .and_return(replicated_stemcell_mob)
        allow(cpi).to receive(:clone_vm)
          .with(
            replicated_stemcell_mob,
            "fake-vm-name",
            folder_mob,
            resource_pool_mob,
            {
              datastore: datastore_mob,
              linked: true,
              snapshot: "fake-snapshot",
              config: config_spec
            }
          )
          .and_return(clone_vm_task)
        allow(cpi).to receive(:generate_network_env)
          .with(created_vm.devices, networks_spec, {}) # empty hash is a placeholder for dvs_index
          .and_return("fake-network-env")
        allow(cpi).to receive(:generate_disk_env)
          .with(created_vm.system_disk, "fake-device")
          .and_return("fake-disk-env")
        allow(cpi).to receive(:generate_agent_env)
          .with("fake-vm-name", created_vm_mob, "fake-agent-id", "fake-network-env", "fake-disk-env")
          .and_return({})
        allow(cpi).to receive(:get_vm_location)
          .with(
            created_vm_mob,
            datacenter: "fake-datacenter",
            datastore: "fake-datastore-name",
            vm: "fake-vm-name"
          )
          .and_return("fake-location")

        allow(cloud_searcher).to receive(:get_properties)
          .with(
            replicated_stemcell_mob,
            VimSdk::Vim::VirtualMachine,
            ['snapshot'],
            ensure_all: true
          )
          .and_return({'snapshot' => snapshot})

        allow(vsphere_client).to receive(:wait_for_task)
          .with(clone_vm_task)
          .and_return(created_vm_mob)
        allow(vsphere_client).to receive(:find_by_inventory_path)
          .with(['fake-datacenter', 'network', 'fake-network-name'])
          .and_return(network_mob)

      end

      # Setup Resource fakes
      before do
        allow(Resources::VM).to receive(:new)
          .with("fake-stemcell-cid", replicated_stemcell_mob, vsphere_client, logger)
          .and_return(replicated_stemcell_vm)
        allow(Resources::VM).to receive(:create_add_device_spec)
          .with(virtual_nic)
          .and_return("fake-added-nic")
        allow(Resources::VM).to receive(:create_delete_device_spec)
          .with(stemcell_nics.first)
          .and_return("fake-deleted-nic")

        allow(Resources::EphemeralDisk).to receive(:new)
          .with(
            Resources::EphemeralDisk::DISK_NAME,
            1024,
            datastore,
            "fake-vm-name"
          )
          .and_return(ephemeral_disk)
        allow(ephemeral_disk).to receive(:create_disk_attachment_spec)
          .with("fake-controller-key")
          .and_return(ephemeral_disk_config)

        allow(Resources::Nic).to receive(:create_virtual_nic)
          .with(
            cloud_searcher,
            "fake-network-name",
            network_mob,
            "fake-pci-key",
            {}
          )
          .and_return(virtual_nic)
      end

      # Setup SDK fakes
      before do
        allow(VimSdk::Vim::Vm::ConfigSpec).to receive(:new)
          .with(config_spec_params)
          .and_return(config_spec)
      end

      it 'creates a VM with the provided VM config options' do
        expect(ip_conflict_detector).to receive(:ensure_no_conflicts).with(networks)

        expect(replicated_stemcell_vm).to receive(:fix_device_unit_numbers)
          .with([
            ephemeral_disk_config,
            "fake-added-nic",
            "fake-deleted-nic"
          ])

        expect(Resources::VM).to receive(:new)
          .with("fake-vm-name", created_vm_mob, vsphere_client, logger)
          .and_return(created_vm)

        expect(agent_env).to receive(:set_env)
          .with(created_vm_mob, "fake-location", {'env' => "fake-agent-env"})

        expect(created_vm).to receive(:power_on)

        expect(DrsRule).to receive(:new)
          .with(
            "fake-drs-rule",
            vsphere_client,
            cloud_searcher,
            cluster_mob,
            logger,
          )
          .and_return(drs_rule)
        expect(drs_rule).to receive(:add_vm)
          .with(created_vm_mob)

        creator.create(vm_config)
      end

      context 'when vm fails to power on' do
        before(:each) do
          allow(ip_conflict_detector).to receive(:ensure_no_conflicts).with(networks)

          allow(replicated_stemcell_vm).to receive(:fix_device_unit_numbers)
            .with([
              ephemeral_disk_config,
              "fake-added-nic",
              "fake-deleted-nic"
            ])

          allow(Resources::VM).to receive(:new)
            .with("fake-vm-name", created_vm_mob, vsphere_client, logger)
            .and_return(created_vm)

          allow(agent_env).to receive(:set_env)
            .with(created_vm_mob, "fake-location", {'env' => "fake-agent-env"})

          allow(created_vm).to receive(:power_on)
            .and_raise("fake-power-on-error")
        end

        it 'deletes the vm and raises an error' do
          expect(created_vm).to receive(:delete)
          expect {
            creator.create(vm_config)
          }.to raise_error("fake-power-on-error")
        end

        context 'when delete vm fails' do
          it 'properly bubbles up the original error message' do
            expect(created_vm).to receive(:delete)
              .and_raise("fake-delete-error")
            expect {
              creator.create(vm_config)
            }.to raise_error("fake-power-on-error")
          end
        end
      end
    end
  end
end
