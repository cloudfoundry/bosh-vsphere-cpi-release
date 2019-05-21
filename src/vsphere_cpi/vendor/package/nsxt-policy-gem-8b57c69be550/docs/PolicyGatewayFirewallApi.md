# SwaggerClient::PolicyGatewayFirewallApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_gateway_policy_for_domain**](PolicyGatewayFirewallApi.md#create_or_replace_gateway_policy_for_domain) | **PUT** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id} | Update gateway policy
[**create_or_replace_gateway_rule**](PolicyGatewayFirewallApi.md#create_or_replace_gateway_rule) | **PUT** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules/{rule-id} | Update gateway rule
[**create_or_replace_tier0_group**](PolicyGatewayFirewallApi.md#create_or_replace_tier0_group) | **PUT** /infra/tier-0s/{tier-0-id}/groups/{group-id} | Create or update Group under specified Tier-0
[**delete_gateway_policy**](PolicyGatewayFirewallApi.md#delete_gateway_policy) | **DELETE** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id} | Delete GatewayPolicy
[**delete_gateway_rule**](PolicyGatewayFirewallApi.md#delete_gateway_rule) | **DELETE** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules/{rule-id} | Delete rule
[**delete_tier0_group**](PolicyGatewayFirewallApi.md#delete_tier0_group) | **DELETE** /infra/tier-0s/{tier-0-id}/groups/{group-id} | Deletes Group under Tier-0
[**list_gateway_rules**](PolicyGatewayFirewallApi.md#list_gateway_rules) | **GET** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules | List rules
[**list_tier0_group**](PolicyGatewayFirewallApi.md#list_tier0_group) | **GET** /infra/tier-0s/{tier-0-id}/groups | List Groups for Tier-0
[**patch_gateway_policy_for_domain**](PolicyGatewayFirewallApi.md#patch_gateway_policy_for_domain) | **PATCH** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id} | Update gateway policy
[**patch_gateway_rule**](PolicyGatewayFirewallApi.md#patch_gateway_rule) | **PATCH** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules/{rule-id} | Update gateway rule
[**patch_tier0_group**](PolicyGatewayFirewallApi.md#patch_tier0_group) | **PATCH** /infra/tier-0s/{tier-0-id}/groups/{group-id} | Create or update Group under specified Tier-0
[**read_gateway_policy_for_domain**](PolicyGatewayFirewallApi.md#read_gateway_policy_for_domain) | **GET** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id} | Read gateway policy
[**read_gateway_rule**](PolicyGatewayFirewallApi.md#read_gateway_rule) | **GET** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules/{rule-id} | Read rule
[**read_tier0_group**](PolicyGatewayFirewallApi.md#read_tier0_group) | **GET** /infra/tier-0s/{tier-0-id}/groups/{group-id} | Read Tier-0 Group
[**view_tier0_gateway_firewall**](PolicyGatewayFirewallApi.md#view_tier0_gateway_firewall) | **GET** /infra/tier-0s/{tier-0-id}/gateway-firewall | Get list of gateway policies with rules that belong to the specific Tier-0 logical router. 
[**view_tier0_locale_services_gateway_firewall**](PolicyGatewayFirewallApi.md#view_tier0_locale_services_gateway_firewall) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-services-id}/gateway-firewall | Get list of gateway policies with rules that belong to the specific Tier-0 LocalServices. 
[**view_tier1_gateway_firewall**](PolicyGatewayFirewallApi.md#view_tier1_gateway_firewall) | **GET** /infra/tier-1s/{tier-1-id}/gateway-firewall | Get list of gateway policies with rules that belong to the specific Tier-1. 
[**view_tier1_locale_services_gateway_firewall**](PolicyGatewayFirewallApi.md#view_tier1_locale_services_gateway_firewall) | **GET** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id}/gateway-firewall | Get list of gateway policies with rules that belong to the specific Tier-1 LocalServices. 


# **create_or_replace_gateway_policy_for_domain**
> GatewayPolicy create_or_replace_gateway_policy_for_domain(domain_id, gateway_policy_id, gateway_policy)

Update gateway policy

Update the gateway policy for a domain. This is a full replace. All the rules are replaced. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

gateway_policy = SwaggerClient::GatewayPolicy.new # GatewayPolicy | 


begin
  #Update gateway policy
  result = api_instance.create_or_replace_gateway_policy_for_domain(domain_id, gateway_policy_id, gateway_policy)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->create_or_replace_gateway_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **gateway_policy** | [**GatewayPolicy**](GatewayPolicy.md)|  | 

### Return type

[**GatewayPolicy**](GatewayPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_gateway_rule**
> Rule create_or_replace_gateway_rule(domain_id, gateway_policy_id, rule_id, rule)

Update gateway rule

Update the gateway rule. Create new rule if a rule with the rule-id is not already present. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

rule = SwaggerClient::Rule.new # Rule | 


begin
  #Update gateway rule
  result = api_instance.create_or_replace_gateway_rule(domain_id, gateway_policy_id, rule_id, rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->create_or_replace_gateway_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **rule** | [**Rule**](Rule.md)|  | 

### Return type

[**Rule**](Rule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_tier0_group**
> Group create_or_replace_tier0_group(tier_0_id, group_id, group)

Create or update Group under specified Tier-0

If a Group with the group-id is not already present, create a new Group under the tier-0-id. Update if exists. The API valiates that Tier-0 is present before creating the Group. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 

group_id = 'group_id_example' # String | 

group = SwaggerClient::Group.new # Group | 


begin
  #Create or update Group under specified Tier-0
  result = api_instance.create_or_replace_tier0_group(tier_0_id, group_id, group)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->create_or_replace_tier0_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **group_id** | **String**|  | 
 **group** | [**Group**](Group.md)|  | 

### Return type

[**Group**](Group.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_gateway_policy**
> delete_gateway_policy(domain_id, gateway_policy_id)

Delete GatewayPolicy

Delete GatewayPolicy

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 


begin
  #Delete GatewayPolicy
  api_instance.delete_gateway_policy(domain_id, gateway_policy_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->delete_gateway_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_gateway_rule**
> delete_gateway_rule(domain_id, gateway_policy_id, rule_id)

Delete rule

Delete rule

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 


begin
  #Delete rule
  api_instance.delete_gateway_rule(domain_id, gateway_policy_id, rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->delete_gateway_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier0_group**
> delete_tier0_group(tier_0_id, group_id)

Deletes Group under Tier-0

Delete the Group under Tier-0. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 

group_id = 'group_id_example' # String | 


begin
  #Deletes Group under Tier-0
  api_instance.delete_tier0_group(tier_0_id, group_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->delete_tier0_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **group_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_gateway_rules**
> RuleListResult list_gateway_rules(domain_id, gateway_policy_id, opts)

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

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
  result = api_instance.list_gateway_rules(domain_id, gateway_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->list_gateway_rules: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RuleListResult**](RuleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier0_group**
> GroupListResult list_tier0_group(tier_0_id, opts)

List Groups for Tier-0

Paginated list of all Groups for Tier-0. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Groups for Tier-0
  result = api_instance.list_tier0_group(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->list_tier0_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GroupListResult**](GroupListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_gateway_policy_for_domain**
> patch_gateway_policy_for_domain(domain_id, gateway_policy_id, gateway_policy)

Update gateway policy

Update the gateway policy for a domain. This is a full replace. All the rules are replaced. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

gateway_policy = SwaggerClient::GatewayPolicy.new # GatewayPolicy | 


begin
  #Update gateway policy
  api_instance.patch_gateway_policy_for_domain(domain_id, gateway_policy_id, gateway_policy)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->patch_gateway_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **gateway_policy** | [**GatewayPolicy**](GatewayPolicy.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_gateway_rule**
> patch_gateway_rule(domain_id, gateway_policy_id, rule_id, rule)

Update gateway rule

Update the gateway rule. Create new rule if a rule with the rule-id is not already present. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

rule = SwaggerClient::Rule.new # Rule | 


begin
  #Update gateway rule
  api_instance.patch_gateway_rule(domain_id, gateway_policy_id, rule_id, rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->patch_gateway_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **rule** | [**Rule**](Rule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier0_group**
> patch_tier0_group(tier_0_id, group_id, group)

Create or update Group under specified Tier-0

If a Group with the group-id is not already present, create a new Group under the tier-0-id. Update if exists. The API valiates that Tier-0 is present before creating the Group. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 

group_id = 'group_id_example' # String | 

group = SwaggerClient::Group.new # Group | 


begin
  #Create or update Group under specified Tier-0
  api_instance.patch_tier0_group(tier_0_id, group_id, group)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->patch_tier0_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **group_id** | **String**|  | 
 **group** | [**Group**](Group.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_gateway_policy_for_domain**
> GatewayPolicy read_gateway_policy_for_domain(domain_id, gateway_policy_id)

Read gateway policy

Read gateway policy for a domain. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 


begin
  #Read gateway policy
  result = api_instance.read_gateway_policy_for_domain(domain_id, gateway_policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->read_gateway_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 

### Return type

[**GatewayPolicy**](GatewayPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_gateway_rule**
> Rule read_gateway_rule(domain_id, gateway_policy_id, rule_id)

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 


begin
  #Read rule
  result = api_instance.read_gateway_rule(domain_id, gateway_policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->read_gateway_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 

### Return type

[**Rule**](Rule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier0_group**
> Group read_tier0_group(tier_0_id, group_id)

Read Tier-0 Group

Read Tier-0 Group

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 

group_id = 'group_id_example' # String | 


begin
  #Read Tier-0 Group
  result = api_instance.read_tier0_group(tier_0_id, group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->read_tier0_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **group_id** | **String**|  | 

### Return type

[**Group**](Group.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **view_tier0_gateway_firewall**
> GatewayPolicyListResult view_tier0_gateway_firewall(tier_0_id)

Get list of gateway policies with rules that belong to the specific Tier-0 logical router. 

Get filtered view of gateway rules associated with the Tier-0. The gateay policies are returned in the order of category and precedence. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 


begin
  #Get list of gateway policies with rules that belong to the specific Tier-0 logical router. 
  result = api_instance.view_tier0_gateway_firewall(tier_0_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->view_tier0_gateway_firewall: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 

### Return type

[**GatewayPolicyListResult**](GatewayPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **view_tier0_locale_services_gateway_firewall**
> GatewayPolicyListResult view_tier0_locale_services_gateway_firewall(tier_0_id, locale_services_id)

Get list of gateway policies with rules that belong to the specific Tier-0 LocalServices. 

Get filtered view of Gateway Firewall rules associated with the Tier-0 Locale Services. The gateway policies are returned in the order of category and sequence number. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 


begin
  #Get list of gateway policies with rules that belong to the specific Tier-0 LocalServices. 
  result = api_instance.view_tier0_locale_services_gateway_firewall(tier_0_id, locale_services_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->view_tier0_locale_services_gateway_firewall: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_services_id** | **String**|  | 

### Return type

[**GatewayPolicyListResult**](GatewayPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **view_tier1_gateway_firewall**
> GatewayPolicyListResult view_tier1_gateway_firewall(tier_1_id)

Get list of gateway policies with rules that belong to the specific Tier-1. 

Get filtered view of Gateway Firewall rules associated with the Tier-1. The gateway policies are returned in the order of category and sequence number. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_1_id = 'tier_1_id_example' # String | 


begin
  #Get list of gateway policies with rules that belong to the specific Tier-1. 
  result = api_instance.view_tier1_gateway_firewall(tier_1_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->view_tier1_gateway_firewall: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 

### Return type

[**GatewayPolicyListResult**](GatewayPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **view_tier1_locale_services_gateway_firewall**
> GatewayPolicyListResult view_tier1_locale_services_gateway_firewall(tier_1_id, locale_services_id)

Get list of gateway policies with rules that belong to the specific Tier-1 LocalServices. 

Get filtered view of Gateway Firewall rules associated with the Tier-1 Locale Services. The gateway policies are returned in the order of category and sequence number. 

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

api_instance = SwaggerClient::PolicyGatewayFirewallApi.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 


begin
  #Get list of gateway policies with rules that belong to the specific Tier-1 LocalServices. 
  result = api_instance.view_tier1_locale_services_gateway_firewall(tier_1_id, locale_services_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGatewayFirewallApi->view_tier1_locale_services_gateway_firewall: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 

### Return type

[**GatewayPolicyListResult**](GatewayPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



