module VSphereCloud
  class VmCreator
    def initialize(client:, cloud_searcher:, logger:, cpi:, datacenter:, agent_env:, ip_conflict_detector:)
      @client = client
      @cloud_searcher = cloud_searcher
      @logger = logger
      @cpi = cpi
      @datacenter = datacenter
      @agent_env = agent_env
      @ip_conflict_detector = ip_conflict_detector
    end

    def create(vm_config)
      # TODO: Remove this once we handle placement resources better
      if vm_config.is_top_level_cluster
        cluster_config = ClusterConfig.new(vm_config.cluster_name, vm_config.cluster_spec)
        cluster = Resources::ClusterProvider.new(@datacenter, @client, @logger).find(vm_config.cluster_name, cluster_config)
      else
        cluster = @datacenter.find_cluster(vm_config.cluster_name)
      end
      datastore = @datacenter.find_datastore(vm_config.datastore_name)

      @ip_conflict_detector.ensure_no_conflicts(vm_config.vsphere_networks)

      @logger.info("Creating vm: #{vm_config.name} on #{cluster.mob} stored in #{datastore.mob}")

      # Replicate stemcell stage
      replicated_stemcell_vm_mob = @cpi.replicate_stemcell(cluster, datastore, vm_config.stemcell_cid)
      replicated_stemcell_properties = @cloud_searcher.get_properties(
        replicated_stemcell_vm_mob,
        VimSdk::Vim::VirtualMachine,
        ['snapshot'],
        ensure_all: true
      )
      replicated_stemcell_vm = Resources::VM.new(vm_config.stemcell_cid, replicated_stemcell_vm_mob, @client, @logger)
      snapshot = replicated_stemcell_properties['snapshot']

      # Create device_change config
      config_spec = VimSdk::Vim::Vm::ConfigSpec.new(vm_config.config_spec_params)
      config_spec.device_change = []

      ephemeral_disk = Resources::EphemeralDisk.new(
        Resources::EphemeralDisk::DISK_NAME,
        vm_config.ephemeral_disk_size,
        datastore,
        vm_config.name
      )

      ephemeral_disk_config = ephemeral_disk.create_disk_attachment_spec(replicated_stemcell_vm.system_disk.controller_key)
      config_spec.device_change << ephemeral_disk_config

      dvs_index = {}
      vm_config.vsphere_networks.each do |network_name, ips|
        ips.each do |_|
          network_mob = @client.find_by_inventory_path([@datacenter.name, 'network', network_name])
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

      @logger.info("Cloning vm: #{replicated_stemcell_vm} to #{vm_config.name}")

      # Clone VM
      task = @cpi.clone_vm(replicated_stemcell_vm.mob,
        vm_config.name,
        @datacenter.vm_folder.mob,
        cluster.resource_pool.mob,
        datastore: datastore.mob,
        linked: true,
        snapshot: snapshot.current_snapshot,
        config: config_spec
      )
      created_vm_mob = @client.wait_for_task(task)
      created_vm = Resources::VM.new(vm_config.name, created_vm_mob, @client, @logger)

      # Set agent env settings
      begin
        network_env = @cpi.generate_network_env(created_vm.devices, vm_config.networks_spec, dvs_index)
        disk_env = @cpi.generate_disk_env(created_vm.system_disk, ephemeral_disk_config.device)
        env = @cpi.generate_agent_env(vm_config.name, created_vm.mob, vm_config.agent_id, network_env, disk_env)
        env['env'] = vm_config.agent_env
        @logger.info("Setting VM env: #{env.pretty_inspect}")

        location = @cpi.get_vm_location(
          created_vm.mob,
          datacenter: @datacenter.name,
          datastore: datastore.name,
          vm: vm_config.name
        )

        @agent_env.set_env(created_vm.mob, location, env)

        # Power on VM
        @logger.info("Powering on VM: #{created_vm}")
        created_vm.power_on

        # DRS Rules
        create_drs_rules(vm_config, created_vm.mob, cluster)
      rescue => e
        e.vm_cid = vm_config.name if e.instance_of?(Cloud::NetworkException)
        @logger.info("#{e} - #{e.backtrace.join("\n")}")
        begin
          created_vm.delete if created_vm
        rescue => ex
          @logger.info("Failed to delete vm '#{vm_config.name}' with message:  #{ex.inspect}")
        end
        raise e
      end

      vm_config.name
    end

    private

    def create_drs_rules(vm_config, vm_mob, cluster)
      return if vm_config.drs_rule.nil?

      drs_rule = VSphereCloud::DrsRule.new(
        vm_config.drs_rule['name'],
        @client,
        @cloud_searcher,
        cluster.mob,
        @logger
      )
      drs_rule.add_vm(vm_mob)
    end
  end
end
