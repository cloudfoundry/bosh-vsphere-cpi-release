# SwaggerClient::PolicyStatisticsGatewayFirewallApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_gateway_policy_statistics**](PolicyStatisticsGatewayFirewallApi.md#get_gateway_policy_statistics) | **GET** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/statistics | Get gateway policy statistics
[**get_gateway_rule_statistics**](PolicyStatisticsGatewayFirewallApi.md#get_gateway_rule_statistics) | **GET** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules/{rule-id}/statistics | Get gateway rule statistics


# **get_gateway_policy_statistics**
> SecurityPolicyStatisticsListResult get_gateway_policy_statistics(domain_id, gateway_policy_id, opts)

Get gateway policy statistics

Get statistics of a gateay policy. - no enforcement point path specified: Stats will be evaluated on each enforcement. point. - {enforcement_point_path}: Stats are evaluated only on the given enforcement point. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyStatisticsGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get gateway policy statistics
  result = api_instance.get_gateway_policy_statistics(domain_id, gateway_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGatewayFirewallApi->get_gateway_policy_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**SecurityPolicyStatisticsListResult**](SecurityPolicyStatisticsListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_gateway_rule_statistics**
> RuleStatisticsListResult get_gateway_rule_statistics(domain_id, gateway_policy_id, rule_id, opts)

Get gateway rule statistics

Get statistics of a gateway rule. - no enforcement point path specified: Stats will be evaluated on each enforcement. point. - {enforcement_point_path}: Stats are evaluated only on the given enforcement point. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyStatisticsGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get gateway rule statistics
  result = api_instance.get_gateway_rule_statistics(domain_id, gateway_policy_id, rule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGatewayFirewallApi->get_gateway_rule_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**RuleStatisticsListResult**](RuleStatisticsListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



