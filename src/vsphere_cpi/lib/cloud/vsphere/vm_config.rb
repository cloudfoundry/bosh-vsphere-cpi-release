module VSphereCloud
  class VmConfig
    include Logger


    UUID_SUFFIX_LENGTH = 12
    DEPLOYMENT_NAME_LENGTH = 25
    MAX_VSPHERE_VM_NAME_LENGTH = 79

    #attr_accessor :vm_cid

    def initialize(manifest_params:, cluster_provider: nil)
      @manifest_params = manifest_params
      @cluster_provider = cluster_provider
    end

    def upgrade_hw_version?(vmtype_hw_version, global_hw_version)
      vmtype_hw_version.nil? ? global_hw_version : vmtype_hw_version
    end

    def name

      return @vm_cid if @vm_cid

      if not human_readable_name_enabled?
        @vm_cid = "vm-#{SecureRandom.uuid}"
        return @vm_cid
      end

      # might need change according to function get_name_info_from_bosh_env in cloud.rb
      # # update
      # # Since the human_readable_name_info relies on the correctness of environment,
      # # it is either have 2 keys or empty
      if human_readable_name_info.has_key?('instance_group_name') && human_readable_name_info.has_key?('deployment_name')
        @vm_cid = generate_human_readable_name(human_readable_name_info['instance_group_name'], human_readable_name_info['deployment_name'])
      ############################################################
      # these will be deleted if current deployment has no problem
      # ##########################################################
      # elsif  !human_readable_name_info.has_key?('instance_group_name') && !human_readable_name_info.has_key?('deployment_name')
      #   logger.info("Deployment and job name not found, will use default type of names")
      #   @vm_cid = "vm-#{SecureRandom.uuid}"
      # elsif !human_readable_name_info.has_key?('instance_group')
      #   logger.info("Deployment name not found, will use default type of names")
      #   @vm_cid = "vm-#{SecureRandom.uuid}"
      # else
      #   logger.info("Job name not found, will use default type of names")
      #
      #   @vm_cid = "vm-#{SecureRandom.uuid}"
      # end
      #
      else
        @vm_cid = "vm-#{SecureRandom.uuid}"
      end

      @vm_cid
    end

    def cluster_placements
      if has_custom_cluster_properties?
        clusters = find_clusters(resource_pool_clusters_spec)
      else
        validate_clusters
        clusters = global_clusters
      end
      cluster_placement_internal(clusters: clusters)
    end

    def drs_rule(cluster)
      cluster_name = cluster.name
      cluster_spec = resource_pool_clusters_spec.find { |cluster_spec| cluster_spec.keys.first == cluster_name }
      return nil if cluster_spec.nil? || cluster_spec[cluster_name].nil?
      cluster_spec[cluster_name].fetch('drs_rules', []).first
    end

    def ephemeral_disk_size
      vm_type.disk
    end

    def stemcell_cid
      stemcell[:cid]
    end

    def stemcell_size
      stemcell[:size]
    end

    def agent_id
      @manifest_params[:agent_id]
    end

    def agent_env
      @manifest_params[:agent_env]
    end

    # unit test passed
    # Question here
    def human_readable_name_enabled?
      @manifest_params[:enable_human_readable_name]
    end

    # unit test passed
    def human_readable_name_info
      @manifest_params.fetch(:human_readable_name_info, {})
    end

    def networks_spec
      @manifest_params[:networks_spec] || {}
    end

    # instance_name_deployment_name_12_uuid
    # instance and deployment should be less or equal to 65
    # for len_in and len_de
    #  if len_in + len_de <=65 won't cut
    #  else
    #     x = in + de -65 # need cut x in total
    #
    #     int max_cut_in = max(len_in - 15, 0 )
    #     int max_cut_dp = max(len_dp - 15, 0 )
    #
    #     while cut one of the name. we need to compare the other
    #     the other could be min(x/2, max_cut_in)
    #     make the length of dep be max (15, len_de - x/2)
    #     make the length of instance be
    #
    def generate_human_readable_name(instance_name, deployment_name)
      allowed_prefix_len = MAX_VSPHERE_VM_NAME_LENGTH - UUID_SUFFIX_LENGTH - 2 # current its 65
      uuid_suffix = SecureRandom.uuid.slice(-UUID_SUFFIX_LENGTH, UUID_SUFFIX_LENGTH)

      if instance_name.size + deployment_name.size <= allowed_prefix_len
        return "#{instance_name}_#{deployment_name}_#{uuid_suffix}"
      end

      cut_length = instance_name.size + deployment_name.size - allowed_prefix_len

      if deployment_name.size <= DEPLOYMENT_NAME_LENGTH
        readable_name = "#{instance_name.slice(0, instance_name.size - cut_length)}_#{deployment_name}_#{uuid_suffix}"
      else
        # eg. deployment name length is 80 and instance name length is 20, cut_length is 80 + 20 - 65 = 35
        # thus we can make instance name length as min (65 - 25, 20), which is 20
        # then we can calculate the allowed length of deployment  (65 - 20) which is larger than default value 25
        instance_name_length = [allowed_prefix_len -  DEPLOYMENT_NAME_LENGTH, instance_name.size].min
        readable_name = "#{instance_name.slice(0, instance_name_length)}_#{deployment_name.slice(0, allowed_prefix_len - instance_name_length)}_#{uuid_suffix}"
      end
      readable_name
    end

    def vsphere_networks
      networks_map = {}
      networks_spec.each_value do |network_spec|
        cloud_properties = network_spec['cloud_properties']
        unless cloud_properties.nil? || cloud_properties['name'].nil?
          name = cloud_properties['name']
          networks_map[name] ||= []
          networks_map[name] << network_spec['ip']
        end
      end
      networks_map
    end

    def config_spec_params
      params = {}
      params[:num_cpus] = vm_type.cpu
      params[:memory_mb] = vm_type.ram
      params[:nested_hv_enabled] = true if vm_type.nested_hardware_virtualization
      params[:cpu_hot_add_enabled] = true if vm_type.cpu_hot_add_enabled
      params[:memory_hot_add_enabled] = true if vm_type.memory_hot_add_enabled
      params.delete_if { |k, v| v.nil? }
    end


    def bosh_group
      if !agent_env['bosh'].nil? then
        return agent_env['bosh']['group']
      else
        return nil
      end
    end

    def vmx_options
      vm_type.vmx_options || {}
    end

    #VSphereCloud::VmType
    def vm_type
      @manifest_params[:vm_type]
    end

    def validate_drs_rules(cluster)
      cluster_name = cluster.name
      cluster_config = resource_pool_clusters_spec.find {|cluster_spec| cluster_spec.keys.first == cluster_name}
      return if cluster_config.nil?

      drs_rules = cluster_config[cluster_name]['drs_rules']
      return if drs_rules.nil?

      if drs_rules.size > 1
        raise 'vSphere CPI supports only one DRS rule per resource pool'
      end

      rule_config = drs_rules.first

      if rule_config['type'] != 'separate_vms'
        raise "vSphere CPI only supports DRS rule of 'separate_vms' type, not '#{rule_config['type']}'"
      end
    end

    private

    def has_custom_cluster_properties?
      # custom properties include drs_rules and vcenter resource_pools
      !resource_pool_clusters_spec.empty?
    end
    
    def find_clusters(clusters_spec)
      clusters_spec.map do |cluster_spec|
        ClusterConfig.new(cluster_spec.keys.first, cluster_spec.values.first)
      end.map do |cluster_config|
        @cluster_provider.find(cluster_config.name, cluster_config, vm_type.datacenter.name)
      end
    end

    def global_clusters
      @manifest_params[:global_clusters] || []
    end

    def stemcell
      @manifest_params[:stemcell] || {}
    end

    def disk_configurations
      @manifest_params[:disk_configurations] || {}
    end

    def datacenters_spec
      vm_type&.datacenters || []
    end

    def resource_pool_clusters_spec
      datacenter_spec = datacenters_spec.first || {}
      datacenter_spec.fetch('clusters', [])
    end

    def validate_clusters
      if global_clusters.empty? && !has_custom_cluster_properties?
        raise Bosh::Clouds::CloudError, 'No valid clusters were provided'
      end
    end

    def cluster_placement_internal(clusters:)
      return @cluster_placement if @cluster_placement

      vm_selection_placement_pipeline = VmPlacementSelectionPipeline.new(disk_config: disk_configurations, req_memory: vm_type.ram) do
        logger.info("Gathering vm placement resources for vm placement allocator pipeline")
        clusters.map do |cluster|
          VmPlacement.new(cluster: cluster, datastores: cluster.accessible_datastores.values, hosts: nil)
        end
      end
      @cluster_placement = vm_selection_placement_pipeline.each.to_a
      raise Bosh::Clouds::CloudError,
        'No valid placement found for VM compute and storage requirement' if @cluster_placement.first.nil?
      @cluster_placement
    end
  end
end
