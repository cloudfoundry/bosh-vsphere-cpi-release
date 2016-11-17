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
require 'cloud/vsphere/resources/helpers/disks'
require 'cloud/vsphere/resources/ephemeral_disk'
require 'cloud/vsphere/resources/persistent_disk'
require 'cloud/vsphere/resources/nic'
require 'cloud/vsphere/resources/folder'
require 'cloud/vsphere/resources/vm'
require 'cloud/vsphere/resources/resource_pool'
require 'cloud/vsphere/resources/util'
require 'cloud/vsphere/resources/task'
require 'cloud/vsphere/drs_rules/drs_lock'
require 'cloud/vsphere/drs_rules/drs_rule'
require 'cloud/vsphere/drs_rules/vm_attribute_manager'
require 'cloud/vsphere/soap_stub'
require 'cloud/vsphere/vm_creator'
require 'cloud/vsphere/vm_provider'
require 'cloud/vsphere/ip_conflict_detector'
require 'cloud/vsphere/disk_configs'
require 'cloud/vsphere/vm_config'
require 'cloud/vsphere/datastore_picker'
require 'cloud/vsphere/cluster_picker'
require 'cloud/vsphere/disk_metadata'
require 'cloud/vsphere/nsx'
require 'cloud/vsphere/task_runner'
require 'cloud/vsphere/sdk_helpers/log_filter'
require 'cloud/vsphere/sdk_helpers/retryable_stub_adapter'
require 'cloud/vsphere/sdk_helpers/retry_judge'
require 'cloud/vsphere/helpers/xml'

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
                     :current_vm_id, :get_disks, :ping,
                     :calculate_vm_cloud_properties

      def initialize(options)
        @delegate = VSphereCloud::Cloud.new(options)
      end
    end

    Vsphere = VSphere # alias name for dynamic plugin loading
  end
end
