# SwaggerClient::PolicyIpdiscoveryprofileApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_ip_discovery_profile**](PolicyIpdiscoveryprofileApi.md#create_ip_discovery_profile) | **PATCH** /infra/ip-discovery-profiles/{ip-discovery-profile-id} | Create IP Discovery Profile
[**delete_ip_discovery_profile**](PolicyIpdiscoveryprofileApi.md#delete_ip_discovery_profile) | **DELETE** /infra/ip-discovery-profiles/{ip-discovery-profile-id} | Delete IP Discovery Profile
[**get_ip_discovery_profile**](PolicyIpdiscoveryprofileApi.md#get_ip_discovery_profile) | **GET** /infra/ip-discovery-profiles/{ip-discovery-profile-id} | Get IP Discovery Profile
[**get_ip_discovery_profiles**](PolicyIpdiscoveryprofileApi.md#get_ip_discovery_profiles) | **GET** /infra/ip-discovery-profiles | List IP Discovery Profiles
[**update_ip_discovery_profile**](PolicyIpdiscoveryprofileApi.md#update_ip_discovery_profile) | **PUT** /infra/ip-discovery-profiles/{ip-discovery-profile-id} | Update IP Discovery Profile


# **create_ip_discovery_profile**
> create_ip_discovery_profile(ip_discovery_profile_id, ip_discovery_profile)

Create IP Discovery Profile

API will create IP Discovery profile. 

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

api_instance = SwaggerClient::PolicyIpdiscoveryprofileApi.new

ip_discovery_profile_id = 'ip_discovery_profile_id_example' # String | IP Discovery Profile ID

ip_discovery_profile = SwaggerClient::IPDiscoveryProfile.new # IPDiscoveryProfile | 


begin
  #Create IP Discovery Profile
  api_instance.create_ip_discovery_profile(ip_discovery_profile_id, ip_discovery_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpdiscoveryprofileApi->create_ip_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_discovery_profile_id** | **String**| IP Discovery Profile ID | 
 **ip_discovery_profile** | [**IPDiscoveryProfile**](IPDiscoveryProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_discovery_profile**
> delete_ip_discovery_profile(ip_discovery_profile_id)

Delete IP Discovery Profile

API will delete IP Discovery profile. 

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

api_instance = SwaggerClient::PolicyIpdiscoveryprofileApi.new

ip_discovery_profile_id = 'ip_discovery_profile_id_example' # String | IP Discovery Profile ID


begin
  #Delete IP Discovery Profile
  api_instance.delete_ip_discovery_profile(ip_discovery_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpdiscoveryprofileApi->delete_ip_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_discovery_profile_id** | **String**| IP Discovery Profile ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_discovery_profile**
> IPDiscoveryProfile get_ip_discovery_profile(ip_discovery_profile_id)

Get IP Discovery Profile

API will get IP Discovery profile. 

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

api_instance = SwaggerClient::PolicyIpdiscoveryprofileApi.new

ip_discovery_profile_id = 'ip_discovery_profile_id_example' # String | IP Discovery Profile ID


begin
  #Get IP Discovery Profile
  result = api_instance.get_ip_discovery_profile(ip_discovery_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpdiscoveryprofileApi->get_ip_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_discovery_profile_id** | **String**| IP Discovery Profile ID | 

### Return type

[**IPDiscoveryProfile**](IPDiscoveryProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_discovery_profiles**
> IPDiscoveryProfileListResult get_ip_discovery_profiles(opts)

List IP Discovery Profiles

API will list all IP Discovery Profiles active in current discovery profile id. 

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

api_instance = SwaggerClient::PolicyIpdiscoveryprofileApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IP Discovery Profiles
  result = api_instance.get_ip_discovery_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpdiscoveryprofileApi->get_ip_discovery_profiles: #{e}"
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

[**IPDiscoveryProfileListResult**](IPDiscoveryProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_ip_discovery_profile**
> IPDiscoveryProfile update_ip_discovery_profile(ip_discovery_profile_id, ip_discovery_profile)

Update IP Discovery Profile

API will update IP Discovery profile. 

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

api_instance = SwaggerClient::PolicyIpdiscoveryprofileApi.new

ip_discovery_profile_id = 'ip_discovery_profile_id_example' # String | IP Discovery Profile ID

ip_discovery_profile = SwaggerClient::IPDiscoveryProfile.new # IPDiscoveryProfile | 


begin
  #Update IP Discovery Profile
  result = api_instance.update_ip_discovery_profile(ip_discovery_profile_id, ip_discovery_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpdiscoveryprofileApi->update_ip_discovery_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_discovery_profile_id** | **String**| IP Discovery Profile ID | 
 **ip_discovery_profile** | [**IPDiscoveryProfile**](IPDiscoveryProfile.md)|  | 

### Return type

[**IPDiscoveryProfile**](IPDiscoveryProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



