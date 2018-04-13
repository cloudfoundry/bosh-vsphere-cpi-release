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

    def add_vm_to_nsgroups(vm, vm_type_nsxt)
      return if vm_type_nsxt.nil? || vm_type_nsxt['ns_groups'].nil? || vm_type_nsxt['ns_groups'].empty?
      return if nsxt_nics(vm).empty?

      @logger.info("Adding vm '#{vm.cid}' to NSGroups: #{vm_type_nsxt['ns_groups']}")
      nsgroups = retrieve_nsgroups(vm_type_nsxt['ns_groups'])

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
        nsgroup.members.any? do |member|
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
          tags.delete_if {|tag| tag.scope == 'bosh/id'}
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

    def create_t1_router(edge_cluster_id, name = nil)
      name = SecureRandom.base64(8) if name.nil?
      raise 'edge_cluster_id param can not be nil' if edge_cluster_id.nil?
      router_api.create_logical_router({ :edge_cluster_id => edge_cluster_id,
                                         :router_type => 'TIER1',
                                         :display_name => name})
    end

    def attach_t1_to_t0(t0_router_id, t1_router_id)
      raise 'T0 router id can not be nil' if t0_router_id.nil?
      raise 'T1 router id can not be nil' if t1_router_id.nil?
      begin
        t0_router_port =  NSXT::LogicalRouterLinkPortOnTIER0.new({
           :logical_router_id => t0_router_id,
           :resource_type => 'LogicalRouterLinkPortOnTIER0'})
        t0_router_port = router_api.create_logical_router_port(t0_router_port)
      rescue Exception => e
        @logger.error("Error creating port on T0 router #{t0_router_id}. Exception: #{e}")
        raise "Error creating port on #{t0_router_id} T0 router. Exception: #{e}"
      end

      begin
        t0_reference = NSXT::ResourceReference.new({
            :target_id => t0_router_port.id,
            :target_type => 'LogicalRouterLinkPortOnTIER0',
            :is_valid => true })
        t1_router_port = NSXT::LogicalRouterLinkPortOnTIER1.new({
            :linked_logical_router_port_id => t0_reference,
            :logical_router_id => t1_router_id,
            :resource_type => 'LogicalRouterLinkPortOnTIER1'})
        router_api.create_logical_router_port(t1_router_port)
      rescue Exception => e
        @logger.error("Error creating port on T1 router #{t1_router_id} and attaching it to T0 port #{t0_router_port.id}. Exception: #{e}")
        raise "Error creating port on T1 (#{t1_router_id}) and attaching it to T0 port #{t0_router_port.id}. Exception: #{e}"
      end
    end

    def create_logical_switch(transport_zone_id, name = nil)
      raise 'Transport zone id can not be nil' if transport_zone_id.nil?

      switch = NSXT::LogicalSwitch.new({
           :admin_state => 'UP',
           :transport_zone_id => transport_zone_id,
           :replication_mode => 'MTEP',
           :display_name => name })
      switch_api.create_logical_switch(switch)
    end

    def attach_switch_to_t1(switch_id, t1_router_id, subnet)
      raise 'Switch id can not be nil' if switch_id.nil?
      raise 'Router id can not be nil' if t1_router_id.nil?
      raise 'Subnet can not be nil' if subnet.nil?

      begin
        logical_port = NSXT::LogicalPort.new({
            :admin_state => 'UP',
            :logical_switch_id => switch_id})
        logical_port = switch_api.create_logical_port(logical_port)
      rescue Exception => e
        @logger.error("Failed to create logical port for switch #{switch_id}. Exception: #{e}")
        raise "Failed to create logical port for switch #{switch_id}. Exception: #{e}"
      end

      begin
        switch_port_ref = NSXT::ResourceReference.new({:target_id => logical_port.id,
                                     :target_type => 'LogicalPort',
                                     :is_valid => true })

        t1_router_port = NSXT::LogicalRouterDownLinkPort.new({
           :logical_router_id => t1_router_id,
           :linked_logical_switch_port_id => switch_port_ref,
           :resource_type => 'LogicalRouterDownLinkPort',
           :subnets => [subnet]})
        router_api.create_logical_router_port(t1_router_port)
      rescue Exception => e
        @logger.error("Failed to create logical port for router #{t1_router_id} and switch #{switch_id}. Exception: #{e}")
        raise "Failed to create logical port for router #{t1_router_id} and switch #{switch_id}. Exception: #{e}"
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
  end
end
