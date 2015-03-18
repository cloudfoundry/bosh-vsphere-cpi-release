require 'forwardable'
require 'securerandom'
require 'common/thread_pool'
require 'common/thread_formatter'

module VSphereCloud
  autoload :Cloud, 'cloud/vsphere/cloud'
end

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
                     :current_vm_id, :get_disks, :ping, :disk_provider

      def initialize(options)
        @delegate = VSphereCloud::Cloud.new(options)
      end
    end

    Vsphere = VSphere # alias name for dynamic plugin loading
  end
end
