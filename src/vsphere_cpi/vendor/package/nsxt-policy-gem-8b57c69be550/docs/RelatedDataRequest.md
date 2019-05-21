# SwaggerClient::RelatedDataRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**included_fields** | **String** | Comma separated list of fields that should be included in query result | [optional] 
**_alias** | **String** | Alias for the response | [optional] 
**preceding_queries** | [**PrecedingQueryRequest**](PrecedingQueryRequest.md) | These will be executed before the aggregation and the result will be passed in as an input filter to the primary  | [optional] 
**filters** | [**Array&lt;FilterRequest&gt;**](FilterRequest.md) | An array of filter conditions | [optional] 
**resource_type** | **String** | Resource type name | 
**stats_fields** | **String** | Comma seperated numeric fields for which stats are to be provided | [optional] 
**join_condition** | **String** | Join condition between the parent and the related object. This is to be specified in \&quot;relatedObjectFieldName:ParentObjectFieldName\&quot; format.  | 
**size** | **Integer** | Number of related objects to return. If not specified all the related objects will be returned. Should be set to 0 if only the count of related objects is desired.  | [optional] 


