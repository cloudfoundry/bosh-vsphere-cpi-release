# SwaggerClient::PrecedingQueryRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**data_source** | **String** | The data source to query on | [optional] 
**query_pipeline** | [**Array&lt;QueryPipeRequest&gt;**](QueryPipeRequest.md) | An array of search queries | 
**ignore_if_empty** | **BOOLEAN** | A flag to indicate if the output of the preceding queries is to be ignored if empty.  | [optional] [default to false]
**field_mappings** | **String** | Comma seperated list of field mappings between the preceding query response and the primary resource. Each field mapping in the list  is to be specified in the \&quot;PrimaryFieldName:{PrecedingFieldName}\&quot; format.  | 


