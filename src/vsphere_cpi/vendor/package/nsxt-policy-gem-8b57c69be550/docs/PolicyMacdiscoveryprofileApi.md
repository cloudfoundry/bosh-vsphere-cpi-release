# SwaggerClient::PolicyMacdiscoveryprofileApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_mac_discovery_profile**](PolicyMacdiscoveryprofileApi.md#create_mac_discovery_profile) | **PATCH** /infra/mac-discovery-profiles/{mac-discovery-profile-id} | Create Mac Discovery Profile
[**delete_mac_discovery_profile**](PolicyMacdiscoveryprofileApi.md#delete_mac_discovery_profile) | **DELETE** /infra/mac-discovery-profiles/{mac-discovery-profile-id} | Delete Mac Discovery Profile
[**get_mac_discovery_profile**](PolicyMacdiscoveryprofileApi.md#get_mac_discovery_profile) | **GET** /infra/mac-discovery-profiles/{mac-discovery-profile-id} | Get Mac Discovery Profile
[**get_mac_discovery_profiles**](PolicyMacdiscoveryprofileApi.md#get_mac_discovery_profiles) | **GET** /infra/mac-discovery-profiles | List Mac Discovery Profiles
[**update_mac_discovery_profile**](PolicyMacdiscoveryprofileApi.md#update_mac_discovery_profile) | **PUT** /infra/mac-discovery-profiles/{mac-discovery-profile-id} | Update Mac Discovery Profile


# **create_mac_discovery_profile**
> create_mac_discovery_profile(mac_discovery_profile_id, mac_discovery_profile)

Create Mac Discovery Profile

API will create Mac Discovery profile. 

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

api_instance = SwaggerClient::PolicyMacdiscoveryprofileApi.new

mac_discovery_profile_id = 'mac_discovery_profile_id_example' # String | Mac Discovery Profile ID

mac_discovery_profile = SwaggerClient::MacDiscoveryProfile.new # MacDiscoveryProfile | 


begin
  #Create Mac Discovery Profile
  api_instance.create_mac_discovery_profile(mac_discovery_profile_id, mac_discovery_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMacdiscoveryprofileApi->create_mac_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mac_discovery_profile_id** | **String**| Mac Discovery Profile ID | 
 **mac_discovery_profile** | [**MacDiscoveryProfile**](MacDiscoveryProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_mac_discovery_profile**
> delete_mac_discovery_profile(mac_discovery_profile_id)

Delete Mac Discovery Profile

API will delete Mac Discovery profile. 

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

api_instance = SwaggerClient::PolicyMacdiscoveryprofileApi.new

mac_discovery_profile_id = 'mac_discovery_profile_id_example' # String | Mac Discovery Profile ID


begin
  #Delete Mac Discovery Profile
  api_instance.delete_mac_discovery_profile(mac_discovery_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMacdiscoveryprofileApi->delete_mac_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mac_discovery_profile_id** | **String**| Mac Discovery Profile ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_mac_discovery_profile**
> MacDiscoveryProfile get_mac_discovery_profile(mac_discovery_profile_id)

Get Mac Discovery Profile

API will get Mac Discovery profile. 

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

api_instance = SwaggerClient::PolicyMacdiscoveryprofileApi.new

mac_discovery_profile_id = 'mac_discovery_profile_id_example' # String | Mac Discovery Profile ID


begin
  #Get Mac Discovery Profile
  result = api_instance.get_mac_discovery_profile(mac_discovery_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMacdiscoveryprofileApi->get_mac_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mac_discovery_profile_id** | **String**| Mac Discovery Profile ID | 

### Return type

[**MacDiscoveryProfile**](MacDiscoveryProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_mac_discovery_profiles**
> MacDiscoveryProfileListResult get_mac_discovery_profiles(opts)

List Mac Discovery Profiles

API will list all Mac Discovery Profiles active in current discovery profile id. 

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

api_instance = SwaggerClient::PolicyMacdiscoveryprofileApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Mac Discovery Profiles
  result = api_instance.get_mac_discovery_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMacdiscoveryprofileApi->get_mac_discovery_profiles: #{e}"
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

[**MacDiscoveryProfileListResult**](MacDiscoveryProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_mac_discovery_profile**
> MacDiscoveryProfile update_mac_discovery_profile(mac_discovery_profile_id, mac_discovery_profile)

Update Mac Discovery Profile

API will update Mac Discovery profile. 

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

api_instance = SwaggerClient::PolicyMacdiscoveryprofileApi.new

mac_discovery_profile_id = 'mac_discovery_profile_id_example' # String | Mac Discovery Profile ID

mac_discovery_profile = SwaggerClient::MacDiscoveryProfile.new # MacDiscoveryProfile | 


begin
  #Update Mac Discovery Profile
  result = api_instance.update_mac_discovery_profile(mac_discovery_profile_id, mac_discovery_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMacdiscoveryprofileApi->update_mac_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mac_discovery_profile_id** | **String**| Mac Discovery Profile ID | 
 **mac_discovery_profile** | [**MacDiscoveryProfile**](MacDiscoveryProfile.md)|  | 

### Return type

[**MacDiscoveryProfile**](MacDiscoveryProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



