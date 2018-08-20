module VSphereCloud
  class VmConfig
    include Logger

    def initialize(manifest_params:, cluster_provider: nil)
      @manifest_params = manifest_params
      @cluster_provider = cluster_provider
    end

    def upgrade_hw_version?(vmtype_hw_version, global_hw_version)
      vmtype_hw_version.nil? ? global_hw_version : vmtype_hw_version
    end

    def name
      @vm_cid ||= "vm-#{SecureRandom.uuid}"
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

    def networks_spec
      @manifest_params[:networks_spec] || {}
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

    def gpu_conf
      vm_type.gpu
    end

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
      clusters = []
      clusters_spec.each do |cluster_spec|
        cluster_config = ClusterConfig.new(cluster_spec.keys.first, cluster_spec.values.first)
        clusters.push(@cluster_provider.find(cluster_spec.keys.first, cluster_config))
      end
      clusters
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



      vm_selection_placement_pipeline = VmPlacementSelectionPipeline.new(disk_config: disk_configurations, req_memory: vm_type.ram, num_gpu: vm_type.num_gpus) do
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
