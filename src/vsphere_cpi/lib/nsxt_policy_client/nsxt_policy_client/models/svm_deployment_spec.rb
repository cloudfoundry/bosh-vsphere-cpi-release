=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Deployment Specs holds information required to deploy the Service-VMs.i.e. OVF url where the partner Service-VM OVF is hosted. The host type on which the OVF(Open Virtualization Format) can be deployed, Form factor to name a few.
  class SVMDeploymentSpec
    # Location of the partner VM OVF to be deployed.
    attr_accessor :ovf_url

    # Deployment Spec name for ease of use, since multiple DeploymentSpec can be specified.
    attr_accessor :name

    # Minimum host version supported by this ovf. If a host in the deployment cluster is having version less than this, then service deployment will not happen on that host.
    attr_accessor :min_host_version

    # Supported ServiceInsertion Form Factor for the OVF deployment. The default FormFactor is Medium.
    attr_accessor :service_form_factor

    # Host Type on which the specified OVF can be deployed.
    attr_accessor :host_type

    # Partner needs to specify the Service VM version which will get deployed.
    attr_accessor :svm_version

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
        :'ovf_url' => :'ovf_url',
        :'name' => :'name',
        :'min_host_version' => :'min_host_version',
        :'service_form_factor' => :'service_form_factor',
        :'host_type' => :'host_type',
        :'svm_version' => :'svm_version'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'ovf_url' => :'String',
        :'name' => :'String',
        :'min_host_version' => :'String',
        :'service_form_factor' => :'String',
        :'host_type' => :'String',
        :'svm_version' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'ovf_url')
        self.ovf_url = attributes[:'ovf_url']
      end

      if attributes.has_key?(:'name')
        self.name = attributes[:'name']
      end

      if attributes.has_key?(:'min_host_version')
        self.min_host_version = attributes[:'min_host_version']
      else
        self.min_host_version = '6.5'
      end

      if attributes.has_key?(:'service_form_factor')
        self.service_form_factor = attributes[:'service_form_factor']
      else
        self.service_form_factor = 'MEDIUM'
      end

      if attributes.has_key?(:'host_type')
        self.host_type = attributes[:'host_type']
      end

      if attributes.has_key?(:'svm_version')
        self.svm_version = attributes[:'svm_version']
      else
        self.svm_version = '1.0'
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @ovf_url.nil?
        invalid_properties.push('invalid value for "ovf_url", ovf_url cannot be nil.')
      end

      if @host_type.nil?
        invalid_properties.push('invalid value for "host_type", host_type cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @ovf_url.nil?
      service_form_factor_validator = EnumAttributeValidator.new('String', ['SMALL', 'MEDIUM', 'LARGE'])
      return false unless service_form_factor_validator.valid?(@service_form_factor)
      return false if @host_type.nil?
      host_type_validator = EnumAttributeValidator.new('String', ['ESXI', 'RHELKVM', 'UBUNTUKVM'])
      return false unless host_type_validator.valid?(@host_type)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] service_form_factor Object to be assigned
    def service_form_factor=(service_form_factor)
      validator = EnumAttributeValidator.new('String', ['SMALL', 'MEDIUM', 'LARGE'])
      unless validator.valid?(service_form_factor)
        fail ArgumentError, 'invalid value for "service_form_factor", must be one of #{validator.allowable_values}.'
      end
      @service_form_factor = service_form_factor
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] host_type Object to be assigned
    def host_type=(host_type)
      validator = EnumAttributeValidator.new('String', ['ESXI', 'RHELKVM', 'UBUNTUKVM'])
      unless validator.valid?(host_type)
        fail ArgumentError, 'invalid value for "host_type", must be one of #{validator.allowable_values}.'
      end
      @host_type = host_type
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          ovf_url == o.ovf_url &&
          name == o.name &&
          min_host_version == o.min_host_version &&
          service_form_factor == o.service_form_factor &&
          host_type == o.host_type &&
          svm_version == o.svm_version
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [ovf_url, name, min_host_version, service_form_factor, host_type, svm_version].hash
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
