# SwaggerClient::ServiceInsertionServiceProfile

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
**resource_type** | **String** | Service Profile type, for example &#39;GiServiceProfile&#39;, &#39;ServiceInsertionServiceProfile&#39; | 
**attributes** | [**Array&lt;Attribute&gt;**](Attribute.md) | List of attributes specific to a partner for which the service is created. These attributes are passed on to the partner appliance and are opaque to the NSX Manager. If a vendor template exposes configurables, then the values are specified here. | [optional] 
**service_id** | **String** | The service to which the service profile belongs. | [optional] 
**redirection_action** | **String** | The redirection action represents if the packet is exclusively redirected to the service, or if a copy is forwarded to the service. Redirection action is not applicable to guest introspection service. | [optional] [default to &#39;PUNT&#39;]
**vendor_template_id** | **String** | Id of the vendor template to be used by the servive profile. | 


