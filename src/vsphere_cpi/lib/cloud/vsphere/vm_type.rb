require 'cloud/vsphere/storage_list'

module VSphereCloud
  class VmType
    include VSphereCloud::StorageList
    attr_reader :datacenter, :storage_list

    # @param [Resources::Datacenter] datacenter
    # @param [Hash] cloud_properties
    # @param [Pbm] pbm
    def initialize(datacenter, cloud_properties, pbm)
      @datacenter = datacenter
      @cloud_properties = cloud_properties
      @pbm = pbm
    end

    %w[cpu ram disk cpu_hot_add_enabled memory_hot_add_enabled nsx vmx_options cpu_reserve_full_mhz
       nsxt nested_hardware_virtualization memory_reservation_locked_to_max upgrade_hw_version datacenters vm_group disable_drs storage_policy tags].each do |name|
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

    def storage_policy_name
      storage_policy&.dig('name')
    end

    # Datastores compatible with given storage policy
    def storage_policy_datastores(policy_name)
      policy_name ? @pbm.find_compatible_datastores(policy_name, @datacenter) : []
    end
  end
end