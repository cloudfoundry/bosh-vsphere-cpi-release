=begin
#NSX API

#VMware NSX REST API

OpenAPI spec version: 1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'

module NSXT

  class LogicalSwitchStatistics
    attr_accessor :tx_bytes

    attr_accessor :rx_packets

    attr_accessor :tx_packets

    attr_accessor :rx_bytes

    attr_accessor :mac_learning

    attr_accessor :dropped_by_security_packets

    # Timestamp when the data was last updated; unset if data source has never updated the data.
    attr_accessor :last_update_timestamp

    # The id of the logical Switch
    attr_accessor :logical_switch_id


    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'tx_bytes' => :'tx_bytes',
        :'rx_packets' => :'rx_packets',
        :'tx_packets' => :'tx_packets',
        :'rx_bytes' => :'rx_bytes',
        :'mac_learning' => :'mac_learning',
        :'dropped_by_security_packets' => :'dropped_by_security_packets',
        :'last_update_timestamp' => :'last_update_timestamp',
        :'logical_switch_id' => :'logical_switch_id'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'tx_bytes' => :'DataCounter',
        :'rx_packets' => :'DataCounter',
        :'tx_packets' => :'DataCounter',
        :'rx_bytes' => :'DataCounter',
        :'mac_learning' => :'MacLearningCounters',
        :'dropped_by_security_packets' => :'PacketsDroppedBySecurity',
        :'last_update_timestamp' => :'Integer',
        :'logical_switch_id' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}){|(k,v), h| h[k.to_sym] = v}

      if attributes.has_key?(:'tx_bytes')
        self.tx_bytes = attributes[:'tx_bytes']
      end

      if attributes.has_key?(:'rx_packets')
        self.rx_packets = attributes[:'rx_packets']
      end

      if attributes.has_key?(:'tx_packets')
        self.tx_packets = attributes[:'tx_packets']
      end

      if attributes.has_key?(:'rx_bytes')
        self.rx_bytes = attributes[:'rx_bytes']
      end

      if attributes.has_key?(:'mac_learning')
        self.mac_learning = attributes[:'mac_learning']
      end

      if attributes.has_key?(:'dropped_by_security_packets')
        self.dropped_by_security_packets = attributes[:'dropped_by_security_packets']
      end

      if attributes.has_key?(:'last_update_timestamp')
        self.last_update_timestamp = attributes[:'last_update_timestamp']
      end

      if attributes.has_key?(:'logical_switch_id')
        self.logical_switch_id = attributes[:'logical_switch_id']
      end

    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      return invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          tx_bytes == o.tx_bytes &&
          rx_packets == o.rx_packets &&
          tx_packets == o.tx_packets &&
          rx_bytes == o.rx_bytes &&
          mac_learning == o.mac_learning &&
          dropped_by_security_packets == o.dropped_by_security_packets &&
          last_update_timestamp == o.last_update_timestamp &&
          logical_switch_id == o.logical_switch_id
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [tx_bytes, rx_packets, tx_packets, rx_bytes, mac_learning, dropped_by_security_packets, last_update_timestamp, logical_switch_id].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.swagger_types.each_pair do |key, type|
        if type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map{ |v| _deserialize($1, v) } )
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
        value.compact.map{ |v| _to_hash(v) }
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
