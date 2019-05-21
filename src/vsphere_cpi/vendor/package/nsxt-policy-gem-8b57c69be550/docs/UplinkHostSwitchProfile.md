# SwaggerClient::UplinkHostSwitchProfile

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
**resource_type** | **String** | Supported HostSwitch profiles. | 
**required_capabilities** | **Array&lt;String&gt;** |  | [optional] 
**lags** | [**Array&lt;Lag&gt;**](Lag.md) | list of LACP group | [optional] 
**transport_vlan** | **Integer** | VLAN used for tagging Overlay traffic of associated HostSwitch | [optional] [default to 0]
**teaming** | [**TeamingPolicy**](TeamingPolicy.md) | Default TeamingPolicy associated with this UplinkProfile | 
**overlay_encap** | **String** | The protocol used to encapsulate overlay traffic | [optional] [default to &#39;GENEVE&#39;]
**named_teamings** | [**Array&lt;NamedTeamingPolicy&gt;**](NamedTeamingPolicy.md) | List of named uplink teaming policies that can be used by logical switches | [optional] 
**mtu** | **Integer** | Maximum Transmission Unit used for uplinks | [optional] 


