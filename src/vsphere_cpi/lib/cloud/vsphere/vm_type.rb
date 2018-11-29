require 'cloud/vsphere/storage_list'

module VSphereCloud
  class VmType
    include VSphereCloud::StorageList
    attr_reader :datacenter, :storage_list

    # @param [Resources::Datacenter] datacenter
    # @param [Hash] cloud_properties
    def initialize(datacenter, cloud_properties)
      @datacenter = datacenter
      @cloud_properties = cloud_properties
    end

    %w[cpu ram disk cpu_hot_add_enabled memory_hot_add_enabled nsx vmx_options
       nsxt nested_hardware_virtualization upgrade_hw_version datacenters vm_group].each do |name|
      define_method(name) { @cloud_properties[name] }
    end

    def storage_list
      @storage_list = @cloud_properties['datastores'] || []
    end

    def nsx_security_groups
      nsx['security_groups'] if nsx
    end

    def nsx_lbs
      nsx['lbs'] if nsx
    end

    def nsxt_server_pools
      nsxt&.dig('lb', 'server_pools')
    end

    def ns_groups
      nsxt&.dig('ns_groups')
    end
  end
end