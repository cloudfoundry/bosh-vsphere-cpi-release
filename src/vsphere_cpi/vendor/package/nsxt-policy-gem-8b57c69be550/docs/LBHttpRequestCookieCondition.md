# SwaggerClient::LbHttpRequestCookieCondition

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inverse** | **BOOLEAN** | A flag to indicate whether reverse the match result of this condition | [optional] [default to false]
**type** | **String** | Type of load balancer rule condition | 
**match_type** | **String** | Match type of cookie value | [optional] [default to &#39;REGEX&#39;]
**cookie_name** | **String** | Name of cookie | 
**cookie_value** | **String** | Value of cookie | 
**case_sensitive** | **BOOLEAN** | If true, case is significant when comparing cookie value.  | [optional] [default to true]


