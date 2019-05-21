# SwaggerClient::LbHttpRequestBodyCondition

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inverse** | **BOOLEAN** | A flag to indicate whether reverse the match result of this condition | [optional] [default to false]
**type** | **String** | Type of load balancer rule condition | 
**body_value** | **String** | HTTP request body | 
**match_type** | **String** | Match type of HTTP body | [optional] [default to &#39;REGEX&#39;]
**case_sensitive** | **BOOLEAN** | If true, case is significant when comparing HTTP body value.  | [optional] [default to true]


