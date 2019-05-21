# SwaggerClient::PolicySecurityProfilesSegmentSecurityProfileApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_segment_security_profile**](PolicySecurityProfilesSegmentSecurityProfileApi.md#create_or_update_segment_security_profile) | **PUT** /infra/segment-security-profiles/{segment-security-profile-id} | PUT segment security profile id
[**delete_segment_security_profile**](PolicySecurityProfilesSegmentSecurityProfileApi.md#delete_segment_security_profile) | **DELETE** /infra/segment-security-profiles/{segment-security-profile-id} | DELETE segment security profile
[**get_segment_security_profile**](PolicySecurityProfilesSegmentSecurityProfileApi.md#get_segment_security_profile) | **GET** /infra/segment-security-profiles/{segment-security-profile-id} | GET Segment security profile id
[**list_segment_security_profiles**](PolicySecurityProfilesSegmentSecurityProfileApi.md#list_segment_security_profiles) | **GET** /infra/segment-security-profiles | List segment security profiles
[**patch_segment_security_profile**](PolicySecurityProfilesSegmentSecurityProfileApi.md#patch_segment_security_profile) | **PATCH** /infra/segment-security-profiles/{segment-security-profile-id} | PATCH segment security profile id


# **create_or_update_segment_security_profile**
> SegmentSecurityProfile create_or_update_segment_security_profile(segment_security_profile_id, segment_security_profile)

PUT segment security profile id

Create or replace a segment security profile 

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

api_instance = SwaggerClient::PolicySecurityProfilesSegmentSecurityProfileApi.new

segment_security_profile_id = 'segment_security_profile_id_example' # String | Segment security profile id

segment_security_profile = SwaggerClient::SegmentSecurityProfile.new # SegmentSecurityProfile | 


begin
  #PUT segment security profile id
  result = api_instance.create_or_update_segment_security_profile(segment_security_profile_id, segment_security_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSegmentSecurityProfileApi->create_or_update_segment_security_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_security_profile_id** | **String**| Segment security profile id | 
 **segment_security_profile** | [**SegmentSecurityProfile**](SegmentSecurityProfile.md)|  | 

### Return type

[**SegmentSecurityProfile**](SegmentSecurityProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_segment_security_profile**
> delete_segment_security_profile(segment_security_profile_id)

DELETE segment security profile

API will delete segment security profile with the given id. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSegmentSecurityProfileApi.new

segment_security_profile_id = 'segment_security_profile_id_example' # String | Segment security profile id


begin
  #DELETE segment security profile
  api_instance.delete_segment_security_profile(segment_security_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSegmentSecurityProfileApi->delete_segment_security_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_security_profile_id** | **String**| Segment security profile id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_security_profile**
> SegmentSecurityProfile get_segment_security_profile(segment_security_profile_id)

GET Segment security profile id

API will return details of the segment security profile with given id. If the profile does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSegmentSecurityProfileApi.new

segment_security_profile_id = 'segment_security_profile_id_example' # String | Segment security profile id


begin
  #GET Segment security profile id
  result = api_instance.get_segment_security_profile(segment_security_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSegmentSecurityProfileApi->get_segment_security_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_security_profile_id** | **String**| Segment security profile id | 

### Return type

[**SegmentSecurityProfile**](SegmentSecurityProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_segment_security_profiles**
> SegmentSecurityProfileListResult list_segment_security_profiles(opts)

List segment security profiles

API will list all segment security profiles. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSegmentSecurityProfileApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List segment security profiles
  result = api_instance.list_segment_security_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSegmentSecurityProfileApi->list_segment_security_profiles: #{e}"
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

[**SegmentSecurityProfileListResult**](SegmentSecurityProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_segment_security_profile**
> patch_segment_security_profile(segment_security_profile_id, segment_security_profile)

PATCH segment security profile id

Create a new segment security profile if the segment security profile with given id does not exist. Otherwise, PATCH the existing segment security profile 

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

api_instance = SwaggerClient::PolicySecurityProfilesSegmentSecurityProfileApi.new

segment_security_profile_id = 'segment_security_profile_id_example' # String | Segment security profile id

segment_security_profile = SwaggerClient::SegmentSecurityProfile.new # SegmentSecurityProfile | 


begin
  #PATCH segment security profile id
  api_instance.patch_segment_security_profile(segment_security_profile_id, segment_security_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSegmentSecurityProfileApi->patch_segment_security_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_security_profile_id** | **String**| Segment security profile id | 
 **segment_security_profile** | [**SegmentSecurityProfile**](SegmentSecurityProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



