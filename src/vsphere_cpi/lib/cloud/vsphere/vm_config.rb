module VSphereCloud
  class VmConfig

    def initialize(manifest_params:, cluster_picker: nil, cluster_provider: nil)
      @manifest_params = manifest_params
      @cluster_picker = cluster_picker
      @cluster_provider = cluster_provider
    end

    def name
      @vm_cid ||= "vm-#{SecureRandom.uuid}"
    end

    def cluster
      if has_custom_cluster_properties?
        clusters = find_clusters(resource_pool_clusters_spec)
        placement = cluster_placement(clusters: clusters)
        clusters.find {|cluster| cluster.name == placement.keys.first}
      else
        validate_clusters
        global_clusters.find do |cluster|
          cluster.name == cluster_placement(clusters: global_clusters).keys.first
        end
      end
    end

    def drs_rule
      cluster_name = cluster.name
      cluster_spec = resource_pool_clusters_spec.find { |cluster_spec| cluster_spec.keys.first == cluster_name }
      return nil if cluster_spec.nil? || cluster_spec[cluster_name].nil?
      cluster_spec[cluster_name].fetch('drs_rules', []).first
    end

    def ephemeral_datastore_name
      return nil if cluster.nil?
      return @datastore_name if @datastore_name

      ephemeral_disk = disk_configurations.find { |disk| disk.ephemeral? }
      cluster_placement(clusters: [cluster])[cluster.name][ephemeral_disk]
    end

    def ephemeral_disk_size
      vm_type['disk']
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
      params[:num_cpus] = vm_type['cpu']
      params[:memory_mb] = vm_type['ram']
      params[:nested_hv_enabled] = true if vm_type['nested_hardware_virtualization']
      params[:cpu_hot_add_enabled] = true if vm_type['cpu_hot_add_enabled']
      params[:memory_hot_add_enabled] = true if vm_type['memory_hot_add_enabled']
      params.delete_if { |k, v| v.nil? }
    end

    def validate
      validate_drs_rules
    end

    def bosh_group
      if !agent_env['bosh'].nil? then
        return agent_env['bosh']['group']
      else
        return nil
      end
    end

    def vmx_options
      vm_type['vmx_options'] || {}
    end

    def datastore_clusters
      @datastore_clusters ||= datastore_clusters_spec
    end

    def sdrs_enabled_datastore_clusters
      datastore_clusters.map do |datastore_cluster_spec|
        VSphereCloud::Resources::StoragePod.find(datastore_cluster_spec.keys.first, @cluster_provider.datacenter_name, @cluster_provider.client)
      end.select(&:drs_enabled?)
    end

    private

    def validate_drs_rules
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

    def vm_type
      @manifest_params[:vm_type] || {}
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
      vm_type['datacenters'] || []
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

    def cluster_placement(clusters:)
      return @cluster_placement if @cluster_placement

      @cluster_picker.update(clusters)
      @cluster_placement = @cluster_picker.best_cluster_placement(
        req_memory: vm_type['ram'],
        disk_configurations: disk_configurations,
      )
    end

    def datastore_clusters_spec
      datastore_clusters_spec = []
      return datastore_clusters_spec unless vm_type['datastores'] && vm_type['datastores'].any?
      vm_type['datastores'].each do |entry|
        hash = Hash.try_convert(entry)
        next if hash.nil?
        if hash.key?('clusters')
          datastore_clusters_spec = hash['clusters']
          break
        end
      end
      datastore_clusters_spec
    end
  end
end
