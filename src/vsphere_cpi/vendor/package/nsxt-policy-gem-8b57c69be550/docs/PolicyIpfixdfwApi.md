# SwaggerClient::PolicyIpfixdfwApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_ipfixdfw_collector_profile**](PolicyIpfixdfwApi.md#create_or_replace_ipfixdfw_collector_profile) | **PUT** /infra/ipfix-dfw-collector-profiles/{ipfix-dfw-collector-profile-id} | Create or Replace IPFIX dfw collector profile
[**create_or_replace_ipfixdfw_profile**](PolicyIpfixdfwApi.md#create_or_replace_ipfixdfw_profile) | **PUT** /infra/ipfix-dfw-profiles/{ipfix-dfw-profile-id} | Create or Replace IPFIX DFW collection Config.
[**delete_ipfixdfw_collector_profile**](PolicyIpfixdfwApi.md#delete_ipfixdfw_collector_profile) | **DELETE** /infra/ipfix-dfw-collector-profiles/{ipfix-dfw-collector-profile-id} | Delete IPFIX dfw Collector profile
[**delete_ipfixdfw_profile**](PolicyIpfixdfwApi.md#delete_ipfixdfw_profile) | **DELETE** /infra/ipfix-dfw-profiles/{ipfix-dfw-profile-id} | Delete IPFIX DFW Profile
[**list_ipfixdfw_collector_profiles**](PolicyIpfixdfwApi.md#list_ipfixdfw_collector_profiles) | **GET** /infra/ipfix-dfw-collector-profiles | List IPFIX Collector profiles.
[**list_ipfixdfw_profiles**](PolicyIpfixdfwApi.md#list_ipfixdfw_profiles) | **GET** /infra/ipfix-dfw-profiles | List IPFIX DFW Profile
[**patch_ipfixdfw_collector_profile**](PolicyIpfixdfwApi.md#patch_ipfixdfw_collector_profile) | **PATCH** /infra/ipfix-dfw-collector-profiles/{ipfix-dfw-collector-profile-id} | IPFIX dfw collector profile id
[**patch_ipfixdfw_profile**](PolicyIpfixdfwApi.md#patch_ipfixdfw_profile) | **PATCH** /infra/ipfix-dfw-profiles/{ipfix-dfw-profile-id} | Patch IPFIX DFW profile
[**read_ipfixdfw_collector_profile**](PolicyIpfixdfwApi.md#read_ipfixdfw_collector_profile) | **GET** /infra/ipfix-dfw-collector-profiles/{ipfix-dfw-collector-profile-id} | Get IPFIX dfw Collector profile
[**read_ipfixdfw_profile**](PolicyIpfixdfwApi.md#read_ipfixdfw_profile) | **GET** /infra/ipfix-dfw-profiles/{ipfix-dfw-profile-id} | Get IPFIX DFW Profile


# **create_or_replace_ipfixdfw_collector_profile**
> IPFIXDFWCollectorProfile create_or_replace_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id, ipfixdfw_collector_profile)

Create or Replace IPFIX dfw collector profile

Create or Replace IPFIX dfw collector profile. IPFIX data will be sent to IPFIX collector port. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_collector_profile_id = 'ipfix_dfw_collector_profile_id_example' # String | IPFIX dfw collector profile id

ipfixdfw_collector_profile = SwaggerClient::IPFIXDFWCollectorProfile.new # IPFIXDFWCollectorProfile | 


begin
  #Create or Replace IPFIX dfw collector profile
  result = api_instance.create_or_replace_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id, ipfixdfw_collector_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->create_or_replace_ipfixdfw_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_collector_profile_id** | **String**| IPFIX dfw collector profile id | 
 **ipfixdfw_collector_profile** | [**IPFIXDFWCollectorProfile**](IPFIXDFWCollectorProfile.md)|  | 

### Return type

[**IPFIXDFWCollectorProfile**](IPFIXDFWCollectorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ipfixdfw_profile**
> IPFIXDFWProfile create_or_replace_ipfixdfw_profile(ipfix_dfw_profile_id, ipfixdfw_profile)

Create or Replace IPFIX DFW collection Config.

Create or replace IPFIX DFW profile. Config will start forwarding data to provided IPFIX DFW collector. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_profile_id = 'ipfix_dfw_profile_id_example' # String | IPFIX DFW Profile ID

ipfixdfw_profile = SwaggerClient::IPFIXDFWProfile.new # IPFIXDFWProfile | 


begin
  #Create or Replace IPFIX DFW collection Config.
  result = api_instance.create_or_replace_ipfixdfw_profile(ipfix_dfw_profile_id, ipfixdfw_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->create_or_replace_ipfixdfw_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_profile_id** | **String**| IPFIX DFW Profile ID | 
 **ipfixdfw_profile** | [**IPFIXDFWProfile**](IPFIXDFWProfile.md)|  | 

### Return type

[**IPFIXDFWProfile**](IPFIXDFWProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ipfixdfw_collector_profile**
> delete_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id)

Delete IPFIX dfw Collector profile

API deletes IPFIX dfw collector profile. Flow forwarding to collector will be stopped. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_collector_profile_id = 'ipfix_dfw_collector_profile_id_example' # String | IPFIX dfw collector Profile id


begin
  #Delete IPFIX dfw Collector profile
  api_instance.delete_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->delete_ipfixdfw_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_collector_profile_id** | **String**| IPFIX dfw collector Profile id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ipfixdfw_profile**
> delete_ipfixdfw_profile(ipfix_dfw_profile_id)

Delete IPFIX DFW Profile

API deletes IPFIX DFW Profile. Selected IPFIX Collectors will stop receiving flows. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_profile_id = 'ipfix_dfw_profile_id_example' # String | IPFIX DFW Profile ID


begin
  #Delete IPFIX DFW Profile
  api_instance.delete_ipfixdfw_profile(ipfix_dfw_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->delete_ipfixdfw_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_profile_id** | **String**| IPFIX DFW Profile ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ipfixdfw_collector_profiles**
> IPFIXDFWCollectorProfileListResult list_ipfixdfw_collector_profiles(opts)

List IPFIX Collector profiles.

API will provide list of all IPFIX dfw collector profiles and their details. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

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
  result = api_instance.list_ipfixdfw_collector_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->list_ipfixdfw_collector_profiles: #{e}"
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

[**IPFIXDFWCollectorProfileListResult**](IPFIXDFWCollectorProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ipfixdfw_profiles**
> IPFIXDFWProfileListResult list_ipfixdfw_profiles(opts)

List IPFIX DFW Profile

API provides list IPFIX DFW profiles available on selected logical DFW. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IPFIX DFW Profile
  result = api_instance.list_ipfixdfw_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->list_ipfixdfw_profiles: #{e}"
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

[**IPFIXDFWProfileListResult**](IPFIXDFWProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_ipfixdfw_collector_profile**
> patch_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id, ipfixdfw_collector_profile)

IPFIX dfw collector profile id

Create a new IPFIX dfw collector profile if the IPFIX dfw collector profile with given id does not already exist. If the IPFIX dfw collector profile with the given id already exists, patch with the existing IPFIX dfw collector profile. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_collector_profile_id = 'ipfix_dfw_collector_profile_id_example' # String | 

ipfixdfw_collector_profile = SwaggerClient::IPFIXDFWCollectorProfile.new # IPFIXDFWCollectorProfile | 


begin
  #IPFIX dfw collector profile id
  api_instance.patch_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id, ipfixdfw_collector_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->patch_ipfixdfw_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_collector_profile_id** | **String**|  | 
 **ipfixdfw_collector_profile** | [**IPFIXDFWCollectorProfile**](IPFIXDFWCollectorProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_ipfixdfw_profile**
> patch_ipfixdfw_profile(ipfix_dfw_profile_id, ipfixdfw_profile)

Patch IPFIX DFW profile

Create a new IPFIX DFW profile if the IPFIX DFW profile with given id does not already exist. If the IPFIX DFW profile with the given id already exists, patch with the existing IPFIX DFW profile. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_profile_id = 'ipfix_dfw_profile_id_example' # String | IPFIX DFW Profile ID

ipfixdfw_profile = SwaggerClient::IPFIXDFWProfile.new # IPFIXDFWProfile | 


begin
  #Patch IPFIX DFW profile
  api_instance.patch_ipfixdfw_profile(ipfix_dfw_profile_id, ipfixdfw_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->patch_ipfixdfw_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_profile_id** | **String**| IPFIX DFW Profile ID | 
 **ipfixdfw_profile** | [**IPFIXDFWProfile**](IPFIXDFWProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ipfixdfw_collector_profile**
> IPFIXDFWCollectorProfile read_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id)

Get IPFIX dfw Collector profile

API will return details of IPFIX dfw collector profile. If profile does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_collector_profile_id = 'ipfix_dfw_collector_profile_id_example' # String | IPFIX dfw collector profile id


begin
  #Get IPFIX dfw Collector profile
  result = api_instance.read_ipfixdfw_collector_profile(ipfix_dfw_collector_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->read_ipfixdfw_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_collector_profile_id** | **String**| IPFIX dfw collector profile id | 

### Return type

[**IPFIXDFWCollectorProfile**](IPFIXDFWCollectorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ipfixdfw_profile**
> IPFIXDFWProfile read_ipfixdfw_profile(ipfix_dfw_profile_id)

Get IPFIX DFW Profile

API will return details of IPFIX DFW profile. 

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

api_instance = SwaggerClient::PolicyIpfixdfwApi.new

ipfix_dfw_profile_id = 'ipfix_dfw_profile_id_example' # String | IPFIX DFW collection id


begin
  #Get IPFIX DFW Profile
  result = api_instance.read_ipfixdfw_profile(ipfix_dfw_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyIpfixdfwApi->read_ipfixdfw_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_dfw_profile_id** | **String**| IPFIX DFW collection id | 

### Return type

[**IPFIXDFWProfile**](IPFIXDFWProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



