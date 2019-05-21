# SwaggerClient::BgpNeighbor

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
**filter_in_ipprefixlist_id** | **String** | This is a deprecated property, Please  use &#39;address_family&#39; instead. | [optional] 
**allow_as_in** | **BOOLEAN** | Flag to enable allowas_in option for BGP neighbor | [optional] [default to false]
**remote_as** | **Integer** | This is a deprecated property, Please use &#39;remote_as_num&#39; instead. | [optional] 
**filter_out_ipprefixlist_id** | **String** | This is a deprecated property, Please use &#39;address_family&#39; instead. | [optional] 
**enable_bfd** | **BOOLEAN** | Flag to enable BFD for this BGP Neighbor. Enable this if the neighbor supports BFD as this will lead to faster convergence. | [optional] [default to false]
**hold_down_timer** | **Integer** | Wait period (seconds) before declaring peer dead | [optional] [default to 180]
**maximum_hop_limit** | **Integer** | This value is set on TTL(time to live) of BGP header. When router receives the BGP packet, it decrements the TTL. The default value of TTL is one when BPG request is initiated.So in the case of a BGP peer multiple hops away and and value of TTL is one, then  next router in the path will decrement the TTL to 0, realize it cant forward the packet and will drop it. If the hop count value to reach neighbor is equal to or less than the maximum_hop_limit value then intermediate router decrements the TTL count by one and forwards the request to BGP neighour. If the hop count value is greater than the maximum_hop_limit value then intermediate router discards the request when TTL becomes 0.  | [optional] [default to 1]
**enabled** | **BOOLEAN** | Flag to enable this BGP Neighbor | [optional] [default to true]
**bfd_config** | [**BfdConfigParameters**](BfdConfigParameters.md) | By specifying these paramaters BFD config for this given peer can be overriden | (the globally configured values will not apply for this peer) | [optional] 
**logical_router_id** | **String** | Logical router id | [optional] 
**remote_as_num** | **String** | 4 Byte ASN of the neighbor in ASPLAIN/ASDOT Format | [optional] 
**filter_out_routemap_id** | **String** | This is a deprecated property, Please use &#39;address_family&#39; instead. | [optional] 
**filter_in_routemap_id** | **String** | This is a deprecated property, Please use &#39;address_family&#39; instead. | [optional] 
**keep_alive_timer** | **Integer** | Frequency (seconds) with which keep alive messages are sent to peers | [optional] [default to 60]
**password** | **String** | User can create (POST) the neighbor with or without the password. The view (GET) on the neighbor, would never reveal if the password is set or not. The password can be set later using edit neighbor workFlow (PUT) On the edit neighbor (PUT), if the user does not specify the password property, the older value is retained. Maximum length of this field is 20 characters.  | [optional] 
**source_address** | **String** | Deprecated - do not provide a value for this field. Use source_addresses instead. | [optional] 
**source_addresses** | **Array&lt;String&gt;** | BGP neighborship will be formed from all these source addresses to this neighbour. | [optional] 
**address_families** | [**Array&lt;BgpNeighborAddressFamily&gt;**](BgpNeighborAddressFamily.md) | User can enable the neighbor for the specific address families and also define filters per address family. When the neighbor is created, it is default enabled for IPV4_UNICAST address family for backward compatibility reasons. User can change that if required, by defining the address family configuration.  | [optional] 
**neighbor_address** | **String** | Neighbor IP Address | 


