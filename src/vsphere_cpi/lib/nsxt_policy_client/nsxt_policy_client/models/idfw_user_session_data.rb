=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Identity Firewall user session data on a client machine (typically a VM). Multiple entries for the same user can be returned if the user logins to multiple sessions on the same VM. 
  class IdfwUserSessionData
    # AD user ID (may not exist).
    attr_accessor :user_id

    # User session ID.  This also indicates whether this is VDI / RDSH.
    attr_accessor :user_session_id

    # Virtual machine (external ID or BIOS UUID) where login/logout events occurred.
    attr_accessor :vm_ext_id

    # Identifier of user session data.
    attr_accessor :id

    # Login time.
    attr_accessor :login_time

    # AD user name.
    attr_accessor :user_name

    # Logout time if applicable.  An active user session has no logout time. Non-active user session is stored (up to last 5 most recent entries) per VM and per user. 
    attr_accessor :logout_time

    # AD Domain of user.
    attr_accessor :domain_name

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'user_id' => :'user_id',
        :'user_session_id' => :'user_session_id',
        :'vm_ext_id' => :'vm_ext_id',
        :'id' => :'id',
        :'login_time' => :'login_time',
        :'user_name' => :'user_name',
        :'logout_time' => :'logout_time',
        :'domain_name' => :'domain_name'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'user_id' => :'String',
        :'user_session_id' => :'Integer',
        :'vm_ext_id' => :'String',
        :'id' => :'String',
        :'login_time' => :'Integer',
        :'user_name' => :'String',
        :'logout_time' => :'Integer',
        :'domain_name' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'user_id')
        self.user_id = attributes[:'user_id']
      end

      if attributes.has_key?(:'user_session_id')
        self.user_session_id = attributes[:'user_session_id']
      end

      if attributes.has_key?(:'vm_ext_id')
        self.vm_ext_id = attributes[:'vm_ext_id']
      end

      if attributes.has_key?(:'id')
        self.id = attributes[:'id']
      end

      if attributes.has_key?(:'login_time')
        self.login_time = attributes[:'login_time']
      end

      if attributes.has_key?(:'user_name')
        self.user_name = attributes[:'user_name']
      end

      if attributes.has_key?(:'logout_time')
        self.logout_time = attributes[:'logout_time']
      end

      if attributes.has_key?(:'domain_name')
        self.domain_name = attributes[:'domain_name']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @user_session_id.nil?
        invalid_properties.push('invalid value for "user_session_id", user_session_id cannot be nil.')
      end

      if @login_time.nil?
        invalid_properties.push('invalid value for "login_time", login_time cannot be nil.')
      end

      if @user_name.nil?
        invalid_properties.push('invalid value for "user_name", user_name cannot be nil.')
      end

      if @domain_name.nil?
        invalid_properties.push('invalid value for "domain_name", domain_name cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @user_session_id.nil?
      return false if @login_time.nil?
      return false if @user_name.nil?
      return false if @domain_name.nil?
      true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          user_id == o.user_id &&
          user_session_id == o.user_session_id &&
          vm_ext_id == o.vm_ext_id &&
          id == o.id &&
          login_time == o.login_time &&
          user_name == o.user_name &&
          logout_time == o.logout_time &&
          domain_name == o.domain_name
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [user_id, user_session_id, vm_ext_id, id, login_time, user_name, logout_time, domain_name].hash
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
