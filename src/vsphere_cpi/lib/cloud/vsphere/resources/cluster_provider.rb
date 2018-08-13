module VSphereCloud
  module Resources
    class ClusterProvider
      attr_reader :client, :datacenter_name

      def initialize(options)
        @datacenter_name = options.fetch(:datacenter_name)
        @client = options.fetch(:client)
      end

      # TODO: Add tests for this
      def find(name, config)
        cluster_mob = cluster_mobs[name]
        raise "Can't find cluster '#{name}'" if cluster_mob.nil?

        cluster_properties = @client.cloud_searcher.get_properties(
          cluster_mob, VimSdk::Vim::ClusterComputeResource,
          Cluster::PROPERTIES, :ensure_all => true
        )
        raise "Can't find properties for cluster '#{name}'" if cluster_properties.nil?

        Cluster.new(
          config,
          cluster_properties,
          @client
        )
      end

      # Delete VM Groups if they are empty
      # @param [Vim::ClusterComputeResource] cluster
      # @param [String[]] vm_group_names - List of VM Groups
      def delete_vm_groups(cluster, vm_group_names)
        return if vm_group_names.empty?
        vm_attribute_manager = VMAttributeManager.new(@client.service_content.custom_fields_manager)
        DrsLock.new(vm_attribute_manager, DrsRule::DRS_LOCK_SUFFIX_VMGROUP ).with_drs_lock do
          empty_vm_groups = cluster.configuration_ex.group.select do |group|
            group.is_a?(VimSdk::Vim::Cluster::VmGroup) && vm_group_names.include?(group.name) && group.vm.empty?
          end
          return if empty_vm_groups.empty?
          group_specs = empty_vm_groups.collect do |vm_group|
            vm_group_spec = VimSdk::Vim::Cluster::VmGroup.new
            vm_group_spec.name = vm_group.name

            group_spec = VimSdk::Vim::Cluster::GroupSpec.new
            group_spec.info = vm_group_spec
            group_spec.operation =  VimSdk::Vim::Option::ArrayUpdateSpec::Operation::REMOVE
            group_spec.remove_key = vm_group.name
            group_spec
          end
          config_spec = VimSdk::Vim::Cluster::ConfigSpecEx.new
          config_spec.group_spec = group_specs
          @client.wait_for_task do
            cluster.reconfigure_ex(config_spec, true)
          end
        end
      end

      private

      def datacenter_mob
        mob = @client.find_by_inventory_path(@datacenter_name)
        raise "Datacenter '#{@datacenter_name}' not found" if mob.nil?
        mob
      end

      def cluster_mobs
        @cluster_mobs ||= begin
          cluster_tuples = @client.cloud_searcher.get_managed_objects(
            VimSdk::Vim::ClusterComputeResource,
            root: datacenter_mob,
            include_name: true
          )
          Hash[*(cluster_tuples.flatten)]
        end
      end
    end
  end
end
