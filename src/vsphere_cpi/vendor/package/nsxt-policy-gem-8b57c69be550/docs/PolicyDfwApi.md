# SwaggerClient::PolicyDfwApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_communication_entry**](PolicyDfwApi.md#delete_communication_entry) | **DELETE** /infra/domains/{domain-id}/communication-maps/{communication-map-id}/communication-entries/{communication-entry-id} | Delete CommunicationEntry
[**delete_communication_map_for_domain**](PolicyDfwApi.md#delete_communication_map_for_domain) | **DELETE** /infra/domains/{domain-id}/communication-maps/{communication-map-id} | Deletes a communication map from this domain
[**delete_security_policy_for_domain**](PolicyDfwApi.md#delete_security_policy_for_domain) | **DELETE** /infra/domains/{domain-id}/security-policies/{security-policy-id} | Deletes a security policy from this domain
[**delete_security_rule**](PolicyDfwApi.md#delete_security_rule) | **DELETE** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules/{rule-id} | Delete rule
[**list_communication_entry**](PolicyDfwApi.md#list_communication_entry) | **GET** /infra/domains/{domain-id}/communication-maps/{communication-map-id}/communication-entries | List CommunicationEntries
[**list_communication_maps_for_domain**](PolicyDfwApi.md#list_communication_maps_for_domain) | **GET** /infra/domains/{domain-id}/communication-maps | List communication maps
[**list_security_policies_for_domain**](PolicyDfwApi.md#list_security_policies_for_domain) | **GET** /infra/domains/{domain-id}/security-policies | List security policies
[**list_security_rules**](PolicyDfwApi.md#list_security_rules) | **GET** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules | List rules
[**patch_communication_entry**](PolicyDfwApi.md#patch_communication_entry) | **PATCH** /infra/domains/{domain-id}/communication-maps/{communication-map-id}/communication-entries/{communication-entry-id} | Patch a CommunicationEntry
[**patch_communication_map_for_domain**](PolicyDfwApi.md#patch_communication_map_for_domain) | **PATCH** /infra/domains/{domain-id}/communication-maps/{communication-map-id} | Patch communication map
[**patch_security_policy_for_domain**](PolicyDfwApi.md#patch_security_policy_for_domain) | **PATCH** /infra/domains/{domain-id}/security-policies/{security-policy-id} | Patch security policy
[**patch_security_rule**](PolicyDfwApi.md#patch_security_rule) | **PATCH** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules/{rule-id} | Patch a rule
[**read_communication_entry**](PolicyDfwApi.md#read_communication_entry) | **GET** /infra/domains/{domain-id}/communication-maps/{communication-map-id}/communication-entries/{communication-entry-id} | Read CommunicationEntry
[**read_communication_map_for_domain**](PolicyDfwApi.md#read_communication_map_for_domain) | **GET** /infra/domains/{domain-id}/communication-maps/{communication-map-id} | Read communication-map
[**read_security_policy_for_domain**](PolicyDfwApi.md#read_security_policy_for_domain) | **GET** /infra/domains/{domain-id}/security-policies/{security-policy-id} | Read security policy
[**read_security_rule**](PolicyDfwApi.md#read_security_rule) | **GET** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules/{rule-id} | Read rule
[**revise_communication_entry_revise**](PolicyDfwApi.md#revise_communication_entry_revise) | **POST** /infra/domains/{domain-id}/communication-maps/{communication-map-id}/communication-entries/{communication-entry-id}?action&#x3D;revise | Revise the positioning of communication entry
[**revise_communication_maps_revise**](PolicyDfwApi.md#revise_communication_maps_revise) | **POST** /infra/domains/{domain-id}/communication-maps/{communication-map-id}?action&#x3D;revise | Revise the positioning of communication maps
[**revise_security_policies_revise**](PolicyDfwApi.md#revise_security_policies_revise) | **POST** /infra/domains/{domain-id}/security-policies/{security-policy-id}?action&#x3D;revise | Revise the positioning of security policies
[**revise_security_rule_revise**](PolicyDfwApi.md#revise_security_rule_revise) | **POST** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules/{rule-id}?action&#x3D;revise | Revise the positioning of rule
[**update_communication_entry**](PolicyDfwApi.md#update_communication_entry) | **PUT** /infra/domains/{domain-id}/communication-maps/{communication-map-id}/communication-entries/{communication-entry-id} | Create or update a CommunicationEntry
[**update_communication_map_for_domain**](PolicyDfwApi.md#update_communication_map_for_domain) | **PUT** /infra/domains/{domain-id}/communication-maps/{communication-map-id} | Create or Update communication map
[**update_security_policy_for_domain**](PolicyDfwApi.md#update_security_policy_for_domain) | **PUT** /infra/domains/{domain-id}/security-policies/{security-policy-id} | Create or Update security policy
[**update_security_rule**](PolicyDfwApi.md#update_security_rule) | **PUT** /infra/domains/{domain-id}/security-policies/{security-policy-id}/rules/{rule-id} | Create or update a rule


# **delete_communication_entry**
> delete_communication_entry(domain_id, communication_map_id, communication_entry_id)

Delete CommunicationEntry

Delete CommunicationEntry This API is deprecated. Please use the following API instead. DELETE /infra/domains/domain-id/security-policies/security-policy-id/rules/rule-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_entry_id = 'communication_entry_id_example' # String | 


begin
  #Delete CommunicationEntry
  api_instance.delete_communication_entry(domain_id, communication_map_id, communication_entry_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->delete_communication_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_entry_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_communication_map_for_domain**
> delete_communication_map_for_domain(domain_id, communication_map_id)

Deletes a communication map from this domain

Deletes the communication map along with all the communication entries This API is deprecated. Please use the following API instead. DELETE /infra/domains/domain-id/security-policies/security-policy-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 


begin
  #Deletes a communication map from this domain
  api_instance.delete_communication_map_for_domain(domain_id, communication_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->delete_communication_map_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_security_policy_for_domain**
> delete_security_policy_for_domain(domain_id, security_policy_id)

Deletes a security policy from this domain

Deletes the security policy along with all the rules 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 


begin
  #Deletes a security policy from this domain
  api_instance.delete_security_policy_for_domain(domain_id, security_policy_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->delete_security_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_security_rule**
> delete_security_rule(domain_id, security_policy_id, rule_id)

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 


begin
  #Delete rule
  api_instance.delete_security_rule(domain_id, security_policy_id, rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->delete_security_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_communication_entry**
> CommunicationEntryListResult list_communication_entry(domain_id, communication_map_id, opts)

List CommunicationEntries

List CommunicationEntries This API is deprecated. Please use the following API instead. GET /infra/domains/domain-id/security-policies/security-policy-id/rules 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List CommunicationEntries
  result = api_instance.list_communication_entry(domain_id, communication_map_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->list_communication_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**CommunicationEntryListResult**](CommunicationEntryListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_communication_maps_for_domain**
> CommunicationMapListResult list_communication_maps_for_domain(domain_id, opts)

List communication maps

List all communication maps for a domain. This API is deprecated. Please use the following API instead. GET /infra/domains/domain-id/security-policies 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List communication maps
  result = api_instance.list_communication_maps_for_domain(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->list_communication_maps_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**CommunicationMapListResult**](CommunicationMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_security_policies_for_domain**
> SecurityPolicyListResult list_security_policies_for_domain(domain_id, opts)

List security policies

List all security policies for a domain. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List security policies
  result = api_instance.list_security_policies_for_domain(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->list_security_policies_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SecurityPolicyListResult**](SecurityPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_security_rules**
> RuleListResult list_security_rules(domain_id, security_policy_id, opts)

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

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
  result = api_instance.list_security_rules(domain_id, security_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->list_security_rules: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
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



# **patch_communication_entry**
> patch_communication_entry(domain_id, communication_map_id, communication_entry_id, communication_entry)

Patch a CommunicationEntry

Patch the CommunicationEntry. This API is deprecated. Please use the following API instead. PATCH /infra/domains/domain-id/security-policies/security-policy-id/rules/rule-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_entry_id = 'communication_entry_id_example' # String | 

communication_entry = SwaggerClient::CommunicationEntry.new # CommunicationEntry | 


begin
  #Patch a CommunicationEntry
  api_instance.patch_communication_entry(domain_id, communication_map_id, communication_entry_id, communication_entry)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->patch_communication_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_entry_id** | **String**|  | 
 **communication_entry** | [**CommunicationEntry**](CommunicationEntry.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_communication_map_for_domain**
> patch_communication_map_for_domain(domain_id, communication_map_id, communication_map)

Patch communication map

Patch the communication map for a domain. This API is deprecated. Please use the following API instead. PATCH /infra/domains/domain-id/security-policies/security-policy-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_map = SwaggerClient::CommunicationMap.new # CommunicationMap | 


begin
  #Patch communication map
  api_instance.patch_communication_map_for_domain(domain_id, communication_map_id, communication_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->patch_communication_map_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_map** | [**CommunicationMap**](CommunicationMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_security_policy_for_domain**
> patch_security_policy_for_domain(domain_id, security_policy_id, security_policy)

Patch security policy

Patch the security policy for a domain. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

security_policy = SwaggerClient::SecurityPolicy.new # SecurityPolicy | 


begin
  #Patch security policy
  api_instance.patch_security_policy_for_domain(domain_id, security_policy_id, security_policy)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->patch_security_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **security_policy** | [**SecurityPolicy**](SecurityPolicy.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_security_rule**
> patch_security_rule(domain_id, security_policy_id, rule_id, rule)

Patch a rule

Patch the rule. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

rule = SwaggerClient::Rule.new # Rule | 


begin
  #Patch a rule
  api_instance.patch_security_rule(domain_id, security_policy_id, rule_id, rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->patch_security_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **rule** | [**Rule**](Rule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_communication_entry**
> CommunicationEntry read_communication_entry(domain_id, communication_map_id, communication_entry_id)

Read CommunicationEntry

Read CommunicationEntry This API is deprecated. Please use the following API instead. GET /infra/domains/domain-id/security-policies/security-policy-id/rules/rule-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_entry_id = 'communication_entry_id_example' # String | 


begin
  #Read CommunicationEntry
  result = api_instance.read_communication_entry(domain_id, communication_map_id, communication_entry_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->read_communication_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_entry_id** | **String**|  | 

### Return type

[**CommunicationEntry**](CommunicationEntry.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_communication_map_for_domain**
> CommunicationMap read_communication_map_for_domain(domain_id, communication_map_id)

Read communication-map

Read communication-map for a domain. This API is deprecated. Please use the following API instead. GET /infra/domains/domain-id/security-policies/security-policy-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 


begin
  #Read communication-map
  result = api_instance.read_communication_map_for_domain(domain_id, communication_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->read_communication_map_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 

### Return type

[**CommunicationMap**](CommunicationMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_security_policy_for_domain**
> SecurityPolicy read_security_policy_for_domain(domain_id, security_policy_id)

Read security policy

Read security policy for a domain. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 


begin
  #Read security policy
  result = api_instance.read_security_policy_for_domain(domain_id, security_policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->read_security_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 

### Return type

[**SecurityPolicy**](SecurityPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_security_rule**
> Rule read_security_rule(domain_id, security_policy_id, rule_id)

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 


begin
  #Read rule
  result = api_instance.read_security_rule(domain_id, security_policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->read_security_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 

### Return type

[**Rule**](Rule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **revise_communication_entry_revise**
> CommunicationEntry revise_communication_entry_revise(domain_id, communication_map_id, communication_entry_id, communication_entry, opts)

Revise the positioning of communication entry

This is used to re-order a communictation entry within a communication map. This API is deprecated. Please use the following API instead. POST /infra/domains/domain-id/security-policies/security-policy-id/rules/rule-id?action=revise 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_entry_id = 'communication_entry_id_example' # String | 

communication_entry = SwaggerClient::CommunicationEntry.new # CommunicationEntry | 

opts = { 
  anchor_path: 'anchor_path_example', # String | The communication map/communication entry path if operation is 'insert_after' or 'insert_before' 
  operation: 'insert_top' # String | Operation
}

begin
  #Revise the positioning of communication entry
  result = api_instance.revise_communication_entry_revise(domain_id, communication_map_id, communication_entry_id, communication_entry, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->revise_communication_entry_revise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_entry_id** | **String**|  | 
 **communication_entry** | [**CommunicationEntry**](CommunicationEntry.md)|  | 
 **anchor_path** | **String**| The communication map/communication entry path if operation is &#39;insert_after&#39; or &#39;insert_before&#39;  | [optional] 
 **operation** | **String**| Operation | [optional] [default to insert_top]

### Return type

[**CommunicationEntry**](CommunicationEntry.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **revise_communication_maps_revise**
> CommunicationMap revise_communication_maps_revise(domain_id, communication_map_id, communication_map, opts)

Revise the positioning of communication maps

This is used to set a precedence of a communication map w.r.t others. This API is deprecated. Please use the following API instead. POST /infra/domains/domain-id/security-policies/security-policy-id?action=revise 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_map = SwaggerClient::CommunicationMap.new # CommunicationMap | 

opts = { 
  anchor_path: 'anchor_path_example', # String | The communication map/communication entry path if operation is 'insert_after' or 'insert_before' 
  operation: 'insert_top' # String | Operation
}

begin
  #Revise the positioning of communication maps
  result = api_instance.revise_communication_maps_revise(domain_id, communication_map_id, communication_map, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->revise_communication_maps_revise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_map** | [**CommunicationMap**](CommunicationMap.md)|  | 
 **anchor_path** | **String**| The communication map/communication entry path if operation is &#39;insert_after&#39; or &#39;insert_before&#39;  | [optional] 
 **operation** | **String**| Operation | [optional] [default to insert_top]

### Return type

[**CommunicationMap**](CommunicationMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **revise_security_policies_revise**
> SecurityPolicy revise_security_policies_revise(domain_id, security_policy_id, security_policy, opts)

Revise the positioning of security policies

This is used to set a precedence of a security policy w.r.t others. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

security_policy = SwaggerClient::SecurityPolicy.new # SecurityPolicy | 

opts = { 
  anchor_path: 'anchor_path_example', # String | The security policy/rule path if operation is 'insert_after' or 'insert_before' 
  operation: 'insert_top' # String | Operation
}

begin
  #Revise the positioning of security policies
  result = api_instance.revise_security_policies_revise(domain_id, security_policy_id, security_policy, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->revise_security_policies_revise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **security_policy** | [**SecurityPolicy**](SecurityPolicy.md)|  | 
 **anchor_path** | **String**| The security policy/rule path if operation is &#39;insert_after&#39; or &#39;insert_before&#39;  | [optional] 
 **operation** | **String**| Operation | [optional] [default to insert_top]

### Return type

[**SecurityPolicy**](SecurityPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **revise_security_rule_revise**
> Rule revise_security_rule_revise(domain_id, security_policy_id, rule_id, rule, opts)

Revise the positioning of rule

This is used to re-order a rule within a security policy. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

rule = SwaggerClient::Rule.new # Rule | 

opts = { 
  anchor_path: 'anchor_path_example', # String | The security policy/rule path if operation is 'insert_after' or 'insert_before' 
  operation: 'insert_top' # String | Operation
}

begin
  #Revise the positioning of rule
  result = api_instance.revise_security_rule_revise(domain_id, security_policy_id, rule_id, rule, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->revise_security_rule_revise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **rule** | [**Rule**](Rule.md)|  | 
 **anchor_path** | **String**| The security policy/rule path if operation is &#39;insert_after&#39; or &#39;insert_before&#39;  | [optional] 
 **operation** | **String**| Operation | [optional] [default to insert_top]

### Return type

[**Rule**](Rule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_communication_entry**
> CommunicationEntry update_communication_entry(domain_id, communication_map_id, communication_entry_id, communication_entry)

Create or update a CommunicationEntry

Update the CommunicationEntry. If a CommunicationEntry with the communication-entry-id is not already present, this API fails with a 404. Creation of CommunicationEntries is not allowed using this API. This API is deprecated. Please use the following API instead PUT /infra/domains/domain-id/security-policies/securit-policy-id/rules/rule-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_entry_id = 'communication_entry_id_example' # String | 

communication_entry = SwaggerClient::CommunicationEntry.new # CommunicationEntry | 


begin
  #Create or update a CommunicationEntry
  result = api_instance.update_communication_entry(domain_id, communication_map_id, communication_entry_id, communication_entry)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->update_communication_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_entry_id** | **String**|  | 
 **communication_entry** | [**CommunicationEntry**](CommunicationEntry.md)|  | 

### Return type

[**CommunicationEntry**](CommunicationEntry.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_communication_map_for_domain**
> CommunicationMap update_communication_map_for_domain(domain_id, communication_map_id, communication_map)

Create or Update communication map

Create or Update the communication map for a domain. This is a full replace. All the CommunicationEntries are replaced. This API is deprecated. Please use the following API instead. PUT /infra/domains/domain-id/security-policies/security-policy-id 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

communication_map_id = 'communication_map_id_example' # String | 

communication_map = SwaggerClient::CommunicationMap.new # CommunicationMap | 


begin
  #Create or Update communication map
  result = api_instance.update_communication_map_for_domain(domain_id, communication_map_id, communication_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->update_communication_map_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **communication_map_id** | **String**|  | 
 **communication_map** | [**CommunicationMap**](CommunicationMap.md)|  | 

### Return type

[**CommunicationMap**](CommunicationMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_security_policy_for_domain**
> SecurityPolicy update_security_policy_for_domain(domain_id, security_policy_id, security_policy)

Create or Update security policy

Create or Update the security policy for a domain. This is a full replace. All the rules are replaced. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

security_policy = SwaggerClient::SecurityPolicy.new # SecurityPolicy | 


begin
  #Create or Update security policy
  result = api_instance.update_security_policy_for_domain(domain_id, security_policy_id, security_policy)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->update_security_policy_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **security_policy** | [**SecurityPolicy**](SecurityPolicy.md)|  | 

### Return type

[**SecurityPolicy**](SecurityPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_security_rule**
> Rule update_security_rule(domain_id, security_policy_id, rule_id, rule)

Create or update a rule

Update the rule. Create new rule if a rule with the rule-id is not already present. 

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

api_instance = SwaggerClient::PolicyDfwApi.new

domain_id = 'domain_id_example' # String | 

security_policy_id = 'security_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

rule = SwaggerClient::Rule.new # Rule | 


begin
  #Create or update a rule
  result = api_instance.update_security_rule(domain_id, security_policy_id, rule_id, rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwApi->update_security_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **security_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **rule** | [**Rule**](Rule.md)|  | 

### Return type

[**Rule**](Rule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



