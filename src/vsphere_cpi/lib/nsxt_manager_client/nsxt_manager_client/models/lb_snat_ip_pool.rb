=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXT
  class LbSnatIpPool
    # Load balancers may need to perform SNAT to ensure reverse traffic from the server can be received and processed by them. There are two modes: LbSnatAutoMap uses the load balancer interface IP and an ephemeral port as the source IP and port of the server side connection. LbSnatIpPool allows user to specify one or more IP addresses along with their subnet masks that should be used for SNAT while connecting to any of the servers in the pool. 
    attr_accessor :type

    # Both SNAT automap and SNAT IP list modes support port overloading which allows the same SNAT IP and port to be used for multiple backend connections as long as the tuple (source IP, source port, destination IP, destination port, IP protocol) after SNAT is performed is unique. The valid number is 1, 2, 4, 8, 16, 32. This is a deprecated property. The port overload factor is fixed to 32 in load balancer engine. If it is upgraded from an old version, the value would be changed to 32 automatically. 
    attr_accessor :port_overload

    # If an IP range is specified, the range may contain no more than 64 IP addresses. 
    attr_accessor :ip_addresses

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
        :'type' => :'type',
        :'port_overload' => :'port_overload',
        :'ip_addresses' => :'ip_addresses'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'type' => :'String',
        :'port_overload' => :'Integer',
        :'ip_addresses' => :'Array<LbSnatIpElement>'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'type')
        self.type = attributes[:'type']
      end

      if attributes.has_key?(:'port_overload')
        self.port_overload = attributes[:'port_overload']
      else
        self.port_overload = 32
      end

      if attributes.has_key?(:'ip_addresses')
        if (value = attributes[:'ip_addresses']).is_a?(Array)
          self.ip_addresses = value
        end
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @type.nil?
        invalid_properties.push('invalid value for "type", type cannot be nil.')
      end

      if !@port_overload.nil? && @port_overload > 32
        invalid_properties.push('invalid value for "port_overload", must be smaller than or equal to 32.')
      end

      if !@port_overload.nil? && @port_overload < 1
        invalid_properties.push('invalid value for "port_overload", must be greater than or equal to 1.')
      end

      if @ip_addresses.nil?
        invalid_properties.push('invalid value for "ip_addresses", ip_addresses cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @type.nil?
      type_validator = EnumAttributeValidator.new('String', ['LbSnatAutoMap', 'LbSnatIpPool'])
      return false unless type_validator.valid?(@type)
      return false if !@port_overload.nil? && @port_overload > 32
      return false if !@port_overload.nil? && @port_overload < 1
      return false if @ip_addresses.nil?
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] type Object to be assigned
    def type=(type)
      validator = EnumAttributeValidator.new('String', ['LbSnatAutoMap', 'LbSnatIpPool'])
      unless validator.valid?(type)
        fail ArgumentError, 'invalid value for "type", must be one of #{validator.allowable_values}.'
      end
      @type = type
    end

    # Custom attribute writer method with validation
    # @param [Object] port_overload Value to be assigned
    def port_overload=(port_overload)
      if !port_overload.nil? && port_overload > 32
        fail ArgumentError, 'invalid value for "port_overload", must be smaller than or equal to 32.'
      end

      if !port_overload.nil? && port_overload < 1
        fail ArgumentError, 'invalid value for "port_overload", must be greater than or equal to 1.'
      end

      @port_overload = port_overload
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          type == o.type &&
          port_overload == o.port_overload &&
          ip_addresses == o.ip_addresses
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [type, port_overload, ip_addresses].hash
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
