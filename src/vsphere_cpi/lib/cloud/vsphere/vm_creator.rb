require 'cloud/vsphere/logger'
require 'cloud/vsphere/cpi_extension'
require 'cloud/vsphere/attach_tag_to_vm'

module VSphereCloud
  class VmCreator
    include Logger

    def initialize(client:, cloud_searcher:, cpi:, datacenter:, agent_env:, tagging_tagger:, default_disk_type:,
                   enable_auto_anti_affinity_drs_rules:, stemcell:, upgrade_hw_version:, pbm:)
      @client = client
      @cloud_searcher = cloud_searcher
      @cpi = cpi
      @datacenter = datacenter
      @agent_env = agent_env
      @tagging_tagger = tagging_tagger
      @default_disk_type = default_disk_type
      @enable_auto_anti_affinity_drs_rules = enable_auto_anti_affinity_drs_rules
      @stemcell = stemcell
      @upgrade_hw_version = upgrade_hw_version
      @pbm = pbm
    end

    def create(vm_config)
      created_vm = nil
      vm_config.cluster_placements.each do |cluster_placement|
        # Get the  cluster from the placement
        cluster = cluster_placement.cluster
        # Validates if the rule specified is of right syntax
        vm_config.validate_drs_rules(cluster)

        # @TA: TODO Choose host here if needed.
        ordered_ephemeral_ds_options = [cluster_placement.disk_placement]

        ordered_ephemeral_ds_options.each_with_index do |target_ds, index|
          logger.debug("Retrying to create vm on #{target_ds.name}") if index != 0

          storage = StoragePicker.choose_ephemeral_storage(
            target_ds.name,
            cluster.accessible_datastores
          )
          datastore, datastore_cluster = storage.is_a?(Resources::StoragePod) ? [nil, storage] : [storage, nil]

          logger.info("Creating vm: #{vm_config.name} on #{cluster} stored in #{datastore}") if datastore
          logger.info("Creating vm: #{vm_config.name} on #{cluster} stored in datastore cluster: #{datastore_cluster.name}") if datastore_cluster

          # Replicate stemcell stage
          replicated_stemcell_vm_mob = @stemcell.replicate(@datacenter, cluster, datastore, datastore_cluster)
          replicated_stemcell_properties = @cloud_searcher.get_properties(
            replicated_stemcell_vm_mob,
            VimSdk::Vim::VirtualMachine,
            %w[snapshot datastore],
            ensure_all: true
          )
          # create vm/ephemeral disk on same datastore as stemcell if datastore cluster is being used.
          if datastore_cluster
            datastore = Resources::Datastore.build_from_client(
              @client,
              replicated_stemcell_properties['datastore']
            ).first
          end
          replicated_stemcell_vm = Resources::VM.new(vm_config.stemcell_cid, replicated_stemcell_vm_mob, @client)

          snapshot = replicated_stemcell_properties['snapshot']

          # Create device_change config
          config_spec = VimSdk::Vim::Vm::ConfigSpec.new(vm_config.config_spec_params)
          config_spec.device_change = []

          ephemeral_disk = Resources::EphemeralDisk.new(
            size_in_mb: vm_config.ephemeral_disk_size,
            datastore:,
            folder: vm_config.name,
            disk_type: @default_disk_type
          )

          ephemeral_disk_config = ephemeral_disk.create_disk_attachment_spec(
            disk_controller_id: replicated_stemcell_vm.system_disk.controller_key
          )

          # # Encrypt ephemeral disk of the VM if encryption_policy is defined
          # if @vm_encryption_policy_name
          #   policy = @pbm.find_policy(@vm_encryption_policy_name)
          #   ephemeral_disk_config.profile = Resources::VM.create_profile_spec(policy)
          # end

          config_spec.device_change << ephemeral_disk_config

          # add extension managed by info to config spec only if extension exists
          if @client.service_content.extension_manager.find_extension(
            VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY
          )
            managed_by_info = VimSdk::Vim::Ext::ManagedByInfo.new
            managed_by_info.extension_key = VCPIExtension::DEFAULT_VSPHERE_CPI_EXTENSION_KEY
            managed_by_info.type = VCPIExtension::DEFAULT_VSPHERE_MANAGED_BY_INFO_RESOURCE
            config_spec.managed_by = managed_by_info
          end

          dvs_index = {}
          vm_config.vsphere_networks.each do |network_name, ips|
            network = @client.find_network_retryably(@datacenter, network_name)
            ips.each do |_|
              virtual_nic = Resources::Nic.create_virtual_nic(
                @cloud_searcher,
                network_name,
                network,
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

          # Re-assign new keys to devices being added.
          # from vc api docs:
          #   When adding new devices, it may be necessary for a client to assign keys temporarily
          #   in order to associate controllers with devices in configuring a virtual machine.
          #   However, the server does not allow a client to reassign a device key,
          #   and the server may assign a different value from the one passed during configuration.
          #   Clients should ensure that existing device keys are not reused as temporary key values
          #   for the new device to be added (for example, by using unique negative integers as temporary keys).
          replicated_stemcell_vm.fix_device_key(config_spec.device_change)

          raise "Unable to parse vmx options: 'vmx_options' is not a Hash" unless vm_config.vmx_options.is_a?(Hash)

          config_spec.extra_config = vm_config.vmx_options.keys.map do |key|
            VimSdk::Vim::Option::OptionValue.new(key:, value: vm_config.vmx_options[key])
          end

          host = nil
          # Before cloning we need to make sure the host is correctly picked up
          # from cluster's host group if provided.
          if !cluster.host_group.nil? && cluster.host_group_drs_rule.strip.casecmp?('MUST') == true
            # placement_spec = VimSdk::Vim::Cluster::PlacementSpec.new
            # placement_spec.config_spec = config_spec
            # placement_spec.datastores = [datastore.mob]
            # placement_spec.hosts = cluster.host_group_mob.host
            # placement_result = cluster.mob.place_vm(placement_spec)
            # raise "No suitable host found by DRS in host group to create VM" if placement_result.recommendations&.empty?
            # begin
            #   host = placement_result.recommendations.first.action.first.target_host
            # # if for some reason, above fails select host manually.
            # rescue => e
            #   logger.warning("Received #{e} while asking DRS for recommendation")
            #   host = cluster.host_group_mob.host.find do |host|
            #     host.runtime.connection_state == 'connected' &&
            #       !host.runtime.in_maintenance_mode
            #   end
            # end
            # @TA:TODO : Stop-Gap measure until DRS team solves bug for placeVM below.
            # Selecting a random host out of all host groups to get initial placement correct
            # Filtering it for healthy host.
            host = cluster.host_group_mob.host.find do |host|
              host.runtime.connection_state == 'connected' &&
                !host.runtime.in_maintenance_mode
            end
            raise "Failed to find a healthy host in #{cluster.host_group} to create the VM." if host.nil?
          end

          # Clone VM
          logger.info("Cloning vm: #{replicated_stemcell_vm} to #{vm_config.name}")
          created_vm_mob = @client.wait_for_task do
            @cpi.clone_vm(
              replicated_stemcell_vm.mob,
              vm_config.name,
              @datacenter.vm_folder.mob,
              cluster.resource_pool.mob,
              datastore: datastore.mob,
              host:,
              linked: true,
              snapshot: snapshot.current_snapshot,
              config: config_spec,
              datastore_cluster:
            )
          end
          next if created_vm_mob.nil?

          created_vm = Resources::VM.new(vm_config.name, created_vm_mob, @client)
          # Set agent env settings
          begin
            network_env = @cpi.generate_network_env(
              created_vm.devices,
              vm_config.networks_spec,
              dvs_index
            )
            disk_env = @cpi.generate_disk_env(
              created_vm.system_disk,
              created_vm.ephemeral_disk,
              vm_config
            )
            env = @cpi.generate_agent_env(
              vm_config.name,
              created_vm.mob,
              vm_config.agent_id,
              network_env,
              disk_env
            )
            env['env'] = vm_config.agent_env
            location = {
              datacenter: @datacenter.name,
              datastore:,
              vm: vm_config.name
            }

            @agent_env.set_env(created_vm.mob, location, env)

            # DRS Rules
            create_drs_rules(vm_config, created_vm.mob, cluster)

            # Add vm to VM Group present in vm_type
            add_vm_to_vm_group(vm_config.vm_type.vm_group, created_vm_mob, cluster)
            unless cluster.host_group.nil?
              # Add vm to VMGroup listed in the cluster description
              add_vm_to_vm_group(cluster.vm_group, created_vm.mob, cluster)
              # Create VM/Host affinity rule
              create_vm_host_affinity_rule(created_vm.mob, cluster)
            end
            # Apply storage policy
            apply_storage_policy(vm_config, created_vm)
            begin
              # Upgrade to latest virtual hardware version
              # We decide to upgrade hardware version on basis of two params
              # 1. vm_type specification of upgrade hardware flag and
              # 2. Global upgrade hardware flag @upgrade_hw_version
              if vm_config.upgrade_hw_version?(vm_config.vm_type.upgrade_hw_version, @upgrade_hw_version)
                created_vm.upgrade_vm_virtual_hardware
              end
            rescue VSphereCloud::VCenterClient::AlreadyUpgraded
              logger.debug('VM already upgraded')
            end
            # Attach Tags to VM
            if vm_config.vm_type.tags && !vm_config.vm_type.tags.empty?
              logger.info("Tags found in config file. Attaching tags to vm '#{vm_config.name}'.")
              begin
                @tagging_tagger.attach_tags(created_vm.mob_id, vm_config.vm_type.tags, vm_config.name)
              rescue => e
                logger.warn("Attaching tags failed with message: #{e}. Continuing without attaching Tags to the VM.")
              end
            end

            begin
              # Power on VM
              logger.info("Powering on VM: #{created_vm}")
              created_vm.power_on
            rescue VSphereCloud::VMPowerOnError, VSphereCloud::VCenterClient::GenericVmConfigFault, VSphereCloud::VCenterClient::TaskException => e
              if e.instance_of?(VSphereCloud::VCenterClient::GenericVmConfigFault) && !cluster_placement.fallback_disk_placements.empty?
                logger.debug('VM start failed with datastore issues, retrying on next ds')
                ordered_ephemeral_ds_options.push(*cluster_placement.fallback_disk_placements) if index.zero?
              end

              begin
                @cpi.delete_vm(created_vm.cid) if created_vm
              rescue => ex
                logger.info("Failed to delete vm '#{vm_config.name}' with message: #{ex.inspect}")
              end
              raise e if cluster_placement.equal?(vm_config.cluster_placements.last) && index == ordered_ephemeral_ds_options.length - 1
              next
            end
            # Pin this VM to the host by disabling DRS actions for the VM
            # if pin vm is enabled in cloud configuration for the VM.
            disable_drs(created_vm, cluster) if vm_config.vm_type.disable_drs
          rescue => e
            e.vm_cid = vm_config.name if e.instance_of?(Cloud::NetworkException)
            logger.info("#{e} - #{e.backtrace.join("\n")}")
            begin
              @cpi.delete_vm(created_vm.cid) if created_vm
            rescue => ex
              logger.info("Failed to delete vm '#{vm_config.name}' with message: #{ex.inspect}")
            end
            raise e
          end
          break
        end
      end
      created_vm
    end

    private

    def disable_drs(vm_resource, cluster_resource)
      DrsLock.new('DISABLE_DRS_LOCK').with_drs_lock do
        drs_vm_spec = VimSdk::Vim::Cluster::DrsVmConfigSpec.new
        drs_vm_spec.info = VimSdk::Vim::Cluster::DrsVmConfigInfo.new
        drs_vm_spec.info.enabled = false
        drs_vm_spec.info.key = vm_resource.mob

        drs_vm_spec.operation = VimSdk::Vim::Option::ArrayUpdateSpec::Operation::ADD

        config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
        config_spec.drs_vm_config_spec = [drs_vm_spec]

        logger.debug("Pinning the VM: #{vm_resource.cid}")
        @client.wait_for_task do
          cluster_resource.mob.reconfigure_ex(config_spec, true)
        end
      end
      logger.debug("VM is pinned")
    end

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

    def add_vm_to_vm_group(vm_group, vm_mob, cluster)
      return if vm_group.nil?
      vm_group_creator = VSphereCloud::VmGroup.new(
        @client,
        cluster.mob
      )
      vm_group_creator.add_vm_to_vm_group(vm_mob, vm_group)
    end

    def create_vm_host_affinity_rule(vm_mob, cluster)
      return if cluster.host_group.nil?
      vm_host_affinity_rule_name = cluster.vm_host_affinity_rule_name
      drs_rule = VSphereCloud::DrsRule.new(
        vm_host_affinity_rule_name,
        @client,
        cluster.mob
      )
      drs_rule.add_vm_host_affinity_rule(cluster.vm_group, cluster.host_group, cluster.host_group_rule_type)
    end

    def apply_storage_policy(vm_config, vm)
      return if vm_config.storage_policy_name.nil?
      policy = @pbm.find_policy(vm_config.storage_policy_name)
      logger.info("Applying storage policy #{vm_config.storage_policy_name} to the vm: #{vm.cid}")
      vm.apply_storage_policy(policy)
    end
  end
end
