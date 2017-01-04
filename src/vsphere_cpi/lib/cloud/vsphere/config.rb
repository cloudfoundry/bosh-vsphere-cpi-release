module VSphereCloud
  class Config
    def self.build(config_hash)
      config = new(config_hash)
      config.validate
      config
    end

    SUPPORTED_DISK_TYPES = ['thin', 'preallocated']

    def initialize(config_hash)
      @config = config_hash

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

      if default_disk_type.nil?
        raise 'Missing required property: vcenters[0].default_disk_type'
      end

      unless SUPPORTED_DISK_TYPES.include?(default_disk_type)
        raise "Unsupported default_disk_type '#{default_disk_type}'. vSphere CPI only supports a default_disk_type of 'preallocated' or 'thin'"
      end

      validate_schema

      @is_validated = true
    end

    REQUIRED_NSX_OPTIONS = ['address', 'user', 'password']
    NSX_MANIFEST_LOCATION = '`jobs.bosh.properties.vcenter.nsx`'

    def nsx_enabled?
      vcenter['nsx'].nil? == false
    end

    def validate_nsx_options
      if vcenter['nsx'].nil?
        raise "Must specify global NSX config in your director manifest under #{NSX_MANIFEST_LOCATION}"
      end

      missing_properties = []
      REQUIRED_NSX_OPTIONS.each do | option |
        missing_properties << option if vcenter['nsx'][option].nil?
      end

      unless missing_properties.empty?
        missing_properties.map! { |p| "'#{p}'"}
        raise "Must specify the NSX config options #{missing_properties.join(', ')} in your director manifest under #{NSX_MANIFEST_LOCATION}"
      end

      true
    end

    def logger
      @logger ||= Bosh::Clouds::Config.logger
    end

    def soap_log
      if vcenter_http_logging
        config['soap_log'] || config['cpi_log']
      else
        nil
      end
    end

    def vcenter_http_logging
      vcenter['http_logging']
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
      vcenter['default_disk_type']
    end

    def vcenter_enable_auto_anti_affinity_drs_rules
      vcenter['enable_auto_anti_affinity_drs_rules']
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

    def nsx_url
      vcenter['nsx']['address']
    end

    def nsx_user
      vcenter['nsx']['user']
    end

    def nsx_password
      vcenter['nsx']['password']
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
            optional('http_logging') => bool,
            optional('enable_auto_anti_affinity_drs_rules') => bool,
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
