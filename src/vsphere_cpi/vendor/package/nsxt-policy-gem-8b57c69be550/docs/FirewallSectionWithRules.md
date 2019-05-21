# SwaggerClient::FirewallSectionWithRules

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
**stateful** | **BOOLEAN** | Stateful or Stateless nature of distributed service section is enforced on all rules inside the section. Layer3 sections can be stateful or stateless. Layer2 sections can only be stateless. | 
**is_default** | **BOOLEAN** | It is a boolean flag which reflects whether a distributed service section is default section or not. Each Layer 3 and Layer 2 section will have at least and at most one default section. | [optional] 
**applied_tos** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of objects where the rules in this section will be enforced. This will take precedence over rule level appliedTo. | [optional] 
**rule_count** | **Integer** | Number of rules in this section. | [optional] 
**section_type** | **String** | Type of the rules which a section can contain. Only homogeneous sections are supported. | 
**priority** | **Integer** | Priority of current section with respect to other sections. In case the field is empty, the list section api should be used to get section priority. | [optional] 
**enforced_on** | **String** | This attribute represents enforcement point of firewall section. For example, firewall section enforced on logical port with attachment type bridge endpoint will have &#39;BRIDGEENDPOINT&#39; value, firewall section enforced on logical router will have &#39;LOGICALROUTER&#39; value and rest have &#39;VIF&#39; value. | [optional] 
**locked** | **BOOLEAN** | Section is locked/unlocked. | [optional] [default to false]
**tcp_strict** | **BOOLEAN** | If TCP strict is enabled on a section and a packet matches rule in it, the following check will be performed. If the packet does not belong to an existing session, the kernel will check to see if the SYN flag of the packet is set. If it is not, then it will drop the packet. | [optional] [default to false]
**lock_modified_by** | **String** | ID of the user who last modified the lock for the section. | [optional] 
**lock_modified_time** | **Integer** | Section locked/unlocked time in epoch milliseconds. | [optional] 
**comments** | **String** | Comments for section lock/unlock. | [optional] 
**autoplumbed** | **BOOLEAN** | This flag indicates whether it is an auto-plumbed section that is associated to a LogicalRouter. Auto-plumbed sections are system owned and cannot be updated via the API. | [optional] [default to false]
**rules** | [**Array&lt;FirewallRulePatch&gt;**](FirewallRulePatch.md) | List of firewall rules in the section. Only homogenous rules are supported. | [optional] 


