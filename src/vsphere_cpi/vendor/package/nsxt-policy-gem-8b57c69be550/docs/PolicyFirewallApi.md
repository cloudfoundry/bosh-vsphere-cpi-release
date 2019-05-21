# SwaggerClient::PolicyFirewallApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_policy_firewall_session_timer_binding**](PolicyFirewallApi.md#delete_policy_firewall_session_timer_binding) | **DELETE** /infra/domains/{domain-id}/groups/{group-id}/firewall-session-timer-profile-binding-maps/{firewall-session-timer-profile-binding-map-id} | Delete Firewall Session Timer Profile Binding
[**delete_policy_firewall_session_timer_profile**](PolicyFirewallApi.md#delete_policy_firewall_session_timer_profile) | **DELETE** /infra/firewall-session-timer-profiles/{firewall-session-timer-profile-id} | Delete Firewall Session Timer Profile
[**get_policy_firewall_session_timer_binding**](PolicyFirewallApi.md#get_policy_firewall_session_timer_binding) | **GET** /infra/domains/{domain-id}/groups/{group-id}/firewall-session-timer-profile-binding-maps/{firewall-session-timer-profile-binding-map-id} | Get Firewall Session Timer Profile Binding Map
[**get_policy_firewall_session_timer_profile**](PolicyFirewallApi.md#get_policy_firewall_session_timer_profile) | **GET** /infra/firewall-session-timer-profiles/{firewall-session-timer-profile-id} | Get Firewall Session Timer Profile
[**list_firewall_session_timer_bindings_across_domains**](PolicyFirewallApi.md#list_firewall_session_timer_bindings_across_domains) | **GET** /infra/domains/firewall-session-timer-profile-binding-maps | List Firewall Session Timer Profile Binding Maps for all domains
[**list_policy_firewall_session_timer_bindings**](PolicyFirewallApi.md#list_policy_firewall_session_timer_bindings) | **GET** /infra/domains/{domain-id}/groups/{group-id}/firewall-session-timer-profile-binding-maps | List Firewall Session Timer Profile Binding Maps
[**list_policy_firewall_session_timer_profiles**](PolicyFirewallApi.md#list_policy_firewall_session_timer_profiles) | **GET** /infra/firewall-session-timer-profiles | List Firewall Session Timer Profiles
[**patch_policy_firewall_session_timer_profile**](PolicyFirewallApi.md#patch_policy_firewall_session_timer_profile) | **PATCH** /infra/firewall-session-timer-profiles/{firewall-session-timer-profile-id} | Create or update Firewall Session Timer Profile
[**patch_policy_firewall_session_timer_profile_binding_map**](PolicyFirewallApi.md#patch_policy_firewall_session_timer_profile_binding_map) | **PATCH** /infra/domains/{domain-id}/groups/{group-id}/firewall-session-timer-profile-binding-maps/{firewall-session-timer-profile-binding-map-id} | Create or update Firewall Session Timer Profile Binding Map
[**update_policy_firewall_session_timer_binding**](PolicyFirewallApi.md#update_policy_firewall_session_timer_binding) | **PUT** /infra/domains/{domain-id}/groups/{group-id}/firewall-session-timer-profile-binding-maps/{firewall-session-timer-profile-binding-map-id} | Update Firewall Session Timer Profile Binding Map
[**update_policy_firewall_session_timer_profile**](PolicyFirewallApi.md#update_policy_firewall_session_timer_profile) | **PUT** /infra/firewall-session-timer-profiles/{firewall-session-timer-profile-id} | Update Firewall Session Timer Profile


# **delete_policy_firewall_session_timer_binding**
> delete_policy_firewall_session_timer_binding(domain_id, group_id, firewall_session_timer_profile_binding_map_id)

Delete Firewall Session Timer Profile Binding

API will delete Firewall Session Timer Profile Binding

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

api_instance = SwaggerClient::PolicyFirewallApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

firewall_session_timer_profile_binding_map_id = 'firewall_session_timer_profile_binding_map_id_example' # String | Firewall Session Timer Profile Binding Map ID


begin
  #Delete Firewall Session Timer Profile Binding
  api_instance.delete_policy_firewall_session_timer_binding(domain_id, group_id, firewall_session_timer_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->delete_policy_firewall_session_timer_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **firewall_session_timer_profile_binding_map_id** | **String**| Firewall Session Timer Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_firewall_session_timer_profile**
> delete_policy_firewall_session_timer_profile(firewall_session_timer_profile_id)

Delete Firewall Session Timer Profile

API will delete Firewall Session Timer Profile

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

api_instance = SwaggerClient::PolicyFirewallApi.new

firewall_session_timer_profile_id = 'firewall_session_timer_profile_id_example' # String | Firewall Session Timer Profile ID


begin
  #Delete Firewall Session Timer Profile
  api_instance.delete_policy_firewall_session_timer_profile(firewall_session_timer_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->delete_policy_firewall_session_timer_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firewall_session_timer_profile_id** | **String**| Firewall Session Timer Profile ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_firewall_session_timer_binding**
> PolicyFirewallSessionTimerProfileBindingMap get_policy_firewall_session_timer_binding(domain_id, group_id, firewall_session_timer_profile_binding_map_id)

Get Firewall Session Timer Profile Binding Map

API will get Firewall Session Timer Profile Binding Map 

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

api_instance = SwaggerClient::PolicyFirewallApi.new

domain_id = 'domain_id_example' # String | Domain-ID

group_id = 'group_id_example' # String | Group ID

firewall_session_timer_profile_binding_map_id = 'firewall_session_timer_profile_binding_map_id_example' # String | Firewall Session Timer Profile Binding Map ID


begin
  #Get Firewall Session Timer Profile Binding Map
  result = api_instance.get_policy_firewall_session_timer_binding(domain_id, group_id, firewall_session_timer_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->get_policy_firewall_session_timer_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain-ID | 
 **group_id** | **String**| Group ID | 
 **firewall_session_timer_profile_binding_map_id** | **String**| Firewall Session Timer Profile Binding Map ID | 

### Return type

[**PolicyFirewallSessionTimerProfileBindingMap**](PolicyFirewallSessionTimerProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_firewall_session_timer_profile**
> PolicyFirewallSessionTimerProfile get_policy_firewall_session_timer_profile(firewall_session_timer_profile_id)

Get Firewall Session Timer Profile

API will get Firewall Session Timer Profile

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

api_instance = SwaggerClient::PolicyFirewallApi.new

firewall_session_timer_profile_id = 'firewall_session_timer_profile_id_example' # String | Firewall Session Timer Profile ID


begin
  #Get Firewall Session Timer Profile
  result = api_instance.get_policy_firewall_session_timer_profile(firewall_session_timer_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->get_policy_firewall_session_timer_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firewall_session_timer_profile_id** | **String**| Firewall Session Timer Profile ID | 

### Return type

[**PolicyFirewallSessionTimerProfile**](PolicyFirewallSessionTimerProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_firewall_session_timer_bindings_across_domains**
> PolicyFirewallSessionTimerProfileBindingMapListResult list_firewall_session_timer_bindings_across_domains(opts)

List Firewall Session Timer Profile Binding Maps for all domains

API will list all Firewall Session Timer Profile Binding Maps across all domains. This API returns the binding maps order by the sequence number. 

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

api_instance = SwaggerClient::PolicyFirewallApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Firewall Session Timer Profile Binding Maps for all domains
  result = api_instance.list_firewall_session_timer_bindings_across_domains(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->list_firewall_session_timer_bindings_across_domains: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyFirewallSessionTimerProfileBindingMapListResult**](PolicyFirewallSessionTimerProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_firewall_session_timer_bindings**
> PolicyFirewallSessionTimerProfileBindingMapListResult list_policy_firewall_session_timer_bindings(domain_id, group_id, opts)

List Firewall Session Timer Profile Binding Maps

API will list all Firewall Session Timer Profile Binding Maps in current group id. 

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

api_instance = SwaggerClient::PolicyFirewallApi.new

domain_id = 'domain_id_example' # String | 

group_id = 'group_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Firewall Session Timer Profile Binding Maps
  result = api_instance.list_policy_firewall_session_timer_bindings(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->list_policy_firewall_session_timer_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **group_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyFirewallSessionTimerProfileBindingMapListResult**](PolicyFirewallSessionTimerProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_firewall_session_timer_profiles**
> PolicyFirewallSessionTimerProfileListResult list_policy_firewall_session_timer_profiles(opts)

List Firewall Session Timer Profiles

API will list all Firewall Session Timer Profiles

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

api_instance = SwaggerClient::PolicyFirewallApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Firewall Session Timer Profiles
  result = api_instance.list_policy_firewall_session_timer_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->list_policy_firewall_session_timer_profiles: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyFirewallSessionTimerProfileListResult**](PolicyFirewallSessionTimerProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_firewall_session_timer_profile**
> patch_policy_firewall_session_timer_profile(firewall_session_timer_profile_id, policy_firewall_session_timer_profile)

Create or update Firewall Session Timer Profile

API will create/update Firewall Session Timer Profile

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

api_instance = SwaggerClient::PolicyFirewallApi.new

firewall_session_timer_profile_id = 'firewall_session_timer_profile_id_example' # String | Firewall Session Timer Profile ID

policy_firewall_session_timer_profile = SwaggerClient::PolicyFirewallSessionTimerProfile.new # PolicyFirewallSessionTimerProfile | 


begin
  #Create or update Firewall Session Timer Profile
  api_instance.patch_policy_firewall_session_timer_profile(firewall_session_timer_profile_id, policy_firewall_session_timer_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->patch_policy_firewall_session_timer_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firewall_session_timer_profile_id** | **String**| Firewall Session Timer Profile ID | 
 **policy_firewall_session_timer_profile** | [**PolicyFirewallSessionTimerProfile**](PolicyFirewallSessionTimerProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_firewall_session_timer_profile_binding_map**
> patch_policy_firewall_session_timer_profile_binding_map(domain_id, group_id, firewall_session_timer_profile_binding_map_id, policy_firewall_session_timer_profile_binding_map)

Create or update Firewall Session Timer Profile Binding Map

API will create or update Firewall Session Timer profile binding map

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

api_instance = SwaggerClient::PolicyFirewallApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

firewall_session_timer_profile_binding_map_id = 'firewall_session_timer_profile_binding_map_id_example' # String | Firewall Session Timer Profile Binding Map ID

policy_firewall_session_timer_profile_binding_map = SwaggerClient::PolicyFirewallSessionTimerProfileBindingMap.new # PolicyFirewallSessionTimerProfileBindingMap | 


begin
  #Create or update Firewall Session Timer Profile Binding Map
  api_instance.patch_policy_firewall_session_timer_profile_binding_map(domain_id, group_id, firewall_session_timer_profile_binding_map_id, policy_firewall_session_timer_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->patch_policy_firewall_session_timer_profile_binding_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **firewall_session_timer_profile_binding_map_id** | **String**| Firewall Session Timer Profile Binding Map ID | 
 **policy_firewall_session_timer_profile_binding_map** | [**PolicyFirewallSessionTimerProfileBindingMap**](PolicyFirewallSessionTimerProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_policy_firewall_session_timer_binding**
> PolicyFirewallSessionTimerProfileBindingMap update_policy_firewall_session_timer_binding(domain_id, group_id, firewall_session_timer_profile_binding_map_id, policy_firewall_session_timer_profile_binding_map)

Update Firewall Session Timer Profile Binding Map

API will update Firewall Session Timer Profile Binding Map

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

api_instance = SwaggerClient::PolicyFirewallApi.new

domain_id = 'domain_id_example' # String | DomainID

group_id = 'group_id_example' # String | Group ID

firewall_session_timer_profile_binding_map_id = 'firewall_session_timer_profile_binding_map_id_example' # String | Firewall Session Timer Profile Binding Map ID

policy_firewall_session_timer_profile_binding_map = SwaggerClient::PolicyFirewallSessionTimerProfileBindingMap.new # PolicyFirewallSessionTimerProfileBindingMap | 


begin
  #Update Firewall Session Timer Profile Binding Map
  result = api_instance.update_policy_firewall_session_timer_binding(domain_id, group_id, firewall_session_timer_profile_binding_map_id, policy_firewall_session_timer_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->update_policy_firewall_session_timer_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| DomainID | 
 **group_id** | **String**| Group ID | 
 **firewall_session_timer_profile_binding_map_id** | **String**| Firewall Session Timer Profile Binding Map ID | 
 **policy_firewall_session_timer_profile_binding_map** | [**PolicyFirewallSessionTimerProfileBindingMap**](PolicyFirewallSessionTimerProfileBindingMap.md)|  | 

### Return type

[**PolicyFirewallSessionTimerProfileBindingMap**](PolicyFirewallSessionTimerProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_policy_firewall_session_timer_profile**
> PolicyFirewallSessionTimerProfile update_policy_firewall_session_timer_profile(firewall_session_timer_profile_id, policy_firewall_session_timer_profile)

Update Firewall Session Timer Profile

API will update Firewall Session Timer Profile

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

api_instance = SwaggerClient::PolicyFirewallApi.new

firewall_session_timer_profile_id = 'firewall_session_timer_profile_id_example' # String | Firewall Session Timer Profile ID

policy_firewall_session_timer_profile = SwaggerClient::PolicyFirewallSessionTimerProfile.new # PolicyFirewallSessionTimerProfile | 


begin
  #Update Firewall Session Timer Profile
  result = api_instance.update_policy_firewall_session_timer_profile(firewall_session_timer_profile_id, policy_firewall_session_timer_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyFirewallApi->update_policy_firewall_session_timer_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **firewall_session_timer_profile_id** | **String**| Firewall Session Timer Profile ID | 
 **policy_firewall_session_timer_profile** | [**PolicyFirewallSessionTimerProfile**](PolicyFirewallSessionTimerProfile.md)|  | 

### Return type

[**PolicyFirewallSessionTimerProfile**](PolicyFirewallSessionTimerProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



