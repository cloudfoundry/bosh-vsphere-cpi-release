# SwaggerClient::ServiceAttachment

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
**attachment_status** | **String** | UP - A Service Attachment will have its Service Port - UP and with a configured IP address. DOWN - An Inactive ServiceAttachment has its Service Port - DOWN. It can be used to connect set of appliances that do not need to exchange traffic to/from/through the Edge node. | [optional] [default to &#39;UP&#39;]
**service_port** | [**ResourceReference**](ResourceReference.md) | Service Port gets created as a part of Service Attachment creation. It is a Logical Router Port of type CentralizedServicePort. It does not participate in distributed routing. Stateless Policy Based Routing service can be applied on this port. | [optional] 
**deployed_to** | [**ResourceReference**](ResourceReference.md) | NSX Resource where we want to create Service Attachment Point. Ex. T0 LR Edge in case of north-south ServiceInsertion and a TransportZone (which is used to define the service plane) in case of east-west service insertion. | 
**logical_switch** | [**ResourceReference**](ResourceReference.md) | Logical Switch gets created as a part of Service Attachment creation. | [optional] 
**local_ips** | [**Array&lt;IPInfo&gt;**](IPInfo.md) | Local IPs associated with this Service Attachment. | [optional] 


