# SwaggerClient::IpfixSwitchUpmProfile

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
**resource_type** | **String** | All IPFIX profile types. | 
**priority** | **Integer** | This priority field is used to resolve conflicts in logical ports/switch  which inherit multiple switch IPFIX profiles from NSGroups.  Override rule is : for multiple profiles inherited from NSGroups, the one with highest priority (lowest number) overrides others; the profile directly applied to logical switch overrides profiles inherited from NSGroup; the profile directly applied to logical port overides profiles inherited from logical switch and/or nsgroup;  The IPFIX exporter will send records to collectors of final effective profile only.  | 
**collector_profile** | **String** | Each IPFIX switching profile can have its own collector profile.  | 
**idle_timeout** | **Integer** | The time in seconds after a flow is expired if no more packets matching this flow are received by the cache.  | [optional] [default to 300]
**max_flows** | **Integer** | The maximum number of flow entries in each exporter flow cache.  | [optional] [default to 16384]
**observation_domain_id** | **Integer** | An identifier that is unique to the exporting process and used to meter the Flows.  | 
**active_timeout** | **Integer** | The time in seconds after a flow is expired even if more packets matching this Flow are received by the cache.  | [optional] [default to 300]
**applied_tos** | [**AppliedTos**](AppliedTos.md) | Entities where the IPFIX profile will be enabled on. Maximum entity count of all types is 128.  | [optional] 
**packet_sample_probability** | **Float** | The probability in percentage that a packet is sampled. The value should be  in range (0,100] and can only have three decimal places at most. The probability  is equal for every packet.  | [optional] 


