module VSphereCloud
  class ClusterConfig
    attr_reader :name

    def initialize(name, config_hash)
      @name = name
      @config = config_hash
    end

    def host_group_name
      if @config.dig('host_group').is_a?(Hash)
        @config.dig('host_group', 'name')
      else
        @config['host_group']
      end
    end

    # Returns default ype should if drs_rule is not specified.
    def host_group_drs_rule
      if @config.dig('host_group').is_a?(Hash)
        host_group_drs_rule = @config.dig('host_group', 'drs_rule')
        unless host_group_drs_rule.nil?
          return host_group_drs_rule
        end
        'SHOULD'
      else
        'MUST'
      end
    end

    def resource_pool
      @config['resource_pool']
    end
  end
end
