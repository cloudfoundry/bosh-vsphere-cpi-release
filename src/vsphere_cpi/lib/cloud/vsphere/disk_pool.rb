require 'cloud/vsphere/storage_list'

module VSphereCloud
  class DiskPool
    include VSphereCloud::StorageList
    attr_reader :datacenter, :storage_list

    # @param [Resources::Datacenter] datacenter
    # @param [Hash] storage_list is a list of datastores and datastore_clusters defined as 'datastores' in cloud_properties.
    def initialize(datacenter, storage_list)
      @datacenter = datacenter
      @storage_list = storage_list || []
    end
  end
end