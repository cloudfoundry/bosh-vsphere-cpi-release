module VSphereCloud
  class VirtualMachineNotFound < StandardError
    def initialize(vm_id)
      @vm_id = vm_id
    end

    def to_s
      "VM #{@vm_id} was expected in NSX-T but was not found"
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
      "Logical port #{@logical_port.id} has multiple values for tag with scope 'bosh/vm_id'"
    end
  end

  class NSXTProvider
    def initialize(config, logger)
      @client = NSXT::Client.new(config.host, config.username, config.password, logger)
      @logger = logger
    end

    def add_vm_to_nsgroups(vm, vm_type_nsxt)
      return if vm_type_nsxt.nil? || vm_type_nsxt['nsgroups'].nil? || vm_type_nsxt['nsgroups'].empty?
      return if nsxt_nics(vm).empty?

      @logger.info("Adding vm '#{vm.cid}' to NSGroups: #{vm_type_nsxt['nsgroups']}")
      nsgroups = retrieve_nsgroups(vm_type_nsxt['nsgroups'])

      lports = logical_ports(vm)
      nsgroups.each do |nsgroup|
        @logger.info("Adding LogicalPorts: #{lports.map(&:id)} to NSGroup '#{nsgroup.id}'")
        nsgroup.add_members(*to_simple_expressions(lports))
      end
    end

    def remove_vm_from_nsgroups(vm)
      return if nsxt_nics(vm).empty?

      lports = logical_ports(vm)

      lport_ids = lports.map(&:id)
      nsgroups = @client.nsgroups.select do |nsgroup|
        not nsgroup.members.select do |member|
          member.is_a?(NSXT::NSGroup::SimpleExpression) &&
            member.target_property == 'id' &&
            lport_ids.include?(member.value)
        end.empty?
      end

      nsgroups.each do |nsgroup|
        @logger.info("Removing LogicalPorts: #{lport_ids} to NSGroup '#{nsgroup.id}'")
        nsgroup.remove_members(*to_simple_expressions(lports))
      end
    end

    def update_vm_metadata_on_logical_ports(vm, metadata)
      return unless metadata.has_key?('id')
      return if nsxt_nics(vm).empty?

      logical_ports(vm).each do |logical_port|
        loop do
          tags = logical_port.tags || []
          tags_by_scope = tags.group_by { |tag| tag['scope'] }
          bosh_vm_id_tags = tags_by_scope.fetch('bosh/vm_id', [])

          raise InvalidLogicalPortError.new(logical_port) if bosh_vm_id_tags.uniq.length > 1

          vm_id_tag = {'scope' => 'bosh/vm_id', 'tag' => metadata['id']}
          tags.delete_if {|tag| tag['scope'] == 'bosh/vm_id'}
          tags << vm_id_tag

          response = logical_port.update('tags' => tags)
          if response.ok?
            break
          elsif response.status == 412
            logical_port.reload!
          else
            raise NSXT::Error.new(response.status_code), response.body
          end
        end
      end
    end

    private

    NSXT_LOGICAL_SWITCH = 'nsx.LogicalSwitch'.freeze

    def retrieve_nsgroups(nsgroup_names)
      @logger.info("Searching for groups: #{nsgroup_names}")
      nsgroups_by_name = @client.nsgroups.each_with_object({}) do |nsgroup, hash|
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
      @logger.info("Searching for LogicalPorts for vm '#{vm.cid}'")
      virtual_machines = @client.virtual_machines(display_name: vm.cid)
      raise VirtualMachineNotFound.new(vm.cid) if virtual_machines.empty?
      raise 'Multiple NSX-T virtual machines found.' if virtual_machines.length > 1
      external_id = virtual_machines.first.external_id

      @logger.info("Searching VIFs with 'owner_vm_id: #{external_id}'")
      vifs = @client.vifs(owner_vm_id: external_id)
      vifs.select! { |vif| !vif.lport_attachment_id.nil? }
      raise VIFNotFound.new(vm.cid, external_id) if vifs.empty?

      lports = vifs.inject([]) do |lports, vif|
        @logger.info("Searching LogicalPorts with 'attachment_id: #{vif.lport_attachment_id}'")
        lports << @client.logical_ports(attachment_id: vif.lport_attachment_id).first
      end.compact
      raise LogicalPortNotFound.new(vm.cid, external_id) if lports.empty?
      @logger.info("LogicalPorts found for vm '#{vm.cid}': #{lports.map(&:id)}'")

      lports
    end

    def to_simple_expressions(lports)
      lports.map do |lport|
        NSXT::NSGroup::SimpleExpression.from_resource(lport, 'id')
      end
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
