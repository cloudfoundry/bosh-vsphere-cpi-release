# SwaggerClient::QueryPipeRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**query** | **String** | Subsequent queries can specify the field values to be used from the output of the previous query. These fields are to be specified within curly braces. e.g. resource_type:LogicalSwitch AND transport_zone_id:{id}.  | 
**wildcard** | **String** | Wildcards to be used with the join conditions. If not provided an exact match would be carried out.  | [optional] 


