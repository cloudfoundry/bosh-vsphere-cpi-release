# SwaggerClient::PolicyNatApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_policy_nat_rule**](PolicyNatApi.md#create_or_replace_policy_nat_rule) | **PUT** /infra/tier-1s/{tier-1-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Update NAT Rule
[**create_or_replace_policy_nat_rule_on_tier0**](PolicyNatApi.md#create_or_replace_policy_nat_rule_on_tier0) | **PUT** /infra/tier-0s/{tier-0-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Update NAT Rule
[**delete_policy_nat_rule**](PolicyNatApi.md#delete_policy_nat_rule) | **DELETE** /infra/tier-1s/{tier-1-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Delete NAT Rule
[**delete_policy_nat_rule_from_tier0**](PolicyNatApi.md#delete_policy_nat_rule_from_tier0) | **DELETE** /infra/tier-0s/{tier-0-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Delete NAT Rule
[**get_policy_nat_rule**](PolicyNatApi.md#get_policy_nat_rule) | **GET** /infra/tier-1s/{tier-1-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Get NAT Rule
[**get_policy_nat_rule_from_tier0**](PolicyNatApi.md#get_policy_nat_rule_from_tier0) | **GET** /infra/tier-0s/{tier-0-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Get NAT Rule
[**get_policy_nat_rule_statistics_from_tier0**](PolicyNatApi.md#get_policy_nat_rule_statistics_from_tier0) | **GET** /infra/tier-0s/{tier-0-id}/nat/{nat-id}/nat-rules/{nat-rule-id}/statistics | Get NAT Rule Statistics
[**get_policy_nat_rule_statistics_from_tier1**](PolicyNatApi.md#get_policy_nat_rule_statistics_from_tier1) | **GET** /infra/tier-1s/{tier-1-id}/nat/{nat-id}/nat-rules/{nat-rule-id}/statistics | Get NAT Rule Statistics
[**list_policy_nat_rules**](PolicyNatApi.md#list_policy_nat_rules) | **GET** /infra/tier-1s/{tier-1-id}/nat/{nat-id}/nat-rules | List NAT Rules
[**list_policy_nat_rules_from_tier0**](PolicyNatApi.md#list_policy_nat_rules_from_tier0) | **GET** /infra/tier-0s/{tier-0-id}/nat/{nat-id}/nat-rules | List NAT Rules
[**list_policy_nat_rules_statistics_from_tier0**](PolicyNatApi.md#list_policy_nat_rules_statistics_from_tier0) | **GET** /infra/tier-0s/{tier-0-id}/nat/statistics | List NAT Rules Statistics
[**list_policy_nat_rules_statistics_from_tier1**](PolicyNatApi.md#list_policy_nat_rules_statistics_from_tier1) | **GET** /infra/tier-1s/{tier-1-id}/nat/statistics | List NAT Rules Statistics
[**patch_policy_nat_rule**](PolicyNatApi.md#patch_policy_nat_rule) | **PATCH** /infra/tier-1s/{tier-1-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Create or update a Nat Rule
[**patch_policy_nat_rule_on_tier0**](PolicyNatApi.md#patch_policy_nat_rule_on_tier0) | **PATCH** /infra/tier-0s/{tier-0-id}/nat/{nat-id}/nat-rules/{nat-rule-id} | Create or update a NAT Rule on tier-0


# **create_or_replace_policy_nat_rule**
> PolicyNatRule create_or_replace_policy_nat_rule(tier_1_id, nat_id, nat_rule_id, policy_nat_rule)

Update NAT Rule

Update NAT Rule on Tier-1 denoted by Tier-1 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-1 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID

policy_nat_rule = SwaggerClient::PolicyNatRule.new # PolicyNatRule | 


begin
  #Update NAT Rule
  result = api_instance.create_or_replace_policy_nat_rule(tier_1_id, nat_id, nat_rule_id, policy_nat_rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->create_or_replace_policy_nat_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 
 **policy_nat_rule** | [**PolicyNatRule**](PolicyNatRule.md)|  | 

### Return type

[**PolicyNatRule**](PolicyNatRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_policy_nat_rule_on_tier0**
> PolicyNatRule create_or_replace_policy_nat_rule_on_tier0(tier_0_id, nat_id, nat_rule_id, policy_nat_rule)

Update NAT Rule

Update NAT Rule on Tier-0 denoted by Tier-0 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-0 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID

policy_nat_rule = SwaggerClient::PolicyNatRule.new # PolicyNatRule | 


begin
  #Update NAT Rule
  result = api_instance.create_or_replace_policy_nat_rule_on_tier0(tier_0_id, nat_id, nat_rule_id, policy_nat_rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->create_or_replace_policy_nat_rule_on_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 
 **policy_nat_rule** | [**PolicyNatRule**](PolicyNatRule.md)|  | 

### Return type

[**PolicyNatRule**](PolicyNatRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_nat_rule**
> delete_policy_nat_rule(tier_1_id, nat_id, nat_rule_id)

Delete NAT Rule

Delete NAT Rule from Tier-1 denoted by Tier-1 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-1 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID


begin
  #Delete NAT Rule
  api_instance.delete_policy_nat_rule(tier_1_id, nat_id, nat_rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->delete_policy_nat_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_nat_rule_from_tier0**
> delete_policy_nat_rule_from_tier0(tier_0_id, nat_id, nat_rule_id)

Delete NAT Rule

Delete NAT Rule from Tier-0 denoted by Tier-0 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-0 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID


begin
  #Delete NAT Rule
  api_instance.delete_policy_nat_rule_from_tier0(tier_0_id, nat_id, nat_rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->delete_policy_nat_rule_from_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_nat_rule**
> PolicyNatRule get_policy_nat_rule(tier_1_id, nat_id, nat_rule_id)

Get NAT Rule

Get NAT Rule from Tier-1 denoted by Tier-1 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-1 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema. 

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID


begin
  #Get NAT Rule
  result = api_instance.get_policy_nat_rule(tier_1_id, nat_id, nat_rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->get_policy_nat_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 

### Return type

[**PolicyNatRule**](PolicyNatRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_nat_rule_from_tier0**
> PolicyNatRule get_policy_nat_rule_from_tier0(tier_0_id, nat_id, nat_rule_id)

Get NAT Rule

Get NAT Rule from Tier-0 denoted by Tier-0 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-0 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema. 

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID


begin
  #Get NAT Rule
  result = api_instance.get_policy_nat_rule_from_tier0(tier_0_id, nat_id, nat_rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->get_policy_nat_rule_from_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 

### Return type

[**PolicyNatRule**](PolicyNatRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_nat_rule_statistics_from_tier0**
> PolicyNatRuleStatisticsListResult get_policy_nat_rule_statistics_from_tier0(tier_0_id, nat_id, nat_rule_id, opts)

Get NAT Rule Statistics

Get NAT Rule Statistics from Tier-0 denoted by Tier-0 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-0 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema. 

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get NAT Rule Statistics
  result = api_instance.get_policy_nat_rule_statistics_from_tier0(tier_0_id, nat_id, nat_rule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->get_policy_nat_rule_statistics_from_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**PolicyNatRuleStatisticsListResult**](PolicyNatRuleStatisticsListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_nat_rule_statistics_from_tier1**
> PolicyNatRuleStatisticsListResult get_policy_nat_rule_statistics_from_tier1(tier_1_id, nat_id, nat_rule_id, opts)

Get NAT Rule Statistics

Get NAT Rule Statistics from Tier-1 denoted by Tier-1 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-1 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema. 

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get NAT Rule Statistics
  result = api_instance.get_policy_nat_rule_statistics_from_tier1(tier_1_id, nat_id, nat_rule_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->get_policy_nat_rule_statistics_from_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**PolicyNatRuleStatisticsListResult**](PolicyNatRuleStatisticsListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_nat_rules**
> PolicyNatRuleListResult list_policy_nat_rules(tier_1_id, nat_id, opts)

List NAT Rules

List NAT Rules from Tier-1 denoted by Tier-1 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-1 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

nat_id = 'nat_id_example' # String | NAT id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List NAT Rules
  result = api_instance.list_policy_nat_rules(tier_1_id, nat_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->list_policy_nat_rules: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **nat_id** | **String**| NAT id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyNatRuleListResult**](PolicyNatRuleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_nat_rules_from_tier0**
> PolicyNatRuleListResult list_policy_nat_rules_from_tier0(tier_0_id, nat_id, opts)

List NAT Rules

List NAT Rules from Tier-0 denoted by Tier-0 ID, under NAT section denoted by &lt;nat-id&gt;. Under tier-0 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

nat_id = 'nat_id_example' # String | NAT id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List NAT Rules
  result = api_instance.list_policy_nat_rules_from_tier0(tier_0_id, nat_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->list_policy_nat_rules_from_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **nat_id** | **String**| NAT id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyNatRuleListResult**](PolicyNatRuleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_nat_rules_statistics_from_tier0**
> PolicyNatRuleStatisticsPerLogicalRouterListResult list_policy_nat_rules_statistics_from_tier0(tier_0_id, opts)

List NAT Rules Statistics

List NAT Rules Statistics from Tier-0 denoted by Tier-0 ID.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List NAT Rules Statistics
  result = api_instance.list_policy_nat_rules_statistics_from_tier0(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->list_policy_nat_rules_statistics_from_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyNatRuleStatisticsPerLogicalRouterListResult**](PolicyNatRuleStatisticsPerLogicalRouterListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_nat_rules_statistics_from_tier1**
> PolicyNatRuleStatisticsPerLogicalRouterListResult list_policy_nat_rules_statistics_from_tier1(tier_1_id, opts)

List NAT Rules Statistics

List NAT Rules Statistics from Tier-1 denoted by Tier-1 ID.

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List NAT Rules Statistics
  result = api_instance.list_policy_nat_rules_statistics_from_tier1(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->list_policy_nat_rules_statistics_from_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyNatRuleStatisticsPerLogicalRouterListResult**](PolicyNatRuleStatisticsPerLogicalRouterListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_nat_rule**
> patch_policy_nat_rule(tier_1_id, nat_id, nat_rule_id, policy_nat_rule)

Create or update a Nat Rule

If a NAT Rule is not already present on Tier-1 denoted by Tier-1 ID, under NAT section denoted by &lt;nat-id&gt;, create a new NAT Rule. If it already exists, update the NAT Rule. Under tier-1 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema. 

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID

policy_nat_rule = SwaggerClient::PolicyNatRule.new # PolicyNatRule | 


begin
  #Create or update a Nat Rule
  api_instance.patch_policy_nat_rule(tier_1_id, nat_id, nat_rule_id, policy_nat_rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->patch_policy_nat_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 
 **policy_nat_rule** | [**PolicyNatRule**](PolicyNatRule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_nat_rule_on_tier0**
> patch_policy_nat_rule_on_tier0(tier_0_id, nat_id, nat_rule_id, policy_nat_rule)

Create or update a NAT Rule on tier-0

If a NAT Rule is not already present on Tier-0 denoted by Tier-0 ID, under NAT section denoted by &lt;nat-id&gt;, create a new NAT Rule. If it already exists, update the NAT Rule. Under tier-0 there will be 3 different NATs(sections). (INTERNAL, USER and DEFAULT) For more details related to NAT section please refer to PolicyNAT schema. 

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

api_instance = SwaggerClient::PolicyNatApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

nat_id = 'nat_id_example' # String | NAT id

nat_rule_id = 'nat_rule_id_example' # String | Rule ID

policy_nat_rule = SwaggerClient::PolicyNatRule.new # PolicyNatRule | 


begin
  #Create or update a NAT Rule on tier-0
  api_instance.patch_policy_nat_rule_on_tier0(tier_0_id, nat_id, nat_rule_id, policy_nat_rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyNatApi->patch_policy_nat_rule_on_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **nat_id** | **String**| NAT id | 
 **nat_rule_id** | **String**| Rule ID | 
 **policy_nat_rule** | [**PolicyNatRule**](PolicyNatRule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



