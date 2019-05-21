# SwaggerClient::FirewallRuleChecksStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**status** | **String** | Current status of the task | [optional] 
**async_response_available** | **BOOLEAN** | True if response for asynchronous request is available | [optional] 
**description** | **String** | Description of the task | [optional] 
**start_time** | **Integer** | The start time of the task in epoch milliseconds | [optional] 
**cancelable** | **BOOLEAN** | True if this task can be canceled | [optional] 
**request_method** | **String** | HTTP request method | [optional] 
**user** | **String** | Name of the user who created this task | [optional] 
**progress** | **Integer** | Task progress if known, from 0 to 100 | [optional] 
**message** | **String** | A message describing the disposition of the task | [optional] 
**request_uri** | **String** | URI of the method invocation that spawned this task | [optional] 
**id** | **String** | Identifier for this task | [optional] 
**end_time** | **Integer** | The end time of the task in epoch milliseconds | [optional] 


