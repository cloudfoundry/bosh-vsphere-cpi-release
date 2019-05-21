# SwaggerClient::PolicyPortmirroringApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_port_mirroring_profile**](PolicyPortmirroringApi.md#create_or_replace_port_mirroring_profile) | **PUT** /infra/port-mirroring-profiles/{port-mirroring-profile-id} | Create or Replace Port Mirroring Profile.
[**delete_port_mirroring_profile**](PolicyPortmirroringApi.md#delete_port_mirroring_profile) | **DELETE** /infra/port-mirroring-profiles/{port-mirroring-profile-id} | Delete Port Mirroring Profile
[**list_port_mirroring_profiles**](PolicyPortmirroringApi.md#list_port_mirroring_profiles) | **GET** /infra/port-mirroring-profiles | List Port Mirroring Profiles
[**patch_port_mirroring_profile**](PolicyPortmirroringApi.md#patch_port_mirroring_profile) | **PATCH** /infra/port-mirroring-profiles/{port-mirroring-profile-id} | Patch Port Mirroring Profile.
[**read_port_mirroring_profile**](PolicyPortmirroringApi.md#read_port_mirroring_profile) | **GET** /infra/port-mirroring-profiles/{port-mirroring-profile-id} | Details of Port Mirroring Profile 


# **create_or_replace_port_mirroring_profile**
> PortMirroringProfile create_or_replace_port_mirroring_profile(port_mirroring_profile_id, port_mirroring_profile)

Create or Replace Port Mirroring Profile.

Create or Replace port mirroring profile. Packets will be mirrored from source group, segment, port to destination group. 

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

api_instance = SwaggerClient::PolicyPortmirroringApi.new

port_mirroring_profile_id = 'port_mirroring_profile_id_example' # String | Port Mirroring Profiles Id

port_mirroring_profile = SwaggerClient::PortMirroringProfile.new # PortMirroringProfile | 


begin
  #Create or Replace Port Mirroring Profile.
  result = api_instance.create_or_replace_port_mirroring_profile(port_mirroring_profile_id, port_mirroring_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPortmirroringApi->create_or_replace_port_mirroring_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **port_mirroring_profile_id** | **String**| Port Mirroring Profiles Id | 
 **port_mirroring_profile** | [**PortMirroringProfile**](PortMirroringProfile.md)|  | 

### Return type

[**PortMirroringProfile**](PortMirroringProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_port_mirroring_profile**
> delete_port_mirroring_profile(port_mirroring_profile_id)

Delete Port Mirroring Profile

API will delete port mirroring profile. Mirroring from source to destination ports will be stopped. 

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

api_instance = SwaggerClient::PolicyPortmirroringApi.new

port_mirroring_profile_id = 'port_mirroring_profile_id_example' # String | Port Mirroring Profile Id


begin
  #Delete Port Mirroring Profile
  api_instance.delete_port_mirroring_profile(port_mirroring_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPortmirroringApi->delete_port_mirroring_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **port_mirroring_profile_id** | **String**| Port Mirroring Profile Id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_port_mirroring_profiles**
> PortMirroringProfileListResult list_port_mirroring_profiles(opts)

List Port Mirroring Profiles

API will list all port mirroring profiles group. 

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

api_instance = SwaggerClient::PolicyPortmirroringApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Port Mirroring Profiles
  result = api_instance.list_port_mirroring_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPortmirroringApi->list_port_mirroring_profiles: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortMirroringProfileListResult**](PortMirroringProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_port_mirroring_profile**
> patch_port_mirroring_profile(port_mirroring_profile_id, port_mirroring_profile)

Patch Port Mirroring Profile.

Create a new Port Mirroring Profile if the Port Mirroring Profile with given id does not already exist. If the Port Mirroring Profile with the given id already exists, patch with the existing Port Mirroring Profile. 

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

api_instance = SwaggerClient::PolicyPortmirroringApi.new

port_mirroring_profile_id = 'port_mirroring_profile_id_example' # String | Port Mirroring Profile Id

port_mirroring_profile = SwaggerClient::PortMirroringProfile.new # PortMirroringProfile | 


begin
  #Patch Port Mirroring Profile.
  api_instance.patch_port_mirroring_profile(port_mirroring_profile_id, port_mirroring_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPortmirroringApi->patch_port_mirroring_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **port_mirroring_profile_id** | **String**| Port Mirroring Profile Id | 
 **port_mirroring_profile** | [**PortMirroringProfile**](PortMirroringProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_port_mirroring_profile**
> PortMirroringProfile read_port_mirroring_profile(port_mirroring_profile_id)

Details of Port Mirroring Profile 

API will return details of port mirroring profile. 

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

api_instance = SwaggerClient::PolicyPortmirroringApi.new

port_mirroring_profile_id = 'port_mirroring_profile_id_example' # String | Port Mirroring Profile Id


begin
  #Details of Port Mirroring Profile 
  result = api_instance.read_port_mirroring_profile(port_mirroring_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPortmirroringApi->read_port_mirroring_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **port_mirroring_profile_id** | **String**| Port Mirroring Profile Id | 

### Return type

[**PortMirroringProfile**](PortMirroringProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



