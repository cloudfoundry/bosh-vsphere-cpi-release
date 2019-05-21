# SwaggerClient::PortAttachment

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**traffic_tag** | **Integer** | Not valid when type is INDEPENDENT, mainly used to identify traffic from different ports in container use case  | [optional] 
**allocate_addresses** | **String** | Indicate how IP will be allocated for the port | [optional] 
**context_id** | **String** | Parent VIF ID if type is CHILD, Transport node ID if type is INDEPENDENT | [optional] 
**type** | **String** | Type of port attachment, it&#39;s an Enum value. | [optional] 
**app_id** | **String** | ID used to identify/look up a child attachment behind a parent attachment  | [optional] 
**id** | **String** | VIF UUID on NSX Manager | [optional] 


