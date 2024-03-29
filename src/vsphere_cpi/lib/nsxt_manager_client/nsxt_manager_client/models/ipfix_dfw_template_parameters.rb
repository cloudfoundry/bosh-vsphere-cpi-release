=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXT
  # This entity represents the flow parameters which are exported. 
  class IpfixDfwTemplateParameters
    # Type of the IPv4 ICMP message. 
    attr_accessor :source_icmp_type

    # Code of the IPv4 ICMP message. 
    attr_accessor :icmp_code

    # The destination transport port of a monitored network flow. 
    attr_accessor :destination_transport_port

    # The number of octets since the previous report (if any) in incoming packets for this flow at the observation point. The number of octets include IP header(s) and payload. 
    attr_accessor :octet_delta_count

    # VIF UUID - enterprise specific Information Element that uniquely identifies VIF. 
    attr_accessor :vif_uuid

    # The value of the protocol number in the IP packet header. 
    attr_accessor :protocol_identifier

    # Five valid values are allowed: 1. Flow Created. 2. Flow Deleted. 3. Flow Denied. 4. Flow Alert (not used in DropKick implementation). 5. Flow Update. 
    attr_accessor :firewall_event

    # Two valid values are allowed: 1. 0x00: igress flow to VM. 2. 0x01: egress flow from VM. 
    attr_accessor :flow_direction

    # The absolute timestamp (seconds) of the last packet of this flow. 
    attr_accessor :flow_end

    # The source transport port of a monitored network flow. 
    attr_accessor :source_transport_port

    # The number of incoming packets since the previous report (if any) for this flow at the observation point. 
    attr_accessor :packet_delta_count

    # The destination IP address of a monitored network flow. 
    attr_accessor :destination_address

    # The source IP address of a monitored network flow. 
    attr_accessor :source_address

    # Firewall rule Id - enterprise specific Information Element that uniquely identifies firewall rule. 
    attr_accessor :rule_id

    # The absolute timestamp (seconds) of the first packet of this flow. 
    attr_accessor :flow_start

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'source_icmp_type' => :'source_icmp_type',
        :'icmp_code' => :'icmp_code',
        :'destination_transport_port' => :'destination_transport_port',
        :'octet_delta_count' => :'octet_delta_count',
        :'vif_uuid' => :'vif_uuid',
        :'protocol_identifier' => :'protocol_identifier',
        :'firewall_event' => :'firewall_event',
        :'flow_direction' => :'flow_direction',
        :'flow_end' => :'flow_end',
        :'source_transport_port' => :'source_transport_port',
        :'packet_delta_count' => :'packet_delta_count',
        :'destination_address' => :'destination_address',
        :'source_address' => :'source_address',
        :'rule_id' => :'rule_id',
        :'flow_start' => :'flow_start'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'source_icmp_type' => :'BOOLEAN',
        :'icmp_code' => :'BOOLEAN',
        :'destination_transport_port' => :'BOOLEAN',
        :'octet_delta_count' => :'BOOLEAN',
        :'vif_uuid' => :'BOOLEAN',
        :'protocol_identifier' => :'BOOLEAN',
        :'firewall_event' => :'BOOLEAN',
        :'flow_direction' => :'BOOLEAN',
        :'flow_end' => :'BOOLEAN',
        :'source_transport_port' => :'BOOLEAN',
        :'packet_delta_count' => :'BOOLEAN',
        :'destination_address' => :'BOOLEAN',
        :'source_address' => :'BOOLEAN',
        :'rule_id' => :'BOOLEAN',
        :'flow_start' => :'BOOLEAN'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'source_icmp_type')
        self.source_icmp_type = attributes[:'source_icmp_type']
      else
        self.source_icmp_type = true
      end

      if attributes.has_key?(:'icmp_code')
        self.icmp_code = attributes[:'icmp_code']
      else
        self.icmp_code = true
      end

      if attributes.has_key?(:'destination_transport_port')
        self.destination_transport_port = attributes[:'destination_transport_port']
      else
        self.destination_transport_port = true
      end

      if attributes.has_key?(:'octet_delta_count')
        self.octet_delta_count = attributes[:'octet_delta_count']
      else
        self.octet_delta_count = true
      end

      if attributes.has_key?(:'vif_uuid')
        self.vif_uuid = attributes[:'vif_uuid']
      else
        self.vif_uuid = true
      end

      if attributes.has_key?(:'protocol_identifier')
        self.protocol_identifier = attributes[:'protocol_identifier']
      else
        self.protocol_identifier = true
      end

      if attributes.has_key?(:'firewall_event')
        self.firewall_event = attributes[:'firewall_event']
      else
        self.firewall_event = true
      end

      if attributes.has_key?(:'flow_direction')
        self.flow_direction = attributes[:'flow_direction']
      else
        self.flow_direction = true
      end

      if attributes.has_key?(:'flow_end')
        self.flow_end = attributes[:'flow_end']
      else
        self.flow_end = true
      end

      if attributes.has_key?(:'source_transport_port')
        self.source_transport_port = attributes[:'source_transport_port']
      else
        self.source_transport_port = true
      end

      if attributes.has_key?(:'packet_delta_count')
        self.packet_delta_count = attributes[:'packet_delta_count']
      else
        self.packet_delta_count = true
      end

      if attributes.has_key?(:'destination_address')
        self.destination_address = attributes[:'destination_address']
      else
        self.destination_address = true
      end

      if attributes.has_key?(:'source_address')
        self.source_address = attributes[:'source_address']
      else
        self.source_address = true
      end

      if attributes.has_key?(:'rule_id')
        self.rule_id = attributes[:'rule_id']
      else
        self.rule_id = true
      end

      if attributes.has_key?(:'flow_start')
        self.flow_start = attributes[:'flow_start']
      else
        self.flow_start = true
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
      true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          source_icmp_type == o.source_icmp_type &&
          icmp_code == o.icmp_code &&
          destination_transport_port == o.destination_transport_port &&
          octet_delta_count == o.octet_delta_count &&
          vif_uuid == o.vif_uuid &&
          protocol_identifier == o.protocol_identifier &&
          firewall_event == o.firewall_event &&
          flow_direction == o.flow_direction &&
          flow_end == o.flow_end &&
          source_transport_port == o.source_transport_port &&
          packet_delta_count == o.packet_delta_count &&
          destination_address == o.destination_address &&
          source_address == o.source_address &&
          rule_id == o.rule_id &&
          flow_start == o.flow_start
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [source_icmp_type, icmp_code, destination_transport_port, octet_delta_count, vif_uuid, protocol_identifier, firewall_event, flow_direction, flow_end, source_transport_port, packet_delta_count, destination_address, source_address, rule_id, flow_start].hash
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
