module VSphereCloud
  class VmGroup
    include Logger
    DRS_LOCK_VMGROUP = 'drs_lock_vm_group'

    # @param [VSphereCloud::VCenterClient] client
    # @param [Vim::ClusterComputeResource] cluster
    def initialize(client, cluster)
      @client = client
      @cluster = cluster
      @vm_attribute_manager = VMAttributeManager.new(
        client.service_content.custom_fields_manager
      )
    end

    # Adds VM to given VM Group
    # @param [Vim::VirtualMachine] vm
    # @params [String] vm_group_name
    def add_vm_to_vm_group(vm, vm_group_name)
      DrsLock.new(@vm_attribute_manager, DRS_LOCK_VMGROUP).with_drs_lock do
        vm_group = find_vm_group(vm_group_name)
        logger.debug("VmGroup: #{vm_group_name} already exists") unless vm_group.nil?

        vm_group_spec = VimSdk::Vim::Cluster::VmGroup.new
        vm_group_spec.vm = vm_group ? vm_group.vm.concat([vm]) : [vm]
        vm_group_spec.name = vm_group_name

        group_spec = VimSdk::Vim::Cluster::GroupSpec.new
        group_spec.info = vm_group_spec

        group_spec.operation = vm_group ? VimSdk::Vim::Option::ArrayUpdateSpec::Operation::EDIT : VimSdk::Vim::Option::ArrayUpdateSpec::Operation::ADD

        config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
        config_spec.group_spec = [group_spec]

        logger.debug("Adding VM to VM group: #{vm_group_name}")
        reconfigure_cluster(config_spec)
      end
    end

    # Delete VM Groups if they are empty
    # @param [String[]] vm_group_names - List of VM Groups
    def delete_vm_groups(vm_group_names)
      return if vm_group_names.empty?
      vm_attribute_manager = VMAttributeManager.new(@client.service_content.custom_fields_manager)
      DrsLock.new(vm_attribute_manager, DRS_LOCK_VMGROUP).with_drs_lock do
        empty_vm_groups = @cluster.configuration_ex.group.select do |group|
          group.is_a?(VimSdk::Vim::Cluster::VmGroup) && vm_group_names.include?(group.name) && group.vm.empty?
        end
        return if empty_vm_groups.empty?
        logger.debug("Deleting empty VmGroups: #{empty_vm_groups.map(&:name)}")
        group_specs = empty_vm_groups.map do |vm_group|
          vm_group_spec = VimSdk::Vim::Cluster::VmGroup.new
          vm_group_spec.name = vm_group.name

          group_spec = VimSdk::Vim::Cluster::GroupSpec.new
          group_spec.info = vm_group_spec
          group_spec.operation =  VimSdk::Vim::Option::ArrayUpdateSpec::Operation::REMOVE
          group_spec.remove_key = vm_group.name
          group_spec
        end

        # If these vm_groups are getting deleted. Also delete all the
        # vm-host group rules associated with it.
        #
        # @TODO : CAVEAT: if anyone creates a rule outside of CPI using these
        # vm_groups, it will be deleted too. To narrow
        # the scope of this caveat, CPI will only delete the
        # vm-host-group-affinity rule type. This is because, currently it only
        # creates vm-host-affinity rule using vm groups.
        rules_spec = get_delete_rule_spec(empty_vm_groups) unless empty_vm_groups.nil?
        config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
        config_spec.group_spec = group_specs
        unless rules_spec&.empty?
          logger.debug("Deleting #{rules_spec.count} vm host affinity rules")
          config_spec.rules_spec = rules_spec
        end
        @client.wait_for_task do
          @cluster.reconfigure_ex(config_spec, true)
        end
      end
    end

    private
    def get_delete_rule_spec(empty_vm_groups)
      # returning empty array for consistent return type.
      if @cluster.configuration_ex.rule.nil?
        return []
      end
      rules_spec= empty_vm_groups.each_with_object([]) do |vm_group, rules_spec|
        # Filter rules for deletion
        rule_keys = @cluster.configuration_ex.rule.select do |rule_info|
          rule_info.is_a?(VimSdk::Vim::Cluster::VmHostRuleInfo) && \
              rule_info.vm_group_name == vm_group.name
        end.map(&:key)

        # Generate Rule Spec
        rule_keys.each do |rkey|
          rule_spec = VimSdk::Vim::Cluster::RuleSpec.new
          rule_spec.operation = VimSdk::Vim::Option::ArrayUpdateSpec::Operation::REMOVE
          rule_spec.remove_key = rkey
          rules_spec << rule_spec
        end
      end
      rules_spec
    end


    def find_vm_group(vm_group_name)
      @cluster.configuration_ex.group.find do |group|
        group.name == vm_group_name && group.is_a?(VimSdk::Vim::Cluster::VmGroup)
      end
    end

    def reconfigure_cluster(config_spec)
      @client.wait_for_task do
        @cluster.reconfigure_ex(config_spec, true)
      end
    end
  end
end