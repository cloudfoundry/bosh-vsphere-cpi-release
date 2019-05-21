# SwaggerClient::ErrorResolverMetadata

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**error_id** | **Integer** | The error id as reported by the entity where the error occurred. | 
**system_metadata** | [**ErrorResolverSystemMetadata**](ErrorResolverSystemMetadata.md) | This can come from some external system like syslog collector | [optional] 
**entity_id** | **String** | The entity/node UUID where the error has occurred. | 
**user_metadata** | [**ErrorResolverUserMetadata**](ErrorResolverUserMetadata.md) | User supplied metadata that might be required by the resolver | [optional] 


