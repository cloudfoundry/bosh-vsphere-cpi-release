require 'cloud/vsphere/logger'

module VSphereCloud
  class DrsRule
    include Logger

    CUSTOM_ATTRIBUTE_NAME = 'drs_rule'
    DRS_LOCK_HOST_VM_GROUP = 'host_vm_group'
    DEFAULT_RULE_NAME = 'vcpi-drs-rule'

    def initialize(rule_name, client, datacenter_cluster)
      @rule_name = rule_name
      @client = client
      @cloud_searcher = CloudSearcher.new(@client.service_content)
      @datacenter_cluster = datacenter_cluster

      @vm_attribute_manager = VMAttributeManager.new(
        client.service_content.custom_fields_manager
      )
    end

    def add_vm(vm)
      tag_vm(vm)

      DrsLock.new(@vm_attribute_manager).with_drs_lock do
        rule = find_rule
        if rule
          update_rule(rule.key)
        else
          add_rule
        end
      end
    end

    # Adds VM to given VM Group & creates VM/HOST Affinity rule
    # @param [Vim::VirtualMachine] vm
    # @param [String] vm_group_name
    # @param [String] host_group_name
    def add_vm_host_affinity_rule(vm_group_name, host_group_name)
      DrsLock.new(@vm_attribute_manager, DRS_LOCK_HOST_VM_GROUP).with_drs_lock do
        rule = find_rule
        # Do not create the rule if it already exists
        unless rule
          # No error is raised if given host group does not exist,
          # it still creates the rule
          create_vm_host_affinity_rule(vm_group_name, host_group_name)
        end
      end
    end

    private

    def tag_vm(vm)
      custom_attribute = @vm_attribute_manager.find_by_name(CUSTOM_ATTRIBUTE_NAME)
      unless custom_attribute
        logger.debug('Creating DRS rule attribute')
        @vm_attribute_manager.create(CUSTOM_ATTRIBUTE_NAME)
      end

      logger.debug("Updating DRS rule attribute value: #{@rule_name}, vm: #{vm.name}")
      vm.set_custom_value(CUSTOM_ATTRIBUTE_NAME, @rule_name)
    end

    def find_rule
      @datacenter_cluster.configuration_ex.rule.find { |r| r.name == @rule_name }
    end

    def add_rule
      logger.debug("Adding DRS rule: #{@rule_name}")
      add_anti_affinity_rule(VimSdk::Vim::Option::ArrayUpdateSpec::Operation::ADD)
    end

    def update_rule(rule_key)
      logger.debug("Updating DRS rule: #{@rule_name}")
      add_anti_affinity_rule(VimSdk::Vim::Option::ArrayUpdateSpec::Operation::EDIT, rule_key)
    end

    def create_vm_host_affinity_rule(vm_group_name, host_group_name)
      vm_host_rule_info = VimSdk::Vim::Cluster::VmHostRuleInfo.new
      vm_host_rule_info.enabled = true
      # This is a HARD AFFINITY rule.
      vm_host_rule_info.mandatory = true
      vm_host_rule_info.name = @rule_name
      vm_host_rule_info.vm_group_name = vm_group_name
      vm_host_rule_info.affine_host_group_name = host_group_name

      cluster_rule_spec = VimSdk::Vim::Cluster::RuleSpec.new
      cluster_rule_spec.info = vm_host_rule_info
      cluster_rule_spec.operation = VimSdk::Vim::Option::ArrayUpdateSpec::Operation::ADD

      config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
      config_spec.rules_spec = [cluster_rule_spec]

      logger.debug("Creating VM/Host Affinity Rule: #{@rule_name}")
      reconfigure_cluster(config_spec)
    end

    def add_anti_affinity_rule(operation, rule_key = nil)
      config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
      rule_spec = VimSdk::Vim::Cluster::RuleSpec.new
      rule_spec.operation = operation

      rule_info = VimSdk::Vim::Cluster::AntiAffinityRuleSpec.new
      rule_info.enabled = true
      rule_info.name = @rule_name
      rule_info.vm = tagged_vms
      vm_names = rule_info.vm.map { |v| v.name }
      logger.debug("Setting DRS rule: #{@rule_name}, vms: #{vm_names.join(', ')}")
      rule_info.key = rule_key if rule_key

      rule_spec.info = rule_info

      config_spec.rules_spec = [rule_spec]
      reconfigure_cluster(config_spec)
    end

    def reconfigure_cluster(config_spec)
      @client.wait_for_task do
        @datacenter_cluster.reconfigure_ex(config_spec, true)
      end
    end

    def tagged_vms
      custom_attribute = @vm_attribute_manager.find_by_name(CUSTOM_ATTRIBUTE_NAME)
      return [] unless custom_attribute

      @cloud_searcher.get_managed_objects_with_attribute(
        VimSdk::Vim::VirtualMachine,
        custom_attribute.key,
        value: @rule_name
      )
    end
  end
end

