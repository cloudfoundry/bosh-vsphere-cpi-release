module VSphereCloud
  class VmCreator
    def initialize(client:, cloud_searcher:, logger:, cpi:, datacenter:, agent_env:, ip_conflict_detector:, default_disk_type:, enable_auto_anti_affinity_drs_rules:)
      @client = client
      @cloud_searcher = cloud_searcher
      @logger = logger
      @cpi = cpi
      @datacenter = datacenter
      @agent_env = agent_env
      @ip_conflict_detector = ip_conflict_detector
      @default_disk_type = default_disk_type
      @enable_auto_anti_affinity_drs_rules = enable_auto_anti_affinity_drs_rules
    end

    def create(vm_config)
      cluster = vm_config.cluster
      storage = choose_storage(vm_config)

      datastore, datastore_cluster = storage.is_a?(Resources::StoragePod) ? [nil, storage] : [storage, nil]

      @ip_conflict_detector.ensure_no_conflicts(vm_config.vsphere_networks)

      @logger.info("Creating vm: #{vm_config.name} on #{cluster.mob} stored in #{datastore.mob}") if datastore
      @logger.info("Creating vm: #{vm_config.name} on #{cluster.mob} stored in Datastore Cluster: #{datastore_cluster.name}") if datastore_cluster

      # Replicate stemcell stage
      replicated_stemcell_vm_mob = @cpi.replicate_stemcell(cluster, datastore, vm_config.stemcell_cid, datastore_cluster)
      replicated_stemcell_properties = @cloud_searcher.get_properties(
        replicated_stemcell_vm_mob,
        VimSdk::Vim::VirtualMachine,
        ['snapshot', 'datastore'],
        ensure_all: true
      )
      #create vm/ephemeral disk on same datastore as stemcell if Datastore Cluster is being used.
      if datastore_cluster
        datastore = Resources::Datastore.build_from_client(@client, replicated_stemcell_properties['datastore']).first
      end
      replicated_stemcell_vm = Resources::VM.new(vm_config.stemcell_cid, replicated_stemcell_vm_mob, @client, @logger)
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

      # Clone VM
      @logger.info("Cloning vm: #{replicated_stemcell_vm} to #{vm_config.name}")
      created_vm_mob = @client.wait_for_task do
        @cpi.clone_vm(replicated_stemcell_vm.mob,
          vm_config.name,
          @datacenter.vm_folder.mob,
          cluster.resource_pool.mob,
          datastore: datastore.mob,
          linked: true,
          snapshot: snapshot.current_snapshot,
          config: config_spec,
          datastore_cluster: datastore_cluster
        )
      end
      created_vm = Resources::VM.new(vm_config.name, created_vm_mob, @client, @logger)

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

        # Power on VM
        @logger.info("Powering on VM: #{created_vm}")
        created_vm.power_on
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

      created_vm
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
        cluster.mob,
        @logger
      )
      drs_rule.add_vm(vm_mob)
    end

    # choose storage from set of datastore and sdrs enabled datastore clusters
    # using weight based algorithm on free space to choose the storage
    # if datastore clusters are provided and none of them have sdrs enabled log an error
    def choose_storage(vm_config)
      storage_options = [ vm_config.cluster.accessible_datastores[vm_config.ephemeral_datastore_name]]
      if vm_config.datastore_clusters.any?
        sdrs_enabled_datastore_clusters = vm_config.sdrs_enabled_datastore_clusters
        @logger.info("None of the datastore clusters have sdrs enabled") unless sdrs_enabled_datastore_clusters.any?
        storage_options << vm_config.sdrs_enabled_datastore_clusters
      end
      weighted_random_sort(storage_options.flatten).first
    end

    def weighted_random_sort(storage_options)
      random_hash = {}
      storage_options.each do |storage_option|
        random_hash[storage_option.mob.__mo_id__] = Random.rand * storage_option.free_space
      end
      storage_options.sort do |x,y|
        random_hash[y.mob.__mo_id__] <=> random_hash[x.mob.__mo_id__]
      end
    end
  end
end
