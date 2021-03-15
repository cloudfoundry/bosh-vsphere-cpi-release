=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # This condition is used to match SSL handshake and SSL connection at all phases.If multiple properties are configured, the rule is considered a match when all the configured properties are matched. 
  class LBHttpSslCondition
    # A flag to indicate whether reverse the match result of this condition
    attr_accessor :inverse

    # Type of load balancer rule condition
    attr_accessor :type

    # Cipher list which supported by client.
    attr_accessor :client_supported_ssl_ciphers

    # The issuer DN match condition of the client certificate for an established SSL connection. 
    attr_accessor :client_certificate_issuer_dn

    # The subject DN match condition of the client certificate for an established SSL connection. 
    attr_accessor :client_certificate_subject_dn

    # Cipher used for an established SSL connection.
    attr_accessor :used_ssl_cipher

    # The type of SSL session reused.
    attr_accessor :session_reused

    # Protocol of an established SSL connection.
    attr_accessor :used_protocol

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
        :'inverse' => :'inverse',
        :'type' => :'type',
        :'client_supported_ssl_ciphers' => :'client_supported_ssl_ciphers',
        :'client_certificate_issuer_dn' => :'client_certificate_issuer_dn',
        :'client_certificate_subject_dn' => :'client_certificate_subject_dn',
        :'used_ssl_cipher' => :'used_ssl_cipher',
        :'session_reused' => :'session_reused',
        :'used_protocol' => :'used_protocol'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'inverse' => :'BOOLEAN',
        :'type' => :'String',
        :'client_supported_ssl_ciphers' => :'Array<String>',
        :'client_certificate_issuer_dn' => :'LBClientCertificateIssuerDnCondition',
        :'client_certificate_subject_dn' => :'LBClientCertificateSubjectDnCondition',
        :'used_ssl_cipher' => :'String',
        :'session_reused' => :'String',
        :'used_protocol' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'inverse')
        self.inverse = attributes[:'inverse']
      else
        self.inverse = false
      end

      if attributes.has_key?(:'type')
        self.type = attributes[:'type']
      end

      if attributes.has_key?(:'client_supported_ssl_ciphers')
        if (value = attributes[:'client_supported_ssl_ciphers']).is_a?(Array)
          self.client_supported_ssl_ciphers = value
        end
      end

      if attributes.has_key?(:'client_certificate_issuer_dn')
        self.client_certificate_issuer_dn = attributes[:'client_certificate_issuer_dn']
      end

      if attributes.has_key?(:'client_certificate_subject_dn')
        self.client_certificate_subject_dn = attributes[:'client_certificate_subject_dn']
      end

      if attributes.has_key?(:'used_ssl_cipher')
        self.used_ssl_cipher = attributes[:'used_ssl_cipher']
      end

      if attributes.has_key?(:'session_reused')
        self.session_reused = attributes[:'session_reused']
      else
        self.session_reused = 'IGNORE'
      end

      if attributes.has_key?(:'used_protocol')
        self.used_protocol = attributes[:'used_protocol']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @type.nil?
        invalid_properties.push('invalid value for "type", type cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @type.nil?
      type_validator = EnumAttributeValidator.new('String', ['LBHttpRequestUriCondition', 'LBHttpRequestHeaderCondition', 'LBHttpRequestMethodCondition', 'LBHttpRequestUriArgumentsCondition', 'LBHttpRequestVersionCondition', 'LBHttpRequestCookieCondition', 'LBHttpRequestBodyCondition', 'LBHttpResponseHeaderCondition', 'LBTcpHeaderCondition', 'LBIpHeaderCondition', 'LBVariableCondition', 'LBHttpSslCondition', 'LBSslSniCondition'])
      return false unless type_validator.valid?(@type)
      used_ssl_cipher_validator = EnumAttributeValidator.new('String', ['TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA', 'TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA', 'TLS_ECDH_RSA_WITH_AES_256_CBC_SHA', 'TLS_RSA_WITH_AES_256_CBC_SHA', 'TLS_RSA_WITH_AES_128_CBC_SHA', 'TLS_RSA_WITH_3DES_EDE_CBC_SHA', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384', 'TLS_RSA_WITH_AES_128_CBC_SHA256', 'TLS_RSA_WITH_AES_128_GCM_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA256', 'TLS_RSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA', 'TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDH_RSA_WITH_AES_128_CBC_SHA', 'TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384'])
      return false unless used_ssl_cipher_validator.valid?(@used_ssl_cipher)
      session_reused_validator = EnumAttributeValidator.new('String', ['IGNORE', 'REUSED', 'NEW'])
      return false unless session_reused_validator.valid?(@session_reused)
      used_protocol_validator = EnumAttributeValidator.new('String', ['SSL_V2', 'SSL_V3', 'TLS_V1', 'TLS_V1_1', 'TLS_V1_2'])
      return false unless used_protocol_validator.valid?(@used_protocol)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] type Object to be assigned
    def type=(type)
      validator = EnumAttributeValidator.new('String', ['LBHttpRequestUriCondition', 'LBHttpRequestHeaderCondition', 'LBHttpRequestMethodCondition', 'LBHttpRequestUriArgumentsCondition', 'LBHttpRequestVersionCondition', 'LBHttpRequestCookieCondition', 'LBHttpRequestBodyCondition', 'LBHttpResponseHeaderCondition', 'LBTcpHeaderCondition', 'LBIpHeaderCondition', 'LBVariableCondition', 'LBHttpSslCondition', 'LBSslSniCondition'])
      unless validator.valid?(type)
        fail ArgumentError, 'invalid value for "type", must be one of #{validator.allowable_values}.'
      end
      @type = type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] used_ssl_cipher Object to be assigned
    def used_ssl_cipher=(used_ssl_cipher)
      validator = EnumAttributeValidator.new('String', ['TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA', 'TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA', 'TLS_ECDH_RSA_WITH_AES_256_CBC_SHA', 'TLS_RSA_WITH_AES_256_CBC_SHA', 'TLS_RSA_WITH_AES_128_CBC_SHA', 'TLS_RSA_WITH_3DES_EDE_CBC_SHA', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA', 'TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384', 'TLS_RSA_WITH_AES_128_CBC_SHA256', 'TLS_RSA_WITH_AES_128_GCM_SHA256', 'TLS_RSA_WITH_AES_256_CBC_SHA256', 'TLS_RSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA', 'TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA', 'TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384', 'TLS_ECDH_RSA_WITH_AES_128_CBC_SHA', 'TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256', 'TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256', 'TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384', 'TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384'])
      unless validator.valid?(used_ssl_cipher)
        fail ArgumentError, 'invalid value for "used_ssl_cipher", must be one of #{validator.allowable_values}.'
      end
      @used_ssl_cipher = used_ssl_cipher
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] session_reused Object to be assigned
    def session_reused=(session_reused)
      validator = EnumAttributeValidator.new('String', ['IGNORE', 'REUSED', 'NEW'])
      unless validator.valid?(session_reused)
        fail ArgumentError, 'invalid value for "session_reused", must be one of #{validator.allowable_values}.'
      end
      @session_reused = session_reused
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] used_protocol Object to be assigned
    def used_protocol=(used_protocol)
      validator = EnumAttributeValidator.new('String', ['SSL_V2', 'SSL_V3', 'TLS_V1', 'TLS_V1_1', 'TLS_V1_2'])
      unless validator.valid?(used_protocol)
        fail ArgumentError, 'invalid value for "used_protocol", must be one of #{validator.allowable_values}.'
      end
      @used_protocol = used_protocol
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          inverse == o.inverse &&
          type == o.type &&
          client_supported_ssl_ciphers == o.client_supported_ssl_ciphers &&
          client_certificate_issuer_dn == o.client_certificate_issuer_dn &&
          client_certificate_subject_dn == o.client_certificate_subject_dn &&
          used_ssl_cipher == o.used_ssl_cipher &&
          session_reused == o.session_reused &&
          used_protocol == o.used_protocol
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [inverse, type, client_supported_ssl_ciphers, client_certificate_issuer_dn, client_certificate_subject_dn, used_ssl_cipher, session_reused, used_protocol].hash
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
