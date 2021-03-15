=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'date'

module NSXTPolicy
  class TraceflowObservationDroppedLogical
    # Timestamp when the observation was created by the transport node (microseconds epoch)
    attr_accessor :timestamp_micro

    # The sub type of the component that issued the observation.
    attr_accessor :component_sub_type

    attr_accessor :resource_type

    # The type of the component that issued the observation.
    attr_accessor :component_type

    # name of the transport node that observed a traceflow packet
    attr_accessor :transport_node_name

    # Timestamp when the observation was created by the transport node (milliseconds epoch)
    attr_accessor :timestamp

    # id of the transport node that observed a traceflow packet
    attr_accessor :transport_node_id

    # the hop count for observations on the transport node that a traceflow packet is injected in will be 0. The hop count is incremented each time a subsequent transport node receives the traceflow packet. The sequence number of 999 indicates that the hop count could not be determined for the containing observation.
    attr_accessor :sequence_no

    # type of the transport node that observed a traceflow packet
    attr_accessor :transport_node_type

    # The name of the component that issued the observation.
    attr_accessor :component_name

    # The ID of the NAT rule that was applied to forward the traceflow packet
    attr_accessor :nat_rule_id

    # The reason traceflow packet was dropped
    attr_accessor :reason

    # The id of the logical port at which the traceflow packet was dropped
    attr_accessor :lport_id

    # The name of the logical port at which the traceflow packet was dropped
    attr_accessor :lport_name

    # The id of the acl rule that was applied to drop the traceflow packet
    attr_accessor :acl_rule_id

    # This field specifies the ARP fails reason ARP_TIMEOUT - ARP failure due to query control plane timeout ARP_CPFAIL - ARP failure due post ARP query message to control plane failure ARP_FROMCP - ARP failure due to deleting ARP entry from control plane ARP_PORTDESTROY - ARP failure due to port destruction ARP_TABLEDESTROY - ARP failure due to ARP table destruction ARP_NETDESTROY - ARP failure due to overlay network destruction
    attr_accessor :arp_fail_reason

    # The index of service path that is a chain of services represents the point where the traceflow packet was dropped. 
    attr_accessor :service_path_index

    # The id of the component that dropped the traceflow packet.
    attr_accessor :component_id

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
        :'timestamp_micro' => :'timestamp_micro',
        :'component_sub_type' => :'component_sub_type',
        :'resource_type' => :'resource_type',
        :'component_type' => :'component_type',
        :'transport_node_name' => :'transport_node_name',
        :'timestamp' => :'timestamp',
        :'transport_node_id' => :'transport_node_id',
        :'sequence_no' => :'sequence_no',
        :'transport_node_type' => :'transport_node_type',
        :'component_name' => :'component_name',
        :'nat_rule_id' => :'nat_rule_id',
        :'reason' => :'reason',
        :'lport_id' => :'lport_id',
        :'lport_name' => :'lport_name',
        :'acl_rule_id' => :'acl_rule_id',
        :'arp_fail_reason' => :'arp_fail_reason',
        :'service_path_index' => :'service_path_index',
        :'component_id' => :'component_id'
      }
    end

    # Attribute type mapping.
    def self.swagger_types
      {
        :'timestamp_micro' => :'Integer',
        :'component_sub_type' => :'String',
        :'resource_type' => :'String',
        :'component_type' => :'String',
        :'transport_node_name' => :'String',
        :'timestamp' => :'Integer',
        :'transport_node_id' => :'String',
        :'sequence_no' => :'Integer',
        :'transport_node_type' => :'String',
        :'component_name' => :'String',
        :'nat_rule_id' => :'Integer',
        :'reason' => :'String',
        :'lport_id' => :'String',
        :'lport_name' => :'String',
        :'acl_rule_id' => :'Integer',
        :'arp_fail_reason' => :'String',
        :'service_path_index' => :'Integer',
        :'component_id' => :'String'
      }
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      return unless attributes.is_a?(Hash)

      # convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      if attributes.has_key?(:'timestamp_micro')
        self.timestamp_micro = attributes[:'timestamp_micro']
      end

      if attributes.has_key?(:'component_sub_type')
        self.component_sub_type = attributes[:'component_sub_type']
      end

      if attributes.has_key?(:'resource_type')
        self.resource_type = attributes[:'resource_type']
      end

      if attributes.has_key?(:'component_type')
        self.component_type = attributes[:'component_type']
      end

      if attributes.has_key?(:'transport_node_name')
        self.transport_node_name = attributes[:'transport_node_name']
      end

      if attributes.has_key?(:'timestamp')
        self.timestamp = attributes[:'timestamp']
      end

      if attributes.has_key?(:'transport_node_id')
        self.transport_node_id = attributes[:'transport_node_id']
      end

      if attributes.has_key?(:'sequence_no')
        self.sequence_no = attributes[:'sequence_no']
      end

      if attributes.has_key?(:'transport_node_type')
        self.transport_node_type = attributes[:'transport_node_type']
      end

      if attributes.has_key?(:'component_name')
        self.component_name = attributes[:'component_name']
      end

      if attributes.has_key?(:'nat_rule_id')
        self.nat_rule_id = attributes[:'nat_rule_id']
      end

      if attributes.has_key?(:'reason')
        self.reason = attributes[:'reason']
      end

      if attributes.has_key?(:'lport_id')
        self.lport_id = attributes[:'lport_id']
      end

      if attributes.has_key?(:'lport_name')
        self.lport_name = attributes[:'lport_name']
      end

      if attributes.has_key?(:'acl_rule_id')
        self.acl_rule_id = attributes[:'acl_rule_id']
      end

      if attributes.has_key?(:'arp_fail_reason')
        self.arp_fail_reason = attributes[:'arp_fail_reason']
      end

      if attributes.has_key?(:'service_path_index')
        self.service_path_index = attributes[:'service_path_index']
      end

      if attributes.has_key?(:'component_id')
        self.component_id = attributes[:'component_id']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @resource_type.nil?
        invalid_properties.push('invalid value for "resource_type", resource_type cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      component_sub_type_validator = EnumAttributeValidator.new('String', ['LR_TIER0', 'LR_TIER1', 'LR_VRF_TIER0', 'LS_TRANSIT', 'SI_CLASSIFIER', 'SI_PROXY', 'VDR', 'ENI', 'AWS_GATEWAY', 'TGW_ROUTE', 'EDGE_UPLINK', 'DELL_GATEWAY', 'UNKNOWN'])
      return false unless component_sub_type_validator.valid?(@component_sub_type)
      return false if @resource_type.nil?
      resource_type_validator = EnumAttributeValidator.new('String', ['TraceflowObservationForwarded', 'TraceflowObservationDropped', 'TraceflowObservationDelivered', 'TraceflowObservationReceived', 'TraceflowObservationForwardedLogical', 'TraceflowObservationDroppedLogical', 'TraceflowObservationReceivedLogical', 'TraceflowObservationReplicationLogical', 'TraceflowObservationRelayedLogical'])
      return false unless resource_type_validator.valid?(@resource_type)
      component_type_validator = EnumAttributeValidator.new('String', ['PHYSICAL', 'LR', 'LS', 'DFW', 'BRIDGE', 'EDGE_TUNNEL', 'EDGE_HOSTSWITCH', 'FW_BRIDGE', 'LOAD_BALANCER', 'NAT', 'IPSEC', 'SERVICE_INSERTION', 'VMC', 'SPOOFGUARD', 'EDGE_FW', 'DLB', 'UNKNOWN'])
      return false unless component_type_validator.valid?(@component_type)
      transport_node_type_validator = EnumAttributeValidator.new('String', ['ESX', 'RHELKVM', 'UBUNTUKVM', 'EDGE', 'PUBLIC_CLOUD_GATEWAY_NODE', 'OTHERS', 'HYPERV'])
      return false unless transport_node_type_validator.valid?(@transport_node_type)
      reason_validator = EnumAttributeValidator.new('String', ['ARP_FAIL', 'BFD', 'DHCP', 'DLB', 'FW_RULE', 'GENEVE', 'GRE', 'IFACE', 'IP', 'IP_REASS', 'IPSEC', 'IPSEC_VTI', 'L2VPN', 'L4PORT', 'LB', 'LROUTER', 'LSERVICE', 'LSWITCH', 'MD_PROXY', 'NAT', 'ND_NS_FAIL', 'NEIGH', 'NO_EIP_FOUND', 'NO_EIP_ASSOCIATION', 'NO_ENI_FOR_IP', 'NO_ENI_FOR_LIF', 'NO_ROUTE', 'NO_ROUTE_TABLE_FOUND', 'NO_UNDERLAY_ROUTE_FOUND', 'NOT_VDR_DOWNLINK,', 'NO_VDR_FOUND', 'NO_VDR_ON_HOST', 'NOT_VDR_UPLINK,', 'SERVICE_INSERT', 'SPOOFGUARD', 'TTL_ZERO', 'TUNNEL', 'VXLAN', 'VXSTT', 'VMC_NO_RESPONSE', 'WRONG_UPLINK', 'UNKNOWN'])
      return false unless reason_validator.valid?(@reason)
      arp_fail_reason_validator = EnumAttributeValidator.new('String', ['ARP_UNKNOWN', 'ARP_TIMEOUT', 'ARP_CPFAIL', 'ARP_FROMCP', 'ARP_PORTDESTROY', 'ARP_TABLEDESTROY', 'ARP_NETDESTROY'])
      return false unless arp_fail_reason_validator.valid?(@arp_fail_reason)
      true
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] component_sub_type Object to be assigned
    def component_sub_type=(component_sub_type)
      validator = EnumAttributeValidator.new('String', ['LR_TIER0', 'LR_TIER1', 'LR_VRF_TIER0', 'LS_TRANSIT', 'SI_CLASSIFIER', 'SI_PROXY', 'VDR', 'ENI', 'AWS_GATEWAY', 'TGW_ROUTE', 'EDGE_UPLINK', 'DELL_GATEWAY', 'UNKNOWN'])
      unless validator.valid?(component_sub_type)
        fail ArgumentError, 'invalid value for "component_sub_type", must be one of #{validator.allowable_values}.'
      end
      @component_sub_type = component_sub_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] resource_type Object to be assigned
    def resource_type=(resource_type)
      validator = EnumAttributeValidator.new('String', ['TraceflowObservationForwarded', 'TraceflowObservationDropped', 'TraceflowObservationDelivered', 'TraceflowObservationReceived', 'TraceflowObservationForwardedLogical', 'TraceflowObservationDroppedLogical', 'TraceflowObservationReceivedLogical', 'TraceflowObservationReplicationLogical', 'TraceflowObservationRelayedLogical'])
      unless validator.valid?(resource_type)
        fail ArgumentError, 'invalid value for "resource_type", must be one of #{validator.allowable_values}.'
      end
      @resource_type = resource_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] component_type Object to be assigned
    def component_type=(component_type)
      validator = EnumAttributeValidator.new('String', ['PHYSICAL', 'LR', 'LS', 'DFW', 'BRIDGE', 'EDGE_TUNNEL', 'EDGE_HOSTSWITCH', 'FW_BRIDGE', 'LOAD_BALANCER', 'NAT', 'IPSEC', 'SERVICE_INSERTION', 'VMC', 'SPOOFGUARD', 'EDGE_FW', 'DLB', 'UNKNOWN'])
      unless validator.valid?(component_type)
        fail ArgumentError, 'invalid value for "component_type", must be one of #{validator.allowable_values}.'
      end
      @component_type = component_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] transport_node_type Object to be assigned
    def transport_node_type=(transport_node_type)
      validator = EnumAttributeValidator.new('String', ['ESX', 'RHELKVM', 'UBUNTUKVM', 'EDGE', 'PUBLIC_CLOUD_GATEWAY_NODE', 'OTHERS', 'HYPERV'])
      unless validator.valid?(transport_node_type)
        fail ArgumentError, 'invalid value for "transport_node_type", must be one of #{validator.allowable_values}.'
      end
      @transport_node_type = transport_node_type
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] reason Object to be assigned
    def reason=(reason)
      validator = EnumAttributeValidator.new('String', ['ARP_FAIL', 'BFD', 'DHCP', 'DLB', 'FW_RULE', 'GENEVE', 'GRE', 'IFACE', 'IP', 'IP_REASS', 'IPSEC', 'IPSEC_VTI', 'L2VPN', 'L4PORT', 'LB', 'LROUTER', 'LSERVICE', 'LSWITCH', 'MD_PROXY', 'NAT', 'ND_NS_FAIL', 'NEIGH', 'NO_EIP_FOUND', 'NO_EIP_ASSOCIATION', 'NO_ENI_FOR_IP', 'NO_ENI_FOR_LIF', 'NO_ROUTE', 'NO_ROUTE_TABLE_FOUND', 'NO_UNDERLAY_ROUTE_FOUND', 'NOT_VDR_DOWNLINK,', 'NO_VDR_FOUND', 'NO_VDR_ON_HOST', 'NOT_VDR_UPLINK,', 'SERVICE_INSERT', 'SPOOFGUARD', 'TTL_ZERO', 'TUNNEL', 'VXLAN', 'VXSTT', 'VMC_NO_RESPONSE', 'WRONG_UPLINK', 'UNKNOWN'])
      unless validator.valid?(reason)
        fail ArgumentError, 'invalid value for "reason", must be one of #{validator.allowable_values}.'
      end
      @reason = reason
    end

    # Custom attribute writer method checking allowed values (enum).
    # @param [Object] arp_fail_reason Object to be assigned
    def arp_fail_reason=(arp_fail_reason)
      validator = EnumAttributeValidator.new('String', ['ARP_UNKNOWN', 'ARP_TIMEOUT', 'ARP_CPFAIL', 'ARP_FROMCP', 'ARP_PORTDESTROY', 'ARP_TABLEDESTROY', 'ARP_NETDESTROY'])
      unless validator.valid?(arp_fail_reason)
        fail ArgumentError, 'invalid value for "arp_fail_reason", must be one of #{validator.allowable_values}.'
      end
      @arp_fail_reason = arp_fail_reason
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          timestamp_micro == o.timestamp_micro &&
          component_sub_type == o.component_sub_type &&
          resource_type == o.resource_type &&
          component_type == o.component_type &&
          transport_node_name == o.transport_node_name &&
          timestamp == o.timestamp &&
          transport_node_id == o.transport_node_id &&
          sequence_no == o.sequence_no &&
          transport_node_type == o.transport_node_type &&
          component_name == o.component_name &&
          nat_rule_id == o.nat_rule_id &&
          reason == o.reason &&
          lport_id == o.lport_id &&
          lport_name == o.lport_name &&
          acl_rule_id == o.acl_rule_id &&
          arp_fail_reason == o.arp_fail_reason &&
          service_path_index == o.service_path_index &&
          component_id == o.component_id
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Fixnum] Hash code
    def hash
      [timestamp_micro, component_sub_type, resource_type, component_type, transport_node_name, timestamp, transport_node_id, sequence_no, transport_node_type, component_name, nat_rule_id, reason, lport_id, lport_name, acl_rule_id, arp_fail_reason, service_path_index, component_id].hash
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
