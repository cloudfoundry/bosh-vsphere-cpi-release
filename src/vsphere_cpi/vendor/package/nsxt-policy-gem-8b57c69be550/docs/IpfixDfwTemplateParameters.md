# SwaggerClient::IpfixDfwTemplateParameters

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**source_icmp_type** | **BOOLEAN** | Type of the IPv4 ICMP message.  | [optional] [default to true]
**icmp_code** | **BOOLEAN** | Code of the IPv4 ICMP message.  | [optional] [default to true]
**destination_transport_port** | **BOOLEAN** | The destination transport port of a monitored network flow.  | [optional] [default to true]
**octet_delta_count** | **BOOLEAN** | The number of octets since the previous report (if any) in incoming packets for this flow at the observation point. The number of octets include IP header(s) and payload.  | [optional] [default to true]
**vif_uuid** | **BOOLEAN** | VIF UUID - enterprise specific Information Element that uniquely identifies VIF.  | [optional] [default to true]
**protocol_identifier** | **BOOLEAN** | The value of the protocol number in the IP packet header.  | [optional] [default to true]
**firewall_event** | **BOOLEAN** | Five valid values are allowed: 1. Flow Created. 2. Flow Deleted. 3. Flow Denied. 4. Flow Alert (not used in DropKick implementation). 5. Flow Update.  | [optional] [default to true]
**flow_direction** | **BOOLEAN** | Two valid values are allowed: 1. 0x00: igress flow to VM. 2. 0x01: egress flow from VM.  | [optional] [default to true]
**flow_end** | **BOOLEAN** | The absolute timestamp (seconds) of the last packet of this flow.  | [optional] [default to true]
**source_transport_port** | **BOOLEAN** | The source transport port of a monitored network flow.  | [optional] [default to true]
**packet_delta_count** | **BOOLEAN** | The number of incoming packets since the previous report (if any) for this flow at the observation point.  | [optional] [default to true]
**destination_address** | **BOOLEAN** | The destination IP address of a monitored network flow.  | [optional] [default to true]
**source_address** | **BOOLEAN** | The source IP address of a monitored network flow.  | [optional] [default to true]
**rule_id** | **BOOLEAN** | Firewall rule Id - enterprise specific Information Element that uniquely identifies firewall rule.  | [optional] [default to true]
**flow_start** | **BOOLEAN** | The absolute timestamp (seconds) of the first packet of this flow.  | [optional] [default to true]


