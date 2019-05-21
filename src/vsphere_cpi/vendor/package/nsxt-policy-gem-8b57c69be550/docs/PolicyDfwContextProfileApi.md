# SwaggerClient::PolicyDfwContextProfileApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_policy_context_profile**](PolicyDfwContextProfileApi.md#delete_policy_context_profile) | **DELETE** /infra/context-profiles/{context-profile-id} | Delete Policy Context Profile
[**get_policy_context_profile**](PolicyDfwContextProfileApi.md#get_policy_context_profile) | **GET** /infra/context-profiles/{context-profile-id} | Get PolicyContextProfile
[**list_policy_context_profiles**](PolicyDfwContextProfileApi.md#list_policy_context_profiles) | **GET** /infra/context-profiles | Get PolicyContextProfiles
[**list_profile_supported_attributes**](PolicyDfwContextProfileApi.md#list_profile_supported_attributes) | **GET** /infra/context-profiles/attributes | List Policy Context Profile supported attributes and sub-attributes
[**patch_create_or_update_policy_context_profile**](PolicyDfwContextProfileApi.md#patch_create_or_update_policy_context_profile) | **PATCH** /infra/context-profiles/{context-profile-id} | Create PolicyContextProfile
[**put_create_or_update_policy_context_profile**](PolicyDfwContextProfileApi.md#put_create_or_update_policy_context_profile) | **PUT** /infra/context-profiles/{context-profile-id} | Create PolicyContextProfile


# **delete_policy_context_profile**
> delete_policy_context_profile(context_profile_id, opts)

Delete Policy Context Profile

Deletes the specified Policy Context Profile. If the Policy Context Profile is consumed in a firewall rule, it won't get deleted. 

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

api_instance = SwaggerClient::PolicyDfwContextProfileApi.new

context_profile_id = 'context_profile_id_example' # String | Policy Context Profile Id

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete Policy Context Profile
  api_instance.delete_policy_context_profile(context_profile_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwContextProfileApi->delete_policy_context_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **context_profile_id** | **String**| Policy Context Profile Id | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_context_profile**
> PolicyContextProfile get_policy_context_profile(context_profile_id)

Get PolicyContextProfile

Get a single PolicyContextProfile by id 

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

api_instance = SwaggerClient::PolicyDfwContextProfileApi.new

context_profile_id = 'context_profile_id_example' # String | 


begin
  #Get PolicyContextProfile
  result = api_instance.get_policy_context_profile(context_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwContextProfileApi->get_policy_context_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **context_profile_id** | **String**|  | 

### Return type

[**PolicyContextProfile**](PolicyContextProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_context_profiles**
> PolicyContextProfileListResult list_policy_context_profiles(opts)

Get PolicyContextProfiles

Get all PolicyContextProfiles 

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

api_instance = SwaggerClient::PolicyDfwContextProfileApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get PolicyContextProfiles
  result = api_instance.list_policy_context_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwContextProfileApi->list_policy_context_profiles: #{e}"
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

[**PolicyContextProfileListResult**](PolicyContextProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_profile_supported_attributes**
> PolicyContextProfileListResult list_profile_supported_attributes(opts)

List Policy Context Profile supported attributes and sub-attributes

Returns supported attribute and sub-attributes for specified attribute key with their supported values, if provided in query/request parameter, else will fetch all supported attributes and sub-attributes for all supported attribute keys. Alternatively, to get a list of supported attributes and sub-attributes fire the following REST API GET https://&lt;policy-mgr&gt;/policy/api/v1/infra/context-profiles/attributes 

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

api_instance = SwaggerClient::PolicyDfwContextProfileApi.new

opts = { 
  attribute_key: 'attribute_key_example', # String | Fetch attributes and sub-attributes for the given attribute key
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Policy Context Profile supported attributes and sub-attributes
  result = api_instance.list_profile_supported_attributes(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwContextProfileApi->list_profile_supported_attributes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **attribute_key** | **String**| Fetch attributes and sub-attributes for the given attribute key | [optional] 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyContextProfileListResult**](PolicyContextProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_create_or_update_policy_context_profile**
> patch_create_or_update_policy_context_profile(context_profile_id, policy_context_profile)

Create PolicyContextProfile

Creates/Updates a PolicyContextProfile, which encapsulates attribute and sub-attributes of network services. Rules for using attributes and sub-attributes in single PolicyContextProfile 1. One type of attribute can't have multiple occurrences. ( Eg. -    Attribute type APP_ID can be used only once per PolicyContextProfile.) 2. For specifying multiple values for an attribute, provide them in an array. 3. If sub-attribtes are mentioned for an attribute, then only single    value is allowed for that attribute. 4. To get a list of supported attributes and sub-attributes fire the following REST API    GET https://&lt;policy-mgr&gt;/policy/api/v1/infra/context-profiles/attributes 

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

api_instance = SwaggerClient::PolicyDfwContextProfileApi.new

context_profile_id = 'context_profile_id_example' # String | 

policy_context_profile = SwaggerClient::PolicyContextProfile.new # PolicyContextProfile | 


begin
  #Create PolicyContextProfile
  api_instance.patch_create_or_update_policy_context_profile(context_profile_id, policy_context_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwContextProfileApi->patch_create_or_update_policy_context_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **context_profile_id** | **String**|  | 
 **policy_context_profile** | [**PolicyContextProfile**](PolicyContextProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **put_create_or_update_policy_context_profile**
> PolicyContextProfile put_create_or_update_policy_context_profile(context_profile_id, policy_context_profile)

Create PolicyContextProfile

Creates/Updates a PolicyContextProfile, which encapsulates attribute and sub-attributes of network services. Rules for using attributes and sub-attributes in single PolicyContextProfile 1. One type of attribute can't have multiple occurrences. ( Eg. -    Attribute type APP_ID can be used only once per PolicyContextProfile.) 2. For specifying multiple values for an attribute, provide them in an array. 3. If sub-attribtes are mentioned for an attribute, then only single    value is allowed for that attribute. 4. To get a list of supported attributes and sub-attributes fire the following REST API    GET https://&lt;policy-mgr&gt;/policy/api/v1/infra/context-profiles/attributes 

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

api_instance = SwaggerClient::PolicyDfwContextProfileApi.new

context_profile_id = 'context_profile_id_example' # String | 

policy_context_profile = SwaggerClient::PolicyContextProfile.new # PolicyContextProfile | 


begin
  #Create PolicyContextProfile
  result = api_instance.put_create_or_update_policy_context_profile(context_profile_id, policy_context_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDfwContextProfileApi->put_create_or_update_policy_context_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **context_profile_id** | **String**|  | 
 **policy_context_profile** | [**PolicyContextProfile**](PolicyContextProfile.md)|  | 

### Return type

[**PolicyContextProfile**](PolicyContextProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



