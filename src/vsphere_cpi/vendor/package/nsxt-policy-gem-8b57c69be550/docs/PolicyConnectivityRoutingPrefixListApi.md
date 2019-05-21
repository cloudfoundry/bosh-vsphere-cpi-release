# SwaggerClient::PolicyConnectivityRoutingPrefixListApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_prefix_list**](PolicyConnectivityRoutingPrefixListApi.md#create_or_replace_prefix_list) | **PUT** /infra/tier-0s/{tier-0-id}/prefix-lists/{prefix-list-id} | Create or update a prefix list
[**delete_prefix_list**](PolicyConnectivityRoutingPrefixListApi.md#delete_prefix_list) | **DELETE** /infra/tier-0s/{tier-0-id}/prefix-lists/{prefix-list-id} | Delete a prefix list
[**list_prefix_lists**](PolicyConnectivityRoutingPrefixListApi.md#list_prefix_lists) | **GET** /infra/tier-0s/{tier-0-id}/prefix-lists | List prefix lists
[**patch_prefix_list**](PolicyConnectivityRoutingPrefixListApi.md#patch_prefix_list) | **PATCH** /infra/tier-0s/{tier-0-id}/prefix-lists/{prefix-list-id} | Create or update a prefix list
[**read_prefix_list**](PolicyConnectivityRoutingPrefixListApi.md#read_prefix_list) | **GET** /infra/tier-0s/{tier-0-id}/prefix-lists/{prefix-list-id} | Read a prefix list


# **create_or_replace_prefix_list**
> PrefixList create_or_replace_prefix_list(tier_0_id, prefix_list_id, prefix_list)

Create or update a prefix list

If prefix list for prefix-list-id is not already present, create a prefix list. If it already exists, replace the prefix list for prefix-list-id. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingPrefixListApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

prefix_list_id = 'prefix_list_id_example' # String | Prefix List ID

prefix_list = SwaggerClient::PrefixList.new # PrefixList | 


begin
  #Create or update a prefix list
  result = api_instance.create_or_replace_prefix_list(tier_0_id, prefix_list_id, prefix_list)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingPrefixListApi->create_or_replace_prefix_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **prefix_list_id** | **String**| Prefix List ID | 
 **prefix_list** | [**PrefixList**](PrefixList.md)|  | 

### Return type

[**PrefixList**](PrefixList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_prefix_list**
> delete_prefix_list(tier_0_id, prefix_list_id)

Delete a prefix list

Delete a prefix list

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

api_instance = SwaggerClient::PolicyConnectivityRoutingPrefixListApi.new

tier_0_id = 'tier_0_id_example' # String | 

prefix_list_id = 'prefix_list_id_example' # String | 


begin
  #Delete a prefix list
  api_instance.delete_prefix_list(tier_0_id, prefix_list_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingPrefixListApi->delete_prefix_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **prefix_list_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_prefix_lists**
> PrefixListResult list_prefix_lists(tier_0_id, opts)

List prefix lists

Paginated list of all prefix lists 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingPrefixListApi.new

tier_0_id = 'tier_0_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List prefix lists
  result = api_instance.list_prefix_lists(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingPrefixListApi->list_prefix_lists: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PrefixListResult**](PrefixListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_prefix_list**
> patch_prefix_list(tier_0_id, prefix_list_id, prefix_list)

Create or update a prefix list

If prefix list for prefix-list-id is not already present, create a prefix list. If it already exists, update prefix list for prefix-list-id. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingPrefixListApi.new

tier_0_id = 'tier_0_id_example' # String | 

prefix_list_id = 'prefix_list_id_example' # String | 

prefix_list = SwaggerClient::PrefixList.new # PrefixList | 


begin
  #Create or update a prefix list
  api_instance.patch_prefix_list(tier_0_id, prefix_list_id, prefix_list)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingPrefixListApi->patch_prefix_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **prefix_list_id** | **String**|  | 
 **prefix_list** | [**PrefixList**](PrefixList.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_prefix_list**
> PrefixList read_prefix_list(tier_0_id, prefix_list_id)

Read a prefix list

Read a prefix list

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

api_instance = SwaggerClient::PolicyConnectivityRoutingPrefixListApi.new

tier_0_id = 'tier_0_id_example' # String | 

prefix_list_id = 'prefix_list_id_example' # String | 


begin
  #Read a prefix list
  result = api_instance.read_prefix_list(tier_0_id, prefix_list_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingPrefixListApi->read_prefix_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **prefix_list_id** | **String**|  | 

### Return type

[**PrefixList**](PrefixList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



