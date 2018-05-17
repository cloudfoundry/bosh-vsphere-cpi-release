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
    def initialize(vm_id, external_id)
      @vm_id = vm_id
      @external_id = external_id
    end

    def to_s
      "VIF for VM #{@vm_id} with 'external_id' #{@external_id} was expected in NSX-T but was not found"
    end
  end

  class LogicalPortNotFound < StandardError
    def initialize(vm_id, external_id)
      @vm_id = vm_id
      @external_id = external_id
    end

    def to_s
      "Logical port for VM #{@vm_id} with 'external_id' #{@external_id} was expected in NSX-T but was not found"
    end
  end

  class NSGroupsNotFound < StandardError
    def initialize(*display_names)
      @display_names = display_names
    end

    def to_s
      "NSGroups [#{@display_names.join(', ')}] was not found in NSX-T"
    end
  end

  class ServerPoolsNotFound < StandardError
    def initialize(*display_names)
      @display_names = display_names
    end

    def to_s
      "ServerPools [#{@display_names.join(', ')}] was not found in NSX-T"
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

  class NSXTProvider
    def initialize(config, logger)
      configuration = NSXT::Configuration.new
      configuration.host = config.host
      configuration.username = config.username
      configuration.password = config.password
      configuration.logger = logger
      configuration.client_side_validation = false
      if ENV['BOSH_NSXT_CA_CERT_FILE']
        configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
      end
      if ENV['NSXT_SKIP_SSL_VERIFY']
        configuration.verify_ssl = false
        configuration.verify_ssl_host = false
      end
      @client = NSXT::ApiClient.new(configuration)
      @logger = logger
      @max_tries = MAX_TRIES
      @sleep_time = DEFAULT_SLEEP_TIME
      @default_vif_type = config.default_vif_type
    end

    private def grouping_obj_svc
      @grouping_obj_svc ||= NSXT::GroupingObjectsApi.new(@client)
    end

    private def logical_switching_svc
      @logical_switching_svc ||= NSXT::LogicalSwitchingApi.new(@client)
    end

    private def fabric_svc
      @fabric_svc ||= NSXT::FabricApi.new(@client)
    end


    private def services_svc
      @services_svc ||= NSXT::ServicesApi.new(@client)
    end

    def add_vm_to_nsgroups(vm, ns_groups)
      return if ns_groups.nil? || ns_groups.empty?
      return if nsxt_nics(vm).empty?

      @logger.info("Adding vm '#{vm.cid}' to NSGroups: #{ns_groups}")
      nsgroups = retrieve_nsgroups(ns_groups)

      lports = logical_ports(vm)
      nsgroups.each do |nsgroup|
        @logger.info("Adding LogicalPorts: #{lports.map(&:id)} to NSGroup '#{nsgroup.id}'")
        grouping_obj_svc.add_or_remove_ns_group_expression(
          nsgroup.id,
          *to_simple_expressions(lports),
          'ADD_MEMBERS'
        )
      end
    end

    def remove_vm_from_nsgroups(vm)
      return if nsxt_nics(vm).empty?

      lports = logical_ports(vm)

      lport_ids = lports.map(&:id)
      nsgroups = grouping_obj_svc.list_ns_groups.results.select do |nsgroup|
        nsgroup.members&.any? do |member|
          member.is_a?(NSXT::NSGroupSimpleExpression) &&
            member.target_property == 'id' &&
            lport_ids.include?(member.value)
        end
      end

      nsgroups.each do |nsgroup|
        @logger.info("Removing LogicalPorts: #{lport_ids} to NSGroup '#{nsgroup.id}'")
        grouping_obj_svc.add_or_remove_ns_group_expression(
          nsgroup.id,
          *to_simple_expressions(lports),
          'REMOVE_MEMBERS'
        )
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
        @logger.info("Setting VIF attachment on logical port #{logical_port.id} to have vif_type '#{vif_type}'")
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
          @logger.info("Adding vm: '#{vm.cid}' with ip:#{vm_ip} to ServerPool: #{server_pool.id} on Port: #{port_no} ")
          pool_member = NSXT::PoolMemberSetting.new(ip_address: vm_ip, port: port_no)
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
        hash[server_pool.display_name] ? hash[server_pool.display_name] << server_pool : hash[server_pool.display_name] = [server_pool]
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
      return static_server_pools, dynamic_server_pools
    end

    def remove_vm_from_server_pools(vm_ip)
        services_svc.list_load_balancer_pools.results.each do |server_pool|
        members_found = server_pool.members&.select {|member| member.ip_address == vm_ip}
        next unless members_found&.any?
        members_found.each do |member_found|
          @logger.info("Removing vm with ip: '#{vm_ip}', port_no: #{member_found.port} from ServerPool: #{server_pool.id} ")
          pool_member = NSXT::PoolMemberSetting.new(ip_address: vm_ip, port: member_found.port)
          pool_member_setting_list = NSXT::PoolMemberSettingList.new(members: [pool_member])
          services_svc.perform_pool_member_action(server_pool.id, pool_member_setting_list, 'REMOVE_MEMBERS')
        end
      end
    end

    def create_t1_router(edge_cluster_id, name = nil)
      name = SecureRandom.base64(8) if name.nil?
      router_api.create_logical_router({ edge_cluster_id: edge_cluster_id,
                                         router_type: 'TIER1',
                                         display_name: name})
    end

    def attach_t1_to_t0(t0_router_id, t1_router_id)
      begin
        t0_router_port =  NSXT::LogicalRouterLinkPortOnTIER0.new({logical_router_id: t0_router_id,
                                                                  resource_type: 'LogicalRouterLinkPortOnTIER0'})
        t0_router_port = router_api.create_logical_router_port(t0_router_port)
      rescue => e
        @logger.error("Error creating port on T0 router #{t0_router_id}. Exception: #{e}")
        raise "Error creating port on #{t0_router_id} T0 router. Exception: #{e}"
      end

      begin
        t0_reference = NSXT::ResourceReference.new({target_id: t0_router_port.id,
                                                    target_type: 'LogicalRouterLinkPortOnTIER0',
                                                    is_valid: true })
        t1_router_port = NSXT::LogicalRouterLinkPortOnTIER1.new({linked_logical_router_port_id: t0_reference,
                                                                 logical_router_id: t1_router_id,
                                                                 resource_type: 'LogicalRouterLinkPortOnTIER1'})
        router_api.create_logical_router_port(t1_router_port)
      rescue => e
        @logger.error("Error creating port on T1 router #{t1_router_id} and attaching it to T0 port #{t0_router_port.id}. Exception: #{e}")
        raise "Error creating port on T1 (#{t1_router_id}) and attaching it to T0 port #{t0_router_port.id}. Exception: #{e}"
      end
    end

    def enable_route_advertisement(router_id)
      config = router_api.read_advertisement_config(router_id)
      config.advertise_nsx_connected_routes = true
      config.enabled = true
      router_api.update_advertisement_config(router_id, config)
    end

    def create_logical_switch(transport_zone_id, name = nil)
      switch = NSXT::LogicalSwitch.new({admin_state: 'UP',
                                        transport_zone_id: transport_zone_id,
                                        replication_mode: 'MTEP',
                                        display_name: name })
      switch_api.create_logical_switch(switch)
    end

    def attach_switch_to_t1(switch_id, t1_router_id, subnet)
      begin
        logical_port = NSXT::LogicalPort.new({:admin_state => 'UP',
                                              :logical_switch_id => switch_id})
        logical_port = switch_api.create_logical_port(logical_port)
      rescue => e
        @logger.error("Failed to create logical port for switch #{switch_id}. Exception: #{e.to_s}")
        raise "Failed to create logical port for switch #{switch_id}. Exception: #{e.to_s}"
      end

      begin
        switch_port_ref = NSXT::ResourceReference.new({target_id: logical_port.id,
                                                       target_type: 'LogicalPort',
                                                       is_valid: true })

        t1_router_port = NSXT::LogicalRouterDownLinkPort.new({logical_router_id: t1_router_id,
                                                              linked_logical_switch_port_id: switch_port_ref,
                                                              resource_type: 'LogicalRouterDownLinkPort',
                                                              subnets: [subnet]})
        router_api.create_logical_router_port(t1_router_port)
      rescue => e
        @logger.error("Failed to create logical port for router #{t1_router_id} and switch #{switch_id}. Exception: #{e.to_s}")
        raise "Failed to create logical port for router #{t1_router_id} and switch #{switch_id}. Exception: #{e.to_s}"
      end
    end

    def delete_logical_switch(switch_id)
      switch_api.delete_logical_switch(switch_id, cascade: true, detach: true)
    end

    def delete_t1_router(t1_router_id)
      router_api.delete_logical_router(t1_router_id, force: true)
    end

    def get_attached_router_ids(switch_id)
      router_ports = router_api.list_logical_router_ports(logical_switch_id: switch_id)
      router_ports.results.map(&:logical_router_id)
    end

    def get_attached_switch_ports(switch_id)
      switch_api.list_logical_ports(logical_switch_id: switch_id).results
    end

    def get_attached_switches_ids(t1_router_id)
      hack_nsxt_client
      router_ports = router_api.list_logical_router_ports(logical_router_id: t1_router_id,
                                                          resource_type: 'LogicalRouterDownLinkPort')
      router_ports.results.select do |port|
        port.linked_logical_switch_port_id.is_valid
      end.map do |valid_port|
        valid_port.linked_logical_switch_port_id.target_id
      end
    end

    private

    MAX_TRIES = 20
    DEFAULT_SLEEP_TIME = 1
    NSXT_LOGICAL_SWITCH = 'nsx.LogicalSwitch'.freeze

    def retrieve_nsgroups(nsgroup_names)
      @logger.info("Searching for groups: #{nsgroup_names}")
      nsgroups_by_name = grouping_obj_svc.list_ns_groups.results.each_with_object({}) do |nsgroup, hash|
        hash[nsgroup.display_name] = nsgroup
      end

      missing = nsgroup_names.reject do |nsgroup_name|
        nsgroups_by_name.key?(nsgroup_name)
      end
      raise NSGroupsNotFound.new(*missing) unless missing.empty?

      found_nsgroups = nsgroup_names.map do |nsgroup_name|
        nsgroups_by_name[nsgroup_name]
      end
      @logger.info("Found NSGroups with ids: #{found_nsgroups.map(&:id)}")

      found_nsgroups
    end

    def logical_ports(vm)
      Bosh::Retryable.new(
        tries: @max_tries,
        sleep: ->(try_count, retry_exception) { @sleep_time },
        on: [VirtualMachineNotFound, MultipleVirtualMachinesFound, VIFNotFound, LogicalPortNotFound]
      ).retryer do |i|
        @logger.info("Searching for LogicalPorts for vm '#{vm.cid}'")
        virtual_machines = fabric_svc.list_virtual_machines(:display_name => vm.cid).results
        raise VirtualMachineNotFound.new(vm.cid) if virtual_machines.empty?
        raise MultipleVirtualMachinesFound.new(vm.cid, virtual_machines.length) if virtual_machines.length > 1
        external_id = virtual_machines.first.external_id

        @logger.info("Searching VIFs with 'owner_vm_id: #{external_id}'")
        vifs = fabric_svc.list_vifs(:owner_vm_id => external_id).results
        vifs.select! { |vif| !vif.lport_attachment_id.nil? }
        raise VIFNotFound.new(vm.cid, external_id) if vifs.empty?

        lports = vifs.inject([]) do |lports, vif|
          @logger.info("Searching LogicalPorts with 'attachment_id: #{vif.lport_attachment_id}'")
          lports << logical_switching_svc.list_logical_ports(attachment_id: vif.lport_attachment_id).results.first
        end.compact
        raise LogicalPortNotFound.new(vm.cid, external_id) if lports.empty?
        @logger.info("LogicalPorts found for vm '#{vm.cid}': #{lports.map(&:id)}'")

        lports
      end
    end

    def to_simple_expressions(lports)
      ns_grp_exprn_lst = NSXT::NSGroupExpressionList.new
      ns_grp_exprn_lst.members = []
      lports.each do |lport|
        ns_grp_exprn_lst.members.push({
          op: 'EQUALS',
          target_type: lport.resource_type,
          target_property: "id",
          value: lport.id,
          resource_type: "NSGroupSimpleExpression"
        })
      end
      ns_grp_exprn_lst
    end

    def nsxt_nics(vm)
      nics = vm.nics.select do |nic|
        nic.backing.is_a?(VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo) &&
          nic.backing.opaque_network_type == NSXT_LOGICAL_SWITCH
      end
      @logger.info("NSX-T networks found for vm '#{vm.cid}': #{nics.map(&:device_info).map(&:summary)}")

      nics
    end

    def router_api
      @router_api ||= NSXT::LogicalRoutingAndServicesApi.new(@client)
    end

    def switch_api
      @switch_api ||= NSXT::LogicalSwitchingApi.new(@client)
    end

    def hack_nsxt_client
      NSXT::LogicalRouterPortListResult.send(:include, ResultWithDownlinkPort)
    end
    module ResultWithDownlinkPort
      def self.included(base)
        base.class_eval do
          def self.swagger_types
            {
                :'_self' => :'SelfResourceLink',
                :'_links' => :'Array<ResourceLink>',
                :'_schema' => :'String',
                :'cursor' => :'String',
                :'sort_ascending' => :'BOOLEAN',
                :'sort_by' => :'String',
                :'result_count' => :'Integer',
                :'results' => :'Array<LogicalRouterDownLinkPort>'
            }
          end
        end
      end
    end
  end
end
