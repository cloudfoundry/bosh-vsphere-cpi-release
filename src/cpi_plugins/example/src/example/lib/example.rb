require 'cloud/vsphere/logger'
require 'cpi_plugin/plugin_base'
require 'cpi_plugin/plugin_helpers'
require 'yaml'

module VSphereCloud
  module CpiPlugin
    class Example < VSphereCloud::CpiPlugin::PluginBase

      # Examine the functions defined on PluginBase to see what callback hooks exist.
      # Search through vsphere_cpi/cloud.rb to see where those callback hooks are called
      # and what data is passed in to them. All hook points get a VSphereCloud::CpiPlugin::PluginCallContext
      # object instance passed in to them that has the CPI 'self' at the call site, and may contain additional
      # data, depending on the hook point.
      #
      # The behavior in this hook function is somewhat atypical. This function is doing double-duty as documentation
      # and as the testing mechanism for the plugin integration tests. It seems unlikely a plugin author would have
      # need to manipulate the CPI's config object, but we need SOME way to signal to to the integration tests that
      # the hook function was called, and that the plugin option processing code functions correctly.
      # However, if one ever DID need to manipulate the CPI's config object, this is one way one might do it.
      def self.has_vm_pre(context)
        logger = VSphereCloud::Logger.logger
        logger.info("Example CPI Plugin: has_vm_pre hook callback called.")
        context.cpi_self.config.instance_variable_get("@config").merge!({"example_plugin_has_vm_pre_called" => true,
          "configured_plugin_options" => context.plugin_options})
      end

      private

      # This serves to demonstrate how one might get the location for the configuration directory for one's plugin, and then
      # load a configuration file supplied by one's plugin release.
      def self.load_config_file
        logger = VSphereCloud::Logger.logger
        config_path = "#{VSphereCloud::CpiPlugin::Helpers.get_plugin_config_base_dir('example')}/config/configuration.yml"

        begin
          @config = YAML.load_file(config_path)
          logger.debug("Parsed config: #{config}")
        rescue => e
          logger.error("Failed to load config file: '#{config_path}'")
          logger.error(e)
        end
      end
    end
  end
end