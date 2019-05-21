# SwaggerClient::PolicyLbPoolAccess

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
**pool_port** | **Integer** | Port for LoadBalancer to send connections to the PolicyLbPoolAccess&#39;s Group. Pool_port could be optional, if it is not specified, LB will use PolicyLbVirtualServer port to connect to backend servers. If the PolicyLbMonitorProfile is configured in PolicyLbPoolAccess and active monitor IP protocol is TCP/UDP(which requires TCP or UDP port number), monitor_port should be specified if pool_port is unset.  | [optional] 
**ip_port_list** | [**Array&lt;IPAddressPortPair&gt;**](IPAddressPortPair.md) | IP Port list for applications within the Group to allow for non-uniform port usage by applications  | [optional] 
**source_nat** | **String** | Depending on the topology, Source NAT (SNAT) may be required to ensure traffic from the server destined to the client is received by the load balancer. SNAT can be enabled per pool. If SNAT is not enabled for a pool, then load balancer uses the client IP and port (spoofing) while establishing connections to the servers. This is referred to as no-SNAT or TRANSPARENT mode.  SNAT is enabled by default and will use the load balancer interface IP and an ephemeral port as the source IP and port of the server side connection.  | [optional] [default to &#39;ENABLED&#39;]
**algorithm** | **String** | Load balanding algorithm controls how the incoming connections are distributed among the members. - ROUND_ROBIN - requests to the application servers are distributed in a round-robin fashion, - LEAST_CONNECTION - next request is assigned to the server with the least number of active connections  | [optional] [default to &#39;ROUND_ROBIN&#39;]
**lb_monitor_profile** | **String** | Path of the PolicyLbMonitorProfile to actively monitor the PolicyLbPoolAccess&#39;s Group  | [optional] 


