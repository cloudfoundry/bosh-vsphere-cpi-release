# SwaggerClient::PolicyConnectivityRoutingRouteMapApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_route_map**](PolicyConnectivityRoutingRouteMapApi.md#create_or_replace_route_map) | **PUT** /infra/tier-0s/{tier-0-id}/route-maps/{route-map-id} | Create or update a route map
[**get_route_map**](PolicyConnectivityRoutingRouteMapApi.md#get_route_map) | **GET** /infra/tier-0s/{tier-0-id}/route-maps/{route-map-id} | Read a route map
[**list_all_route_maps**](PolicyConnectivityRoutingRouteMapApi.md#list_all_route_maps) | **GET** /infra/tier-0s/{tier-0-id}/route-maps | List route maps
[**patch_route_map**](PolicyConnectivityRoutingRouteMapApi.md#patch_route_map) | **PATCH** /infra/tier-0s/{tier-0-id}/route-maps/{route-map-id} | Create or update a route map
[**remove_route_map**](PolicyConnectivityRoutingRouteMapApi.md#remove_route_map) | **DELETE** /infra/tier-0s/{tier-0-id}/route-maps/{route-map-id} | Delete a route map


# **create_or_replace_route_map**
> Tier0RouteMap create_or_replace_route_map(tier_0_id, route_map_id, tier0_route_map)

Create or update a route map

If a route map with the route-map-id is not already present, create a new route map. If it already exists, replace the route map instance with the new object. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingRouteMapApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_map_id = 'route_map_id_example' # String | 

tier0_route_map = SwaggerClient::Tier0RouteMap.new # Tier0RouteMap | 


begin
  #Create or update a route map
  result = api_instance.create_or_replace_route_map(tier_0_id, route_map_id, tier0_route_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingRouteMapApi->create_or_replace_route_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_map_id** | **String**|  | 
 **tier0_route_map** | [**Tier0RouteMap**](Tier0RouteMap.md)|  | 

### Return type

[**Tier0RouteMap**](Tier0RouteMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_route_map**
> Tier0RouteMap get_route_map(tier_0_id, route_map_id)

Read a route map

Read a route map

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

api_instance = SwaggerClient::PolicyConnectivityRoutingRouteMapApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_map_id = 'route_map_id_example' # String | 


begin
  #Read a route map
  result = api_instance.get_route_map(tier_0_id, route_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingRouteMapApi->get_route_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_map_id** | **String**|  | 

### Return type

[**Tier0RouteMap**](Tier0RouteMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_all_route_maps**
> Tier0RouteMapListResult list_all_route_maps(tier_0_id, opts)

List route maps

Paginated list of all route maps under a tier-0 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingRouteMapApi.new

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
  #List route maps
  result = api_instance.list_all_route_maps(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingRouteMapApi->list_all_route_maps: #{e}"
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

[**Tier0RouteMapListResult**](Tier0RouteMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_route_map**
> patch_route_map(tier_0_id, route_map_id, tier0_route_map)

Create or update a route map

If a route map with the route-map-id is not already present, create a new route map. If it already exists, update the route map for specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingRouteMapApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_map_id = 'route_map_id_example' # String | 

tier0_route_map = SwaggerClient::Tier0RouteMap.new # Tier0RouteMap | 


begin
  #Create or update a route map
  api_instance.patch_route_map(tier_0_id, route_map_id, tier0_route_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingRouteMapApi->patch_route_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_map_id** | **String**|  | 
 **tier0_route_map** | [**Tier0RouteMap**](Tier0RouteMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **remove_route_map**
> remove_route_map(tier_0_id, route_map_id)

Delete a route map

Delete a route map

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

api_instance = SwaggerClient::PolicyConnectivityRoutingRouteMapApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_map_id = 'route_map_id_example' # String | 


begin
  #Delete a route map
  api_instance.remove_route_map(tier_0_id, route_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingRouteMapApi->remove_route_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_map_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



