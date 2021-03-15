=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # List all the TNs spaned in L3PortMirrorSession mirror stack health status. 
  class TnNodeStackSpanStatus
    # For L3PortMirrorSession configured mirror stack, show the TN node friendly name which spaned in L3PortMirrorSession. 
    attr_accessor :tn_node_name

    # Show the vmknic health status, if the vmknic has been bouned to mirror stack, it will show SUCCESS or it will show FAILED. 
    attr_accessor :vmknic_status

    # Show the dedicated mirror stack health status, if the TN node has the mirror stack, it will show SUCCESS or it will show FAILED. 
    attr_accessor :dedicated_stack_status

    # For L3PortMirrorSession configured mirror stack, show the TN node UUID which spaned in L3PortMirrorSession. 
    attr_accessor :tn_node_id

    # Give the detail info for mirror stack and vmknic health status. If the stack or vmknic is FAILED, detail info will tell user reason why the stauts is FAILED. So that user can correct their configuration. 
    attr_accessor :detail

    # TN miror stack status will be updated periodically, this item indicates the lastest timestamp of TN node stack status is updated. 
    attr_accessor :last_updated_time

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
        :'tn_node_name' => :'tn_node_name',
        :'vmknic_status' => :'vmknic_status',
        :'dedicated_stack_status' => :'dedicated_stack_status',
        :'tn_node_id' => :'tn_node_id',
        :'detail' => :'detail',
        :'last_updated_time' => :'last_updated_time'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'tn_node_name' => :'String',
        :'vmknic_status' => :'String',
        :'dedicated_stack_status' => :'String',
        :'tn_node_id' => :'String',
        :'detail' => :'String',
        :'last_updated_time' => :'Integer'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'tn_node_name')
        self.tn_node_name = attributes[:'tn_node_name']
      end

      if attributes.has_key?(:'vmknic_status')
        self.vmknic_status = attributes[:'vmknic_status']
      end

      if attributes.has_key?(:'dedicated_stack_status')
        self.dedicated_stack_status = attributes[:'dedicated_stack_status']
      end

      if attributes.has_key?(:'tn_node_id')
        self.tn_node_id = attributes[:'tn_node_id']
      end

      if attributes.has_key?(:'detail')
        self.detail = attributes[:'detail']
      end

      if attributes.has_key?(:'last_updated_time')
        self.last_updated_time = attributes[:'last_updated_time']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @tn_node_name.nil?
        invalid_properties.push('invalid value for "tn_node_name", tn_node_name cannot be nil.')
      end

      if @vmknic_status.nil?
        invalid_properties.push('invalid value for "vmknic_status", vmknic_status cannot be nil.')
      end

      if @dedicated_stack_status.nil?
        invalid_properties.push('invalid value for "dedicated_stack_status", dedicated_stack_status cannot be nil.')
      end

      if @detail.nil?
        invalid_properties.push('invalid value for "detail", detail cannot be nil.')
      end

      if @last_updated_time.nil?
        invalid_properties.push('invalid value for "last_updated_time", last_updated_time cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @tn_node_name.nil?
      return false if @vmknic_status.nil?
      vmknic_status_validator = EnumAttributeValidator.new('String', ['UNKNOWN', 'SUCCESS', 'FAILED'])
      return false unless vmknic_status_validator.valid?(@vmknic_status)
      return false if @dedicated_stack_status.nil?
      dedicated_stack_status_validator = EnumAttributeValidator.new('String', ['UNKNOWN', 'SUCCESS', 'FAILED'])
      return false unless dedicated_stack_status_validator.valid?(@dedicated_stack_status)
      return false if @detail.nil?
      return false if @last_updated_time.nil?
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] vmknic_status Object to be assigned
    def vmknic_status=(vmknic_status)
      validator = EnumAttributeValidator.new('String', ['UNKNOWN', 'SUCCESS', 'FAILED'])
      unless validator.valid?(vmknic_status)
        fail ArgumentError, 'invalid value for "vmknic_status", must be one of #{validator.allowable_values}.'
      end
      @vmknic_status = vmknic_status
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] dedicated_stack_status Object to be assigned
    def dedicated_stack_status=(dedicated_stack_status)
      validator = EnumAttributeValidator.new('String', ['UNKNOWN', 'SUCCESS', 'FAILED'])
      unless validator.valid?(dedicated_stack_status)
        fail ArgumentError, 'invalid value for "dedicated_stack_status", must be one of #{validator.allowable_values}.'
      end
      @dedicated_stack_status = dedicated_stack_status
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          tn_node_name == o.tn_node_name &&
          vmknic_status == o.vmknic_status &&
          dedicated_stack_status == o.dedicated_stack_status &&
          tn_node_id == o.tn_node_id &&
          detail == o.detail &&
          last_updated_time == o.last_updated_time
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [tn_node_name, vmknic_status, dedicated_stack_status, tn_node_id, detail, last_updated_time].hash
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
