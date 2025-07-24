require 'cloud/vsphere/logger'
require 'cloud/vsphere/cpi_extension'
require 'cloud/vsphere/attach_tag_to_vm'

module VSphereCloud
  class VmCreator
    include Logger

    def initialize(agent_env_client:,
                   additional_agent_env:,
                   client:,
                   cloud_searcher:,
                   cpi:,
                   datacenter:,
                   default_disk_type:,
                   enable_auto_anti_affinity_drs_rules:,
                   ensure_no_ip_conflicts:,
                   ip_conflict_detector:,
                   pbm:,
                   stemcell:,
                   tagging_tagger:,
                   upgrade_hw_version:,
                   default_hw_version:)
      @agent_env_client = agent_env_client
      @additional_agent_env = additional_agent_env
      @client = client
      @cloud_searcher = cloud_searcher
      @cpi = cpi
      @datacenter = datacenter
      @default_disk_type = default_disk_type
      @enable_auto_anti_affinity_drs_rules = enable_auto_anti_affinity_drs_rules
      @ensure_no_ip_conflicts = ensure_no_ip_conflicts
      @ip_conflict_detector = ip_conflict_detector
      @pbm = pbm
      @stemcell = stemcell
      @tagging_tagger = tagging_tagger
      @upgrade_hw_version = upgrade_hw_version
      @default_hw_version = default_hw_version
    end

    def create(vm_config)
      vm_config.cluster_placements.each do |cluster_placement|
        # Get the  cluster from the placement
        cluster = cluster_placement.cluster
        # Validates if the rule specified is of right syntax
        vm_config.validate_drs_rules(cluster)
        vm_config.calculate_cpu_reservation(cluster)

        # @TA: TODO Choose host here if needed.
        ordered_ephemeral_ds_options = [cluster_placement.disk_placement]

        ordered_ephemeral_ds_options.each_with_index do |target_ds, index|
          logger.debug("Retrying to create vm on #{target_ds.name}") if index != 0

          storage = StoragePicker.choose_ephemeral_storage(
            target_ds.name,
            cluster.accessible_datastores
          )
          datastore, datastore_cluster = storage.is_a?(Resources::StoragePod) ? [nil, storage] : [storage, nil]

          if @ensure_no_ip_conflicts
            @ip_conflict_detector.ensure_no_conflicts(vm_config.vsphere_networks)
          end

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

          paravirtual_scsi_controller_spec = replicated_stemcell_vm.create_paravirtual_scsi_controller_spec
          raise 'Failed to create device change to paravirtual controller' if paravirtual_scsi_controller_spec.nil?
          scsi_controller_device_change_spec = Resources::VM.create_edit_device_spec(paravirtual_scsi_controller_spec)
          config_spec.device_change << scsi_controller_device_change_spec

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
          # Don't link clone if expanding root disk, otherwise "Invalid operation for device '0'. Disks with parents cannot be expanded."
          linked = vm_config.root_disk_size_gb > 0 ? false : true
          created_vm_mob = @client.wait_for_task do
            @cpi.clone_vm(
              replicated_stemcell_vm.mob,
              vm_config.name,
              @datacenter.vm_folder.mob,
              cluster.resource_pool.mob,
              datastore: datastore.mob,
              host:,
              linked: linked,
              snapshot: snapshot.current_snapshot,
              config: config_spec,
              datastore_cluster:
            )
          end
          next if created_vm_mob.nil?

          created_vm = Resources::VM.new(vm_config.name, created_vm_mob, @client)
          # Set agent env settings
          begin
            network_env = generate_network_env(
              created_vm.devices,
              vm_config.networks_spec,
              dvs_index
            )
            disk_env = generate_disk_env(
              created_vm.system_disk,
              created_vm.ephemeral_disk,
              vm_config.disk_uuid_is_enabled?
            )
            env = generate_agent_env(
              vm_config.name,
              created_vm.mob,
              vm_config.agent_id,
              @additional_agent_env,
              network_env,
              disk_env
            )
            env['env'] = vm_config.agent_env
            location = {
              datacenter: @datacenter.name,
              datastore:,
              vm: vm_config.name
            }

            @agent_env_client.set_env(created_vm.mob, location, env)

            begin
              # Upgrade to latest virtual hardware version
              # We decide to upgrade hardware version on basis of four params
              # 1. vm_type specification of upgrade hardware flag and
              # 2. Global upgrade hardware flag @upgrade_hw_version
              # 3. vm_config of vgpus has entries (>1 vgpu requires upgraded hw)
              # 4. vm_config of pci_passthroughs has entries
              if vm_config.upgrade_hw_version?(vm_config.vm_type.upgrade_hw_version, @upgrade_hw_version)
                created_vm.upgrade_vm_virtual_hardware
              elsif !vm_config.vgpus.empty?
                created_vm.upgrade_vm_virtual_hardware
              elsif !vm_config.pci_passthroughs.empty?
                created_vm.upgrade_vm_virtual_hardware
              else
                created_vm.upgrade_vm_virtual_hardware(@default_hw_version)
              end
            rescue VSphereCloud::VCenterClient::AlreadyUpgraded
              logger.debug('VM already upgraded')
            end
            # Add vGPU devices after hardware version has been upgraded
            # Jammy stemcell at hardware version 13 only allows 1 vGPU; we want to be able to add more
            unless vm_config.vgpus.empty?
              config_spec = VimSdk::Vim::Vm::ConfigSpec.new
              vm_config.vgpus.each do |vgpu|
                vgpu = Resources::PCIPassthrough.create_vgpu(vgpu)
                vgpu_config = Resources::VM.create_add_device_spec(vgpu)
                config_spec.device_change << vgpu_config
              end
              @client.reconfig_vm(created_vm_mob, config_spec)
            end
            unless vm_config.pci_passthroughs.empty?
              vm_config.pci_passthroughs.each do |pci_passthrough|
                virtual_pci_passthrough = Resources::PCIPassthrough.create_pci_passthrough(
                  vendor_id: pci_passthrough['vendor_id'],
                  device_id: pci_passthrough['device_id'],
                )
                config_spec = VimSdk::Vim::Vm::ConfigSpec.new
                config_spec.device_change << Resources::VM.create_add_device_spec(virtual_pci_passthrough)
                # add 1 GPU per task, allow multiple GPUs with same deviceId to be added
                @client.reconfig_vm(created_vm_mob, config_spec)
              end
            end

            if vm_config.root_disk_size_gb > 0
              device_spec = Resources::VM.create_edit_device_spec(created_vm.system_disk)
              device_spec.device.capacity_in_kb = vm_config.root_disk_size_gb * 2 ** 20 # GiB → kiB
              config_spec = VimSdk::Vim::Vm::ConfigSpec.new
              config_spec.device_change << device_spec
              @client.reconfig_vm(created_vm_mob, config_spec)
            end

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
          return created_vm # we have successfully created & powered-on a VM
        end
      end
    end

    def generate_network_env(devices, networks, dvs_index)
      nics = {}

      devices.each do |device|
        next unless device.kind_of?(VimSdk::Vim::Vm::Device::VirtualEthernetCard)
        v_network_name = case device.backing
         when VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo
           # If we see DistributedVirtualPortBackingInfo for the device, we're dealing with a cVDS (managed in vsphere):

           # https://kb.vmware.com/s/article/79872#The_reasons_for_running_NSX-T_on_VDS
           #
           # With NSX-T 3.0, it is now possible to run NSX-T directly on a VDS (the VDS version must be at least 7.0).
           # On ESXi platform, the N-VDS was already sharing its code base with the VDS in the first place, so this
           # is not really a change of NSX virtual switch but rather a change of how it is represented in vCenter

           # In case this is a NSX-T >= 3 backed VDS, we want to filter the networks we fetch from vsphere because
           # NSX-T may not be used exclusively by vCenter and may have created DVPGs from external sources (e.g via NCP
           # in kubernetes)
           # This can lead to a situation where we potentially find thousands of NSX Logical Switches represented as
           # vsphere DVPGs because they're accessible from the DVS so we need to rely on filtering.

           # Find portgroup that match the portgroup key specified in the device
           filtered_dvpg = @cloud_searcher.find_resources_by_property_path(@datacenter.mob, 'DistributedVirtualPortgroup', 'key') do |portgroup_key|
             portgroup_key == device.backing.port.portgroup_key
           end

           # Check if portgroup is backed by NSX-T
           dvpg = filtered_dvpg.detect do |n|
             n.config.respond_to?(:backing_type) &&
               n.config.backing_type == 'nsx'
           end

           if dvpg.nil?
             # If we couldn't find an NSX backed DVPG, we're looking at a standard DVPG.
             dvs_index[device.backing.port.portgroup_key]
           else
             # If it is backed by NSX-T we want the logical_switch_uuid. This matches the opaque_network_id on an N-VDS
             dvs_index[dvpg.config.logical_switch_uuid]
           end
         when VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo
           # If we see OpaqueNetworkBackingInfo for the device, we're dealing with is a NVDS (managed in nsx):
           # https://kb.vmware.com/s/article/79872#NSX-T_with_N-VDS
           #
           # Another reason for decoupling from vSphere was to allow NSX-T to have its own release cycle,
           # so that features and bug fixes would be independent of vSphere’s timeline.
           # To achieve that feat, the NSX-T virtual switch, the N-VDS, is leveraging an already existing
           # software infrastructure that was designed to allow vSphere to consume networking through a
           # set of API calls to third party virtual switches. As a result, NSX-T segments are represented
           # as “opaque networks”, a name clearly showing that those objects are completely independent
           # and unmanageable from vSphere
           dvs_index[device.backing.opaque_network_id]
         else
           PathFinder.new.path(device.backing.network)
         end
        nics[v_network_name] = (nics.fetch(v_network_name, []) << device)
      end

      network_env = {}
      networks.each do |network_name, network|
        network_entry = network.dup
        v_network_name = network['cloud_properties']['name']
        network = nics[v_network_name]
        raise Cloud::NetworkException, "Could not find network '#{v_network_name}'" if network.nil?
        nic = network.pop
        network_entry['mac'] = nic.mac_address
        network_env[network_name] = network_entry
      end
      network_env
    end

    def generate_disk_env(system_disk, ephemeral_disk, disk_uuid_is_enabled)
      # When disk.enableUUID is true on the vmx options, consistent volume IDs are requested, and we can use them
      # to ensure the precise ephemeral volume is mounted. This is mandatory for cases where multiple SCSI controllers
      # are present on the VM, as is common with Kubernetes VMs.
      #
      # Note: This value is set inconsistently throughout the code base; see `vm.disk_uuid_is_enabled?` for details.
      if disk_uuid_is_enabled
        logger.info("Using ephemeral disk UUID #{ephemeral_disk.backing.uuid.downcase}")
        {
          'system' => system_disk.unit_number.to_s,
          'ephemeral' => { 'id' => ephemeral_disk.backing.uuid.downcase },
          'persistent' => {}
        }
      else
        logger.info("Using ephemeral disk unit number #{ephemeral_disk.unit_number.to_s}")
        {
          'system' => system_disk.unit_number.to_s,
          'ephemeral' => ephemeral_disk.unit_number.to_s,
          'persistent' => {}
        }
      end
    end

    def generate_agent_env(name, vm, agent_id, additional_agent_env, networking_env, disk_env)
      vm_env = {
        'name' => name,
        'id' => vm.__mo_id__
      }

      env = {}
      env['vm'] = vm_env
      env['agent_id'] = agent_id
      env['networks'] = networking_env
      env['disks'] = disk_env
      env.merge!(additional_agent_env)
      env
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
