require 'pry-byebug'

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

  class NSGroupsNotFound < StandardError
    def initialize(*display_names)
      @display_names = display_names
    end

    def to_s
      "NSGroups [#{@display_names.join(', ')}] was not found in NSX-T"
    end
  end

  class LogicalPortNotFound < StandardError
  end

  class NSXTProvider
    def initialize(config)
      @client = NSXT::Client.new(config.host, config.username, config.password)
    end

    def add_vm_to_nsgroups(vm, vm_type_nsxt)
      return if vm_type_nsxt.nil? || vm_type_nsxt['nsgroups'].nil? || vm_type_nsxt['nsgroups'].empty?
      return if nsxt_nics(vm).empty?

      nsgroups = retrieve_nsgroups(vm_type_nsxt['nsgroups'])

      lports = logical_ports(vm)
      nsgroups.each do |nsgroup|
        nsgroup.add_members(*to_simple_expressions(lports))
      end
    end

    def remove_vm_from_nsgroups(vm)
      return if nsxt_nics(vm).empty?

      lports = logical_ports(vm)

      lport_ids = lports.map(&:id)
      nsgroups = @client.nsgroups.select do |nsgroup|
        not nsgroup.members.select do |member|
          member.is_a?(VSphereCloud::NSXT::NSGroup::SimpleExpression) &&
            member.target_property == 'id' &&
            lport_ids.include?(member.value)
        end.empty?
      end

      nsgroups.each do |nsgroup|
        nsgroup.remove_members(*to_simple_expressions(lports))
      end
    end

    private

    NSXT_LOGICAL_SWITCH = 'nsx.LogicalSwitch'.freeze

    def retrieve_nsgroups(nsgroup_names)
      nsgroups_by_name = @client.nsgroups.each_with_object({}) do |nsgroup, hash|
        hash[nsgroup.display_name] = nsgroup
      end

      missing = nsgroup_names.reject do |nsgroup_name|
        nsgroups_by_name.key?(nsgroup_name)
      end
      raise NSGroupsNotFound.new(*missing) unless missing.empty?

      nsgroup_names.map do |nsgroup_name|
        nsgroups_by_name[nsgroup_name]
      end
    end

    def logical_ports(vm)
      virtual_machines = @client.virtual_machines(display_name: vm.cid)
      raise VirtualMachineNotFound.new(vm.cid) if virtual_machines.empty?
      raise 'Multiple NSX-T virtual machines found.' if virtual_machines.length > 1
      external_id = virtual_machines.first.external_id

      vifs = @client.vifs(owner_vm_id: external_id)
      vifs.select! { |vif| !vif.lport_attachment_id.nil? }
      raise VIFNotFound.new(vm.cid, external_id) if vifs.empty?

      lports = vifs.inject([]) do |lports, vif|
        lports << @client.logical_ports(attachment_id: vif.lport_attachment_id).first
      end.compact
      raise LogicalPortNotFound if lports.empty?

      lports
    end

    def to_simple_expressions(lports)
      lports.map do |lport|
        VSphereCloud::NSXT::NSGroup::SimpleExpression.from_resource(lport, 'id')
      end
    end

    def nsxt_nics(vm)
      vm.nics.select do |nic|
        nic.backing.is_a?(VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo) &&
          nic.backing.opaque_network_type == NSXT_LOGICAL_SWITCH
      end
    end
  end
end