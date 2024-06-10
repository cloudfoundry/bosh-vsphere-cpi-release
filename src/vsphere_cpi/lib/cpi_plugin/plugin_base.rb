require 'cpi_plugin/plugin_helpers'

module VSphereCloud
  module CpiPlugin
    class PluginCallContext
      def initialize(plugin_name, cpi_self, call_specific_hash)
        @plugin_name = plugin_name
        @plugin_active = !cpi_self.config.plugins.nil? && !cpi_self.config.plugins[plugin_name].nil?
        @cpi_self = cpi_self

        @call_specific_hash = call_specific_hash

        if !cpi_self.config.plugins.nil?
          @plugin_options = cpi_self.config.plugins[@plugin_name]
        else
          @plugin_options = {}
        end
      end

      def is_plugin_active?
        @plugin_active
      end

      def plugin_options
        @plugin_options
      end

      def plugin_cloud_properties
        if @plugin_cloud_properties.nil?
          @plugin_cloud_properties = VSphereCloud::CpiPlugin::Helpers::create_plugin_cloud_properties(@plugin_name, @call_specific_hash.fetch(:cloud_properties, {}))
        end

        @plugin_cloud_properties
      end

      def vm_config
        @call_specific_hash.fetch(:vm_config, nil)
      end

      def vm_cid
        @call_specific_hash.fetch(:vm_cid, nil)
      end

      def vm_ip
        @call_specific_hash.fetch(:vm_ip, nil)
      end

      def cpi_self
        @cpi_self
      end
    end

    class PluginBase
      def self.attach_disk_pre(plugin_call_context) end
      def self.attach_disk_post(plugin_call_context) end
      def self.calculate_vm_cloud_properties_pre(plugin_call_context) end
      def self.calculate_vm_cloud_properties_post(plugin_call_context) end
      def self.create_disk_pre(plugin_call_context) end
      def self.create_disk_post(plugin_call_context) end
      def self.create_stemcell_pre(plugin_call_context) end
      def self.create_stemcell_post(plugin_call_context) end
      def self.create_network_pre(plugin_call_context) end
      def self.create_network_post(plugin_call_context) end
      def self.create_vm_pre(plugin_call_context) end
      def self.create_vm_post(plugin_call_context) end
      def self.delete_disk_pre(plugin_call_context) end
      def self.delete_disk_post(plugin_call_context) end
      def self.delete_snapshot_pre(plugin_call_context) end
      def self.delete_snapshot_post(plugin_call_context) end
      def self.delete_stemcell_pre(plugin_call_context) end
      def self.delete_stemcell_post(plugin_call_context) end
      def self.delete_network_pre(plugin_call_context) end
      def self.delete_network_post(plugin_call_context) end
      def self.delete_vm_pre(plugin_call_context) end
      def self.delete_vm_post(plugin_call_context) end
      def self.detach_disk_pre(plugin_call_context) end
      def self.detach_disk_post(plugin_call_context) end
      def self.get_disks_pre(plugin_call_context) end
      def self.get_disks_post(plugin_call_context) end
      def self.has_disk_pre(plugin_call_context) end
      def self.has_disk_post(plugin_call_context) end
      def self.has_vm_pre(plugin_call_context) end
      def self.has_vm_post(plugin_call_context) end
      def self.info_pre(plugin_call_context) end
      def self.info_post(plugin_call_context) end
      def self.reboot_vm_pre(plugin_call_context) end
      def self.reboot_vm_post(plugin_call_context) end
      def self.resize_disk_pre(plugin_call_context) end
      def self.resize_disk_post(plugin_call_context) end
      def self.set_disk_metadata_pre(plugin_call_context) end
      def self.set_disk_metadata_post(plugin_call_context) end
      def self.set_vm_metadata_pre(plugin_call_context) end
      def self.set_vm_metadata_post(plugin_call_context) end
      def self.snapshot_disk_pre(plugin_call_context) end
      def self.snapshot_disk_post(plugin_call_context) end
    end
  end
end