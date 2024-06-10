module VSphereCloud
  module CpiPlugin
    module Helpers
      def self.create_plugin_cloud_properties(plugin_name, cloud_properties)
        cloud_properties.fetch("plugins", {}).fetch(plugin_name, {})
      end

      def self.get_plugin_config_base_dir(plugin_name = '')
        jobs_dir_env = ENV['BOSH_JOBS_DIR']
        if jobs_dir_env.nil?
          return "/var/vcap/jobs/#{plugin_name}/"
        else
          return "#{jobs_dir_env}/#{plugin_name}/"
        end
      end
    end
  end
end
