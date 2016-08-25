module VSphereCloud
  class Config
    def self.build(config_hash)
      config = new(config_hash)
      config.validate
      config
    end

    DEFAULT_DISK_TYPE = 'preallocated'
    SUPPORTED_DISK_TYPES = ['thin', 'preallocated', nil]

    def initialize(config_hash)
      @config = config_hash
      @vcenter_host = nil
      @vcenter_user = nil
      @vcenter_password = nil

      @is_validated = false
    end

    def validate
      return true if @is_validated

      unless config['vcenters'].size == 1
        raise 'vSphere CPI only supports a single vCenter'
      end

      unless config['vcenters'].first['datacenters'].size ==1
        raise 'vSphere CPI only supports a single datacenter'
      end

      default_disk_type = config['vcenters'].first['default_disk_type']
      unless SUPPORTED_DISK_TYPES.include?(default_disk_type)
        raise "Unsupported default_disk_type '#{default_disk_type}'. vSphere CPI only supports a default_disk_type of 'preallocated' or 'thin'"
      end

      validate_schema

      @is_validated = true
    end

    def logger
      @logger ||= Bosh::Clouds::Config.logger
    end

    def soap_log
      config['soap_log'] || config['cpi_log']
    end

    def agent
      config['agent']
    end

    def vcenter_host
      vcenter['host']
    end

    def vcenter_api_uri
      URI.parse("https://#{vcenter_host}/sdk/vimService")
    end

    def vcenter_user
      vcenter['user']
    end

    def vcenter_password
      vcenter['password']
    end

    def vcenter_default_disk_type
      vcenter['default_disk_type'] || DEFAULT_DISK_TYPE
    end

    def datacenter_name
      vcenter_datacenter['name']
    end

    def datacenter_vm_folder
      vcenter_datacenter['vm_folder']
    end

    def datacenter_template_folder
      vcenter_datacenter['template_folder']
    end

    def datacenter_disk_path
      vcenter_datacenter['disk_path']
    end

    def datacenter_datastore_pattern
      vcenter_datacenter['datastore_pattern']
    end

    def datacenter_persistent_datastore_pattern
      vcenter_datacenter['persistent_datastore_pattern']
    end

    def datacenter_clusters
      @cluster_objs ||= cluster_objs
    end

    def datacenter_use_sub_folder
      datacenter_clusters.any? { |_, cluster| cluster.resource_pool } ||
        !!vcenter_datacenter['use_sub_folder']
    end

    private

    attr_reader :config

    def is_validated?
      raise 'Configuration has not been validated' unless @is_validated
    end

    def vcenter
      config['vcenters'].first
    end

    def vcenter_datacenter
      vcenter['datacenters'].first
    end

    def validate_schema
      # Membrane schema for the provided config.
      schema = Membrane::SchemaParser.parse do
        {
          'agent' => dict(String, Object), # passthrough to the agent
          optional('cpi_log') => enum(String, Object),
          optional('soap_log') => enum(String, Object),
          'vcenters' => [{
            'host' => String,
            'user' => String,
            'password' => String,
            'datacenters' => [{
              'name' => String,
              'vm_folder' => String,
              'template_folder' => String,
              optional('use_sub_folder') => bool,
              'disk_path' => String,
              'datastore_pattern' => String,
              'persistent_datastore_pattern' => String,
              optional('allow_mixed_datastores') => bool,
              'clusters' => [enum(String, dict(String, {optional('resource_pool') => String})
              )]
            }]
          }]
        }
      end

      schema.validate(config)
    end

    def cluster_objs
      cluster_objs = {}
      vcenter_datacenter['clusters'].each do |cluster|
        if cluster.is_a?(Hash)
          name = cluster.keys.first
          cluster_objs[name] = ClusterConfig.new(name, cluster[name])
        else
          cluster_objs[cluster] = ClusterConfig.new(cluster, {})
        end
      end
      cluster_objs
    end
  end

end
