# SwaggerClient::IPDiscoveryProfile

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
**arp_nd_binding_timeout** | **Integer** | This property controls the ARP and ND cache timeout period. It is recommended that this property be greater than the ARP/ND cache timeout on the VM.  | [optional] [default to 10]
**ip_v6_discovery_options** | [**IPv6DiscoveryOptions**](IPv6DiscoveryOptions.md) | Indicates IPv6 Discovery options | [optional] 
**duplicate_ip_detection** | [**DuplicateIPDetectionOptions**](DuplicateIPDetectionOptions.md) | Duplicate IP detection is used to determine if there is any IP conflict with any other port on the same logical switch. If a conflict is detected, then the IP is marked as a duplicate on the port where the IP was discovered last. The duplicate IP will not be added to the realized address binings for the port and hence will not be used in DFW rules or other security configurations for the port.rt.  | [optional] 
**tofu_enabled** | **BOOLEAN** | Indicates whether \&quot;Trust on First Use(TOFU)\&quot; paradigm is enabled. | [optional] [default to true]
**ip_v4_discovery_options** | [**IPv4DiscoveryOptions**](IPv4DiscoveryOptions.md) | Indicates IPv4 Discovery options | [optional] 


