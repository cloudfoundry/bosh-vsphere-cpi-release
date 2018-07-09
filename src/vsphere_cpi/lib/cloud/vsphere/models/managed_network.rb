module VSphereCloud
  class ManagedNetwork
     def initialize(switch, range = nil, gateway = nil)
      @switch = switch
      @range = range
      @gateway = gateway
    end

    def created_network
      return {} if @range.nil?
      {range: @range,
       gateway: @gateway,
       reserved: []}
    end

    def to_a
      [ @switch.id, created_network, {name: @switch.display_name} ]
    end

    def to_json(opts)
      to_a.to_json
    end
  end
end