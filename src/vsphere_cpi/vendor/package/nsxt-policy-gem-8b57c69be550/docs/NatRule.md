# SwaggerClient::NatRule

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_system_owned** | **BOOLEAN** | Indicates system owned resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**description** | **String** | Description of this resource | [optional] 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**_create_user** | **String** | ID of the user who created this resource | [optional] 
**_protection** | **String** | Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite&#x3D;true. UNKNOWN - the _protection field could not be determined for this           entity.  | [optional] 
**_create_time** | **Integer** | Timestamp of resource creation | [optional] 
**_last_modified_time** | **Integer** | Timestamp of last modification | [optional] 
**_last_modified_user** | **String** | ID of the user who last modified this resource | [optional] 
**id** | **String** | Unique identifier of this resource | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**match_destination_network** | **String** | IP Address | CIDR | (null implies Any)  | [optional] 
**translated_network** | **String** | IP Address | IP Range | CIDR | [optional] 
**rule_priority** | **Integer** | Ascending, valid range [0-2147483647]. If multiple rules have the same priority, evaluation sequence is undefined.  | [optional] [default to 1024]
**match_service** | [**NSServiceElement**](NSServiceElement.md) | A NSServiceElement that specifies the matching services of source ports, destination ports, ip protocol version and number, sub protocol version and number, ICMP type and code, etc. The match_service can be one of IPProtocolNSService,L4PortSetNSService or ICMPTypeNSService. REFLEXIVE NAT does not support match_service.  | [optional] 
**applied_tos** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | Holds the list of LogicalRouterPort Ids that a NAT rule can be applied to. The LogicalRouterPort used must belong to the same LogicalRouter for which the NAT Rule is created. As of now a NAT rule can only have a single LogicalRouterPort as applied_tos. When applied_tos is not set, the NAT rule is applied to all LogicalRouterPorts beloging to the LogicalRouter. | [optional] 
**enabled** | **BOOLEAN** | enable/disable the rule | [optional] [default to true]
**internal_rule_id** | **String** | Internal NAT rule uuid for debug used in Controller and backend. | [optional] 
**logging** | **BOOLEAN** | enable/disable the logging of rule | [optional] [default to false]
**translated_ports** | **String** | port number or port range. DNAT only | [optional] 
**action** | **String** | valid actions: SNAT, DNAT, NO_SNAT, NO_DNAT, REFLEXIVE. All rules in a logical router are either stateless or stateful. Mix is not supported. SNAT and DNAT are stateful, can NOT be supported when the logical router is running at active-active HA mode; REFLEXIVE is stateless. NO_SNAT and NO_DNAT have no translated_fields, only match fields are supported.  | 
**firewall_match** | **String** | Indicate how firewall is applied to a traffic packet. Firewall can be bypassed, or be applied to external/internal address of NAT rule. For NO_SNAT or NO_DNAT, it must be BYPASS or leave it unassigned.  The firewall_match will take priority over nat_pass. If the firewall_match is not provided, the nat_pass will be picked up.  | [optional] 
**nat_pass** | **BOOLEAN** | Default is true. If the nat_pass is set to true, the following firewall stage will be skipped. Please note, if action is NO_SNAT or NO_DNAT, then nat_pass must be set to true or omitted.  Nat_pass was deprecated with an alternative firewall_match. Please stop using nat_pass to specify whether firewall stage is skipped. if you want to skip, please set firewall_match to BYPASS. If you do not want to skip, please set the firewall_match to MATCH_EXTERNAL_ADDRESS or MATCH_INTERNAL_ADDRESS.  Please note, the firewall_match will take priority over the nat_pass. If both are provided, the nat_pass is ignored. If firewall_match is not provided while the nat_pass is specified, the nat_pass will still be picked up. In this case, if nat_pass is set to false, firewall rule will be applied on internall address of a packet, i.e. MATCH_INTERNAL_ADDRESS.  | [optional] [default to true]
**logical_router_id** | **String** | Logical router id | [optional] 
**match_source_network** | **String** | IP Address | CIDR | (null implies Any)  | [optional] 


