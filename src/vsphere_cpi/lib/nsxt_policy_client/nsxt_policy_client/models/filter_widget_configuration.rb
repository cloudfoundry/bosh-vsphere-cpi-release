=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Represents configuration for filter widget. This is abstract representation of filter widget.
  class FilterWidgetConfiguration
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

    # Title of the widget. If display_name is omitted, the widget will be shown without a title.
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

    # Supported visualization types are LabelValueConfiguration, DonutConfiguration, GridConfiguration, StatsConfiguration, MultiWidgetConfiguration, GraphConfiguration, ContainerConfiguration, CustomWidgetConfiguration and DropdownFilterWidgetConfiguration.
    attr_accessor :resource_type

    # Features required to view the widget.
    attr_accessor :feature_set

    # Default filter values to be passed to datasources. This will be used when the report is requested without filter values.
    attr_accessor :default_filter_value

    # The 'datasources' represent the sources from which data will be fetched. Currently, only NSX-API is supported as a 'default' datasource. An example of specifying 'default' datasource along with the urls to fetch data from is given at 'example_request' section of 'CreateWidgetConfiguration' API.
    attr_accessor :datasources

    # Specify relavite weight in WidgetItem for placement in a view. Please see WidgetItem for details.
    attr_accessor :weight

    attr_accessor :footer

    # Flag to indicate that widget will continue to work without filter value. If this flag is set to false then default_filter_value is manadatory.
    attr_accessor :filter_value_required

    # Represents the horizontal span of the widget / container.
    attr_accessor :span

    # Icons to be applied at dashboard for widgets and UI elements.
    attr_accessor :icons

    # Set to true if this widget should be used as a drilldown.
    attr_accessor :is_drilldown

    # Id of filter widget for subscription, if any. Id should be a valid id of an existing filter widget. Filter widget should be from the same view. Datasource URLs should have placeholder values equal to filter alias to accept the filter value on filter change.
    attr_accessor :filter

    # Id of drilldown widget, if any. Id should be a valid id of an existing widget. A widget is considered as drilldown widget when it is associated with any other widget and provides more detailed information about any data item from the parent widget.
    attr_accessor :drilldown_id

    # Please use the property 'shared' of View instead of this. The widgets of a shared view are visible to other users.
    attr_accessor :shared

    # Legend to be displayed. If legend is not needed, do not include it.
    attr_accessor :legend

    # Alias to be used when emitting filter value.
    attr_accessor :_alias

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
        :'feature_set' => :'feature_set',
        :'default_filter_value' => :'default_filter_value',
        :'datasources' => :'datasources',
        :'weight' => :'weight',
        :'footer' => :'footer',
        :'filter_value_required' => :'filter_value_required',
        :'span' => :'span',
        :'icons' => :'icons',
        :'is_drilldown' => :'is_drilldown',
        :'filter' => :'filter',
        :'drilldown_id' => :'drilldown_id',
        :'shared' => :'shared',
        :'legend' => :'legend',
        :'_alias' => :'alias'
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
        :'feature_set' => :'FeatureSet',
        :'default_filter_value' => :'Array<DefaultFilterValue>',
        :'datasources' => :'Array<Datasource>',
        :'weight' => :'Integer',
        :'footer' => :'Footer',
        :'filter_value_required' => :'BOOLEAN',
        :'span' => :'Integer',
        :'icons' => :'Array<Icon>',
        :'is_drilldown' => :'BOOLEAN',
        :'filter' => :'String',
        :'drilldown_id' => :'String',
        :'shared' => :'BOOLEAN',
        :'legend' => :'Legend',
        :'_alias' => :'String'
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

      if attributes.has_key?(:'feature_set')
        self.feature_set = attributes[:'feature_set']
      end

      if attributes.has_key?(:'default_filter_value')
        if (value = attributes[:'default_filter_value']).is_a?(Array)
          self.default_filter_value = value
        end
      end

      if attributes.has_key?(:'datasources')
        if (value = attributes[:'datasources']).is_a?(Array)
          self.datasources = value
        end
      end

      if attributes.has_key?(:'weight')
        self.weight = attributes[:'weight']
      end

      if attributes.has_key?(:'footer')
        self.footer = attributes[:'footer']
      end

      if attributes.has_key?(:'filter_value_required')
        self.filter_value_required = attributes[:'filter_value_required']
      else
        self.filter_value_required = true
      end

      if attributes.has_key?(:'span')
        self.span = attributes[:'span']
      end

      if attributes.has_key?(:'icons')
        if (value = attributes[:'icons']).is_a?(Array)
          self.icons = value
        end
      end

      if attributes.has_key?(:'is_drilldown')
        self.is_drilldown = attributes[:'is_drilldown']
      else
        self.is_drilldown = false
      end

      if attributes.has_key?(:'filter')
        self.filter = attributes[:'filter']
      end

      if attributes.has_key?(:'drilldown_id')
        self.drilldown_id = attributes[:'drilldown_id']
      end

      if attributes.has_key?(:'shared')
        self.shared = attributes[:'shared']
      end

      if attributes.has_key?(:'legend')
        self.legend = attributes[:'legend']
      end

      if attributes.has_key?(:'alias')
        self._alias = attributes[:'alias']
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

      if @resource_type.nil?
        invalid_properties.push('invalid value for "resource_type", resource_type cannot be nil.')
      end

      if @resource_type.to_s.length > 255
        invalid_properties.push('invalid value for "resource_type", the character length must be smaller than or equal to 255.')
      end

      if !@span.nil? && @span > 12
        invalid_properties.push('invalid value for "span", must be smaller than or equal to 12.')
      end

      if !@span.nil? && @span < 1
        invalid_properties.push('invalid value for "span", must be greater than or equal to 1.')
      end

      if !@drilldown_id.nil? && @drilldown_id.to_s.length > 255
        invalid_properties.push('invalid value for "drilldown_id", the character length must be smaller than or equal to 255.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if !@display_name.nil? && @display_name.to_s.length > 255
      return false if !@description.nil? && @description.to_s.length > 1024
      return false if @resource_type.nil?
      resource_type_validator = EnumAttributeValidator.new('String', ['LabelValueConfiguration', 'DonutConfiguration', 'MultiWidgetConfiguration', 'ContainerConfiguration', 'StatsConfiguration', 'GridConfiguration', 'GraphConfiguration', 'CustomWidgetConfiguration', 'DropdownFilterWidgetConfiguration'])
      return false unless resource_type_validator.valid?(@resource_type)
      return false if @resource_type.to_s.length > 255
      return false if !@span.nil? && @span > 12
      return false if !@span.nil? && @span < 1
      return false if !@drilldown_id.nil? && @drilldown_id.to_s.length > 255
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
    # @param [Object] resource_type Object to be assigned
    def resource_type=(resource_type)
      validator = EnumAttributeValidator.new('String', ['LabelValueConfiguration', 'DonutConfiguration', 'MultiWidgetConfiguration', 'ContainerConfiguration', 'StatsConfiguration', 'GridConfiguration', 'GraphConfiguration', 'CustomWidgetConfiguration', 'DropdownFilterWidgetConfiguration'])
      unless validator.valid?(resource_type)
        fail ArgumentError, 'invalid value for "resource_type", must be one of #{validator.allowable_values}.'
      end
      @resource_type = resource_type
    end

    # Custom attribute writer method with validation
    # @param [Object] span Value to be assigned
    def span=(span)
      if !span.nil? && span > 12
        fail ArgumentError, 'invalid value for "span", must be smaller than or equal to 12.'
      end

      if !span.nil? && span < 1
        fail ArgumentError, 'invalid value for "span", must be greater than or equal to 1.'
      end

      @span = span
    end

    # Custom attribute writer method with validation
    # @param [Object] drilldown_id Value to be assigned
    def drilldown_id=(drilldown_id)
      if !drilldown_id.nil? && drilldown_id.to_s.length > 255
        fail ArgumentError, 'invalid value for "drilldown_id", the character length must be smaller than or equal to 255.'
      end

      @drilldown_id = drilldown_id
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
          feature_set == o.feature_set &&
          default_filter_value == o.default_filter_value &&
          datasources == o.datasources &&
          weight == o.weight &&
          footer == o.footer &&
          filter_value_required == o.filter_value_required &&
          span == o.span &&
          icons == o.icons &&
          is_drilldown == o.is_drilldown &&
          filter == o.filter &&
          drilldown_id == o.drilldown_id &&
          shared == o.shared &&
          legend == o.legend &&
          _alias == o._alias
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [_self, _links, _schema, _revision, _system_owned, display_name, description, tags, _create_user, _protection, _create_time, _last_modified_time, _last_modified_user, id, resource_type, feature_set, default_filter_value, datasources, weight, footer, filter_value_required, span, icons, is_drilldown, filter, drilldown_id, shared, legend, _alias].hash
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
