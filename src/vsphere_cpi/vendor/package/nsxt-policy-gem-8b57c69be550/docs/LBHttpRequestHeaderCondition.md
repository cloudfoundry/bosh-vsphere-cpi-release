# SwaggerClient::LbHttpRequestHeaderCondition

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inverse** | **BOOLEAN** | A flag to indicate whether reverse the match result of this condition | [optional] [default to false]
**type** | **String** | Type of load balancer rule condition | 
**header_value** | **String** | Value of HTTP header | 
**case_sensitive** | **BOOLEAN** | If true, case is significant when comparing HTTP header value.  | [optional] [default to true]
**match_type** | **String** | Match type of HTTP header value | [optional] [default to &#39;REGEX&#39;]
**header_name** | **String** | Name of HTTP header | 


