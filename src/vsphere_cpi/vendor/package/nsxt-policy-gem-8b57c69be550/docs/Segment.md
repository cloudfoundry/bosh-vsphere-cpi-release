# SwaggerClient::Segment

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
**vlan_ids** | **Array&lt;String&gt;** | VLAN ids for a VLAN backed Segment. Can be a VLAN id or a range of VLAN ids specified with &#39;-&#39; in between.  | [optional] 
**subnets** | [**Array&lt;SegmentSubnet&gt;**](SegmentSubnet.md) | Subnet configuration. Max 1 subnet | [optional] 
**overlay_id** | **Integer** | Used for overlay connectivity of segments. The overlay_id should be allocated from the pool as definied by enforcement-point. If not provided, it is auto-allocated from the default pool on the enforcement-point.  | [optional] 
**ls_id** | **String** | This property is deprecated. The property will continue to work as expected for existing segments. The segments that are newly created with ls_id will be ignored. Sepcify pre-creted logical switch id for Segment.  | [optional] 
**connectivity_path** | **String** | Policy path to the connecting Tier-0 or Tier-1. Valid only for segments created under Infra.  | [optional] 
**type** | **String** | Segment type based on configuration.  | [optional] 
**advanced_config** | [**SegmentAdvancedConfig**](SegmentAdvancedConfig.md) | Advanced configuration for Segment.  | [optional] 
**transport_zone_path** | **String** | Policy path to the transport zone. Supported for VLAN backed segments as well as Overlay Segments. This field is required for VLAN backed Segments. Auto assigned if only one transport zone exists in the enforcement point. Default transport zone is auto assigned for overlay segments if none specified.  | [optional] 
**l2_extension** | [**L2Extension**](L2Extension.md) | Configuration for extending Segment through L2 VPN | [optional] 
**domain_name** | **String** | DNS domain name | [optional] 


