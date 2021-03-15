=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXT
  class VifAttachmentContext
    # A flag to indicate whether to allocate addresses from allocation     pools bound to the parent logical switch. 
    attr_accessor :allocate_addresses

    # Used to identify which concrete class it is
    attr_accessor :resource_type

    # Type of the VIF attached to logical port
    attr_accessor :vif_type

    # VIF ID of the parent VIF if vif_type is CHILD
    attr_accessor :parent_vif_id

    # An application ID used to identify / look up a child VIF behind a parent VIF. Only effective when vif_type is CHILD. 
    attr_accessor :app_id

    # Current we use VLAN id as the traffic tag. Only effective when vif_type is CHILD. Each logical port inside a container must have a unique traffic tag. If the traffic_tag is not unique, no error is generated, but traffic will not be delivered to any port with a non-unique tag. 
    attr_accessor :traffic_tag

    # Only effective when vif_type is INDEPENDENT. Each logical port inside a bare metal server or container must have a transport node UUID. We use transport node ID as transport node UUID. 
    attr_accessor :transport_node_uuid

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
        :'allocate_addresses' => :'allocate_addresses',
        :'resource_type' => :'resource_type',
        :'vif_type' => :'vif_type',
        :'parent_vif_id' => :'parent_vif_id',
        :'app_id' => :'app_id',
        :'traffic_tag' => :'traffic_tag',
        :'transport_node_uuid' => :'transport_node_uuid'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'allocate_addresses' => :'String',
        :'resource_type' => :'String',
        :'vif_type' => :'String',
        :'parent_vif_id' => :'String',
        :'app_id' => :'String',
        :'traffic_tag' => :'Integer',
        :'transport_node_uuid' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'allocate_addresses')
        self.allocate_addresses = attributes[:'allocate_addresses']
      end

      if attributes.has_key?(:'resource_type')
        self.resource_type = attributes[:'resource_type']
      end

      if attributes.has_key?(:'vif_type')
        self.vif_type = attributes[:'vif_type']
      end

      if attributes.has_key?(:'parent_vif_id')
        self.parent_vif_id = attributes[:'parent_vif_id']
      end

      if attributes.has_key?(:'app_id')
        self.app_id = attributes[:'app_id']
      end

      if attributes.has_key?(:'traffic_tag')
        self.traffic_tag = attributes[:'traffic_tag']
      end

      if attributes.has_key?(:'transport_node_uuid')
        self.transport_node_uuid = attributes[:'transport_node_uuid']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @resource_type.nil?
        invalid_properties.push('invalid value for "resource_type", resource_type cannot be nil.')
      end

      if @vif_type.nil?
        invalid_properties.push('invalid value for "vif_type", vif_type cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      allocate_addresses_validator = EnumAttributeValidator.new('String', ['IpPool', 'MacPool', 'Both', 'None'])
      return false unless allocate_addresses_validator.valid?(@allocate_addresses)
      return false if @resource_type.nil?
      return false if @vif_type.nil?
      vif_type_validator = EnumAttributeValidator.new('String', ['PARENT', 'CHILD', 'INDEPENDENT'])
      return false unless vif_type_validator.valid?(@vif_type)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] allocate_addresses Object to be assigned
    def allocate_addresses=(allocate_addresses)
      validator = EnumAttributeValidator.new('String', ['IpPool', 'MacPool', 'Both', 'None'])
      unless validator.valid?(allocate_addresses)
        fail ArgumentError, 'invalid value for "allocate_addresses", must be one of #{validator.allowable_values}.'
      end
      @allocate_addresses = allocate_addresses
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] vif_type Object to be assigned
    def vif_type=(vif_type)
      validator = EnumAttributeValidator.new('String', ['PARENT', 'CHILD', 'INDEPENDENT'])
      unless validator.valid?(vif_type)
        fail ArgumentError, 'invalid value for "vif_type", must be one of #{validator.allowable_values}.'
      end
      @vif_type = vif_type
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          allocate_addresses == o.allocate_addresses &&
          resource_type == o.resource_type &&
          vif_type == o.vif_type &&
          parent_vif_id == o.parent_vif_id &&
          app_id == o.app_id &&
          traffic_tag == o.traffic_tag &&
          transport_node_uuid == o.transport_node_uuid
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [allocate_addresses, resource_type, vif_type, parent_vif_id, app_id, traffic_tag, transport_node_uuid].hash
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
        temp_model = NSXT.const_get(type).new
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
