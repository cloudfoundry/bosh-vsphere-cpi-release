# SwaggerClient::EdgeNode

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
**resource_type** | **String** | Fabric node type, for example &#39;HostNode&#39;, &#39;EdgeNode&#39; or &#39;PublicCloudGatewayNode&#39; | 
**discovered_ip_addresses** | **Array&lt;String&gt;** | Discovered IP Addresses of the fabric node, version 4 or 6 | [optional] 
**ip_addresses** | **Array&lt;String&gt;** | IP Addresses of the Node, version 4 or 6. This property is mandatory for all nodes except for automatic deployment of edge virtual machine node. For automatic deployment, the ip address from management_port_subnets property will be considered.  | [optional] 
**external_id** | **String** | ID of the Node maintained on the Node and used to recognize the Node | [optional] 
**fqdn** | **String** | Fully qualified domain name of the fabric node | [optional] 
**deployment_config** | [**EdgeNodeDeploymentConfig**](EdgeNodeDeploymentConfig.md) | When this configuration is specified, edge fabric node of deployment_type VIRTUAL_MACHINE will be deployed and registered with MP.  | [optional] 
**allocation_list** | **Array&lt;String&gt;** | List of logical router ids to which this edge node is allocated. | [optional] 
**deployment_type** | **String** | Supported edge deployment type. | [optional] 


