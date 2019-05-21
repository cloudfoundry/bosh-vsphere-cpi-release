# SwaggerClient::PolicyDiscoveryprofilebindingApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_infra_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#delete_infra_port_discovery_binding) | **DELETE** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Delete Infra Port Discovery Profile Binding Profile
[**delete_infra_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#delete_infra_segment_discovery_binding) | **DELETE** /infra/segments/{infra-segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Delete Segment Discovery Profile Binding Profile
[**delete_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#delete_port_discovery_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Delete Port Discovery Profile Binding Profile
[**delete_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#delete_segment_discovery_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Delete Segment Discovery Profile Binding Profile
[**get_infra_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#get_infra_port_discovery_binding) | **GET** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Get Infra Port Discovery Profile Binding Map
[**get_infra_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#get_infra_segment_discovery_binding) | **GET** /infra/segments/{infra-segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Get Infra Segment Discovery Profile Binding Map
[**get_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#get_port_discovery_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Get Port Discovery Profile Binding Map
[**get_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#get_segment_discovery_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Get Segment Discovery Profile Binding Map
[**list_infra_port_discovery_bindings**](PolicyDiscoveryprofilebindingApi.md#list_infra_port_discovery_bindings) | **GET** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-discovery-profile-binding-maps | List Infra Port Discovery Profile Binding Maps
[**list_infra_segment_discovery_bindings**](PolicyDiscoveryprofilebindingApi.md#list_infra_segment_discovery_bindings) | **GET** /infra/segments/{infra-segment-id}/segment-discovery-profile-binding-maps | List Infra Segment Discovery Profile Binding Maps
[**list_port_discovery_bindings**](PolicyDiscoveryprofilebindingApi.md#list_port_discovery_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-discovery-profile-binding-maps | List Port Discovery Profile Binding Maps
[**list_segment_discovery_bindings**](PolicyDiscoveryprofilebindingApi.md#list_segment_discovery_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-discovery-profile-binding-maps | List Segment Discovery Profile Binding Maps
[**patch_infra_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#patch_infra_port_discovery_binding) | **PATCH** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Create Infra Port Discovery Profile Binding Map
[**patch_infra_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#patch_infra_segment_discovery_binding) | **PATCH** /infra/segments/{infra-segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Create Infra Segment Discovery Profile Binding Map
[**patch_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#patch_port_discovery_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Create Port Discovery Profile Binding Map
[**patch_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#patch_segment_discovery_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Create Segment Discovery Profile Binding Map
[**update_infra_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#update_infra_port_discovery_binding) | **PUT** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Update Infra Port Discovery Profile Binding Map
[**update_infra_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#update_infra_segment_discovery_binding) | **PUT** /infra/segments/{infra-segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Update Infra Segment Discovery Profile Binding Map
[**update_port_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#update_port_discovery_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-discovery-profile-binding-maps/{port-discovery-profile-binding-map-id} | Update Port Discovery Profile Binding Map
[**update_segment_discovery_binding**](PolicyDiscoveryprofilebindingApi.md#update_segment_discovery_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-discovery-profile-binding-maps/{segment-discovery-profile-binding-map-id} | Update Segment Discovery Profile Binding Map


# **delete_infra_port_discovery_binding**
> delete_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id)

Delete Infra Port Discovery Profile Binding Profile

API will delete Infra Port Discovery Profile Binding Profile

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID


begin
  #Delete Infra Port Discovery Profile Binding Profile
  api_instance.delete_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->delete_infra_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment_discovery_binding**
> delete_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id)

Delete Segment Discovery Profile Binding Profile

API will delete Segment Discovery Profile Binding Profile

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID


begin
  #Delete Segment Discovery Profile Binding Profile
  api_instance.delete_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->delete_infra_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_port_discovery_binding**
> delete_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id)

Delete Port Discovery Profile Binding Profile

API will delete Port Discovery Profile Binding Profile

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID


begin
  #Delete Port Discovery Profile Binding Profile
  api_instance.delete_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->delete_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_segment_discovery_binding**
> delete_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id)

Delete Segment Discovery Profile Binding Profile

API will delete Segment Discovery Profile Binding Profile

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID


begin
  #Delete Segment Discovery Profile Binding Profile
  api_instance.delete_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->delete_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_port_discovery_binding**
> PortDiscoveryProfileBindingMap get_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id)

Get Infra Port Discovery Profile Binding Map

API will get Infra Port Discovery Profile Binding Map 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID


begin
  #Get Infra Port Discovery Profile Binding Map
  result = api_instance.get_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->get_infra_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 

### Return type

[**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_discovery_binding**
> SegmentDiscoveryProfileBindingMap get_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id)

Get Infra Segment Discovery Profile Binding Map

API will get Infra Segment Discovery Profile Binding Map 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID


begin
  #Get Infra Segment Discovery Profile Binding Map
  result = api_instance.get_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->get_infra_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 

### Return type

[**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_port_discovery_binding**
> PortDiscoveryProfileBindingMap get_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id)

Get Port Discovery Profile Binding Map

API will get Port Discovery Profile Binding Map 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID


begin
  #Get Port Discovery Profile Binding Map
  result = api_instance.get_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->get_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 

### Return type

[**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_discovery_binding**
> SegmentDiscoveryProfileBindingMap get_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id)

Get Segment Discovery Profile Binding Map

API will get Segment Discovery Profile Binding Map 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID


begin
  #Get Segment Discovery Profile Binding Map
  result = api_instance.get_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->get_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 

### Return type

[**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_port_discovery_bindings**
> PortDiscoveryProfileBindingMapListResult list_infra_port_discovery_bindings(infra_segment_id, infra_port_id, opts)

List Infra Port Discovery Profile Binding Maps

API will list all Infra Port Discovery Profile Binding Maps in current port id. 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | 

infra_port_id = 'infra_port_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Infra Port Discovery Profile Binding Maps
  result = api_instance.list_infra_port_discovery_bindings(infra_segment_id, infra_port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->list_infra_port_discovery_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**|  | 
 **infra_port_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortDiscoveryProfileBindingMapListResult**](PortDiscoveryProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_segment_discovery_bindings**
> SegmentDiscoveryProfileBindingMapListResult list_infra_segment_discovery_bindings(infra_segment_id, opts)

List Infra Segment Discovery Profile Binding Maps

API will list all Infra Segment Discovery Profile Binding Maps in current segment id. 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Infra Segment Discovery Profile Binding Maps
  result = api_instance.list_infra_segment_discovery_bindings(infra_segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->list_infra_segment_discovery_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentDiscoveryProfileBindingMapListResult**](SegmentDiscoveryProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_port_discovery_bindings**
> PortDiscoveryProfileBindingMapListResult list_port_discovery_bindings(tier_1_id, segment_id, port_id, opts)

List Port Discovery Profile Binding Maps

API will list all Port Discovery Profile Binding Maps in current port id. 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Port Discovery Profile Binding Maps
  result = api_instance.list_port_discovery_bindings(tier_1_id, segment_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->list_port_discovery_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortDiscoveryProfileBindingMapListResult**](PortDiscoveryProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_segment_discovery_bindings**
> SegmentDiscoveryProfileBindingMapListResult list_segment_discovery_bindings(tier_1_id, segment_id, opts)

List Segment Discovery Profile Binding Maps

API will list all Segment Discovery Profile Binding Maps in current segment id. 

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Segment Discovery Profile Binding Maps
  result = api_instance.list_segment_discovery_bindings(tier_1_id, segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->list_segment_discovery_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentDiscoveryProfileBindingMapListResult**](SegmentDiscoveryProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_port_discovery_binding**
> patch_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)

Create Infra Port Discovery Profile Binding Map

API will create Infra Port Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID

port_discovery_profile_binding_map = SwaggerClient::PortDiscoveryProfileBindingMap.new # PortDiscoveryProfileBindingMap | 


begin
  #Create Infra Port Discovery Profile Binding Map
  api_instance.patch_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->patch_infra_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 
 **port_discovery_profile_binding_map** | [**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment_discovery_binding**
> patch_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)

Create Infra Segment Discovery Profile Binding Map

API will create Infra Segment Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID

segment_discovery_profile_binding_map = SwaggerClient::SegmentDiscoveryProfileBindingMap.new # SegmentDiscoveryProfileBindingMap | 


begin
  #Create Infra Segment Discovery Profile Binding Map
  api_instance.patch_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->patch_infra_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 
 **segment_discovery_profile_binding_map** | [**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_port_discovery_binding**
> patch_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)

Create Port Discovery Profile Binding Map

API will create Port Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID

port_discovery_profile_binding_map = SwaggerClient::PortDiscoveryProfileBindingMap.new # PortDiscoveryProfileBindingMap | 


begin
  #Create Port Discovery Profile Binding Map
  api_instance.patch_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->patch_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 
 **port_discovery_profile_binding_map** | [**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_segment_discovery_binding**
> patch_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)

Create Segment Discovery Profile Binding Map

API will create Segment Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID

segment_discovery_profile_binding_map = SwaggerClient::SegmentDiscoveryProfileBindingMap.new # SegmentDiscoveryProfileBindingMap | 


begin
  #Create Segment Discovery Profile Binding Map
  api_instance.patch_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->patch_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 
 **segment_discovery_profile_binding_map** | [**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra_port_discovery_binding**
> PortDiscoveryProfileBindingMap update_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)

Update Infra Port Discovery Profile Binding Map

API will update Infra Port Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID

port_discovery_profile_binding_map = SwaggerClient::PortDiscoveryProfileBindingMap.new # PortDiscoveryProfileBindingMap | 


begin
  #Update Infra Port Discovery Profile Binding Map
  result = api_instance.update_infra_port_discovery_binding(infra_segment_id, infra_port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->update_infra_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 
 **port_discovery_profile_binding_map** | [**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)|  | 

### Return type

[**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra_segment_discovery_binding**
> SegmentDiscoveryProfileBindingMap update_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)

Update Infra Segment Discovery Profile Binding Map

API will update Infra Segment Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID

segment_discovery_profile_binding_map = SwaggerClient::SegmentDiscoveryProfileBindingMap.new # SegmentDiscoveryProfileBindingMap | 


begin
  #Update Infra Segment Discovery Profile Binding Map
  result = api_instance.update_infra_segment_discovery_binding(infra_segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->update_infra_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 
 **segment_discovery_profile_binding_map** | [**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)|  | 

### Return type

[**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_port_discovery_binding**
> PortDiscoveryProfileBindingMap update_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)

Update Port Discovery Profile Binding Map

API will update Port Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_discovery_profile_binding_map_id = 'port_discovery_profile_binding_map_id_example' # String | Port Discovery Profile Binding Map ID

port_discovery_profile_binding_map = SwaggerClient::PortDiscoveryProfileBindingMap.new # PortDiscoveryProfileBindingMap | 


begin
  #Update Port Discovery Profile Binding Map
  result = api_instance.update_port_discovery_binding(tier_1_id, segment_id, port_id, port_discovery_profile_binding_map_id, port_discovery_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->update_port_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_discovery_profile_binding_map_id** | **String**| Port Discovery Profile Binding Map ID | 
 **port_discovery_profile_binding_map** | [**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)|  | 

### Return type

[**PortDiscoveryProfileBindingMap**](PortDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_segment_discovery_binding**
> SegmentDiscoveryProfileBindingMap update_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)

Update Segment Discovery Profile Binding Map

API will update Segment Discovery Profile Binding Map

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

api_instance = SwaggerClient::PolicyDiscoveryprofilebindingApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_discovery_profile_binding_map_id = 'segment_discovery_profile_binding_map_id_example' # String | Segment Discovery Profile Binding Map ID

segment_discovery_profile_binding_map = SwaggerClient::SegmentDiscoveryProfileBindingMap.new # SegmentDiscoveryProfileBindingMap | 


begin
  #Update Segment Discovery Profile Binding Map
  result = api_instance.update_segment_discovery_binding(tier_1_id, segment_id, segment_discovery_profile_binding_map_id, segment_discovery_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDiscoveryprofilebindingApi->update_segment_discovery_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_discovery_profile_binding_map_id** | **String**| Segment Discovery Profile Binding Map ID | 
 **segment_discovery_profile_binding_map** | [**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)|  | 

### Return type

[**SegmentDiscoveryProfileBindingMap**](SegmentDiscoveryProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



