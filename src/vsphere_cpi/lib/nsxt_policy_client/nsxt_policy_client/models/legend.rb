=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  # Represents legend that describes the entities of the widget.
  class Legend
    # Describes the relative placement of legend. The legend of a widget can be placed either to the TOP or BOTTOM or LEFT or RIGHT relative to the widget. For example, if RIGHT is chosen then legend is placed to the right of the widget.
    attr_accessor :position

    # If set to true, it will display the counts in legend. If set to false, counts of entities are not displayed in the legend.
    attr_accessor :display_count

    # Describes the render type for the legend. The legend for an entity describes the entity in the widget. The supported legend type is a circle against which the entity's details such as display_name are shown. The color of the circle denotes the color of the entity shown inside the widget.
    attr_accessor :type

    # Show unit of entities in the legend.
    attr_accessor :unit

    # Describes the alignment of legend. Alignment of a legend denotes how individual items of the legend are aligned in a container. For example, if VERTICAL is chosen then the items of the legend will appear one below the other and if HORIZONTAL is chosen then the items will appear side by side.
    attr_accessor :alignment

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
        :'position' => :'position',
        :'display_count' => :'display_count',
        :'type' => :'type',
        :'unit' => :'unit',
        :'alignment' => :'alignment'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'position' => :'String',
        :'display_count' => :'BOOLEAN',
        :'type' => :'String',
        :'unit' => :'String',
        :'alignment' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'position')
        self.position = attributes[:'position']
      else
        self.position = 'RIGHT'
      end

      if attributes.has_key?(:'display_count')
        self.display_count = attributes[:'display_count']
      else
        self.display_count = true
      end

      if attributes.has_key?(:'type')
        self.type = attributes[:'type']
      else
        self.type = 'CIRCLE'
      end

      if attributes.has_key?(:'unit')
        self.unit = attributes[:'unit']
      end

      if attributes.has_key?(:'alignment')
        self.alignment = attributes[:'alignment']
      else
        self.alignment = 'VERTICAL'
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      position_validator = EnumAttributeValidator.new('String', ['TOP', 'BOTTOM', 'LEFT', 'RIGHT', 'TOP_RIGHT'])
      return false unless position_validator.valid?(@position)
      type_validator = EnumAttributeValidator.new('String', ['CIRCLE'])
      return false unless type_validator.valid?(@type)
      alignment_validator = EnumAttributeValidator.new('String', ['HORIZONTAL', 'VERTICAL'])
      return false unless alignment_validator.valid?(@alignment)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] position Object to be assigned
    def position=(position)
      validator = EnumAttributeValidator.new('String', ['TOP', 'BOTTOM', 'LEFT', 'RIGHT', 'TOP_RIGHT'])
      unless validator.valid?(position)
        fail ArgumentError, 'invalid value for "position", must be one of #{validator.allowable_values}.'
      end
      @position = position
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] type Object to be assigned
    def type=(type)
      validator = EnumAttributeValidator.new('String', ['CIRCLE'])
      unless validator.valid?(type)
        fail ArgumentError, 'invalid value for "type", must be one of #{validator.allowable_values}.'
      end
      @type = type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] alignment Object to be assigned
    def alignment=(alignment)
      validator = EnumAttributeValidator.new('String', ['HORIZONTAL', 'VERTICAL'])
      unless validator.valid?(alignment)
        fail ArgumentError, 'invalid value for "alignment", must be one of #{validator.allowable_values}.'
      end
      @alignment = alignment
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          position == o.position &&
          display_count == o.display_count &&
          type == o.type &&
          unit == o.unit &&
          alignment == o.alignment
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [position, display_count, type, unit, alignment].hash
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
