# SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_tier0_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#create_or_replace_tier0_static_routes) | **PUT** /infra/tier-0s/{tier-0-id}/static-routes/{route-id} | Create or update a Tier-0 static routes
[**create_or_replace_tier1_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#create_or_replace_tier1_static_routes) | **PUT** /infra/tier-1s/{tier-1-id}/static-routes/{route-id} | Create or update a Tier-1 static routes
[**delete_tier0_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#delete_tier0_static_routes) | **DELETE** /infra/tier-0s/{tier-0-id}/static-routes/{route-id} | Delete Tier-0 static routes
[**delete_tier1_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#delete_tier1_static_routes) | **DELETE** /infra/tier-1s/{tier-1-id}/static-routes/{route-id} | Delete Tier-1 static routes
[**list_tier0_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#list_tier0_static_routes) | **GET** /infra/tier-0s/{tier-0-id}/static-routes | List Tier-0 Static Routes
[**list_tier1_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#list_tier1_static_routes) | **GET** /infra/tier-1s/{tier-1-id}/static-routes | List Tier-1 Static Routes
[**patch_tier0_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#patch_tier0_static_routes) | **PATCH** /infra/tier-0s/{tier-0-id}/static-routes/{route-id} | Create or update a Tier-0 static routes
[**patch_tier1_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#patch_tier1_static_routes) | **PATCH** /infra/tier-1s/{tier-1-id}/static-routes/{route-id} | Create or update a Tier-1 static routes
[**read_tier0_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#read_tier0_static_routes) | **GET** /infra/tier-0s/{tier-0-id}/static-routes/{route-id} | Read Tier-0 static routes
[**read_tier1_static_routes**](PolicyConnectivityRoutingStaticRoutesApi.md#read_tier1_static_routes) | **GET** /infra/tier-1s/{tier-1-id}/static-routes/{route-id} | Read Tier-1 static routes


# **create_or_replace_tier0_static_routes**
> StaticRoutes create_or_replace_tier0_static_routes(tier_0_id, route_id, static_routes)

Create or update a Tier-0 static routes

If static routes for route-id are not already present, create static routes. If it already exists, replace the static routes for route-id. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_id = 'route_id_example' # String | 

static_routes = SwaggerClient::StaticRoutes.new # StaticRoutes | 


begin
  #Create or update a Tier-0 static routes
  result = api_instance.create_or_replace_tier0_static_routes(tier_0_id, route_id, static_routes)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->create_or_replace_tier0_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_id** | **String**|  | 
 **static_routes** | [**StaticRoutes**](StaticRoutes.md)|  | 

### Return type

[**StaticRoutes**](StaticRoutes.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_tier1_static_routes**
> StaticRoutes create_or_replace_tier1_static_routes(tier_1_id, route_id, static_routes)

Create or update a Tier-1 static routes

If static routes for route-id are not already present, create static routes. If it already exists, replace the static routes for route-id. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_1_id = 'tier_1_id_example' # String | 

route_id = 'route_id_example' # String | 

static_routes = SwaggerClient::StaticRoutes.new # StaticRoutes | 


begin
  #Create or update a Tier-1 static routes
  result = api_instance.create_or_replace_tier1_static_routes(tier_1_id, route_id, static_routes)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->create_or_replace_tier1_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **route_id** | **String**|  | 
 **static_routes** | [**StaticRoutes**](StaticRoutes.md)|  | 

### Return type

[**StaticRoutes**](StaticRoutes.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier0_static_routes**
> delete_tier0_static_routes(tier_0_id, route_id)

Delete Tier-0 static routes

Delete Tier-0 static routes

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_id = 'route_id_example' # String | 


begin
  #Delete Tier-0 static routes
  api_instance.delete_tier0_static_routes(tier_0_id, route_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->delete_tier0_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier1_static_routes**
> delete_tier1_static_routes(tier_1_id, route_id)

Delete Tier-1 static routes

Delete Tier-1 static routes

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_1_id = 'tier_1_id_example' # String | 

route_id = 'route_id_example' # String | 


begin
  #Delete Tier-1 static routes
  api_instance.delete_tier1_static_routes(tier_1_id, route_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->delete_tier1_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **route_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier0_static_routes**
> StaticRoutesListResult list_tier0_static_routes(tier_0_id, opts)

List Tier-0 Static Routes

Paginated list of all Tier-0 Static Routes 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

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
  #List Tier-0 Static Routes
  result = api_instance.list_tier0_static_routes(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->list_tier0_static_routes: #{e}"
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

[**StaticRoutesListResult**](StaticRoutesListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier1_static_routes**
> StaticRoutesListResult list_tier1_static_routes(tier_1_id, opts)

List Tier-1 Static Routes

Paginated list of all Tier-1 Static Routes 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_1_id = 'tier_1_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Tier-1 Static Routes
  result = api_instance.list_tier1_static_routes(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->list_tier1_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**StaticRoutesListResult**](StaticRoutesListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier0_static_routes**
> patch_tier0_static_routes(tier_0_id, route_id, static_routes)

Create or update a Tier-0 static routes

If static routes for route-id are not already present, create static routes. If it already exists, update static routes for route-id. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_id = 'route_id_example' # String | 

static_routes = SwaggerClient::StaticRoutes.new # StaticRoutes | 


begin
  #Create or update a Tier-0 static routes
  api_instance.patch_tier0_static_routes(tier_0_id, route_id, static_routes)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->patch_tier0_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_id** | **String**|  | 
 **static_routes** | [**StaticRoutes**](StaticRoutes.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier1_static_routes**
> patch_tier1_static_routes(tier_1_id, route_id, static_routes)

Create or update a Tier-1 static routes

If static routes for route-id are not already present, create static routes. If it already exists, update static routes for route-id. 

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_1_id = 'tier_1_id_example' # String | 

route_id = 'route_id_example' # String | 

static_routes = SwaggerClient::StaticRoutes.new # StaticRoutes | 


begin
  #Create or update a Tier-1 static routes
  api_instance.patch_tier1_static_routes(tier_1_id, route_id, static_routes)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->patch_tier1_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **route_id** | **String**|  | 
 **static_routes** | [**StaticRoutes**](StaticRoutes.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier0_static_routes**
> StaticRoutes read_tier0_static_routes(tier_0_id, route_id)

Read Tier-0 static routes

Read Tier-0 static routes

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_0_id = 'tier_0_id_example' # String | 

route_id = 'route_id_example' # String | 


begin
  #Read Tier-0 static routes
  result = api_instance.read_tier0_static_routes(tier_0_id, route_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->read_tier0_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **route_id** | **String**|  | 

### Return type

[**StaticRoutes**](StaticRoutes.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier1_static_routes**
> StaticRoutes read_tier1_static_routes(tier_1_id, route_id)

Read Tier-1 static routes

Read Tier-1 static routes

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

api_instance = SwaggerClient::PolicyConnectivityRoutingStaticRoutesApi.new

tier_1_id = 'tier_1_id_example' # String | 

route_id = 'route_id_example' # String | 


begin
  #Read Tier-1 static routes
  result = api_instance.read_tier1_static_routes(tier_1_id, route_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityRoutingStaticRoutesApi->read_tier1_static_routes: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **route_id** | **String**|  | 

### Return type

[**StaticRoutes**](StaticRoutes.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



