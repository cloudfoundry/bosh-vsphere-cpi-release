# SwaggerClient::HttpsPolicyLbVirtualServer

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
**resource_type** | **String** |  | 
**path** | **String** | Absolute path of this object | [optional] 
**parent_path** | **String** | Path of its parent | [optional] 
**relative_path** | **String** | Path relative from its parent | [optional] 
**children** | [**Array&lt;ChildPolicyConfigResource&gt;**](ChildPolicyConfigResource.md) | subtree for this type within policy tree containing nested elements.  | [optional] 
**marked_for_delete** | **BOOLEAN** | Intent objects are not directly deleted from the system when a delete is invoked on them. They are marked for deletion and only when all the realized entities for that intent object gets deleted, the intent object is deleted. Objects that are marked for deletion are not returned in GET call. One can use the search API to get these objects.  | [optional] [default to false]
**access_log_enabled** | **BOOLEAN** | If access log is enabled, all HTTP requests sent to an L7 virtual server are logged to the access log file. Both successful requests (backend server returns 2xx) and unsuccessful requests (backend server returns 4xx or 5xx) are logged to access log, if enabled.  | [optional] [default to false]
**router_path** | **String** | Path to router type object that PolicyLbVirtualServer connects to. The only supported router object is Network.  | 
**lb_persistence_profile** | **String** | Path to optional object that enables persistence on a virtual server allowing related client connections to be sent to the same backend server. Persistence is disabled by default.  | [optional] 
**traffic_source** | **String** |  | [optional] 
**ip_address** | **String** | Configures the IP address of the PolicyLbVirtualServer where it receives all client connections and distributes them among the backend servers.  | 
**ports** | **Array&lt;String&gt;** | Ports contains a list of at least one port or port range such as \&quot;80\&quot;, \&quot;1234-1236\&quot;. Each port element in the list should be a single port or a single port range.  | 
**insert_client_ip_header** | **BOOLEAN** | Backend web servers typically log each request they handle along with the requesting client IP address. These logs are used for debugging, analytics and other such purposes. If the deployment topology requires enabling SNAT on the load balancer, then server will see the client as the SNAT IP which defeats the purpose of logging. To work around this issue, load balancer can be configured to insert XFF HTTP header with the original client IP address. Backend servers can then be configured to log the IP address in XFF header instead of the source IP address of the connection. If XFF header is not present in the incoming request, load balancer inserts a new XFF header with the client IP address.  | [optional] [default to false]
**client_ssl_settings** | **String** | Security settings representing various security settings when the VirtualServer acts as an SSL server - BASE_SECURE_111317 - MODERATE_SECURE_111317 - HIGH_SECURE_111317  | [optional] [default to &#39;HIGH_SECURE_111317&#39;]
**client_ssl_certificate_ids** | **Array&lt;String&gt;** | Client-side SSL profile binding allows multiple certificates, for different hostnames, to be bound to the same virtual server. The setting is used when load balancer acts as an SSL server and terminating the client SSL connection  | [optional] 
**default_client_ssl_certificate_id** | **String** | The setting is used when load balancer acts as an SSL server and terminating the client SSL connection.  A default certificate should be specified which will be used if the server does not host multiple hostnames on the same IP address or if the client does not support SNI extension.  | 


