# SwaggerClient::PolicyForwardingApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_forwarding_policy**](PolicyForwardingApi.md#create_or_update_forwarding_policy) | **PUT** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id} | Create or update forwarding policy
[**create_or_update_forwarding_rule**](PolicyForwardingApi.md#create_or_update_forwarding_rule) | **PUT** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id}/rules/{rule-id} | Update forwarding rule
[**delete_forwarding_policy**](PolicyForwardingApi.md#delete_forwarding_policy) | **DELETE** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id} | Delete forwarding policy
[**delete_forwarding_rule**](PolicyForwardingApi.md#delete_forwarding_rule) | **DELETE** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id}/rules/{rule-id} | Delete ForwardingRule
[**list_forwarding_policies**](PolicyForwardingApi.md#list_forwarding_policies) | **GET** /infra/domains/{domain-id}/forwarding-policies | List forwarding policies for the given domain
[**list_forwarding_rule**](PolicyForwardingApi.md#list_forwarding_rule) | **GET** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id}/rules | List rules
[**patch_forwarding_policy**](PolicyForwardingApi.md#patch_forwarding_policy) | **PATCH** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id} | Create or update forwarding policy
[**patch_forwarding_rule**](PolicyForwardingApi.md#patch_forwarding_rule) | **PATCH** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id}/rules/{rule-id} | Update forwarding rule
[**read_forwarding_policy**](PolicyForwardingApi.md#read_forwarding_policy) | **GET** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id} | Read forwarding policy
[**read_forwarding_rule**](PolicyForwardingApi.md#read_forwarding_rule) | **GET** /infra/domains/{domain-id}/forwarding-policies/{forwarding-policy-id}/rules/{rule-id} | Read rule


# **create_or_update_forwarding_policy**
> ForwardingPolicy create_or_update_forwarding_policy(domain_id, forwarding_policy_id, forwarding_policy)

Create or update forwarding policy

Create or update the forwarding policy. 

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id

forwarding_policy = SwaggerClient::ForwardingPolicy.new # ForwardingPolicy | 


begin
  #Create or update forwarding policy
  result = api_instance.create_or_update_forwarding_policy(domain_id, forwarding_policy_id, forwarding_policy)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->create_or_update_forwarding_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 
 **forwarding_policy** | [**ForwardingPolicy**](ForwardingPolicy.md)|  | 

### Return type

[**ForwardingPolicy**](ForwardingPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_forwarding_rule**
> ForwardingRule create_or_update_forwarding_rule(domain_id, forwarding_policy_id, rule_id, forwarding_rule)

Update forwarding rule

Create a rule with the rule-id is not already present, otherwise update the rule. 

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id

rule_id = 'rule_id_example' # String | rule id

forwarding_rule = SwaggerClient::ForwardingRule.new # ForwardingRule | 


begin
  #Update forwarding rule
  result = api_instance.create_or_update_forwarding_rule(domain_id, forwarding_policy_id, rule_id, forwarding_rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->create_or_update_forwarding_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 
 **rule_id** | **String**| rule id | 
 **forwarding_rule** | [**ForwardingRule**](ForwardingRule.md)|  | 

### Return type

[**ForwardingRule**](ForwardingRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_forwarding_policy**
> delete_forwarding_policy(domain_id, forwarding_policy_id)

Delete forwarding policy

Delete forwarding policy.

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id


begin
  #Delete forwarding policy
  api_instance.delete_forwarding_policy(domain_id, forwarding_policy_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->delete_forwarding_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_forwarding_rule**
> delete_forwarding_rule(domain_id, forwarding_policy_id, rule_id)

Delete ForwardingRule

Delete ForwardingRule

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain ID

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding Map ID

rule_id = 'rule_id_example' # String | ForwardingRule ID


begin
  #Delete ForwardingRule
  api_instance.delete_forwarding_rule(domain_id, forwarding_policy_id, rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->delete_forwarding_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **forwarding_policy_id** | **String**| Forwarding Map ID | 
 **rule_id** | **String**| ForwardingRule ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_forwarding_policies**
> ForwardingPolicyListResult list_forwarding_policies(domain_id, opts)

List forwarding policies for the given domain

List all forwarding policies for the given domain ordered by precedence. 

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List forwarding policies for the given domain
  result = api_instance.list_forwarding_policies(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->list_forwarding_policies: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ForwardingPolicyListResult**](ForwardingPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_forwarding_rule**
> ForwardingRuleListResult list_forwarding_rule(domain_id, forwarding_policy_id, opts)

List rules

List rules

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List rules
  result = api_instance.list_forwarding_rule(domain_id, forwarding_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->list_forwarding_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ForwardingRuleListResult**](ForwardingRuleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_forwarding_policy**
> patch_forwarding_policy(domain_id, forwarding_policy_id, forwarding_policy)

Create or update forwarding policy

Create or update the forwarding policy. 

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id

forwarding_policy = SwaggerClient::ForwardingPolicy.new # ForwardingPolicy | 


begin
  #Create or update forwarding policy
  api_instance.patch_forwarding_policy(domain_id, forwarding_policy_id, forwarding_policy)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->patch_forwarding_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 
 **forwarding_policy** | [**ForwardingPolicy**](ForwardingPolicy.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_forwarding_rule**
> patch_forwarding_rule(domain_id, forwarding_policy_id, rule_id, forwarding_rule)

Update forwarding rule

Create a rule with the rule-id is not already present, otherwise update the rule. 

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id

rule_id = 'rule_id_example' # String | Rule id

forwarding_rule = SwaggerClient::ForwardingRule.new # ForwardingRule | 


begin
  #Update forwarding rule
  api_instance.patch_forwarding_rule(domain_id, forwarding_policy_id, rule_id, forwarding_rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->patch_forwarding_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 
 **rule_id** | **String**| Rule id | 
 **forwarding_rule** | [**ForwardingRule**](ForwardingRule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_forwarding_policy**
> ForwardingPolicy read_forwarding_policy(domain_id, forwarding_policy_id)

Read forwarding policy

Read forwarding policy. 

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id


begin
  #Read forwarding policy
  result = api_instance.read_forwarding_policy(domain_id, forwarding_policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->read_forwarding_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 

### Return type

[**ForwardingPolicy**](ForwardingPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_forwarding_rule**
> ForwardingRule read_forwarding_rule(domain_id, forwarding_policy_id, rule_id)

Read rule

Read rule

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

api_instance = SwaggerClient::PolicyForwardingApi.new

domain_id = 'domain_id_example' # String | Domain id

forwarding_policy_id = 'forwarding_policy_id_example' # String | Forwarding map id

rule_id = 'rule_id_example' # String | Rule id


begin
  #Read rule
  result = api_instance.read_forwarding_rule(domain_id, forwarding_policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyForwardingApi->read_forwarding_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **forwarding_policy_id** | **String**| Forwarding map id | 
 **rule_id** | **String**| Rule id | 

### Return type

[**ForwardingRule**](ForwardingRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



