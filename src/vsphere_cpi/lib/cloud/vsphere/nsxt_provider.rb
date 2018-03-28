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

    private def services_svc
      @services_svc ||= NSXT::ServicesApi.new(@client)
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

    def add_vm_to_lbs(vm, load_balancers)
      server_pools = load_balancers['server_pools']
      return if server_pools.nil? ||  server_pools.empty?
      load_balancer_pools = retrieve_load_balancer_pools(server_pools)
      vm_ip = vm.mob.guest&.ip_address
      while vm_ip.nil?
        sleep(5)
        vm_ip =  vm.mob.guest&.ip_address
        vm_ip =  vm.mob.guest&.ip_address
      end
      raise("Cannot add VM: #{vm.cid} to Load balancer as it does not have primary ip") unless vm_ip
      load_balancer_pools.each do |load_balancer_pool|
        @logger.info("Adding vm: '#{vm.cid}' to ServerPools: #{load_balancer_pool} ")
        pool_member = NSXT::PoolMemberSetting.new(ip_address: vm_ip, port: 80)
        pool_member_setting_list = NSXT::PoolMemberSettingList.new(members: [pool_member])
        services_svc.perform_pool_member_action(load_balancer_pool.id, pool_member_setting_list, 'ADD_MEMBERS')
      end
    end

    def retrieve_load_balancer_pools(server_pools)
      pool_name = server_pools.first['pool_name']
      server_pools = services_svc.list_load_balancer_pools.results
      server_pools.select do |server_pool|
        server_pool.display_name == pool_name
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
  end
end
