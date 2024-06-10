require 'cloud/vsphere/logger'
require 'cpi_plugin/plugin_base'

module VSphereCloud
  module CpiPlugin
    class Registry
      def initialize(plugins)
        @logger = VSphereCloud::Logger.logger
        @plugin_objects = []

        load_path = ENV['BOSH_PACKAGES_DIR']
        if load_path.nil? || load_path == ''
          @logger.debug("CpiPlugin::Registry: BOSH_PACKAGES_DIR environment variable is not set; using default load path '/var/vcap/packages'")
          load_path = '/var/vcap/packages/'
        end

        @logger.debug("CpiPlugin::Registry: Initializing with plugin list #{plugins}")
        plugins.each do |plugin|
          @logger.debug("CpiPlugin::Registry: Initializing plugin  '#{plugin}'")
          path = "#{load_path}/#{plugin}/lib"
          $LOAD_PATH.push(path)
          begin
            require plugin
          rescue LoadError => e
            @logger.error("CpiPlugin::Registry: Unable to load plugin '#{plugin}' from path '#{path}' with $LOAD_PATH #{$LOAD_PATH}")
            @logger.error(e)
            raise e
          end

          plugin_obj = Object.const_get("VSphereCloud::CpiPlugin::#{plugin.capitalize}")
          @plugin_objects.push({:plugin_object => plugin_obj, :plugin_name => plugin})
        end
      end

      def run_pre_hooks(cpi_method, cpi_self, context = {})
        plugin_method = "#{cpi_method}_pre"
        if cpi_method == :has_vm?
          plugin_method = 'has_vm_pre'
        elsif cpi_method == :has_disk?
          plugin_method = 'has_disk_pre'
        end

        @plugin_objects.each do |p_obj|
          plugin_object = p_obj[:plugin_object]
          plugin_name = p_obj[:plugin_name]
          context_object = VSphereCloud::CpiPlugin::PluginCallContext.new(plugin_name, cpi_self, context)
          plugin_object.send(plugin_method, context_object)
        end
        return nil
      end

      def run_post_hooks(cpi_method, cpi_self, context = {})
        plugin_method = "#{cpi_method}_post"
        if cpi_method == :has_vm?
          plugin_method = 'has_vm_post'
        elsif cpi_method == :has_disk?
          plugin_method = 'has_disk_post'
        end

        @plugin_objects.each do |p_obj|
          plugin_object = p_obj[:plugin_object]
          plugin_name = p_obj[:plugin_name]
          context_object = VSphereCloud::CpiPlugin::PluginCallContext.new(plugin_name, cpi_self, context)
          plugin_object.send(plugin_method, context_object)
        end
        return nil
      end
    end
  end
end
