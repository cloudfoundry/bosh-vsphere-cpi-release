require 'cloud/vsphere/logger'

module VSphereCloud
  class VmCreator
    include Logger

    def initialize(client:, cloud_searcher:, cpi:, datacenter:, agent_env:, ip_conflict_detector:, default_disk_type:, enable_auto_anti_affinity_drs_rules:, stemcell:, upgrade_hw_version:)
      @client = client
      @cloud_searcher = cloud_searcher
      @cpi = cpi
      @datacenter = datacenter
      @agent_env = agent_env
      @ip_conflict_detector = ip_conflict_detector
      @default_disk_type = default_disk_type
      @enable_auto_anti_affinity_drs_rules = enable_auto_anti_affinity_drs_rules
      @stemcell = stemcell
      @upgrade_hw_version = upgrade_hw_version
    end

    def create(vm_config)
      cluster = vm_config.cluster
      storage = StoragePicker.choose_ephemeral_storage(vm_config.ephemeral_datastore_name, vm_config.cluster.accessible_datastores, vm_config.vm_type)

      datastore, datastore_cluster = storage.is_a?(Resources::StoragePod) ? [nil, storage] : [storage, nil]

      @ip_conflict_detector.ensure_no_conflicts(vm_config.vsphere_networks)

      logger.info("Creating vm: #{vm_config.name} on #{cluster.mob} stored in #{datastore.mob}") if datastore
      logger.info("Creating vm: #{vm_config.name} on #{cluster.mob} stored in datastore cluster: #{datastore_cluster.name}") if datastore_cluster

      # Replicate stemcell stage
      replicated_stemcell_vm_mob = @stemcell.replicate(@datacenter, cluster, datastore, datastore_cluster)
      replicated_stemcell_properties = @cloud_searcher.get_properties(
        replicated_stemcell_vm_mob,
        VimSdk::Vim::VirtualMachine,
        ['snapshot', 'datastore'],
        ensure_all: true
      )
      #create vm/ephemeral disk on same datastore as stemcell if datastore cluster is being used.
      if datastore_cluster
        datastore = Resources::Datastore.build_from_client(@client, replicated_stemcell_properties['datastore']).first
      end
      replicated_stemcell_vm = Resources::VM.new(vm_config.stemcell_cid, replicated_stemcell_vm_mob, @client)
      snapshot = replicated_stemcell_properties['snapshot']

      # Create device_change config
      config_spec = VimSdk::Vim::Vm::ConfigSpec.new(vm_config.config_spec_params)
      config_spec.device_change = []

      ephemeral_disk = Resources::EphemeralDisk.new(
        size_in_mb: vm_config.ephemeral_disk_size,
        datastore: datastore,
        folder: vm_config.name,
        disk_type: @default_disk_type,
      )

      ephemeral_disk_config = ephemeral_disk.create_disk_attachment_spec(
        disk_controller_id: replicated_stemcell_vm.system_disk.controller_key,
      )
      config_spec.device_change << ephemeral_disk_config

      dvs_index = {}
      vm_config.vsphere_networks.each do |network_name, ips|
        network_mob = @client.find_network(@datacenter, network_name)
        if network_mob.nil?
          raise "Unable to find network '#{network_name}'. Verify that the portgroup exists."
        end
        ips.each do |_|
          virtual_nic = Resources::Nic.create_virtual_nic(
            @cloud_searcher,
            network_name,
            network_mob,
            replicated_stemcell_vm.pci_controller.key,
            dvs_index
          )
          nic_config = Resources::VM.create_add_device_spec(virtual_nic)
          config_spec.device_change << nic_config
        end
      end

      replicated_stemcell_vm.nics.each do |nic|
        nic_config = Resources::VM.create_delete_device_spec(nic)
        config_spec.device_change << nic_config
      end

      replicated_stemcell_vm.fix_device_unit_numbers(config_spec.device_change)

      if vm_config.vmx_options.is_a?(Hash)
        config_spec.extra_config = vm_config.vmx_options.keys.map { |key|
          VimSdk::Vim::Option::OptionValue.new(key: key, value: vm_config.vmx_options[key])
        }
      else
        raise "Unable to parse vmx options: 'vmx_options' is not a Hash"
      end

      if vm_config.attach_gpu?
        # This should be non-breaking as host-resource will be nil in case no gpu calc happens
        # Get final cluster placements
        cluster_placement = vm_config.cluster_placements
        # get the first host resource that satisfies criteria
        host_resource = cluster_placement[cluster.name][:host_array]&.first
        add_gpu_device(config_spec, replicated_stemcell_vm, cluster, host_resource, vm_config.gpu_config['number_of_gpus'])
      else
        host_resource = nil
      end

      logger.info("Cloning VM on Datastore: #{datastore.name}, Cluster: #{cluster.name}, Host: #{host_resource.nil? ? "Determined by DRS" : host_resource.name} ")

      # Clone VM
      logger.info("Cloning vm: #{replicated_stemcell_vm} to #{vm_config.name}")
      created_vm_mob = @client.wait_for_task do
        @cpi.clone_vm(replicated_stemcell_vm.mob,
          vm_config.name,
          @datacenter.vm_folder.mob,
          cluster.resource_pool.mob,
          datastore: datastore.mob,
          host: host_resource,
          linked: true,
          snapshot: snapshot.current_snapshot,
          config: config_spec,
          datastore_cluster: datastore_cluster
        )
      end
      created_vm = Resources::VM.new(vm_config.name, created_vm_mob, @client)

      # Set agent env settings
      begin
        network_env = @cpi.generate_network_env(created_vm.devices, vm_config.networks_spec, dvs_index)
        disk_env = @cpi.generate_disk_env(created_vm.system_disk, ephemeral_disk_config.device)
        env = @cpi.generate_agent_env(vm_config.name, created_vm.mob, vm_config.agent_id, network_env, disk_env)
        env['env'] = vm_config.agent_env

        location = {
          datacenter: @datacenter.name,
          datastore: datastore.name,
          vm: vm_config.name,
        }

        @agent_env.set_env(created_vm.mob, location, env)

        # DRS Rules
        create_drs_rules(vm_config, created_vm.mob, cluster)

        begin
          # Upgrade to latest virtual hardware version
          # We decide to upgrade hardware version on basis of two params
          # 1. vm_type specification of upgrade hardware flag and
          # 2. Global upgrade hardware flag @upgrade_hw_version
          if vm_config.upgrade_hw_version?(vm_config.vm_type.upgrade_hw_version, @upgrade_hw_version)
            created_vm.upgrade_vm_virtual_hardware
          end
        rescue VSphereCloud::VCenterClient::AlreadyUpgraded
        end

        # Power on VM
        logger.info("Powering on VM: #{created_vm}")
        created_vm.power_on
      rescue => e
        e.vm_cid = vm_config.name if e.instance_of?(Cloud::NetworkException)
        logger.info("#{e} - #{e.backtrace.join("\n")}")
        begin
          @cpi.delete_vm(created_vm.cid) if created_vm
        rescue => ex
          logger.info("Failed to delete vm '#{vm_config.name}' with message:  #{ex.inspect}")
        end
        raise e
      end

      created_vm
    end

    def add_gpu_device(config_spec, replicated_stemcell_vm, cluster, host_resource, num_gpus)

      qct = cluster.mob.environment_browser.query_config_target(host_resource.mob)
      sysid_map = qct.pci_passthrough.map { |x| [x.pci_device.id, x.system_id]}.to_h

      host_resource.available_gpu.each do |gpu_dev|
        device_config_spec = VimSdk::Vim::Vm::Device::VirtualDeviceSpec.new
        dev = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        dev.key = -1
        dev.controller_key=replicated_stemcell_vm.pci_controller.key

        back = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DeviceBackingInfo.new
        back.id=gpu_dev.id
        back.system_id=sysid_map[back.id]
        back.vendor_id=gpu_dev.vendor_id
        back.device_id=gpu_dev.device_id.to_i.to_s(16)

        dev.device_info = VimSdk::Vim::Description.new
        dev.device_info.label = 'CPI:GPU'
        dev.device_info.summary = 'This GPU Passthrough has been attached by BOSH vSphereCPI'
        dev.backing=back
        device_config_spec.device=dev
        device_config_spec.operation = VimSdk::Vim::Vm::Device::VirtualDeviceSpec::Operation::ADD
        config_spec.device_change << device_config_spec

        num_gpus = num_gpus - 1
        break if num_gpus == 0
      end
      config_spec.memory_reservation_locked_to_max = true
    end

    private

    def should_create_auto_drs_rule(vm_config)
      return @enable_auto_anti_affinity_drs_rules && vm_config.drs_rule.nil? && !vm_config.bosh_group.nil?
    end

    def create_drs_rules(vm_config, vm_mob, cluster)
      if should_create_auto_drs_rule(vm_config) then
        drs_rule_name = vm_config.bosh_group
      elsif !vm_config.drs_rule.nil? then
        drs_rule_name = vm_config.drs_rule['name']
      else
        return
      end

      drs_rule = VSphereCloud::DrsRule.new(
        drs_rule_name,
        @client,
        @cloud_searcher,
        cluster.mob
      )
      drs_rule.add_vm(vm_mob)
    end
  end
end
