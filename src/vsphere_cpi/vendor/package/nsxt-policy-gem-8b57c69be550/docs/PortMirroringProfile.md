# SwaggerClient::PortMirroringProfile

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
**path** | **String** | Absolute path of this object | [optional] 
**parent_path** | **String** | Path of its parent | [optional] 
**relative_path** | **String** | Path relative from its parent | [optional] 
**children** | [**Array&lt;ChildPolicyConfigResource&gt;**](ChildPolicyConfigResource.md) | subtree for this type within policy tree containing nested elements.  | [optional] 
**marked_for_delete** | **BOOLEAN** | Intent objects are not directly deleted from the system when a delete is invoked on them. They are marked for deletion and only when all the realized entities for that intent object gets deleted, the intent object is deleted. Objects that are marked for deletion are not returned in GET call. One can use the search API to get these objects.  | [optional] [default to false]
**direction** | **String** | Port mirroring profile direction | [optional] [default to &#39;BIDIRECTIONAL&#39;]
**profile_type** | **String** | Allows user to select type of port mirroring session. | [optional] [default to &#39;REMOTE_L3_SPAN&#39;]
**snap_length** | **Integer** | If this property is set, the packet will be truncated to the provided length. If this property is unset, entire packet will be mirrored.  | [optional] 
**encapsulation_type** | **String** | User can provide Mirror Destination type e.g GRE, ERSPAN_TWO or ERSPAN_THREE.If profile type is REMOTE_L3_SPAN, encapsulation type is used else ignored. | [optional] [default to &#39;GRE&#39;]
**erspan_id** | **Integer** | Used by physical switch for the mirror traffic forwarding. Must be provided and only effective when encapsulation type is ERSPAN type II or type III.  | [optional] [default to 0]
**gre_key** | **Integer** | User-configurable 32-bit key only for GRE | [optional] [default to 0]
**destination_group** | **String** | Data from source group will be copied to members of destination group. Only IPSET group and group with membership criteria VM is supported. IPSET group allows only three ip&#39;s.  | 


