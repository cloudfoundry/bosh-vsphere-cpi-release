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
      @client = NSXT::Client.new(config.host, config.username, config.password, logger)
      @logger = logger
      @max_tries = MAX_TRIES
      @sleep_time = DEFAULT_SLEEP_TIME
      @default_vif_type = config.default_vif_type
    end

    def add_vm_to_nsgroups(vm, vm_type_nsxt)
      return if vm_type_nsxt.nil? || vm_type_nsxt['ns_groups'].nil? || vm_type_nsxt['ns_groups'].empty?
      return if nsxt_nics(vm).empty?

      @logger.info("Adding vm '#{vm.cid}' to NSGroups: #{vm_type_nsxt['ns_groups']}")
      nsgroups = retrieve_nsgroups(vm_type_nsxt['ns_groups'])

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
          bosh_id_tags = tags_by_scope.fetch('bosh/id', [])

          raise InvalidLogicalPortError.new(logical_port) if bosh_id_tags.uniq.length > 1

          id_tag = { 'scope' => 'bosh/id', 'tag' => Digest::SHA1.hexdigest(metadata['id']) }
          tags.delete_if {|tag| tag['scope'] == 'bosh/id'}
          tags << id_tag

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

    def set_vif_type(vm, vm_type_nsxt)
      vif_type = (vm_type_nsxt || {})['vif_type'] || @default_vif_type
      return if vif_type.nil?
      return if nsxt_nics(vm).empty?

      logical_ports(vm).each do |logical_port|
        @logger.info("Setting VIF attachment on logical port #{logical_port.id} to have vif_type '#{vif_type}'")
        loop do
          attachment = logical_port.attachment.merge('context' => {
            'resource_type': 'VifAttachmentContext', 'vif_type': vif_type
          })

          response = logical_port.update('attachment' => attachment)
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

    MAX_TRIES = 20
    DEFAULT_SLEEP_TIME = 1
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
      Bosh::Retryable.new(
        tries: @max_tries,
        sleep: ->(try_count, retry_exception) { @sleep_time },
        on: [VirtualMachineNotFound, MultipleVirtualMachinesFound, VIFNotFound, LogicalPortNotFound]
      ).retryer do |i|
        @logger.info("Searching for LogicalPorts for vm '#{vm.cid}'")
        virtual_machines = @client.virtual_machines(display_name: vm.cid)
        raise VirtualMachineNotFound.new(vm.cid) if virtual_machines.empty?
        raise MultipleVirtualMachinesFound.new(vm.cid, virtual_machines.length) if virtual_machines.length > 1
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
