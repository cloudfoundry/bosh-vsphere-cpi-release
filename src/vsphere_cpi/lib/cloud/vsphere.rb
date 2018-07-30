require 'forwardable'
require 'securerandom'
require 'common/thread_pool'
require 'common/thread_formatter'
require 'ruby_vim_sdk'

require 'cloud/vsphere/retryer'
require 'cloud/vsphere/object_stringifier'
require 'cloud/vsphere/agent_env'
require 'cloud/vsphere/cloud'
require 'cloud/vsphere/cloud_searcher'
require 'cloud/vsphere/config'
require 'cloud/vsphere/cluster_config'
require 'cloud/vsphere/exception'
require 'cloud/vsphere/file_provider'
require 'cloud/vsphere/lease_obtainer'
require 'cloud/vsphere/lease_updater'
require 'cloud/vsphere/path_finder'
require 'cloud/vsphere/base_http_client'
require 'cloud/vsphere/cpi_http_client'
require 'cloud/vsphere/nsx_http_client'
require 'cloud/vsphere/vcenter_client'
require 'cloud/vsphere/resources/cluster_provider'
require 'cloud/vsphere/resources/cluster'
require 'cloud/vsphere/resources/datacenter'
require 'cloud/vsphere/resources/datastore'
require 'cloud/vsphere/resources/disk'
require 'cloud/vsphere/resources/nic'
require 'cloud/vsphere/resources/folder'
require 'cloud/vsphere/resources/vm'
require 'cloud/vsphere/resources/resource_pool'
require 'cloud/vsphere/resources/storage_pod'
require 'cloud/vsphere/resources/util'
require 'cloud/vsphere/resources/task'
require 'cloud/vsphere/drs_rules/drs_lock'
require 'cloud/vsphere/drs_rules/drs_rule'
require 'cloud/vsphere/drs_rules/vm_attribute_manager'
require 'cloud/vsphere/soap_stub'
require 'cloud/vsphere/vm_creator'
require 'cloud/vsphere/vm_provider'
require 'cloud/vsphere/stemcell'
require 'cloud/vsphere/ip_conflict_detector'
require 'cloud/vsphere/disk_config'
require 'cloud/vsphere/disk_pool'
require 'cloud/vsphere/storage_list'
require 'cloud/vsphere/vm_type'
require 'cloud/vsphere/vm_config'
require 'cloud/vsphere/storage_picker'
require 'cloud/vsphere/director_disk_cid'
require 'cloud/vsphere/nsx'
require 'cloud/vsphere/nsxt_provider'
require 'cloud/vsphere/task_runner'
require 'cloud/vsphere/sdk_helpers/log_filter'
require 'cloud/vsphere/sdk_helpers/retryable_stub_adapter'
require 'cloud/vsphere/sdk_helpers/retry_judge'
require 'cloud/vsphere/helpers/xml'
require 'nsxt/nsxt_client'
require 'cloud/vsphere/helpers/object_helpers'
require 'cloud/vsphere/network'
require 'cloud/vsphere/models/network_definition'
require 'cloud/vsphere/models/managed_network'
require 'cloud/vsphere/nsxt_helpers/nsxt_switch_provider'
require 'cloud/vsphere/nsxt_helpers/nsxt_api_client_builder'
require 'cloud/vsphere/nsxt_helpers/nsxt_router_provider'
require 'cloud/vsphere/nsxt_helpers/nsxt_ip_block_provider'
require 'cloud/vsphere/selection_pipeline'
require 'cloud/vsphere/disk_placement_selection_pipeline'
require 'cloud/vsphere/vm_placement_selection_pipeline'



module Bosh
  module Clouds
    class VSphere
      extend Forwardable

      def_delegators :@delegate,
                     :create_stemcell, :delete_stemcell,
                     :create_vm, :delete_vm, :reboot_vm, :has_vm?,
                     :set_vm_metadata,
                     :configure_networks,
                     :create_disk, :has_disk?, :delete_disk,
                     :attach_disk, :detach_disk,
                     :snapshot_disk, :delete_snapshot,
                     :current_vm_id, :get_disks, :ping, :resize_disk,
                     :calculate_vm_cloud_properties,
                     :info, :set_disk_metadata,
                     :create_network, :delete_network

      def initialize(options)
        @delegate = VSphereCloud::Cloud.new(options)
      end
    end

    Vsphere = VSphere # alias name for dynamic plugin loading
  end
end
