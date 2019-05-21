# SwaggerClient::EmbeddedResource

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_owner** | [**OwnerResourceLink**](OwnerResourceLink.md) | Owner of this resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**id** | **String** | Identifier of the resource | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**description** | **String** | Description of this resource | [optional] 


