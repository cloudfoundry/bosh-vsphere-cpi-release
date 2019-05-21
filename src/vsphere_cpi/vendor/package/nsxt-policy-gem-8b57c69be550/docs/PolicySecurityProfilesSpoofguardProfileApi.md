# SwaggerClient::PolicySecurityProfilesSpoofguardProfileApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_spoof_guard_profile**](PolicySecurityProfilesSpoofguardProfileApi.md#create_or_update_spoof_guard_profile) | **PUT** /infra/spoofguard-profiles/{spoofguard-profile-id} | Create or replace SpoofGuard profile
[**delete_spoof_guard_profile**](PolicySecurityProfilesSpoofguardProfileApi.md#delete_spoof_guard_profile) | **DELETE** /infra/spoofguard-profiles/{spoofguard-profile-id} | Delete SpoofGuard profile
[**get_spoof_guard_profile**](PolicySecurityProfilesSpoofguardProfileApi.md#get_spoof_guard_profile) | **GET** /infra/spoofguard-profiles/{spoofguard-profile-id} | Get SpoofGuard profile
[**list_spoof_guard_profiles**](PolicySecurityProfilesSpoofguardProfileApi.md#list_spoof_guard_profiles) | **GET** /infra/spoofguard-profiles | List SpoofGuard profiles
[**patch_spoof_guard_profile**](PolicySecurityProfilesSpoofguardProfileApi.md#patch_spoof_guard_profile) | **PATCH** /infra/spoofguard-profiles/{spoofguard-profile-id} | Patch SpoofGuard profile


# **create_or_update_spoof_guard_profile**
> SpoofGuardProfile create_or_update_spoof_guard_profile(spoofguard_profile_id, spoof_guard_profile)

Create or replace SpoofGuard profile

API will create or replace SpoofGuard profile. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSpoofguardProfileApi.new

spoofguard_profile_id = 'spoofguard_profile_id_example' # String | SpoofGuard profile id

spoof_guard_profile = SwaggerClient::SpoofGuardProfile.new # SpoofGuardProfile | 


begin
  #Create or replace SpoofGuard profile
  result = api_instance.create_or_update_spoof_guard_profile(spoofguard_profile_id, spoof_guard_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSpoofguardProfileApi->create_or_update_spoof_guard_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spoofguard_profile_id** | **String**| SpoofGuard profile id | 
 **spoof_guard_profile** | [**SpoofGuardProfile**](SpoofGuardProfile.md)|  | 

### Return type

[**SpoofGuardProfile**](SpoofGuardProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_spoof_guard_profile**
> delete_spoof_guard_profile(spoofguard_profile_id)

Delete SpoofGuard profile

API will delete SpoofGuard profile with the given id. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSpoofguardProfileApi.new

spoofguard_profile_id = 'spoofguard_profile_id_example' # String | SpoofGuard profile id


begin
  #Delete SpoofGuard profile
  api_instance.delete_spoof_guard_profile(spoofguard_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSpoofguardProfileApi->delete_spoof_guard_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spoofguard_profile_id** | **String**| SpoofGuard profile id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_spoof_guard_profile**
> SpoofGuardProfile get_spoof_guard_profile(spoofguard_profile_id)

Get SpoofGuard profile

API will return details of the SpoofGuard profile with given id. If the profile does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSpoofguardProfileApi.new

spoofguard_profile_id = 'spoofguard_profile_id_example' # String | SpoofGuard profile id


begin
  #Get SpoofGuard profile
  result = api_instance.get_spoof_guard_profile(spoofguard_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSpoofguardProfileApi->get_spoof_guard_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spoofguard_profile_id** | **String**| SpoofGuard profile id | 

### Return type

[**SpoofGuardProfile**](SpoofGuardProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_spoof_guard_profiles**
> SpoofGuardProfileListResult list_spoof_guard_profiles(opts)

List SpoofGuard profiles

API will list all SpoofGuard profiles. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSpoofguardProfileApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List SpoofGuard profiles
  result = api_instance.list_spoof_guard_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSpoofguardProfileApi->list_spoof_guard_profiles: #{e}"
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

[**SpoofGuardProfileListResult**](SpoofGuardProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_spoof_guard_profile**
> patch_spoof_guard_profile(spoofguard_profile_id, spoof_guard_profile)

Patch SpoofGuard profile

Create a new SpoofGuard profile if the SpoofGuard profile with the given id does not exist. Otherwise, patch with the existing SpoofGuard profile. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSpoofguardProfileApi.new

spoofguard_profile_id = 'spoofguard_profile_id_example' # String | SpoofGuard profile id

spoof_guard_profile = SwaggerClient::SpoofGuardProfile.new # SpoofGuardProfile | 


begin
  #Patch SpoofGuard profile
  api_instance.patch_spoof_guard_profile(spoofguard_profile_id, spoof_guard_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSpoofguardProfileApi->patch_spoof_guard_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **spoofguard_profile_id** | **String**| SpoofGuard profile id | 
 **spoof_guard_profile** | [**SpoofGuardProfile**](SpoofGuardProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



