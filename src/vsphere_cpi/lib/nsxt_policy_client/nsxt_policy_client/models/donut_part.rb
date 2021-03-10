=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'date'

module NSXTPolicy
  # Represents an entity or portion to be plotted on a donut or stats chart.
  class DonutPart
    # A numerical value that represents the portion or entity of the donut or stats chart.
    attr_accessor :field

    # If true, legend will be shown only if the data for the part is available. This is applicable only if legends are specified in widget configuration.
    attr_accessor :hide_empty_legend

    # If the condition is met then the part will be displayed. Examples of expression syntax are provided under 'example_request' section of 'CreateWidgetConfiguration' API.
    attr_accessor :condition

    # Id of drilldown widget, if any. Id should be a valid id of an existing widget. A widget is considered as drilldown widget when it is associated with any other widget and provides more detailed information about any data item from the parent widget.
    attr_accessor :drilldown_id

    # If a section 'template' holds this donut or stats part, then the label is auto-generated from the fetched field values after applying the template.
    attr_accessor :label

    # Hyperlink of the specified UI page that provides details. If drilldown_id is provided, then navigation cannot be used.
    attr_accessor :navigation

    # Multi-line text to be shown on tooltip while hovering over the portion.
    attr_accessor :tooltip

    # Additional rendering or conditional evaluation of the field values to be performed, if any.
    attr_accessor :render_configuration

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'field' => :'field',
        :'hide_empty_legend' => :'hide_empty_legend',
        :'condition' => :'condition',
        :'drilldown_id' => :'drilldown_id',
        :'label' => :'label',
        :'navigation' => :'navigation',
        :'tooltip' => :'tooltip',
        :'render_configuration' => :'render_configuration'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'field' => :'String',
        :'hide_empty_legend' => :'BOOLEAN',
        :'condition' => :'String',
        :'drilldown_id' => :'String',
        :'label' => :'Label',
        :'navigation' => :'String',
        :'tooltip' => :'Array<Tooltip>',
        :'render_configuration' => :'Array<RenderConfiguration>'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'field')
        self.field = attributes[:'field']
      end

      if attributes.has_key?(:'hide_empty_legend')
        self.hide_empty_legend = attributes[:'hide_empty_legend']
      else
        self.hide_empty_legend = false
      end

      if attributes.has_key?(:'condition')
        self.condition = attributes[:'condition']
      end

      if attributes.has_key?(:'drilldown_id')
        self.drilldown_id = attributes[:'drilldown_id']
      end

      if attributes.has_key?(:'label')
        self.label = attributes[:'label']
      end

      if attributes.has_key?(:'navigation')
        self.navigation = attributes[:'navigation']
      end

      if attributes.has_key?(:'tooltip')
        if (value = attributes[:'tooltip']).is_a?(Array)
          self.tooltip = value
        end
      end

      if attributes.has_key?(:'render_configuration')
        if (value = attributes[:'render_configuration']).is_a?(Array)
          self.render_configuration = value
        end
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @field.nil?
        invalid_properties.push('invalid value for "field", field cannot be nil.')
      end

      if @field.to_s.length > 1024
        invalid_properties.push('invalid value for "field", the character length must be smaller than or equal to 1024.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @field.nil?
      return false if @field.to_s.length > 1024
      true
    end

    # Custom attribute writer method with validation
    # @param [Object] field Value to be assigned
    def field=(field)
      if field.nil?
        fail ArgumentError, 'field cannot be nil'
      end

      if field.to_s.length > 1024
        fail ArgumentError, 'invalid value for "field", the character length must be smaller than or equal to 1024.'
      end

      @field = field
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          field == o.field &&
          hide_empty_legend == o.hide_empty_legend &&
          condition == o.condition &&
          drilldown_id == o.drilldown_id &&
          label == o.label &&
          navigation == o.navigation &&
          tooltip == o.tooltip &&
          render_configuration == o.render_configuration
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [field, hide_empty_legend, condition, drilldown_id, label, navigation, tooltip, render_configuration].hash
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
