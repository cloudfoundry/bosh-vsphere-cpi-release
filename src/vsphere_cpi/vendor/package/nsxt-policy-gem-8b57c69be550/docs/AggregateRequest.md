# SwaggerClient::AggregateRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**included_fields** | **String** | Comma separated list of fields that should be included in query result | [optional] 
**_alias** | **String** | Alias for the response | [optional] 
**preceding_queries** | [**PrecedingQueryRequest**](PrecedingQueryRequest.md) | These will be executed before the aggregation and the result will be passed in as an input filter to the primary  | [optional] 
**filters** | [**Array&lt;FilterRequest&gt;**](FilterRequest.md) | An array of filter conditions | [optional] 
**resource_type** | **String** | Resource type name | 


