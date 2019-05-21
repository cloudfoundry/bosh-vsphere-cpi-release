# SwaggerClient::PolicyIpfixl2Api

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_ipfixl2_collector_profile**](PolicyIpfixl2Api.md#create_or_replace_ipfixl2_collector_profile) | **PUT** /infra/ipfix-l2-collector-profiles/{ipfix-l2-collector-profile-id} | Create or Replace IPFIX collector profile
[**create_or_replace_ipfixl2_profile**](PolicyIpfixl2Api.md#create_or_replace_ipfixl2_profile) | **PUT** /infra/ipfix-l2-profiles/{ipfix-l2-profile-id} | Create or Replace IPFIX L2 profile
[**delete_ipfixl2_collector_profile**](PolicyIpfixl2Api.md#delete_ipfixl2_collector_profile) | **DELETE** /infra/ipfix-l2-collector-profiles/{ipfix-l2-collector-profile-id} | Delete IPFIX Collector profile
[**delete_ipfixl2_profile**](PolicyIpfixl2Api.md#delete_ipfixl2_profile) | **DELETE** /infra/ipfix-l2-profiles/{ipfix-l2-profile-id} | Delete IPFIX L2 Profile
[**list_ipfixl2_collector_profiles**](PolicyIpfixl2Api.md#list_ipfixl2_collector_profiles) | **GET** /infra/ipfix-l2-collector-profiles | List IPFIX Collector profiles.
[**list_ipfixl2_profiles**](PolicyIpfixl2Api.md#list_ipfixl2_profiles) | **GET** /infra/ipfix-l2-profiles | List IPFIX L2 Profiles
[**patch_ipfixl2_collector_profile**](PolicyIpfixl2Api.md#patch_ipfixl2_collector_profile) | **PATCH** /infra/ipfix-l2-collector-profiles/{ipfix-l2-collector-profile-id} | Patch IPFIX collector profile
[**patch_ipfixl2_profile**](PolicyIpfixl2Api.md#patch_ipfixl2_profile) | **PATCH** /infra/ipfix-l2-profiles/{ipfix-l2-profile-id} | Patch IPFIX L2profile
[**read_ipfixl2_collector_profile**](PolicyIpfixl2Api.md#read_ipfixl2_collector_profile) | **GET** /infra/ipfix-l2-collector-profiles/{ipfix-l2-collector-profile-id} | Get IPFIX Collector profile
[**read_ipfixl2_profile**](PolicyIpfixl2Api.md#read_ipfixl2_profile) | **GET** /infra/ipfix-l2-profiles/{ipfix-l2-profile-id} | Get IPFIX L2 Profile


# **create_or_replace_ipfixl2_collector_profile**
> IPFIXL2CollectorProfile create_or_replace_ipfixl2_collector_profile(ipfix_l2_collector_profile_id, ipfixl2_collector_profile)

Create or Replace IPFIX collector profile

Create or Replace IPFIX collector profile. IPFIX data will be sent to IPFIX collector. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_collector_profile_id = 'ipfix_l2_collector_profile_id_example' # String | IPFIX collector profile id

ipfixl2_collector_profile = SwaggerClient::IPFIXL2CollectorProfile.new # IPFIXL2CollectorProfile | 


begin
  #Create or Replace IPFIX collector profile
  result = api_instance.create_or_replace_ipfixl2_collector_profile(ipfix_l2_collector_profile_id, ipfixl2_collector_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->create_or_replace_ipfixl2_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_collector_profile_id** | **String**| IPFIX collector profile id | 
 **ipfixl2_collector_profile** | [**IPFIXL2CollectorProfile**](IPFIXL2CollectorProfile.md)|  | 

### Return type

[**IPFIXL2CollectorProfile**](IPFIXL2CollectorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ipfixl2_profile**
> IPFIXL2Profile create_or_replace_ipfixl2_profile(ipfix_l2_profile_id, ipfixl2_profile)

Create or Replace IPFIX L2 profile

Create or replace IPFIX L2 Profile. Profile is reusable entity. Single profile can attached multiple bindings e.g group, segment and port. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_profile_id = 'ipfix_l2_profile_id_example' # String | IPFIX L2 Profile ID

ipfixl2_profile = SwaggerClient::IPFIXL2Profile.new # IPFIXL2Profile | 


begin
  #Create or Replace IPFIX L2 profile
  result = api_instance.create_or_replace_ipfixl2_profile(ipfix_l2_profile_id, ipfixl2_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->create_or_replace_ipfixl2_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_profile_id** | **String**| IPFIX L2 Profile ID | 
 **ipfixl2_profile** | [**IPFIXL2Profile**](IPFIXL2Profile.md)|  | 

### Return type

[**IPFIXL2Profile**](IPFIXL2Profile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ipfixl2_collector_profile**
> delete_ipfixl2_collector_profile(ipfix_l2_collector_profile_id)

Delete IPFIX Collector profile

API deletes IPFIX collector profile. Flow forwarding to collector will be stopped. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_collector_profile_id = 'ipfix_l2_collector_profile_id_example' # String | IPFIX collector Profile id


begin
  #Delete IPFIX Collector profile
  api_instance.delete_ipfixl2_collector_profile(ipfix_l2_collector_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->delete_ipfixl2_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_collector_profile_id** | **String**| IPFIX collector Profile id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ipfixl2_profile**
> delete_ipfixl2_profile(ipfix_l2_profile_id)

Delete IPFIX L2 Profile

API deletes IPFIX L2 Profile. Flow forwarding to selected collector will be stopped. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_profile_id = 'ipfix_l2_profile_id_example' # String | IPFIX L2 Profile ID


begin
  #Delete IPFIX L2 Profile
  api_instance.delete_ipfixl2_profile(ipfix_l2_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->delete_ipfixl2_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_profile_id** | **String**| IPFIX L2 Profile ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ipfixl2_collector_profiles**
> IPFIXL2CollectorProfileListResult list_ipfixl2_collector_profiles(opts)

List IPFIX Collector profiles.

API will provide list of all IPFIX collector profiles and their details. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IPFIX Collector profiles.
  result = api_instance.list_ipfixl2_collector_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->list_ipfixl2_collector_profiles: #{e}"
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

[**IPFIXL2CollectorProfileListResult**](IPFIXL2CollectorProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ipfixl2_profiles**
> IPFIXL2ProfileListResult list_ipfixl2_profiles(opts)

List IPFIX L2 Profiles

API provides list IPFIX L2 Profiles available on selected logical l2. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IPFIX L2 Profiles
  result = api_instance.list_ipfixl2_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->list_ipfixl2_profiles: #{e}"
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

[**IPFIXL2ProfileListResult**](IPFIXL2ProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_ipfixl2_collector_profile**
> patch_ipfixl2_collector_profile(ipfix_l2_collector_profile_id, ipfixl2_collector_profile)

Patch IPFIX collector profile

Create a new IPFIX collector profile if the IPFIX collector profile with given id does not already exist. If the IPFIX collector profile with the given id already exists, patch with the existing IPFIX collector profile. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_collector_profile_id = 'ipfix_l2_collector_profile_id_example' # String | IPFIX collector profile id

ipfixl2_collector_profile = SwaggerClient::IPFIXL2CollectorProfile.new # IPFIXL2CollectorProfile | 


begin
  #Patch IPFIX collector profile
  api_instance.patch_ipfixl2_collector_profile(ipfix_l2_collector_profile_id, ipfixl2_collector_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->patch_ipfixl2_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_collector_profile_id** | **String**| IPFIX collector profile id | 
 **ipfixl2_collector_profile** | [**IPFIXL2CollectorProfile**](IPFIXL2CollectorProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_ipfixl2_profile**
> patch_ipfixl2_profile(ipfix_l2_profile_id, ipfixl2_profile)

Patch IPFIX L2profile

Create a new IPFIX L2 profile if the IPFIX L2 profile with given id does not already exist. If the IPFIX L2 profile with the given id already exists, patch with the existing IPFIX L2 profile. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_profile_id = 'ipfix_l2_profile_id_example' # String | IPFIX L2 Profile ID

ipfixl2_profile = SwaggerClient::IPFIXL2Profile.new # IPFIXL2Profile | 


begin
  #Patch IPFIX L2profile
  api_instance.patch_ipfixl2_profile(ipfix_l2_profile_id, ipfixl2_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->patch_ipfixl2_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_profile_id** | **String**| IPFIX L2 Profile ID | 
 **ipfixl2_profile** | [**IPFIXL2Profile**](IPFIXL2Profile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ipfixl2_collector_profile**
> IPFIXL2CollectorProfile read_ipfixl2_collector_profile(ipfix_l2_collector_profile_id)

Get IPFIX Collector profile

API will return details of IPFIX collector profile. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_collector_profile_id = 'ipfix_l2_collector_profile_id_example' # String | IPFIX collector profile id


begin
  #Get IPFIX Collector profile
  result = api_instance.read_ipfixl2_collector_profile(ipfix_l2_collector_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->read_ipfixl2_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_collector_profile_id** | **String**| IPFIX collector profile id | 

### Return type

[**IPFIXL2CollectorProfile**](IPFIXL2CollectorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ipfixl2_profile**
> IPFIXL2Profile read_ipfixl2_profile(ipfix_l2_profile_id)

Get IPFIX L2 Profile

API will return details of IPFIX L2 profile. 

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

api_instance = SwaggerClient::PolicyIpfixl2Api.new

ipfix_l2_profile_id = 'ipfix_l2_profile_id_example' # String | IPFIX L2 profile id


begin
  #Get IPFIX L2 Profile
  result = api_instance.read_ipfixl2_profile(ipfix_l2_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixl2Api->read_ipfixl2_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_l2_profile_id** | **String**| IPFIX L2 profile id | 

### Return type

[**IPFIXL2Profile**](IPFIXL2Profile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



