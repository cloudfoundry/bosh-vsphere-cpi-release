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

    def network_names
      networks_spec = @manifest_params[:networks_spec] || {}
      names = []
      networks_spec.each_value do |network_spec|
        cloud_properties = network_spec['cloud_properties']
        names << cloud_properties['name'] unless cloud_properties.nil? || cloud_properties['name'].nil?
      end
      names
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
