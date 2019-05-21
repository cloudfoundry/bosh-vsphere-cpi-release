# SwaggerClient::PolicyConnectivityRoutingBgpApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_bgp_neighbor_config**](PolicyConnectivityRoutingBgpApi.md#create_or_replace_bgp_neighbor_config) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp/neighbors/{neighbor-id} | Create or update a BGP neighbor config
[**create_or_replace_bgp_routing_config**](PolicyConnectivityRoutingBgpApi.md#create_or_replace_bgp_routing_config) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp | Create or update a BGP routing config
[**delete_bgp_neighbor_config**](PolicyConnectivityRoutingBgpApi.md#delete_bgp_neighbor_config) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp/neighbors/{neighbor-id} | Delete BGP neighbor config
[**list_bgp_neighbor_configs**](PolicyConnectivityRoutingBgpApi.md#list_bgp_neighbor_configs) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp/neighbors | List BGP neighbor configurations
[**patch_bgp_neighbor_config**](PolicyConnectivityRoutingBgpApi.md#patch_bgp_neighbor_config) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp/neighbors/{neighbor-id} | Create or update a BGP neighbor config
[**patch_bgp_routing_config**](PolicyConnectivityRoutingBgpApi.md#patch_bgp_routing_config) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp | Create or update BGP routing config
[**read_bgp_neighbor_config**](PolicyConnectivityRoutingBgpApi.md#read_bgp_neighbor_config) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp/neighbors/{neighbor-id} | Read BGP neighbor config
[**read_bgp_routing_config**](PolicyConnectivityRoutingBgpApi.md#read_bgp_routing_config) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/bgp | Read BGP routing config


# **create_or_replace_bgp_neighbor_config**
> BgpNeighborConfig create_or_replace_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id, bgp_neighbor_config)

Create or update a BGP neighbor config

If BGP neighbor config with the neighbor-id is not already present, create a new neighbor config. If it already exists, replace the BGP neighbor config with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

neighbor_id = 'neighbor_id_example' # String | 

bgp_neighbor_config = SwaggerClient::BgpNeighborConfig.new # BgpNeighborConfig | 


begin
  #Create or update a BGP neighbor config
  result = api_instance.create_or_replace_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id, bgp_neighbor_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->create_or_replace_bgp_neighbor_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **neighbor_id** | **String**|  | 
 **bgp_neighbor_config** | [**BgpNeighborConfig**](BgpNeighborConfig.md)|  | 

### Return type

[**BgpNeighborConfig**](BgpNeighborConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_bgp_routing_config**
> BgpRoutingConfig create_or_replace_bgp_routing_config(tier_0_id, locale_service_id, bgp_routing_config)

Create or update a BGP routing config

If BGP routing config is not already present, create BGP routing config. If it already exists, replace the BGP routing config with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

bgp_routing_config = SwaggerClient::BgpRoutingConfig.new # BgpRoutingConfig | 


begin
  #Create or update a BGP routing config
  result = api_instance.create_or_replace_bgp_routing_config(tier_0_id, locale_service_id, bgp_routing_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->create_or_replace_bgp_routing_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **bgp_routing_config** | [**BgpRoutingConfig**](BgpRoutingConfig.md)|  | 

### Return type

[**BgpRoutingConfig**](BgpRoutingConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_bgp_neighbor_config**
> delete_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id)

Delete BGP neighbor config

Delete BGP neighbor config

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

neighbor_id = 'neighbor_id_example' # String | 


begin
  #Delete BGP neighbor config
  api_instance.delete_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->delete_bgp_neighbor_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **neighbor_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_bgp_neighbor_configs**
> BgpNeighborConfigListResult list_bgp_neighbor_configs(tier_0_id, locale_service_id, opts)

List BGP neighbor configurations

Paginated list of all BGP neighbor configurations 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List BGP neighbor configurations
  result = api_instance.list_bgp_neighbor_configs(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->list_bgp_neighbor_configs: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**BgpNeighborConfigListResult**](BgpNeighborConfigListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_bgp_neighbor_config**
> patch_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id, bgp_neighbor_config)

Create or update a BGP neighbor config

If BGP neighbor config with the neighbor-id is not already present, create a new neighbor config. If it already exists, replace the BGP neighbor config with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

neighbor_id = 'neighbor_id_example' # String | 

bgp_neighbor_config = SwaggerClient::BgpNeighborConfig.new # BgpNeighborConfig | 


begin
  #Create or update a BGP neighbor config
  api_instance.patch_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id, bgp_neighbor_config)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->patch_bgp_neighbor_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **neighbor_id** | **String**|  | 
 **bgp_neighbor_config** | [**BgpNeighborConfig**](BgpNeighborConfig.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_bgp_routing_config**
> patch_bgp_routing_config(tier_0_id, locale_service_id, bgp_routing_config)

Create or update BGP routing config

If an BGP routing config not present, create BGP routing config. If it already exists, update the routing config. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

bgp_routing_config = SwaggerClient::BgpRoutingConfig.new # BgpRoutingConfig | 


begin
  #Create or update BGP routing config
  api_instance.patch_bgp_routing_config(tier_0_id, locale_service_id, bgp_routing_config)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->patch_bgp_routing_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **bgp_routing_config** | [**BgpRoutingConfig**](BgpRoutingConfig.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_bgp_neighbor_config**
> BgpNeighborConfig read_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id)

Read BGP neighbor config

Read BGP neighbor config

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

neighbor_id = 'neighbor_id_example' # String | 


begin
  #Read BGP neighbor config
  result = api_instance.read_bgp_neighbor_config(tier_0_id, locale_service_id, neighbor_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->read_bgp_neighbor_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **neighbor_id** | **String**|  | 

### Return type

[**BgpNeighborConfig**](BgpNeighborConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_bgp_routing_config**
> BgpRoutingConfig read_bgp_routing_config(tier_0_id, locale_service_id)

Read BGP routing config

Read BGP routing config

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

api_instance = SwaggerClient::PolicyConnectivityRoutingBgpApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 


begin
  #Read BGP routing config
  result = api_instance.read_bgp_routing_config(tier_0_id, locale_service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingBgpApi->read_bgp_routing_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 

### Return type

[**BgpRoutingConfig**](BgpRoutingConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



