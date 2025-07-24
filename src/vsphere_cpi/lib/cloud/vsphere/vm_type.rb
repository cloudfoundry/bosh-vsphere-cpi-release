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

    CLOUD_PROPERTIES_HASH_PROXY_METHODS = %w[
      cpu
      cpu_hot_add_enabled
      cpu_reserve_full_mhz
      datacenters
      disable_drs
      disk
      memory_hot_add_enabled
      memory_reservation_locked_to_max
      nested_hardware_virtualization
      nsx
      nsxt
      pci_passthroughs
      ram
      root_disk_size_gb
      storage_policy
      tags
      upgrade_hw_version
      vgpus
      vm_group
      vmx_options
    ]

    CLOUD_PROPERTIES_HASH_PROXY_METHODS.each do |method_name|
      define_method(method_name) { @cloud_properties[method_name] }
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

    def disk_uuid_is_enabled?
      # Because of the vSphere vmx option disk.enableUUID the option here is a little different:
      # `{"disk.enableUUID": 1}` as a key instead of `{"disk": {"enableUUID: 1}}` See `vm.disk_uuid_is_enabled?`
      # for an explanation of the parameters.
      [1, '1', 'TRUE'].include? vmx_options&.dig('disk.enableUUID')
    end
  end
end
