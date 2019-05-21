# SwaggerClient::PortMirroringSession

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
**direction** | **String** | Port mirroring session direction | 
**mirror_sources** | [**Array&lt;MirrorSource&gt;**](MirrorSource.md) | Mirror sources | 
**encapsulation_vlan_id** | **Integer** | Only for Remote SPAN Port Mirror. | [optional] 
**session_type** | **String** | If this property is unset, this session will be treated as LocalPortMirrorSession.  | [optional] [default to &#39;LocalPortMirrorSession&#39;]
**snap_length** | **Integer** | If this property is set, the packet will be truncated to the provided length. If this property is unset, entire packet will be mirrored.  | [optional] 
**port_mirroring_filters** | [**Array&lt;PortMirroringFilter&gt;**](PortMirroringFilter.md) | An array of 5-tuples used to filter packets for the mirror session, if not provided, all the packets will be mirrored. | [optional] 
**preserve_original_vlan** | **BOOLEAN** | Only for Remote SPAN Port Mirror. Whether to preserve original VLAN. | [optional] [default to false]
**mirror_destination** | [**MirrorDestination**](MirrorDestination.md) | Mirror destination | 


