=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Advanced configuration for Segment
  class SegmentAdvancedConfig
    # Connectivity configuration to manually connect (ON) or disconnect (OFF) a Tier1 segment from corresponding Tier1 gateway. Only valid for Tier1 Segments. This property is ignored for L2 VPN extended segments when subnets property is not specified. 
    attr_accessor :connectivity

    # An ordered list of routing policies to forward traffic to the next hop. 
    attr_accessor :local_egress_routing_policies

    # Enable multicast on the downlink LRP created to connect the segment to Tier0/Tier1 gateway.  Enabled by default, even when segment.advanced_config property is not specified. 
    attr_accessor :multicast

    # When set to true, any port attached to this logical switch will not be visible through VC/ESX UI 
    attr_accessor :inter_router

    # The name of the switching uplink teaming policy for the Segment. This name corresponds to one of the switching uplink teaming policy names listed in TransportZone associated with the Segment. See transport_zone_path property above for more details. When this property is not specified, the segment will not have a teaming policy associated with it and the host switch's default teaming policy will be used by MP.
    attr_accessor :uplink_teaming_policy_name

    # Policy path to IP address pools. 
    attr_accessor :address_pool_paths

    # This profile is applie dto the downlink logical router port created while attaching this semgnet to tier-0 or tier-1. If this field is empty, NDRA profile of the router is applied to the newly created port. 
    attr_accessor :ndra_profile_path

    # When set to true, all the ports created on this segment will behave in a hybrid fashion. The hybrid port indicates to NSX that the VM intends to operate in underlay mode, but retains the ability to forward egress traffic to the NSX overlay network. This property is only applicable for segment created with transport zone type OVERLAY_STANDARD. This property cannot be modified after segment is created. 
    attr_accessor :hybrid

    # This URPF mode is applied to the downlink logical router port created while attaching this segment to tier-0 or tier-1. 
    attr_accessor :urpf_mode

    # This property is used to enable proximity routing with local egress. When set to true, logical router interface (downlink) connecting Segment to Tier0/Tier1 gateway is configured with prefix-length 32. 
    attr_accessor :local_egress

    class EnumAttributeValidator
      attr_reader :datatype
      attr_reader :allowable_values

      def initialize(datatype, allowable_values)
        @allowable_values = allowable_values.map do |value|
          case datatype.to_s
          when /Integer/i
            value.to_i
          when /Float/i
            value.to_f
          else
            value
          end
        end
      end

      def valid?(value)
        !value || allowable_values.include?(value)
      end
    end

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'connectivity' => :'connectivity',
        :'local_egress_routing_policies' => :'local_egress_routing_policies',
        :'multicast' => :'multicast',
        :'inter_router' => :'inter_router',
        :'uplink_teaming_policy_name' => :'uplink_teaming_policy_name',
        :'address_pool_paths' => :'address_pool_paths',
        :'ndra_profile_path' => :'ndra_profile_path',
        :'hybrid' => :'hybrid',
        :'urpf_mode' => :'urpf_mode',
        :'local_egress' => :'local_egress'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'connectivity' => :'String',
        :'local_egress_routing_policies' => :'Array<LocalEgressRoutingEntry>',
        :'multicast' => :'BOOLEAN',
        :'inter_router' => :'BOOLEAN',
        :'uplink_teaming_policy_name' => :'String',
        :'address_pool_paths' => :'Array<String>',
        :'ndra_profile_path' => :'String',
        :'hybrid' => :'BOOLEAN',
        :'urpf_mode' => :'String',
        :'local_egress' => :'BOOLEAN'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'connectivity')
        self.connectivity = attributes[:'connectivity']
      else
        self.connectivity = 'ON'
      end

      if attributes.has_key?(:'local_egress_routing_policies')
        if (value = attributes[:'local_egress_routing_policies']).is_a?(Array)
          self.local_egress_routing_policies = value
        end
      end

      if attributes.has_key?(:'multicast')
        self.multicast = attributes[:'multicast']
      end

      if attributes.has_key?(:'inter_router')
        self.inter_router = attributes[:'inter_router']
      else
        self.inter_router = false
      end

      if attributes.has_key?(:'uplink_teaming_policy_name')
        self.uplink_teaming_policy_name = attributes[:'uplink_teaming_policy_name']
      end

      if attributes.has_key?(:'address_pool_paths')
        if (value = attributes[:'address_pool_paths']).is_a?(Array)
          self.address_pool_paths = value
        end
      end

      if attributes.has_key?(:'ndra_profile_path')
        self.ndra_profile_path = attributes[:'ndra_profile_path']
      end

      if attributes.has_key?(:'hybrid')
        self.hybrid = attributes[:'hybrid']
      else
        self.hybrid = false
      end

      if attributes.has_key?(:'urpf_mode')
        self.urpf_mode = attributes[:'urpf_mode']
      else
        self.urpf_mode = 'STRICT'
      end

      if attributes.has_key?(:'local_egress')
        self.local_egress = attributes[:'local_egress']
      else
        self.local_egress = false
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      connectivity_validator = EnumAttributeValidator.new('String', ['ON', 'OFF'])
      return false unless connectivity_validator.valid?(@connectivity)
      urpf_mode_validator = EnumAttributeValidator.new('String', ['NONE', 'STRICT'])
      return false unless urpf_mode_validator.valid?(@urpf_mode)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] connectivity Object to be assigned
    def connectivity=(connectivity)
      validator = EnumAttributeValidator.new('String', ['ON', 'OFF'])
      unless validator.valid?(connectivity)
        fail ArgumentError, 'invalid value for "connectivity", must be one of #{validator.allowable_values}.'
      end
      @connectivity = connectivity
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] urpf_mode Object to be assigned
    def urpf_mode=(urpf_mode)
      validator = EnumAttributeValidator.new('String', ['NONE', 'STRICT'])
      unless validator.valid?(urpf_mode)
        fail ArgumentError, 'invalid value for "urpf_mode", must be one of #{validator.allowable_values}.'
      end
      @urpf_mode = urpf_mode
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          connectivity == o.connectivity &&
          local_egress_routing_policies == o.local_egress_routing_policies &&
          multicast == o.multicast &&
          inter_router == o.inter_router &&
          uplink_teaming_policy_name == o.uplink_teaming_policy_name &&
          address_pool_paths == o.address_pool_paths &&
          ndra_profile_path == o.ndra_profile_path &&
          hybrid == o.hybrid &&
          urpf_mode == o.urpf_mode &&
          local_egress == o.local_egress
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [connectivity, local_egress_routing_policies, multicast, inter_router, uplink_teaming_policy_name, address_pool_paths, ndra_profile_path, hybrid, urpf_mode, local_egress].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end # or else data not found in attributes(hash), not an issue as the data can be optional
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :DateTime
        DateTime.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :BOOLEAN
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        temp_model = NSXTPolicy.const_get(type).new
        temp_model.build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        next if value.nil?
        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end

  end
end
