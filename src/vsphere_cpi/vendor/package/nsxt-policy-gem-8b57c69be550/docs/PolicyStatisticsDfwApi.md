# SwaggerClient::PolicyStatisticsDfwApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_rule_statistics**](PolicyStatisticsDfwApi.md#get_rule_statistics) | **GET** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules/{rule-id}/statistics | Get rule statistics
[**get_security_policy_statistics**](PolicyStatisticsDfwApi.md#get_security_policy_statistics) | **GET** /infra/domains/{domain-id}/security-policies/{security-policy-id}/statistics | Get security policy statistics


# **get_rule_statistics**
> RuleStatisticsListResult get_rule_statistics(domain_id, security_policy_id, rule_id, opts)

Get rule statistics

Get statistics of a rule. - no enforcement point path specified: Stats will be evaluated on each enforcement point. - {enforcement_point_path}: Stats are evaluated only on the given enforcement point. 

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

api_instance = SwaggerClient::PolicyStatisticsDfwApi.new

domain_id = 'domain_id_example' # String | Domain id

security_policy_id = 'security_policy_id_example' # String | Security policy id

rule_id = 'rule_id_example' # String | Rule id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get rule statistics
  result = api_instance.get_rule_statistics(domain_id, security_policy_id, rule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsDfwApi->get_rule_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **security_policy_id** | **String**| Security policy id | 
 **rule_id** | **String**| Rule id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**RuleStatisticsListResult**](RuleStatisticsListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_security_policy_statistics**
> SecurityPolicyStatisticsListResult get_security_policy_statistics(domain_id, security_policy_id, opts)

Get security policy statistics

Get statistics of a security policy. - no enforcement point path specified: Stats will be evaluated on each enforcement point. - {enforcement_point_path}: Stats are evaluated only on the given enforcement point. 

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

api_instance = SwaggerClient::PolicyStatisticsDfwApi.new

domain_id = 'domain_id_example' # String | Domain id

security_policy_id = 'security_policy_id_example' # String | Security policy id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get security policy statistics
  result = api_instance.get_security_policy_statistics(domain_id, security_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsDfwApi->get_security_policy_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **security_policy_id** | **String**| Security policy id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**SecurityPolicyStatisticsListResult**](SecurityPolicyStatisticsListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



