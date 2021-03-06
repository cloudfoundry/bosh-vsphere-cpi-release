=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Represents a NAT rule between source and destination at T0/T1 router.
  class PolicyNatRule
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

    # Absolute path of this object
    attr_accessor :path

    # Path of its parent
    attr_accessor :parent_path

    # This is a UUID generated by the GM/LM to uniquely identify entites in a federated environment. For entities that are stretched across multiple sites, the same ID will be used on all the stretched sites. 
    attr_accessor :unique_id

    # Path relative from its parent
    attr_accessor :relative_path

    # subtree for this type within policy tree containing nested elements. 
    attr_accessor :children

    # Global intent objects cannot be modified by the user. However, certain global intent objects can be overridden locally by use of this property. In such cases, the overridden local values take precedence over the globally defined values for the properties. 
    attr_accessor :overridden

    # Intent objects are not directly deleted from the system when a delete is invoked on them. They are marked for deletion and only when all the realized entities for that intent object gets deleted, the intent object is deleted. Objects that are marked for deletion are not returned in GET call. One can use the search API to get these objects. 
    attr_accessor :marked_for_delete

    # This supports single IP address or comma separated list of single IP addresses or CIDR. This does not support IP range or IP sets. For SNAT, DNAT, NAT64 and REFLEXIVE rules, this ia a mandatory field, which represents the translated network address. For NO_SNAT and NO_DNAT this should be empty. 
    attr_accessor :translated_network

    # The flag, which suggests whether the logging of NAT rule is enabled or disabled. The default is False. 
    attr_accessor :logging

    # It represents the path of Service on which the NAT rule will be applied. If not provided or if it is blank then Policy manager will consider it as ANY. Please note, if this is a DNAT, the destination_port of the service will be realized on NSX Manager as the translated_port. And if this is a SNAT, the destination_port will be ignored. 
    attr_accessor :service

    # This supports single IP address or comma separated list of single IP addresses or CIDR. This does not support IP range or IP sets. For SNAT, NO_SNAT, NAT64 and REFLEXIVE rules, this is a mandatory field and represents the source network of the packets leaving the network. For DNAT and NO_DNAT rules, optionally it can contain source network of incoming packets. NULL value for this field represents ANY network. 
    attr_accessor :source_network

    # The flag, which suggests whether the NAT rule is enabled or disabled. The default is True. 
    attr_accessor :enabled

    # Please note, if there is service configured in this NAT rule, the translated_port will be realized on NSX Manager as the destination_port. If there is no sevice configured, the port will be ignored. 
    attr_accessor :translated_ports

    # Source NAT(SNAT) - translates a source IP address in an outbound packet so that the packet appears to originate from a different network. SNAT is only supported when the logical router is running in active-standby mode. Destination NAT(DNAT) - translates the destination IP address of inbound packets so that packets are delivered to a target address into another network. DNAT is only supported when the logical router is running in active-standby mode. Reflexive NAT(REFLEXIVE) - IP-Range and CIDR are supported to define the \"n\". The number of original networks should be exactly the same as that of translated networks. The address translation is deterministic. Reflexive is supported on both Active/Standby and Active/Active LR. NO_SNAT and NO_DNAT - These do not have support for translated_fields, only source_network and destination_network fields are supported. NAT64 - translates an external IPv6 address to a internal IPv4 address. 
    attr_accessor :action

    # Represents the array of policy paths of ProviderInterface or NetworkInterface or labels of type ProviderInterface or NetworkInterface on which the NAT rule should get enforced. The interfaces must belong to the same router for which the NAT Rule is created. 
    attr_accessor :scope

    # It indicates how the firewall matches the address after NATing if firewall stage is not skipped.  MATCH_EXTERNAL_ADDRESS indicates the firewall will be applied to external address of a NAT rule. For SNAT, the external address is the translated source address after NAT is done. For DNAT, the external address is the original destination address before NAT is done. For REFLEXIVE, to egress traffic, the firewall will be applied to the translated source address after NAT is done; To ingress traffic, the firewall will be applied to the original destination address before NAT is done.  MATCH_INTERNAL_ADDRESS indicates the firewall will be applied to internal address of a NAT rule. For SNAT, the internal address is the original source address before NAT is done. For DNAT, the internal address is the translated destination address after NAT is done. For REFLEXIVE, to egress traffic, the firewall will be applied to the original source address before NAT is done; To ingress traffic, the firewall will be applied to the translated destination address after NAT is done.  BYPASS indicates the firewall stage will be skipped.  For NO_SNAT or NO_DNAT, it must be BYPASS or leave it unassigned 
    attr_accessor :firewall_match

    # This supports single IP address or comma separated list of single IP addresses or CIDR. This does not support IP range or IP sets. For DNAT and NO_DNAT rules, this is a mandatory field, and represents the destination network for the incoming packets. For other type of rules, optionally it can contain destination network of outgoing packets. NULL value for this field represents ANY network. 
    attr_accessor :destination_network

    # The sequence_number decides the rule_priority of a NAT rule. Sequence_number and rule_priority have 1:1 mapping.For each NAT section, there will be reserved rule_priority numbers.The valid range of rule_priority number is from 0 to 2147483647(MAX_INT). 1. INTERNAL section     rule_priority reserved from 0 - 1023 (1024 rules)     valid sequence_number range  0 - 1023 2. USER section    rule_priority reserved from 1024 - 2147482623 (2147481600 rules)    valid sequence_number range  0 - 2147481599 3. DEFAULT section    rule_priority reserved from 2147482624 - 2147483647 (1024 rules)    valid sequence_number range  0 - 1023 
    attr_accessor :sequence_number

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
        :'path' => :'path',
        :'parent_path' => :'parent_path',
        :'unique_id' => :'unique_id',
        :'relative_path' => :'relative_path',
        :'children' => :'children',
        :'overridden' => :'overridden',
        :'marked_for_delete' => :'marked_for_delete',
        :'translated_network' => :'translated_network',
        :'logging' => :'logging',
        :'service' => :'service',
        :'source_network' => :'source_network',
        :'enabled' => :'enabled',
        :'translated_ports' => :'translated_ports',
        :'action' => :'action',
        :'scope' => :'scope',
        :'firewall_match' => :'firewall_match',
        :'destination_network' => :'destination_network',
        :'sequence_number' => :'sequence_number'
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
        :'path' => :'String',
        :'parent_path' => :'String',
        :'unique_id' => :'String',
        :'relative_path' => :'String',
        :'children' => :'Array<ChildPolicyConfigResource>',
        :'overridden' => :'BOOLEAN',
        :'marked_for_delete' => :'BOOLEAN',
        :'translated_network' => :'String',
        :'logging' => :'BOOLEAN',
        :'service' => :'String',
        :'source_network' => :'String',
        :'enabled' => :'BOOLEAN',
        :'translated_ports' => :'String',
        :'action' => :'String',
        :'scope' => :'Array<String>',
        :'firewall_match' => :'String',
        :'destination_network' => :'String',
        :'sequence_number' => :'Integer'
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

      if attributes.has_key?(:'path')
        self.path = attributes[:'path']
      end

      if attributes.has_key?(:'parent_path')
        self.parent_path = attributes[:'parent_path']
      end

      if attributes.has_key?(:'unique_id')
        self.unique_id = attributes[:'unique_id']
      end

      if attributes.has_key?(:'relative_path')
        self.relative_path = attributes[:'relative_path']
      end

      if attributes.has_key?(:'children')
        if (value = attributes[:'children']).is_a?(Array)
          self.children = value
        end
      end

      if attributes.has_key?(:'overridden')
        self.overridden = attributes[:'overridden']
      else
        self.overridden = false
      end

      if attributes.has_key?(:'marked_for_delete')
        self.marked_for_delete = attributes[:'marked_for_delete']
      else
        self.marked_for_delete = false
      end

      if attributes.has_key?(:'translated_network')
        self.translated_network = attributes[:'translated_network']
      end

      if attributes.has_key?(:'logging')
        self.logging = attributes[:'logging']
      else
        self.logging = false
      end

      if attributes.has_key?(:'service')
        self.service = attributes[:'service']
      end

      if attributes.has_key?(:'source_network')
        self.source_network = attributes[:'source_network']
      end

      if attributes.has_key?(:'enabled')
        self.enabled = attributes[:'enabled']
      else
        self.enabled = true
      end

      if attributes.has_key?(:'translated_ports')
        self.translated_ports = attributes[:'translated_ports']
      end

      if attributes.has_key?(:'action')
        self.action = attributes[:'action']
      end

      if attributes.has_key?(:'scope')
        if (value = attributes[:'scope']).is_a?(Array)
          self.scope = value
        end
      end

      if attributes.has_key?(:'firewall_match')
        self.firewall_match = attributes[:'firewall_match']
      else
        self.firewall_match = 'MATCH_INTERNAL_ADDRESS'
      end

      if attributes.has_key?(:'destination_network')
        self.destination_network = attributes[:'destination_network']
      end

      if attributes.has_key?(:'sequence_number')
        self.sequence_number = attributes[:'sequence_number']
      else
        self.sequence_number = 0
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

      if @action.nil?
        invalid_properties.push('invalid value for "action", action cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if !@display_name.nil? && @display_name.to_s.length > 255
      return false if !@description.nil? && @description.to_s.length > 1024
      return false if @action.nil?
      action_validator = EnumAttributeValidator.new('String', ['SNAT', 'DNAT', 'REFLEXIVE', 'NO_SNAT', 'NO_DNAT', 'NAT64'])
      return false unless action_validator.valid?(@action)
      firewall_match_validator = EnumAttributeValidator.new('String', ['MATCH_EXTERNAL_ADDRESS', 'MATCH_INTERNAL_ADDRESS', 'BYPASS'])
      return false unless firewall_match_validator.valid?(@firewall_match)
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
    # @param [Object] action Object to be assigned
    def action=(action)
      validator = EnumAttributeValidator.new('String', ['SNAT', 'DNAT', 'REFLEXIVE', 'NO_SNAT', 'NO_DNAT', 'NAT64'])
      unless validator.valid?(action)
        fail ArgumentError, 'invalid value for "action", must be one of #{validator.allowable_values}.'
      end
      @action = action
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] firewall_match Object to be assigned
    def firewall_match=(firewall_match)
      validator = EnumAttributeValidator.new('String', ['MATCH_EXTERNAL_ADDRESS', 'MATCH_INTERNAL_ADDRESS', 'BYPASS'])
      unless validator.valid?(firewall_match)
        fail ArgumentError, 'invalid value for "firewall_match", must be one of #{validator.allowable_values}.'
      end
      @firewall_match = firewall_match
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
          path == o.path &&
          parent_path == o.parent_path &&
          unique_id == o.unique_id &&
          relative_path == o.relative_path &&
          children == o.children &&
          overridden == o.overridden &&
          marked_for_delete == o.marked_for_delete &&
          translated_network == o.translated_network &&
          logging == o.logging &&
          service == o.service &&
          source_network == o.source_network &&
          enabled == o.enabled &&
          translated_ports == o.translated_ports &&
          action == o.action &&
          scope == o.scope &&
          firewall_match == o.firewall_match &&
          destination_network == o.destination_network &&
          sequence_number == o.sequence_number
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [_self, _links, _schema, _revision, _system_owned, display_name, description, tags, _create_user, _protection, _create_time, _last_modified_time, _last_modified_user, id, resource_type, path, parent_path, unique_id, relative_path, children, overridden, marked_for_delete, translated_network, logging, service, source_network, enabled, translated_ports, action, scope, firewall_match, destination_network, sequence_number].hash
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
