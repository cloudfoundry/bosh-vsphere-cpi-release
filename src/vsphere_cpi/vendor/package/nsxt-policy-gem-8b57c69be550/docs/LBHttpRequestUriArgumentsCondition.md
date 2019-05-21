# SwaggerClient::LbHttpRequestUriArgumentsCondition

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inverse** | **BOOLEAN** | A flag to indicate whether reverse the match result of this condition | [optional] [default to false]
**type** | **String** | Type of load balancer rule condition | 
**uri_arguments** | **String** | URI arguments, aka query string of URI.  | 
**match_type** | **String** | Match type of URI arguments | [optional] [default to &#39;REGEX&#39;]
**case_sensitive** | **BOOLEAN** | If true, case is significant when comparing URI arguments.  | [optional] [default to true]


