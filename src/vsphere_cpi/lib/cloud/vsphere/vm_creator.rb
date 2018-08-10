require 'cloud/vsphere/logger'
require 'cloud/vsphere/cpi_extension'

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
      created_vm = nil
      vm_config.cluster_placements.each do |cluster_placement|
        # Get the  cluster from the placement
        cluster = cluster_placement.cluster
        # Validates if the rule specified is of right syntax
        vm_config.validate_drs_rules(cluster)

        #@TA: TODO Choose host here if needed.

        storage = StoragePicker.choose_ephemeral_storage(cluster_placement.disk_placement.name,
          cluster.accessible_datastores, vm_config.vm_type)

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

        # add extension managed by info to config spec only if extension exists
        if @client.service_content.extension_manager.find_extension(
          VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY) then
          managed_by_info = VimSdk::Vim::Ext::ManagedByInfo.new
          managed_by_info.extension_key = VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY
          managed_by_info.type =  VCPIExtension::DEFAULT_VSPHERE_MANAGED_BY_INFO_RESOURCE
          config_spec.managed_by = managed_by_info
        end


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
        logger.info("Cloning vm: #{replicated_stemcell_vm} to #{vm_config.name}")
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
        next if created_vm_mob.nil?

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

          # Add vm to VMGroup
          add_vm_to_vm_group(vm_config, created_vm.mob, cluster)

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

        break
      end

      created_vm
    end

    private

    def should_create_auto_drs_rule(vm_config, cluster)
      return @enable_auto_anti_affinity_drs_rules && vm_config.drs_rule(cluster).nil? && !vm_config.bosh_group.nil?
    end

    def create_drs_rules(vm_config, vm_mob, cluster)
      if should_create_auto_drs_rule(vm_config, cluster) then
        drs_rule_name = vm_config.bosh_group
      elsif !vm_config.drs_rule(cluster).nil? then
        drs_rule_res = vm_config.drs_rule(cluster)
        drs_rule_name = drs_rule_res['name']
      else
        return
      end

      drs_rule = VSphereCloud::DrsRule.new(
        drs_rule_name,
        @client,
        cluster.mob
      )
      drs_rule.add_vm(vm_mob)
    end

    # using DrsRule here as this will eventually be used to create vm/host group rule
    # for initial release we are only adding support for vm_group
    def add_vm_to_vm_group(vm_config, vm_mob, cluster)
      return if vm_config.vm_type.vm_group.nil?
      drs_rule_name = DrsRule::DEFAULT_RULE_NAME #Passing it on purpose as this would be temporary
      drs_rule = VSphereCloud::DrsRule.new(
        drs_rule_name,
        @client,
        cluster.mob
      )
      drs_rule.add_vm_to_vm_group(vm_mob, vm_config.vm_type.vm_group)
    end
  end
end
