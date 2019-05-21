# SwaggerClient::ServiceInsertionRule

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_owner** | [**OwnerResourceLink**](OwnerResourceLink.md) | Owner of this resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**id** | **String** | Identifier of the resource | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**description** | **String** | Description of this resource | [optional] 
**is_default** | **BOOLEAN** | Flag to indicate whether rule is default. | [optional] 
**direction** | **String** | Rule direction in case of stateless distributed service rules. This will only considered if section level parameter is set to stateless. Default to IN_OUT if not specified. | [optional] [default to &#39;IN_OUT&#39;]
**rule_tag** | **String** | User level field which will be printed in CLI and packet logs. | [optional] 
**ip_protocol** | **String** | Type of IP packet that should be matched while enforcing the rule. | [optional] [default to &#39;IPV4_IPV6&#39;]
**notes** | **String** | User notes specific to the rule. | [optional] 
**applied_tos** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of object where rule will be enforced. The section level field overrides this one. Null will be treated as any. | [optional] 
**logged** | **BOOLEAN** | Flag to enable packet logging. Default is disabled. | [optional] [default to false]
**disabled** | **BOOLEAN** | Flag to disable rule. Disabled will only be persisted but never provisioned/realized. | [optional] [default to false]
**sources** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of sources. Null will be treated as any. | [optional] 
**action** | **String** | Action enforced on the packets which matches the distributed service rule. Currently DS Layer supports below actions. ALLOW           - Forward any packet when a rule with this action gets a match (Used by Firewall). DROP            - Drop any packet when a rule with this action gets a match. Packets won&#39;t go further(Used by Firewall). REJECT          - Terminate TCP connection by sending TCP reset for a packet when a rule with this action gets a match (Used by Firewall). REDIRECT        - Redirect any packet to a partner appliance when a rule with this action gets a match (Used by Service Insertion). DO_NOT_REDIRECT - Do not redirect any packet to a partner appliance when a rule with this action gets a match (Used by Service Insertion). | 
**sources_excluded** | **BOOLEAN** | Negation of the source. | [optional] [default to false]
**destinations_excluded** | **BOOLEAN** | Negation of the destination. | [optional] [default to false]
**destinations** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of the destinations. Null will be treated as any. | [optional] 
**services** | [**Array&lt;ServiceInsertionService&gt;**](ServiceInsertionService.md) | List of the services. Null will be treated as any. | [optional] 
**redirect_tos** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | A rule can be redirected to ServiceInstance, InstanceEndpoint for North/South Traffic. A rule can be redirected to ServiceChain for East/West Traffic. | 
**section_id** | **String** | ID of the section to which this rule belongs. | [optional] 


