# SwaggerClient::PolicyGiApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_endpoint_policy**](PolicyGiApi.md#create_or_update_endpoint_policy) | **PUT** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id} | Create or update Endpoint policy
[**create_or_update_endpoint_rule**](PolicyGiApi.md#create_or_update_endpoint_rule) | **PUT** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id}/endpoint-rules/{endpoint-rule-id} | Update Endpoint rule
[**delete_endpoint_policy**](PolicyGiApi.md#delete_endpoint_policy) | **DELETE** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id} | Delete Endpoint policy
[**delete_endpoint_rule**](PolicyGiApi.md#delete_endpoint_rule) | **DELETE** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id}/endpoint-rules/{endpoint-rule-id} | Delete EndpointRule
[**list_endpoint_rule**](PolicyGiApi.md#list_endpoint_rule) | **GET** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id}/endpoint-rules | List Endpoint rules
[**patch_endpoint_policy**](PolicyGiApi.md#patch_endpoint_policy) | **PATCH** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id} | Create or update Endpoint policy
[**patch_endpoint_rule**](PolicyGiApi.md#patch_endpoint_rule) | **PATCH** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id}/endpoint-rules/{endpoint-rule-id} | Update Endpoint rule
[**read_endpoint_policy**](PolicyGiApi.md#read_endpoint_policy) | **GET** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id} | Read Endpoint policy
[**read_endpoint_rule**](PolicyGiApi.md#read_endpoint_rule) | **GET** /infra/domains/{domain-id}/endpoint-policies/{endpoint-policy-id}/endpoint-rules/{endpoint-rule-id} | Read Endpoint rule


# **create_or_update_endpoint_policy**
> EndpointPolicy create_or_update_endpoint_policy(domain_id, endpoint_policy_id, endpoint_policy)

Create or update Endpoint policy

Create or update the Endpoint policy. 

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id

endpoint_policy = SwaggerClient::EndpointPolicy.new # EndpointPolicy | 


begin
  #Create or update Endpoint policy
  result = api_instance.create_or_update_endpoint_policy(domain_id, endpoint_policy_id, endpoint_policy)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->create_or_update_endpoint_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 
 **endpoint_policy** | [**EndpointPolicy**](EndpointPolicy.md)|  | 

### Return type

[**EndpointPolicy**](EndpointPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_endpoint_rule**
> EndpointRule create_or_update_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id, endpoint_rule)

Update Endpoint rule

Create a Endpoint rule with the endpoint-rule-id is not already present, otherwise update the Endpoint Rule. 

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id

endpoint_rule_id = 'endpoint_rule_id_example' # String | Endpoint rule id

endpoint_rule = SwaggerClient::EndpointRule.new # EndpointRule | 


begin
  #Update Endpoint rule
  result = api_instance.create_or_update_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id, endpoint_rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->create_or_update_endpoint_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 
 **endpoint_rule_id** | **String**| Endpoint rule id | 
 **endpoint_rule** | [**EndpointRule**](EndpointRule.md)|  | 

### Return type

[**EndpointRule**](EndpointRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_endpoint_policy**
> delete_endpoint_policy(domain_id, endpoint_policy_id)

Delete Endpoint policy

Delete Endpoint policy.

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id


begin
  #Delete Endpoint policy
  api_instance.delete_endpoint_policy(domain_id, endpoint_policy_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->delete_endpoint_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_endpoint_rule**
> delete_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id)

Delete EndpointRule

Delete EndpointRule

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain ID

endpoint_policy_id = 'endpoint_policy_id_example' # String | EndpointPolicy ID

endpoint_rule_id = 'endpoint_rule_id_example' # String | EndpointRule ID


begin
  #Delete EndpointRule
  api_instance.delete_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->delete_endpoint_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **endpoint_policy_id** | **String**| EndpointPolicy ID | 
 **endpoint_rule_id** | **String**| EndpointRule ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_endpoint_rule**
> EndpointRuleListResult list_endpoint_rule(domain_id, endpoint_policy_id, opts)

List Endpoint rules

List Endpoint rules

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Endpoint rules
  result = api_instance.list_endpoint_rule(domain_id, endpoint_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->list_endpoint_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**EndpointRuleListResult**](EndpointRuleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_endpoint_policy**
> patch_endpoint_policy(domain_id, endpoint_policy_id, endpoint_policy)

Create or update Endpoint policy

Create or update the Endpoint policy. 

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id

endpoint_policy = SwaggerClient::EndpointPolicy.new # EndpointPolicy | 


begin
  #Create or update Endpoint policy
  api_instance.patch_endpoint_policy(domain_id, endpoint_policy_id, endpoint_policy)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->patch_endpoint_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 
 **endpoint_policy** | [**EndpointPolicy**](EndpointPolicy.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_endpoint_rule**
> patch_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id, endpoint_rule)

Update Endpoint rule

Create a Endpoint rule with the endpoint-rule-id is not already present, otherwise update the Endpoint Rule. 

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id

endpoint_rule_id = 'endpoint_rule_id_example' # String | Endpoint rule id

endpoint_rule = SwaggerClient::EndpointRule.new # EndpointRule | 


begin
  #Update Endpoint rule
  api_instance.patch_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id, endpoint_rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->patch_endpoint_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 
 **endpoint_rule_id** | **String**| Endpoint rule id | 
 **endpoint_rule** | [**EndpointRule**](EndpointRule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_endpoint_policy**
> EndpointPolicy read_endpoint_policy(domain_id, endpoint_policy_id)

Read Endpoint policy

Read Endpoint policy. 

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id


begin
  #Read Endpoint policy
  result = api_instance.read_endpoint_policy(domain_id, endpoint_policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->read_endpoint_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 

### Return type

[**EndpointPolicy**](EndpointPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_endpoint_rule**
> EndpointRule read_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id)

Read Endpoint rule

Read Endpoint rule

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

api_instance = SwaggerClient::PolicyGiApi.new

domain_id = 'domain_id_example' # String | Domain id

endpoint_policy_id = 'endpoint_policy_id_example' # String | Endpoint policy id

endpoint_rule_id = 'endpoint_rule_id_example' # String | Endpoint rule id


begin
  #Read Endpoint rule
  result = api_instance.read_endpoint_rule(domain_id, endpoint_policy_id, endpoint_rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGiApi->read_endpoint_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **endpoint_policy_id** | **String**| Endpoint policy id | 
 **endpoint_rule_id** | **String**| Endpoint rule id | 

### Return type

[**EndpointRule**](EndpointRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



