require 'cloud/vsphere/logger'
require 'digest'

module VSphereCloud
  class VirtualMachineNotFound < StandardError
    def initialize(vm_id)
      @vm_id = vm_id
    end

    def to_s
      "VM #{@vm_id} was expected in NSX-T but was not found"
    end
  end

  class VirtualMachineIpNotFound < StandardError
    def initialize(vm_id)
      @vm_id = vm_id
    end

    def to_s
      "Did not find primary IP for VM #{@vm_id}"
    end
  end

  class MultipleVirtualMachinesFound < StandardError
    def initialize(vm_id, count)
      @vm_id = vm_id
      @count = count
    end

    def to_s
      "Multiple NSX-T virtual machines (#{@vm_id}) found. (#{@count})"
    end
  end

  class VIFNotFound < StandardError
    def initialize(vm_id=nil, external_id=nil, vif_id=nil)
      @vm_id = vm_id
      @external_id = external_id
      @vif_id = vif_id
    end

    def to_s
      if @vm_id
        return "VIF for VM #{@vm_id} with 'external_id' #{@external_id} was expected in NSX-T but was not found"
      else
        return "VIF for lport attachment id #{@vif_id} was expected in NSX-T but was not found"

      end
    end
  end

  class LogicalPortNotFound < StandardError
    def initialize(vm_id=nil, external_id=nil, vif_id=nil)
      @vm_id = vm_id
      @external_id = external_id
      @vif_id = vif_id
    end

    def to_s
      if @vm_id
        return "Logical port for VM #{@vm_id} with 'external_id' #{@external_id} was expected in NSX-T but was not found"
      else
        return "Logical port with lport_attachment_id #{@vif_id} was expected in NSX-T but was not found"
      end

    end
  end

  class NSGroupsNotFound < StandardError
    def initialize(*display_names)
      @display_names = display_names
    end

    def to_s
      "NSGroups [#{@display_names.join(', ')}] were not found in NSX-T"
    end
  end

  class ServerPoolsNotFound < StandardError
    def initialize(*display_names)
      @display_names = display_names
    end

    def to_s
      "ServerPools [#{@display_names.join(', ')}] were not found in NSX-T"
    end
  end

  class InvalidLogicalPortError < StandardError
    def initialize(logical_port)
      @logical_port = logical_port
    end

    def to_s
      "Logical port #{@logical_port.id} has multiple values for tag with scope 'bosh/id'"
    end
  end

  class NSXTOptimisticUpdateError < StandardError
  end

  class NSXTProvider
    include Logger
    extend Hooks

    def initialize(client_builder , default_vif_type, vcenter_client, datacenter)
      @client_builder = client_builder
      @max_tries = MAX_TRIES
      @sleep_time = DEFAULT_SLEEP_TIME
      @default_vif_type = default_vif_type
      @vcenter_client = vcenter_client
      @datacenter = datacenter
    end

    private def grouping_obj_svc
      @grouping_obj_svc ||= NSXT::ManagementPlaneApiGroupingObjectsNsGroupsApi.new(@client_builder.get_client)
    end

    private def logical_switching_svc
      @logical_switching_svc ||= NSXT::ManagementPlaneApiLogicalSwitchingLogicalSwitchPortsApi.new(@client_builder.get_client)
    end

    private def vm_fabric_svc
      @vm_fabric_svc ||= NSXT::ManagementPlaneApiFabricVirtualMachinesApi.new(@client_builder.get_client)
    end

    private def vif_fabric_svc
      @vif_fabric_svc ||= NSXT::ManagementPlaneApiFabricVifsApi.new(@client_builder.get_client)
    end

    private def services_svc
      @services_svc ||= NSXT::ManagementPlaneApiServicesLoadbalancerApi.new(@client_builder.get_client)
    end

    def add_vm_to_nsgroups(vm, ns_groups)
      return if ns_groups.nil? || ns_groups.empty?
      return if nsxt_nics(vm).empty?
      lports = logical_ports(vm)
      logger.info("Adding vm '#{vm.cid}' to NSGroups: #{ns_groups}")
      nsgroups = retrieve_nsgroups(ns_groups)
      nsgroups.each do |nsgroup|
        logger.info("Adding LogicalPorts: #{lports.map(&:id)} to NSGroup '#{nsgroup.id}'")
        Bosh::Retryable.new(
            tries: 50,
            on: [NSXTOptimisticUpdateError]
        ).retryer do |i|
          grouping_obj_svc.add_or_remove_ns_group_expression(
            nsgroup.id,
            *to_simple_expressions(lports),
            'ADD_MEMBERS'
          )
        rescue NSXT::ApiCallError => e
          raise NSXTOptimisticUpdateError if e.code == 409 || e.code == 412 #Conflict or PreconditionFailed
          raise
        end
      end
    end

    def remove_vm_from_nsgroups(vm)
      return if nsxt_nics(vm).empty?
      lports = logical_ports(vm)
      lport_ids = lports.map(&:id)
      nsgroups = retrieve_all_ns_groups_with_pagination.select do |nsgroup|
        nsgroup.members&.any? do |member|
          member.is_a?(NSXT::NSGroupSimpleExpression) &&
            member.target_property == 'id' &&
            lport_ids.include?(member.value)
        end
      end
      nsgroups.each do |nsgroup|
        next if nsgroup._protection != "NOT_PROTECTED"
        logger.info("Removing LogicalPorts: #{lport_ids} to NSGroup '#{nsgroup.id}'")
        Bosh::Retryable.new(
            tries: 50,
            on: [NSXTOptimisticUpdateError]
        ).retryer do |i|
          grouping_obj_svc.add_or_remove_ns_group_expression(
            nsgroup.id,
            *to_simple_expressions(lports),
            'REMOVE_MEMBERS'
          )
        rescue NSXT::ApiCallError => e
          raise NSXTOptimisticUpdateError if e.code == 409 || e.code == 412 #Conflict or PreconditionFailed
          raise
        end
      end
    end

    def update_vm_metadata_on_logical_ports(vm, metadata)
      return unless metadata.has_key?('id')
      return if nsxt_nics(vm).empty?

      logical_ports(vm).each do |logical_port|
        loop do
          tags = logical_port.tags || []
          tags_by_scope = tags.group_by { |tag| tag.scope }
          bosh_id_tags = tags_by_scope.fetch('bosh/id', [])

          raise InvalidLogicalPortError.new(logical_port) if bosh_id_tags.uniq.length > 1

          id_tag = NSXT::Tag.new('scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest(metadata['id']))
          tags.delete_if { |tag| tag.scope == 'bosh/id' }
          tags << id_tag

          logical_port.tags = tags
          begin
            lport = logical_switching_svc.update_logical_port_with_http_info(logical_port.id, logical_port)
            break if lport
          rescue NSXT::ApiCallError => e
            if e.code == 412
              logical_port = logical_switching_svc.get_logical_port(logical_port.id)
            else
              raise e
            end
          end
        end
      end
    end

    def set_vif_type(vm, vm_type_nsxt)
      vif_type = (vm_type_nsxt || {}).has_key?('vif_type') ? vm_type_nsxt['vif_type'] : @default_vif_type
      return if vif_type.nil?
      return if nsxt_nics(vm).empty?
      ports = logical_ports(vm)
      ports.each do |logical_port|
        logger.info("Setting VIF attachment on logical port #{logical_port.id} to have vif_type '#{vif_type}'")
        loop do
          logical_port.attachment.context = NSXT::VifAttachmentContext.new
          logical_port.attachment.context.resource_type = 'VifAttachmentContext'
          logical_port.attachment.context.vif_type = vif_type
          begin
            lport = logical_switching_svc.update_logical_port_with_http_info(logical_port.id, logical_port)
            break if lport
          rescue NSXT::ApiCallError => e
            if e.code == 412
              logical_port = logical_switching_svc.get_logical_port(logical_port.id)
            else
              raise e
            end
          end
        end
      end
    end

    # Add vm to given list of static Load Balancer Server Pools
    # @param [Resources::VM] vm
    # @param [[NSXT::LbPool, integer][]] server_pools Array of Load_balancer_pool and port no
    def add_vm_to_server_pools(vm, server_pools)
      return if server_pools.nil? || server_pools.empty?
      Bosh::Retryable.new(
        tries: 50,
        sleep: ->(try_count, retry_exception) { 2 },
        on: [VirtualMachineIpNotFound]
      ).retryer do |i|
        vm_ip = vm.mob.guest&.ip_address
        raise VirtualMachineIpNotFound.new(vm) unless vm_ip
        server_pools.each do |server_pool, port_no|
          logger.info("Adding vm: '#{vm.cid}' with ip:#{vm_ip} to ServerPool: #{server_pool.id} on Port: #{port_no} ")
          pool_member = NSXT::PoolMemberSetting.new(ip_address: vm_ip, port: port_no, display_name: vm.cid)
          pool_member_setting_list = NSXT::PoolMemberSettingList.new(members: [pool_member])
          begin
            services_svc.perform_pool_member_action(server_pool.id, pool_member_setting_list, 'ADD_MEMBERS')
          rescue NSXT::ApiCallError => e
            retry if e.code == 409 || e.code == 412 #Conflict or PreconditionFailed
            raise e
          end
        end
      end
    end

    # Returns an array of Static Server Pools and Dynamic Server Pools
    # For Static Server Pools corresponding port no is also returned
    # @param [array] server_pools It is an array of hashes with server_pool names and port
    def retrieve_server_pools(server_pools)
      return [] if server_pools.nil? || server_pools.empty?

      #Create a hash of server_pools with key as their name and value as list of matching server_pools
      server_pools_by_name = services_svc.list_load_balancer_pools.results.each_with_object({}) do |server_pool, hash|
        if server_pool._protection == 'NOT_PROTECTED' # only return the pools we're allowed to modify, not the Policy API's pools
          hash[server_pool.display_name] ? hash[server_pool.display_name] << server_pool : hash[server_pool.display_name] = [server_pool]
        end
      end

      missing = server_pools.reject do |server_pool|
        server_pools_by_name.key?(server_pool['name'])
      end
      raise ServerPoolsNotFound.new(*missing) unless missing.empty?

      static_server_pools, dynamic_server_pools = [], []
      server_pools.each do |server_pool|
        server_pool_name = server_pool['name']
        server_pool_port = server_pool['port']
        matching_server_pools = server_pools_by_name[server_pool_name]
        matching_server_pools.each do |matching_server_pool|
          matching_server_pool.member_group ? dynamic_server_pools << matching_server_pool : static_server_pools << [matching_server_pool, server_pool_port]
        end
      end
      [static_server_pools, dynamic_server_pools]
    end

    def remove_vm_from_server_pools(vm_ip, vm_cid, cpi_metadata_version)
        services_svc.list_load_balancer_pools.results.each do |server_pool|
        members_found = server_pool.members&.select {|member| member.ip_address == vm_ip}
        next unless members_found&.any?
        members_found.each do |member_found|
          if (cpi_metadata_version > 0 && vm_cid == member_found.display_name) || cpi_metadata_version == 0
            logger.info("Removing vm with ip: '#{vm_ip}', port_no: #{member_found.port} from ServerPool: #{server_pool.id} ")
            pool_member = NSXT::PoolMemberSetting.new(ip_address: vm_ip, port: member_found.port)
            pool_member_setting_list = NSXT::PoolMemberSettingList.new(members: [pool_member])
            services_svc.perform_pool_member_action(server_pool.id, pool_member_setting_list, 'REMOVE_MEMBERS')
          end
        end
      end
    end

    def retrieve_lport_display_names_from_vif_ids(switch_vif_id_list)
      switch_lport_display_id = []
      switch_vif_id_list.each do |switch, vif_id|
        logical_port_display_name = logical_port_display_name_from_vif_id(vif_id: vif_id)
        switch_lport_display_id << [switch, logical_port_display_name]
      end
      logger.info("Fetched all switch, port pairs #{switch_lport_display_id}")
      switch_lport_display_id
    end

    before(*instance_methods) { require 'nsxt_manager_client/nsxt_manager_client' }

    private

    MAX_TRIES = 20
    DEFAULT_SLEEP_TIME = NSXT_MIN_SLEEP = 1
    NSXT_LOGICAL_SWITCH = 'nsx.LogicalSwitch'.freeze
    NSXT_MULTI_VM_COPY_RETRY = 62

    def retrieve_all_ns_groups_with_pagination
      logger.info("Gathering all NS Groups")
      objects = []
      result_list = grouping_obj_svc.list_ns_groups
      objects.push(*result_list.results)
      until result_list.cursor.nil?
        result_list = grouping_obj_svc.list_ns_groups(cursor: result_list.cursor)
        objects.push(*result_list.results)
      end
      logger.info("Found #{objects.size} number of NS Groups")
      objects
    end

    def retrieve_nsgroups(nsgroup_names)
      logger.info("Searching for groups: #{nsgroup_names}")
      nsgroups_by_name = retrieve_all_ns_groups_with_pagination.each_with_object({}) do |nsgroup, hash|
        hash[nsgroup.display_name] = nsgroup
      end

      missing = nsgroup_names.reject do |nsgroup_name|
        nsgroups_by_name.key?(nsgroup_name)
      end
      raise NSGroupsNotFound.new(*missing) unless missing.empty?

      found_nsgroups = nsgroup_names.map do |nsgroup_name|
        ns_group = nsgroups_by_name[nsgroup_name]
        next if ns_group._protection != 'NOT_PROTECTED'
        ns_group
      end.compact
      logger.info("Found NSGroups with ids: #{found_nsgroups.map(&:id)}")

      found_nsgroups
    end

    def logical_port_display_name_from_vif_id(vif_id:)
      Bosh::Retryable.new(
          tries: @max_tries,
          sleep: ->(try_count, retry_exception) { @sleep_time },
          on: [VIFNotFound, LogicalPortNotFound]
      ).retryer do |_|
        logger.info("Searching LogicalPorts with attachment_id: #{vif_id}")
        lport = logical_switching_svc.list_logical_ports(attachment_id: vif_id).results&.first
        raise LogicalPortNotFound.new(vif_id: vif_id) if lport.nil?
        logger.info("LogicalPort: #{lport.display_name} found for attachment_id: #{vif_id}")
        lport.display_name
      end
    end

    def logical_ports(vm)
      Bosh::Retryable.new(
        tries: [@max_tries, NSXT_MULTI_VM_COPY_RETRY].max,
        sleep: ->(try_count, retry_exception) { [NSXT_MIN_SLEEP, @sleep_time].max },
        on: [VirtualMachineNotFound, MultipleVirtualMachinesFound, VIFNotFound, LogicalPortNotFound]
      ).retryer do |i|
        logger.info("Searching for LogicalPorts for vm '#{vm.cid}'")
        virtual_machines = vm_fabric_svc.list_virtual_machines(display_name: vm.cid).results
        # NSX-T sometimes returns multiple VMs for same display id. Log it to be able to
        # study these objects later. @TODO: Can be removed after one stable release.
        logger.info("Virtual Machines fetched : #{virtual_machines.pretty_inspect}") if virtual_machines.length > 1

        raise VirtualMachineNotFound.new(vm.cid) if virtual_machines.empty?

        external_id = virtual_machines.first.external_id
        # NSX-T in events of v-motion or grouped vm_tool info maintains multiple copies of same
        # VM. This can last upto a minute. Recaliberating retries and sleep to try at least
        # for a minute to get single VM eventually. Or try to proceed in case below

        # A best effort algorithm:
        # if all vms returned by nsxt fabric have same external id,
        # it means vm was being v-motioned and external_id is safe to use.
        # else we can keep retrying until single vm appears after a minute max.
        all_vms_are_equal = virtual_machines.all? do |vm_nsxt_resource|
          vm_nsxt_resource.external_id == external_id
        end
        raise MultipleVirtualMachinesFound.new(vm.cid, virtual_machines.length) unless all_vms_are_equal

        logger.info("Searching VIFs with 'owner_vm_id: #{external_id}'")
        vifs = vif_fabric_svc.list_vifs(owner_vm_id: external_id).results
        vifs.select! { |vif| !vif.lport_attachment_id.nil? }
        raise VIFNotFound.new(vm.cid, external_id) if vifs.empty?

        lports = vifs.inject([]) do |lports, vif|
          logger.info("Searching LogicalPorts with 'attachment_id: #{vif.lport_attachment_id}'")
          lports << logical_switching_svc.list_logical_ports(attachment_id: vif.lport_attachment_id).results.first
        end.compact
        raise LogicalPortNotFound.new(vm.cid, external_id) if lports.empty?
        logger.info("LogicalPorts found for vm '#{vm.cid}': #{lports.map(&:id)}'")

        lports
      end
    end

    def to_simple_expressions(lports)
      ns_grp_exprn_lst = NSXT::NSGroupExpressionList.new
      ns_grp_exprn_lst.members = []
      lports.each do |lport|
        ns_grp_exprn_lst.members.push(
          op: 'EQUALS',
          target_type: lport.resource_type,
          target_property: "id",
          value: lport.id,
          resource_type: "NSGroupSimpleExpression"
        )
      end
      ns_grp_exprn_lst
    end

    def nsxt_nics(vm)
      nics = vm.nics.select do |nic|
        case nic.backing
        when VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo
          next unless nic.backing.opaque_network_type == NSXT_LOGICAL_SWITCH
          logger.info("NIC with device key #{nic.key} is backed by opaque NSXT network")
        when VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo
          next unless @vcenter_client.dvpg_istype_nsxt?(
              key: nic.backing.port.portgroup_key, dc_mob: @datacenter.mob
          )
          logger.info("NIC with device key #{nic.key} is backed by NSXT DVPG")
        end
      end
      logger.info("NSX-T networks found for vm '#{vm.cid}': #{nics.map(&:device_info).map(&:summary)}")
      nics
    end

  end
end