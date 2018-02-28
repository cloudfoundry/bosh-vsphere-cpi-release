=begin
#NSX API

#VMware NSX REST API

OpenAPI spec version: 1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.3.1

=end

require 'date'

module NSXT

  class DneService
    # Display name of the NSX resource.
    attr_accessor :target_display_name

    # Will be set to false if the referenced NSX resource has been deleted.
    attr_accessor :is_valid

    # Identifier of the NSX resource.
    attr_accessor :target_id

    # Type of the NSX resource.
    attr_accessor :target_type

    # Dne API accepts raw protocol and ports as part of NS service element in Dne Rule that describes traffic corresponding to an NSService. 
    attr_accessor :service


    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'target_display_name' => :'target_display_name',
        :'is_valid' => :'is_valid',
        :'target_id' => :'target_id',
        :'target_type' => :'target_type',
        :'service' => :'service'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'target_display_name' => :'String',
        :'is_valid' => :'BOOLEAN',
        :'target_id' => :'String',
        :'target_type' => :'String',
        :'service' => :'NSServiceElement'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}){|(k,v), h| h[k.to_sym] = v}

      if attributes.has_key?(:'target_display_name')
        self.target_display_name = attributes[:'target_display_name']
      end

      if attributes.has_key?(:'is_valid')
        self.is_valid = attributes[:'is_valid']
      end

      if attributes.has_key?(:'target_id')
        self.target_id = attributes[:'target_id']
      end

      if attributes.has_key?(:'target_type')
        self.target_type = attributes[:'target_type']
      end

      if attributes.has_key?(:'service')
        self.service = attributes[:'service']
      end

    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if !@target_display_name.nil? && @target_display_name.to_s.length > 255
        invalid_properties.push("invalid value for 'target_display_name', the character length must be smaller than or equal to 255.")
      end

      if !@target_id.nil? && @target_id.to_s.length > 64
        invalid_properties.push("invalid value for 'target_id', the character length must be smaller than or equal to 64.")
      end

      if !@target_type.nil? && @target_type.to_s.length > 255
        invalid_properties.push("invalid value for 'target_type', the character length must be smaller than or equal to 255.")
      end

      return invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if !@target_display_name.nil? && @target_display_name.to_s.length > 255
      return false if !@target_id.nil? && @target_id.to_s.length > 64
      return false if !@target_type.nil? && @target_type.to_s.length > 255
      return true
    end

    # Custom attribute writer method with validation
    # @param [Object] target_display_name Value to be assigned
    def target_display_name=(target_display_name)

      if !target_display_name.nil? && target_display_name.to_s.length > 255
        fail ArgumentError, "invalid value for 'target_display_name', the character length must be smaller than or equal to 255."
      end

      @target_display_name = target_display_name
    end

    # Custom attribute writer method with validation
    # @param [Object] target_id Value to be assigned
    def target_id=(target_id)

      if !target_id.nil? && target_id.to_s.length > 64
        fail ArgumentError, "invalid value for 'target_id', the character length must be smaller than or equal to 64."
      end

      @target_id = target_id
    end

    # Custom attribute writer method with validation
    # @param [Object] target_type Value to be assigned
    def target_type=(target_type)

      if !target_type.nil? && target_type.to_s.length > 255
        fail ArgumentError, "invalid value for 'target_type', the character length must be smaller than or equal to 255."
      end

      @target_type = target_type
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          target_display_name == o.target_display_name &&
          is_valid == o.is_valid &&
          target_id == o.target_id &&
          target_type == o.target_type &&
          service == o.service
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [target_display_name, is_valid, target_id, target_type, service].hash
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
