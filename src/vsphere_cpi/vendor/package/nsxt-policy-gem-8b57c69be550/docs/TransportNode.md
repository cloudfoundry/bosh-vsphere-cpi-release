# SwaggerClient::TransportNode

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
**host_switch_spec** | [**HostSwitchSpec**](HostSwitchSpec.md) | This property is used to either create standard host switches or to inform NSX about preconfigured host switches that already exist on the transport node.  Pass an array of either StandardHostSwitchSpec objects or PreconfiguredHostSwitchSpec objects. It is an error to pass an array containing different types of HostSwitchSpec objects.  | [optional] 
**node_id** | **String** | Unique Id of the fabric node | [optional] 
**node_deployment_info** | [**Node**](Node.md) |  | [optional] 
**host_switches** | [**Array&lt;HostSwitch&gt;**](HostSwitch.md) | This property is deprecated in favor of &#39;host_switch_spec&#39;. Property &#39;host_switches&#39; can only be used for NSX managed transport nodes. &#39;host_switch_spec&#39; can be used for both NSX managed or manually preconfigured host switches. | [optional] 
**maintenance_mode** | **String** | The property is read-only, used for querying result. User could update transport node maintenance mode by UpdateTransportNodeMaintenanceMode call. | [optional] 
**is_overridden** | **BOOLEAN** | This flag is relevant to only those hosts which are part of a compute collection which has transport node profile (TNP) applied on it. If you change the transport node configuration and it is different than cluster level TNP then this flag will be set to true  | [optional] 
**transport_zone_endpoints** | [**Array&lt;TransportZoneEndPoint&gt;**](TransportZoneEndPoint.md) | Transport zone endpoints. | [optional] 


