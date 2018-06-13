module VSphereCloud
  class NSXTSwitchProvider
    include Logger

    def initialize(client)
      @client = client
    end

    def create_logical_switch(transport_zone_id, opts = {})
      switch_opts = {admin_state: 'UP',
              transport_zone_id: transport_zone_id,
              replication_mode: 'MTEP'}
      if opts[:name]
        switch_opts[:display_name] = opts[:name]
      end
      if opts[:tags]
        switch_opts[:tags] = opts[:tags]
      end
      switch = NSXT::LogicalSwitch.new(switch_opts)
      switch_api.create_logical_switch(switch)
    end

    def delete_logical_switch(switch_id)
      switch_api.delete_logical_switch(switch_id, cascade: true, detach: true)
    end

    def get_attached_switch_ports(switch_id)
      switch_api.list_logical_ports(logical_switch_id: switch_id).results
    end

    def get_switch_by_id(switch_id)
      switch_api.get_logical_switch(switch_id)
    end

    def get_switches_by_name(switch_name)
      switch_api.list_logical_switches.results.find_all do |switch|
        switch.display_name == switch_name
      end
    end

    def create_logical_port(switch_id)
      begin
        logical_port = NSXT::LogicalPort.new({admin_state: 'UP',
                                              logical_switch_id: switch_id})
        return switch_api.create_logical_port(logical_port)
      rescue => e
        logger.error("Failed to create logical port for switch #{switch_id}. Exception: #{e.inspect}")
        raise "Failed to create logical port for switch #{switch_id}. Exception: #{e.inspect}"
      end
    end

    private

    def switch_api
      @switch_api ||= NSXT::LogicalSwitchingApi.new(@client)
    end
  end
end