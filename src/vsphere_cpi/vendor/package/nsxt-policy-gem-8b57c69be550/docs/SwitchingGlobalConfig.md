# SwaggerClient::SwitchingGlobalConfig

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
**resource_type** | **String** | Valid Global configuration types | 
**global_replication_mode_enabled** | **BOOLEAN** | When this flag is set true, certain types of BUM packets will be sent to all VTEPs in the global VTEP table, ignoring the logical switching span. | [optional] [default to false]
**physical_uplink_mtu** | **Integer** | This is the global default MTU for all the physical uplinks in a NSX domain. This is the default value for the optional uplink profile MTU field. When the MTU value is not specified in the uplink profile, this global value will be used. This value can be overridden by providing a value for the optional MTU field in the uplink profile. Whenever this value is updated, the updated value will only be propagated to the uplinks that don&#39;t have the MTU value in their uplink profiles. If this value is not set, the default value of 1700 will be used. The Transport Node state can be monitored to confirm if the updated MTU value has been realized. | [optional] [default to 1700]


