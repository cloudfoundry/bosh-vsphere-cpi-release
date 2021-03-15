=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # A rule indicates the action to be performed for various types of traffic flowing between workload groups.
  class Rule
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

    # Flag to disable the rule. Default is enabled.
    attr_accessor :disabled

    # Define direction of traffic. 
    attr_accessor :direction

    # Type of IP packet that should be matched while enforcing the rule. The value is set to IPV4_IPV6 for Layer3 rule if not specified. For Layer2/Ether rule the value must be null. 
    attr_accessor :ip_protocol

    # Text for additional notes on changes.
    attr_accessor :notes

    # Flag to enable packet logging. Default is disabled.
    attr_accessor :logged

    # Holds the list of layer 7 service profile paths. These profiles accept attributes and sub-attributes of various network services (e.g. L4 AppId, encryption algorithm, domain name, etc) as key value pairs. 
    attr_accessor :profiles

    # This is a unique 4 byte positive number that is assigned by the system.  This rule id is passed all the way down to the data path. The first 1GB (1000 to 2^30) will be shared by GM and LM with zebra style striped number space. For E.g 1000 to (1Million -1) by LM, (1M - 2M-1) by GM and so on. 
    attr_accessor :rule_id

    # A flag to indicate whether rule is a default rule.
    attr_accessor :is_default

    # User level field which will be printed in CLI and packet logs. 
    attr_accessor :tag

    # We need paths as duplicate names may exist for groups under different domains. Along with paths we support IP Address of type IPv4 and IPv6. IP Address can be in one of the format(CIDR, IP Address, Range of IP Address). In order to specify all groups, use the constant \"ANY\". This is case insensitive. If \"ANY\" is used, it should be the ONLY element in the group array. Error will be thrown if ANY is used in conjunction with other values. 
    attr_accessor :source_groups

    # We need paths as duplicate names may exist for groups under different domains. Along with paths we support IP Address of type IPv4 and IPv6. IP Address can be in one of the format(CIDR, IP Address, Range of IP Address). In order to specify all groups, use the constant \"ANY\". This is case insensitive. If \"ANY\" is used, it should be the ONLY element in the group array. Error will be thrown if ANY is used in conjunction with other values. 
    attr_accessor :destination_groups

    # In order to specify all services, use the constant \"ANY\". This is case insensitive. If \"ANY\" is used, it should be the ONLY element in the services array. Error will be thrown if ANY is used in conjunction with other values. 
    attr_accessor :services

    # The list of policy paths where the rule is applied LR/Edge/T0/T1/LRP etc. Note that a given rule can be applied on multiple LRs/LRPs. 
    attr_accessor :scope

    # In order to specify raw services this can be used, along with services which contains path to services. This can be empty or null. 
    attr_accessor :service_entries

    # If set to true, the rule gets applied on all the groups that are NOT part of the destination groups. If false, the rule applies to the destination groups 
    attr_accessor :destinations_excluded

    # This field is used to resolve conflicts between multiple Rules under Security or Gateway Policy for a Domain If no sequence number is specified in the payload, a value of 0 is assigned by default. If there are multiple rules with the same sequence number then their order is not deterministic. If a specific order of rules is desired, then one has to specify unique sequence numbers or use the POST request on the rule entity with a query parameter action=revise to let the framework assign a sequence number 
    attr_accessor :sequence_number

    # If set to true, the rule gets applied on all the groups that are NOT part of the source groups. If false, the rule applies to the source groups 
    attr_accessor :sources_excluded

    # The action to be applied to all the services The JUMP_TO_APPLICATION action is only supported for rules created in the Environment category. Once a match is hit then the rule processing will jump to the rules present in the Application category, skipping all further rules in the Environment category. If no rules match in the Application category then the default application rule will be hit. This is applicable only for DFW. 
    attr_accessor :action

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
        :'disabled' => :'disabled',
        :'direction' => :'direction',
        :'ip_protocol' => :'ip_protocol',
        :'notes' => :'notes',
        :'logged' => :'logged',
        :'profiles' => :'profiles',
        :'rule_id' => :'rule_id',
        :'is_default' => :'is_default',
        :'tag' => :'tag',
        :'source_groups' => :'source_groups',
        :'destination_groups' => :'destination_groups',
        :'services' => :'services',
        :'scope' => :'scope',
        :'service_entries' => :'service_entries',
        :'destinations_excluded' => :'destinations_excluded',
        :'sequence_number' => :'sequence_number',
        :'sources_excluded' => :'sources_excluded',
        :'action' => :'action'
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
        :'disabled' => :'BOOLEAN',
        :'direction' => :'String',
        :'ip_protocol' => :'String',
        :'notes' => :'String',
        :'logged' => :'BOOLEAN',
        :'profiles' => :'Array<String>',
        :'rule_id' => :'Integer',
        :'is_default' => :'BOOLEAN',
        :'tag' => :'String',
        :'source_groups' => :'Array<String>',
        :'destination_groups' => :'Array<String>',
        :'services' => :'Array<String>',
        :'scope' => :'Array<String>',
        :'service_entries' => :'Array<ServiceEntry>',
        :'destinations_excluded' => :'BOOLEAN',
        :'sequence_number' => :'Integer',
        :'sources_excluded' => :'BOOLEAN',
        :'action' => :'String'
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

      if attributes.has_key?(:'disabled')
        self.disabled = attributes[:'disabled']
      else
        self.disabled = false
      end

      if attributes.has_key?(:'direction')
        self.direction = attributes[:'direction']
      else
        self.direction = 'IN_OUT'
      end

      if attributes.has_key?(:'ip_protocol')
        self.ip_protocol = attributes[:'ip_protocol']
      end

      if attributes.has_key?(:'notes')
        self.notes = attributes[:'notes']
      end

      if attributes.has_key?(:'logged')
        self.logged = attributes[:'logged']
      else
        self.logged = false
      end

      if attributes.has_key?(:'profiles')
        if (value = attributes[:'profiles']).is_a?(Array)
          self.profiles = value
        end
      end

      if attributes.has_key?(:'rule_id')
        self.rule_id = attributes[:'rule_id']
      end

      if attributes.has_key?(:'is_default')
        self.is_default = attributes[:'is_default']
      end

      if attributes.has_key?(:'tag')
        self.tag = attributes[:'tag']
      end

      if attributes.has_key?(:'source_groups')
        if (value = attributes[:'source_groups']).is_a?(Array)
          self.source_groups = value
        end
      end

      if attributes.has_key?(:'destination_groups')
        if (value = attributes[:'destination_groups']).is_a?(Array)
          self.destination_groups = value
        end
      end

      if attributes.has_key?(:'services')
        if (value = attributes[:'services']).is_a?(Array)
          self.services = value
        end
      end

      if attributes.has_key?(:'scope')
        if (value = attributes[:'scope']).is_a?(Array)
          self.scope = value
        end
      end

      if attributes.has_key?(:'service_entries')
        if (value = attributes[:'service_entries']).is_a?(Array)
          self.service_entries = value
        end
      end

      if attributes.has_key?(:'destinations_excluded')
        self.destinations_excluded = attributes[:'destinations_excluded']
      else
        self.destinations_excluded = false
      end

      if attributes.has_key?(:'sequence_number')
        self.sequence_number = attributes[:'sequence_number']
      end

      if attributes.has_key?(:'sources_excluded')
        self.sources_excluded = attributes[:'sources_excluded']
      else
        self.sources_excluded = false
      end

      if attributes.has_key?(:'action')
        self.action = attributes[:'action']
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

      if !@notes.nil? && @notes.to_s.length > 2048
        invalid_properties.push('invalid value for "notes", the character length must be smaller than or equal to 2048.')
      end

      if !@sequence_number.nil? && @sequence_number < 0
        invalid_properties.push('invalid value for "sequence_number", must be greater than or equal to 0.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if !@display_name.nil? && @display_name.to_s.length > 255
      return false if !@description.nil? && @description.to_s.length > 1024
      direction_validator = EnumAttributeValidator.new('String', ['IN', 'OUT', 'IN_OUT'])
      return false unless direction_validator.valid?(@direction)
      ip_protocol_validator = EnumAttributeValidator.new('String', ['IPV4', 'IPV6', 'IPV4_IPV6'])
      return false unless ip_protocol_validator.valid?(@ip_protocol)
      return false if !@notes.nil? && @notes.to_s.length > 2048
      return false if !@sequence_number.nil? && @sequence_number < 0
      action_validator = EnumAttributeValidator.new('String', ['ALLOW', 'DROP', 'REJECT', 'JUMP_TO_APPLICATION'])
      return false unless action_validator.valid?(@action)
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
    # @param [Object] direction Object to be assigned
    def direction=(direction)
      validator = EnumAttributeValidator.new('String', ['IN', 'OUT', 'IN_OUT'])
      unless validator.valid?(direction)
        fail ArgumentError, 'invalid value for "direction", must be one of #{validator.allowable_values}.'
      end
      @direction = direction
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] ip_protocol Object to be assigned
    def ip_protocol=(ip_protocol)
      validator = EnumAttributeValidator.new('String', ['IPV4', 'IPV6', 'IPV4_IPV6'])
      unless validator.valid?(ip_protocol)
        fail ArgumentError, 'invalid value for "ip_protocol", must be one of #{validator.allowable_values}.'
      end
      @ip_protocol = ip_protocol
    end

    # Custom attribute writer method with validation
    # @param [Object] notes Value to be assigned
    def notes=(notes)
      if !notes.nil? && notes.to_s.length > 2048
        fail ArgumentError, 'invalid value for "notes", the character length must be smaller than or equal to 2048.'
      end

      @notes = notes
    end

    # Custom attribute writer method with validation
    # @param [Object] sequence_number Value to be assigned
    def sequence_number=(sequence_number)
      if !sequence_number.nil? && sequence_number < 0
        fail ArgumentError, 'invalid value for "sequence_number", must be greater than or equal to 0.'
      end

      @sequence_number = sequence_number
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] action Object to be assigned
    def action=(action)
      validator = EnumAttributeValidator.new('String', ['ALLOW', 'DROP', 'REJECT', 'JUMP_TO_APPLICATION'])
      unless validator.valid?(action)
        fail ArgumentError, 'invalid value for "action", must be one of #{validator.allowable_values}.'
      end
      @action = action
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
          disabled == o.disabled &&
          direction == o.direction &&
          ip_protocol == o.ip_protocol &&
          notes == o.notes &&
          logged == o.logged &&
          profiles == o.profiles &&
          rule_id == o.rule_id &&
          is_default == o.is_default &&
          tag == o.tag &&
          source_groups == o.source_groups &&
          destination_groups == o.destination_groups &&
          services == o.services &&
          scope == o.scope &&
          service_entries == o.service_entries &&
          destinations_excluded == o.destinations_excluded &&
          sequence_number == o.sequence_number &&
          sources_excluded == o.sources_excluded &&
          action == o.action
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [_self, _links, _schema, _revision, _system_owned, display_name, description, tags, _create_user, _protection, _create_time, _last_modified_time, _last_modified_user, id, resource_type, path, parent_path, unique_id, relative_path, children, overridden, marked_for_delete, disabled, direction, ip_protocol, notes, logged, profiles, rule_id, is_default, tag, source_groups, destination_groups, services, scope, service_entries, destinations_excluded, sequence_number, sources_excluded, action].hash
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
