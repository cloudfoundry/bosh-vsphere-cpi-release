=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.7

=end

require 'date'

module NSXT
  # IPSec VPN tunnel profile is a reusable profile that captures phase two negotiation parameters and tunnel properties. Any changes affects all IPSec VPN sessions consuming this profile.
  class IPSecVPNTunnelProfile
    # Link to this resource
    attr_accessor :_self

    # The server will populate this field when returing the resource. Ignored on PUT and POST.
    attr_accessor :_links

    # Schema for this resource
    attr_accessor :_schema

    # The _revision property describes the current revision of the resource. To prevent clients from overwriting each other's changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected.
    attr_accessor :_revision

    # Indicates system owned resource
    attr_accessor :_system_owned

    # Defaults to ID if not set
    attr_accessor :display_name

    # Description of this resource
    attr_accessor :description

    # Opaque identifiers meaningful to the API user
    attr_accessor :tags

    # ID of the user who created this resource
    attr_accessor :_create_user

    # Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite=true. UNKNOWN - the _protection field could not be determined for this           entity. 
    attr_accessor :_protection

    # Timestamp of resource creation
    attr_accessor :_create_time

    # Timestamp of last modification
    attr_accessor :_last_modified_time

    # ID of the user who last modified this resource
    attr_accessor :_last_modified_user

    # Unique identifier of this resource
    attr_accessor :id

    # The type of this resource.
    attr_accessor :resource_type

    # Encapsulation Mode to be used for encryption of packet. Tunnel mode protects internal routing information by encrypting IP header of original packet.
    attr_accessor :encapsulation_mode

    # IPSec transform specifies IPSec security protocol.
    attr_accessor :transform_protocol

    # Algorithm to be used for message digest. Default digest algorithm is implicitly covered by default encryption algorithm \"AES_GCM_128\".
    attr_accessor :digest_algorithms

    # Encryption algorithm to encrypt/decrypt the messages exchanged between IPSec VPN initiator and responder during tunnel negotiation. Default is AES_GCM_128.
    attr_accessor :encryption_algorithms

    # If true, perfect forward secrecy (PFS) is enabled.
    attr_accessor :enable_perfect_forward_secrecy

    # Diffie-Hellman group to be used if PFS is enabled. Default is GROUP14.
    attr_accessor :dh_groups

    # Defragmentation policy helps to handle defragmentation bit present in the inner packet. COPY copies the defragmentation bit from the inner IP packet into the outer packet. CLEAR ignores the defragmentation bit present in the inner packet.
    attr_accessor :df_policy

    # SA life time specifies the expiry time of security association. Default is 3600 seconds. 
    attr_accessor :sa_life_time

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
        :'_self' => :'_self',
        :'_links' => :'_links',
        :'_schema' => :'_schema',
        :'_revision' => :'_revision',
        :'_system_owned' => :'_system_owned',
        :'display_name' => :'display_name',
        :'description' => :'description',
        :'tags' => :'tags',
        :'_create_user' => :'_create_user',
        :'_protection' => :'_protection',
        :'_create_time' => :'_create_time',
        :'_last_modified_time' => :'_last_modified_time',
        :'_last_modified_user' => :'_last_modified_user',
        :'id' => :'id',
        :'resource_type' => :'resource_type',
        :'encapsulation_mode' => :'encapsulation_mode',
        :'transform_protocol' => :'transform_protocol',
        :'digest_algorithms' => :'digest_algorithms',
        :'encryption_algorithms' => :'encryption_algorithms',
        :'enable_perfect_forward_secrecy' => :'enable_perfect_forward_secrecy',
        :'dh_groups' => :'dh_groups',
        :'df_policy' => :'df_policy',
        :'sa_life_time' => :'sa_life_time'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'_self' => :'SelfResourceLink',
        :'_links' => :'Array<ResourceLink>',
        :'_schema' => :'String',
        :'_revision' => :'Integer',
        :'_system_owned' => :'BOOLEAN',
        :'display_name' => :'String',
        :'description' => :'String',
        :'tags' => :'Array<Tag>',
        :'_create_user' => :'String',
        :'_protection' => :'String',
        :'_create_time' => :'Integer',
        :'_last_modified_time' => :'Integer',
        :'_last_modified_user' => :'String',
        :'id' => :'String',
        :'resource_type' => :'String',
        :'encapsulation_mode' => :'String',
        :'transform_protocol' => :'String',
        :'digest_algorithms' => :'Array<String>',
        :'encryption_algorithms' => :'Array<String>',
        :'enable_perfect_forward_secrecy' => :'BOOLEAN',
        :'dh_groups' => :'Array<String>',
        :'df_policy' => :'String',
        :'sa_life_time' => :'Integer'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'_self')
        self._self = attributes[:'_self']
      end

      if attributes.has_key?(:'_links')
        if (value = attributes[:'_links']).is_a?(Array)
          self._links = value
        end
      end

      if attributes.has_key?(:'_schema')
        self._schema = attributes[:'_schema']
      end

      if attributes.has_key?(:'_revision')
        self._revision = attributes[:'_revision']
      end

      if attributes.has_key?(:'_system_owned')
        self._system_owned = attributes[:'_system_owned']
      end

      if attributes.has_key?(:'display_name')
        self.display_name = attributes[:'display_name']
      end

      if attributes.has_key?(:'description')
        self.description = attributes[:'description']
      end

      if attributes.has_key?(:'tags')
        if (value = attributes[:'tags']).is_a?(Array)
          self.tags = value
        end
      end

      if attributes.has_key?(:'_create_user')
        self._create_user = attributes[:'_create_user']
      end

      if attributes.has_key?(:'_protection')
        self._protection = attributes[:'_protection']
      end

      if attributes.has_key?(:'_create_time')
        self._create_time = attributes[:'_create_time']
      end

      if attributes.has_key?(:'_last_modified_time')
        self._last_modified_time = attributes[:'_last_modified_time']
      end

      if attributes.has_key?(:'_last_modified_user')
        self._last_modified_user = attributes[:'_last_modified_user']
      end

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
      end

      if attributes.has_key?(:'resource_type')
        self.resource_type = attributes[:'resource_type']
      end

      if attributes.has_key?(:'encapsulation_mode')
        self.encapsulation_mode = attributes[:'encapsulation_mode']
      else
        self.encapsulation_mode = 'TUNNEL_MODE'
      end

      if attributes.has_key?(:'transform_protocol')
        self.transform_protocol = attributes[:'transform_protocol']
      else
        self.transform_protocol = 'ESP'
      end

      if attributes.has_key?(:'digest_algorithms')
        if (value = attributes[:'digest_algorithms']).is_a?(Array)
          self.digest_algorithms = value
        end
      end

      if attributes.has_key?(:'encryption_algorithms')
        if (value = attributes[:'encryption_algorithms']).is_a?(Array)
          self.encryption_algorithms = value
        end
      end

      if attributes.has_key?(:'enable_perfect_forward_secrecy')
        self.enable_perfect_forward_secrecy = attributes[:'enable_perfect_forward_secrecy']
      else
        self.enable_perfect_forward_secrecy = true
      end

      if attributes.has_key?(:'dh_groups')
        if (value = attributes[:'dh_groups']).is_a?(Array)
          self.dh_groups = value
        end
      end

      if attributes.has_key?(:'df_policy')
        self.df_policy = attributes[:'df_policy']
      else
        self.df_policy = 'COPY'
      end

      if attributes.has_key?(:'sa_life_time')
        self.sa_life_time = attributes[:'sa_life_time']
      else
        self.sa_life_time = 3600
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if !@display_name.nil? && @display_name.to_s.length > 255
        invalid_properties.push('invalid value for "display_name", the character length must be smaller than or equal to 255.')
      end

      if !@description.nil? && @description.to_s.length > 1024
        invalid_properties.push('invalid value for "description", the character length must be smaller than or equal to 1024.')
      end

      if !@sa_life_time.nil? && @sa_life_time > 31536000
        invalid_properties.push('invalid value for "sa_life_time", must be smaller than or equal to 31536000.')
      end

      if !@sa_life_time.nil? && @sa_life_time < 900
        invalid_properties.push('invalid value for "sa_life_time", must be greater than or equal to 900.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if !@display_name.nil? && @display_name.to_s.length > 255
      return false if !@description.nil? && @description.to_s.length > 1024
      encapsulation_mode_validator = EnumAttributeValidator.new('String', ['TUNNEL_MODE'])
      return false unless encapsulation_mode_validator.valid?(@encapsulation_mode)
      transform_protocol_validator = EnumAttributeValidator.new('String', ['ESP'])
      return false unless transform_protocol_validator.valid?(@transform_protocol)
      df_policy_validator = EnumAttributeValidator.new('String', ['COPY', 'CLEAR'])
      return false unless df_policy_validator.valid?(@df_policy)
      return false if !@sa_life_time.nil? && @sa_life_time > 31536000
      return false if !@sa_life_time.nil? && @sa_life_time < 900
      true
    end

    # Custom attribute writer method with validation
    # @param [Object] display_name Value to be assigned
    def display_name=(display_name)
      if !display_name.nil? && display_name.to_s.length > 255
        fail ArgumentError, 'invalid value for "display_name", the character length must be smaller than or equal to 255.'
      end

      @display_name = display_name
    end

    # Custom attribute writer method with validation
    # @param [Object] description Value to be assigned
    def description=(description)
      if !description.nil? && description.to_s.length > 1024
        fail ArgumentError, 'invalid value for "description", the character length must be smaller than or equal to 1024.'
      end

      @description = description
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] encapsulation_mode Object to be assigned
    def encapsulation_mode=(encapsulation_mode)
      validator = EnumAttributeValidator.new('String', ['TUNNEL_MODE'])
      unless validator.valid?(encapsulation_mode)
        fail ArgumentError, 'invalid value for "encapsulation_mode", must be one of #{validator.allowable_values}.'
      end
      @encapsulation_mode = encapsulation_mode
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] transform_protocol Object to be assigned
    def transform_protocol=(transform_protocol)
      validator = EnumAttributeValidator.new('String', ['ESP'])
      unless validator.valid?(transform_protocol)
        fail ArgumentError, 'invalid value for "transform_protocol", must be one of #{validator.allowable_values}.'
      end
      @transform_protocol = transform_protocol
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] df_policy Object to be assigned
    def df_policy=(df_policy)
      validator = EnumAttributeValidator.new('String', ['COPY', 'CLEAR'])
      unless validator.valid?(df_policy)
        fail ArgumentError, 'invalid value for "df_policy", must be one of #{validator.allowable_values}.'
      end
      @df_policy = df_policy
    end

    # Custom attribute writer method with validation
    # @param [Object] sa_life_time Value to be assigned
    def sa_life_time=(sa_life_time)
      if !sa_life_time.nil? && sa_life_time > 31536000
        fail ArgumentError, 'invalid value for "sa_life_time", must be smaller than or equal to 31536000.'
      end

      if !sa_life_time.nil? && sa_life_time < 900
        fail ArgumentError, 'invalid value for "sa_life_time", must be greater than or equal to 900.'
      end

      @sa_life_time = sa_life_time
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          _self == o._self &&
          _links == o._links &&
          _schema == o._schema &&
          _revision == o._revision &&
          _system_owned == o._system_owned &&
          display_name == o.display_name &&
          description == o.description &&
          tags == o.tags &&
          _create_user == o._create_user &&
          _protection == o._protection &&
          _create_time == o._create_time &&
          _last_modified_time == o._last_modified_time &&
          _last_modified_user == o._last_modified_user &&
          id == o.id &&
          resource_type == o.resource_type &&
          encapsulation_mode == o.encapsulation_mode &&
          transform_protocol == o.transform_protocol &&
          digest_algorithms == o.digest_algorithms &&
          encryption_algorithms == o.encryption_algorithms &&
          enable_perfect_forward_secrecy == o.enable_perfect_forward_secrecy &&
          dh_groups == o.dh_groups &&
          df_policy == o.df_policy &&
          sa_life_time == o.sa_life_time
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [_self, _links, _schema, _revision, _system_owned, display_name, description, tags, _create_user, _protection, _create_time, _last_modified_time, _last_modified_user, id, resource_type, encapsulation_mode, transform_protocol, digest_algorithms, encryption_algorithms, enable_perfect_forward_secrecy, dh_groups, df_policy, sa_life_time].hash
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