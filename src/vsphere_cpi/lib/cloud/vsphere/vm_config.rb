module VSphereCloud
  class VmConfig

    attr_writer :manifest_params

    def initialize
      @manifest_params = {}
    end

    def name
      @vm_cid ||= "vm-#{SecureRandom.uuid}"
    end

    def cluster
      @manifest_params[:cluster]
    end

    def datastore
      @manifest_params[:datastore]
    end

    def ephemeral_disk_size
      @manifest_params[:ephemeral_disk_size]
    end

    def networks
      networks_spec = @manifest_params[:networks_spec] || {}
      networks_map = {}
      networks_spec.each_value do |network_spec|
        cloud_properties = network_spec['cloud_properties']
        unless cloud_properties.nil? || cloud_properties['name'].nil?
          name = cloud_properties['name']
          ip = network_spec['ip']
          networks_map[name] = ip
        end
      end
      networks_map
    end

    def config_spec_params
      params = {}
      params[:num_cpus] = resource_pool["cpu"]
      params[:memory_mb] = resource_pool["memory"]
      params[:nested_hv_enabled] = true if resource_pool["nested_hardware_virtualization"]
      params.delete_if { |k, v| v.nil? }
    end

    private

    def resource_pool
      @manifest_params[:resource_pool] || {}
    end

    def networks_spec
      @manifest_params[:resource_pool] || {}
    end

  end
end
