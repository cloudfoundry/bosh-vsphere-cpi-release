=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Detail information about port attachment
  class PortAttachment
    # Not valid when type field is INDEPENDENT, mainly used to identify traffic from different ports in container use case. 
    attr_accessor :traffic_tag

    # Indicate how IP will be allocated for the port
    attr_accessor :allocate_addresses

    # Flag to indicate if hyperbus configuration is required.
    attr_accessor :hyperbus_mode

    # Set to PARENT when type field is CHILD. Read only field.
    attr_accessor :context_type

    # If type is CHILD and the parent port is on the same segment as the child port, then this field should be VIF ID of the parent port. If type is CHILD and the parent port is on a different segment, then this field should be policy path of the parent port. If type is INDEPENDENT/STATIC, then this field should be transport node ID. 
    attr_accessor :context_id

    # List of Evpn tenant VLAN IDs the Parent logical-port serves in Evpn Route-Server mode. Only effective when attachment type is PARENT and the logical-port is attached to vRouter VM.
    attr_accessor :evpn_vlans

    # Indicate application interface configuration for Bare Metal Server.
    attr_accessor :bms_interface_config

    # Type of port attachment. STATIC is added to replace INDEPENDENT. INDEPENDENT type and PARENT type are deprecated.
    attr_accessor :type

    # ID used to identify/look up a child attachment behind a parent attachment 
    attr_accessor :app_id

    # VIF UUID on NSX Manager. If the attachement type is PARENT, this property is required.
    attr_accessor :id

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
        :'traffic_tag' => :'traffic_tag',
        :'allocate_addresses' => :'allocate_addresses',
        :'hyperbus_mode' => :'hyperbus_mode',
        :'context_type' => :'context_type',
        :'context_id' => :'context_id',
        :'evpn_vlans' => :'evpn_vlans',
        :'bms_interface_config' => :'bms_interface_config',
        :'type' => :'type',
        :'app_id' => :'app_id',
        :'id' => :'id'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'traffic_tag' => :'Integer',
        :'allocate_addresses' => :'String',
        :'hyperbus_mode' => :'String',
        :'context_type' => :'String',
        :'context_id' => :'String',
        :'evpn_vlans' => :'Array<String>',
        :'bms_interface_config' => :'AttachedInterfaceEntry',
        :'type' => :'String',
        :'app_id' => :'String',
        :'id' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'traffic_tag')
        self.traffic_tag = attributes[:'traffic_tag']
      end

      if attributes.has_key?(:'allocate_addresses')
        self.allocate_addresses = attributes[:'allocate_addresses']
      end

      if attributes.has_key?(:'hyperbus_mode')
        self.hyperbus_mode = attributes[:'hyperbus_mode']
      else
        self.hyperbus_mode = 'DISABLE'
      end

      if attributes.has_key?(:'context_type')
        self.context_type = attributes[:'context_type']
      end

      if attributes.has_key?(:'context_id')
        self.context_id = attributes[:'context_id']
      end

      if attributes.has_key?(:'evpn_vlans')
        if (value = attributes[:'evpn_vlans']).is_a?(Array)
          self.evpn_vlans = value
        end
      end

      if attributes.has_key?(:'bms_interface_config')
        self.bms_interface_config = attributes[:'bms_interface_config']
      end

      if attributes.has_key?(:'type')
        self.type = attributes[:'type']
      end

      if attributes.has_key?(:'app_id')
        self.app_id = attributes[:'app_id']
      end

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
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
      allocate_addresses_validator = EnumAttributeValidator.new('String', ['IP_POOL', 'MAC_POOL', 'BOTH', 'NONE', 'DHCP'])
      return false unless allocate_addresses_validator.valid?(@allocate_addresses)
      hyperbus_mode_validator = EnumAttributeValidator.new('String', ['ENABLE', 'DISABLE'])
      return false unless hyperbus_mode_validator.valid?(@hyperbus_mode)
      context_type_validator = EnumAttributeValidator.new('String', ['PARENT'])
      return false unless context_type_validator.valid?(@context_type)
      type_validator = EnumAttributeValidator.new('String', ['PARENT', 'CHILD', 'INDEPENDENT', 'STATIC'])
      return false unless type_validator.valid?(@type)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] allocate_addresses Object to be assigned
    def allocate_addresses=(allocate_addresses)
      validator = EnumAttributeValidator.new('String', ['IP_POOL', 'MAC_POOL', 'BOTH', 'NONE', 'DHCP'])
      unless validator.valid?(allocate_addresses)
        fail ArgumentError, 'invalid value for "allocate_addresses", must be one of #{validator.allowable_values}.'
      end
      @allocate_addresses = allocate_addresses
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] hyperbus_mode Object to be assigned
    def hyperbus_mode=(hyperbus_mode)
      validator = EnumAttributeValidator.new('String', ['ENABLE', 'DISABLE'])
      unless validator.valid?(hyperbus_mode)
        fail ArgumentError, 'invalid value for "hyperbus_mode", must be one of #{validator.allowable_values}.'
      end
      @hyperbus_mode = hyperbus_mode
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] context_type Object to be assigned
    def context_type=(context_type)
      validator = EnumAttributeValidator.new('String', ['PARENT'])
      unless validator.valid?(context_type)
        fail ArgumentError, 'invalid value for "context_type", must be one of #{validator.allowable_values}.'
      end
      @context_type = context_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] type Object to be assigned
    def type=(type)
      validator = EnumAttributeValidator.new('String', ['PARENT', 'CHILD', 'INDEPENDENT', 'STATIC'])
      unless validator.valid?(type)
        fail ArgumentError, 'invalid value for "type", must be one of #{validator.allowable_values}.'
      end
      @type = type
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          traffic_tag == o.traffic_tag &&
          allocate_addresses == o.allocate_addresses &&
          hyperbus_mode == o.hyperbus_mode &&
          context_type == o.context_type &&
          context_id == o.context_id &&
          evpn_vlans == o.evpn_vlans &&
          bms_interface_config == o.bms_interface_config &&
          type == o.type &&
          app_id == o.app_id &&
          id == o.id
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [traffic_tag, allocate_addresses, hyperbus_mode, context_type, context_id, evpn_vlans, bms_interface_config, type, app_id, id].hash
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
