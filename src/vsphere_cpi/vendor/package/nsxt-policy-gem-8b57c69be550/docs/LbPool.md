# SwaggerClient::LBPool

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
**active_monitor_paths** | **Array&lt;String&gt;** | In case of active healthchecks, load balancer itself initiates new connections (or sends ICMP ping) to the servers periodically to check their health, completely independent of any data traffic. Active healthchecks are disabled by default and can be enabled for a server pool by binding a health monitor to the pool. Currently, only one active health monitor can be configured per server pool.  | [optional] 
**tcp_multiplexing_enabled** | **BOOLEAN** | TCP multiplexing allows the same TCP connection between load balancer and the backend server to be used for sending multiple client requests from different client TCP connections.  | [optional] [default to false]
**snat_translation** | [**LBSnatTranslation**](LBSnatTranslation.md) | Depending on the topology, Source NAT (SNAT) may be required to ensure traffic from the server destined to the client is received by the load balancer. SNAT can be enabled per pool. If SNAT is not enabled for a pool, then load balancer uses the client IP and port (spoofing) while establishing connections to the servers. This is referred to as no-SNAT or TRANSPARENT mode.  By default Source NAT is enabled as LBSnatAutoMap.  | [optional] 
**member_group** | [**LBPoolMemberGroup**](LBPoolMemberGroup.md) | Load balancer pool support grouping object as dynamic pool members. When member group is defined, members setting should not be specified.  | [optional] 
**algorithm** | **String** | Load Balancing algorithm chooses a server for each new connection by going through the list of servers in the pool. Currently, following load balancing algorithms are supported with ROUND_ROBIN as the default. ROUND_ROBIN means that a server is selected in a round-robin fashion. The weight would be ignored even if it is configured. WEIGHTED_ROUND_ROBIN means that a server is selected in a weighted round-robin fashion. Default weight of 1 is used if weight is not configured. LEAST_CONNECTION means that a server is selected when it has the least number of connections. The weight would be ignored even if it is configured. Slow start would be enabled by default. WEIGHTED_LEAST_CONNECTION means that a server is selected in a weighted least connection fashion. Default weight of 1 is used if weight is not configured. Slow start would be enabled by default. IP_HASH means that consistent hash is performed on the source IP address of the incoming connection. This ensures that the same client IP address will always reach the same server as long as no server goes down or up. It may be used on the Internet to provide a best-effort stickiness to clients which refuse session cookies.  | [optional] [default to &#39;ROUND_ROBIN&#39;]
**tcp_multiplexing_number** | **Integer** | The maximum number of TCP connections per pool that are idly kept alive for sending future client requests.  | [optional] [default to 6]
**members** | [**Array&lt;LBPoolMember&gt;**](LBPoolMember.md) | Server pool consists of one or more pool members. Each pool member is identified, typically, by an IP address and a port.  | [optional] 
**passive_monitor_path** | **String** | Passive healthchecks are disabled by default and can be enabled by attaching a passive health monitor to a server pool. Each time a client connection to a pool member fails, its failed count is incremented. For pools bound to L7 virtual servers, a connection is considered to be failed and failed count is incremented if any TCP connection errors (e.g. TCP RST or failure to send data) or SSL handshake failures occur. For pools bound to L4 virtual servers, if no response is received to a TCP SYN sent to the pool member or if a TCP RST is received in response to a TCP SYN, then the pool member is considered to have failed and the failed count is incremented.  | [optional] 
**min_active_members** | **Integer** | A pool is considered active if there are at least certain minimum number of members.  | [optional] [default to 1]


