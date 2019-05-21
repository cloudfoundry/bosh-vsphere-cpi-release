# SwaggerClient::SegmentSecurityProfile

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
**bpdu_filter_enable** | **BOOLEAN** | Indicates whether BPDU filter is enabled. BPDU filtering is enabled by default.  | [optional] [default to true]
**ra_guard_enabled** | **BOOLEAN** | Enable or disable Router Advertisement Guard.  | [optional] [default to false]
**dhcp_client_block_v6_enabled** | **BOOLEAN** | Filters DHCP server and/or client IPv6 traffic. DHCP server blocking is enabled and client blocking is disabled by default.  | [optional] [default to false]
**non_ip_traffic_block_enabled** | **BOOLEAN** | A flag to block all traffic except IP/(G)ARP/BPDU.  | [optional] [default to false]
**bpdu_filter_allow** | **Array&lt;String&gt;** | Pre-defined list of allowed MAC addresses to be excluded from BPDU filtering. List of allowed MACs - 01:80:c2:00:00:00, 01:80:c2:00:00:01, 01:80:c2:00:00:02, 01:80:c2:00:00:03,                        01:80:c2:00:00:04, 01:80:c2:00:00:05, 01:80:c2:00:00:06, 01:80:c2:00:00:07,                        01:80:c2:00:00:08, 01:80:c2:00:00:09, 01:80:c2:00:00:0a, 01:80:c2:00:00:0b,                        01:80:c2:00:00:0c, 01:80:c2:00:00:0d, 01:80:c2:00:00:0e, 01:80:c2:00:00:0f,                        00:e0:2b:00:00:00, 00:e0:2b:00:00:04, 00:e0:2b:00:00:06, 01:00:0c:00:00:00,                        01:00:0c:cc:cc:cc, 01:00:0c:cc:cc:cd, 01:00:0c:cd:cd:cd, 01:00:0c:cc:cc:c0,                        01:00:0c:cc:cc:c1, 01:00:0c:cc:cc:c2, 01:00:0c:cc:cc:c3, 01:00:0c:cc:cc:c4,                        01:00:0c:cc:cc:c5, 01:00:0c:cc:cc:c6, 01:00:0c:cc:cc:c7  | [optional] 
**dhcp_server_block_enabled** | **BOOLEAN** | Filters DHCP server and/or client traffic. DHCP server blocking is enabled and client blocking is disabled by default.  | [optional] [default to true]
**rate_limits_enabled** | **BOOLEAN** | Enable or disable Rate Limits  | [optional] [default to false]
**rate_limits** | [**TrafficRateLimits**](TrafficRateLimits.md) | Allows configuration of rate limits for broadcast and multicast traffic. Rate limiting is disabled by default | [optional] 
**dhcp_client_block_enabled** | **BOOLEAN** | Filters DHCP server and/or client traffic. DHCP server blocking is enabled and client blocking is disabled by default.  | [optional] [default to false]
**dhcp_server_block_v6_enabled** | **BOOLEAN** | Filters DHCP server and/or client IPv6 traffic. DHCP server blocking is enabled and client blocking is disabled by default.  | [optional] [default to true]


