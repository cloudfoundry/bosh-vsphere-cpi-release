# SwaggerClient::PolicyConnectivityRoutingCommunityListApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_community_list**](PolicyConnectivityRoutingCommunityListApi.md#create_or_replace_community_list) | **PUT** /infra/tier-0s/{tier-0-id}/community-lists/{community-list-id} | Create or update a BGP community list
[**delete_community_list**](PolicyConnectivityRoutingCommunityListApi.md#delete_community_list) | **DELETE** /infra/tier-0s/{tier-0-id}/community-lists/{community-list-id} | Delete a BGP community list
[**list_community_list**](PolicyConnectivityRoutingCommunityListApi.md#list_community_list) | **GET** /infra/tier-0s/{tier-0-id}/community-lists | List BGP community lists
[**patch_community_list**](PolicyConnectivityRoutingCommunityListApi.md#patch_community_list) | **PATCH** /infra/tier-0s/{tier-0-id}/community-lists/{community-list-id} | Create or update a BGP community list
[**read_community_list**](PolicyConnectivityRoutingCommunityListApi.md#read_community_list) | **GET** /infra/tier-0s/{tier-0-id}/community-lists/{community-list-id} | Read a BGP community list


# **create_or_replace_community_list**
> CommunityList create_or_replace_community_list(tier_0_id, community_list_id, community_list)

Create or update a BGP community list

If a community list with the community-list-id is not already present, create a new community list. If it already exists, replace the community list instance with the new object. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingCommunityListApi.new

tier_0_id = 'tier_0_id_example' # String | 

community_list_id = 'community_list_id_example' # String | 

community_list = SwaggerClient::CommunityList.new # CommunityList | 


begin
  #Create or update a BGP community list
  result = api_instance.create_or_replace_community_list(tier_0_id, community_list_id, community_list)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingCommunityListApi->create_or_replace_community_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **community_list_id** | **String**|  | 
 **community_list** | [**CommunityList**](CommunityList.md)|  | 

### Return type

[**CommunityList**](CommunityList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_community_list**
> delete_community_list(tier_0_id, community_list_id)

Delete a BGP community list

Delete a BGP community list

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

api_instance = SwaggerClient::PolicyConnectivityRoutingCommunityListApi.new

tier_0_id = 'tier_0_id_example' # String | 

community_list_id = 'community_list_id_example' # String | 


begin
  #Delete a BGP community list
  api_instance.delete_community_list(tier_0_id, community_list_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingCommunityListApi->delete_community_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **community_list_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_community_list**
> CommunityListListResult list_community_list(tier_0_id, opts)

List BGP community lists

Paginated list of all community lists under a tier-0 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingCommunityListApi.new

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
  #List BGP community lists
  result = api_instance.list_community_list(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingCommunityListApi->list_community_list: #{e}"
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

[**CommunityListListResult**](CommunityListListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_community_list**
> patch_community_list(tier_0_id, community_list_id, community_list)

Create or update a BGP community list

If a community list with the community-list-id is not already present, create a new community list. If it already exists, update the community list for specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingCommunityListApi.new

tier_0_id = 'tier_0_id_example' # String | 

community_list_id = 'community_list_id_example' # String | 

community_list = SwaggerClient::CommunityList.new # CommunityList | 


begin
  #Create or update a BGP community list
  api_instance.patch_community_list(tier_0_id, community_list_id, community_list)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingCommunityListApi->patch_community_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **community_list_id** | **String**|  | 
 **community_list** | [**CommunityList**](CommunityList.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_community_list**
> CommunityList read_community_list(tier_0_id, community_list_id)

Read a BGP community list

Read a BGP community list

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

api_instance = SwaggerClient::PolicyConnectivityRoutingCommunityListApi.new

tier_0_id = 'tier_0_id_example' # String | 

community_list_id = 'community_list_id_example' # String | 


begin
  #Read a BGP community list
  result = api_instance.read_community_list(tier_0_id, community_list_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingCommunityListApi->read_community_list: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **community_list_id** | **String**|  | 

### Return type

[**CommunityList**](CommunityList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



