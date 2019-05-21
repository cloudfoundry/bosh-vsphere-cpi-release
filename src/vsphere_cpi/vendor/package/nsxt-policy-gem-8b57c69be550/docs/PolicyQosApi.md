# SwaggerClient::PolicyQosApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_qo_s_profile**](PolicyQosApi.md#create_or_replace_qo_s_profile) | **PUT** /infra/qos-profiles/{qos-profile-id} | Create or Replace QoS profile.
[**delete_infra_port_qo_s_binding**](PolicyQosApi.md#delete_infra_port_qo_s_binding) | **DELETE** /infra/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Delete Port QoS Profile Binding Profile
[**delete_infra_segment_qo_s_binding**](PolicyQosApi.md#delete_infra_segment_qo_s_binding) | **DELETE** /infra/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Delete Segment QoS Profile Binding Profile
[**delete_port_qo_s_binding**](PolicyQosApi.md#delete_port_qo_s_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Delete Port QoS Profile Binding Profile
[**delete_qo_s_profile**](PolicyQosApi.md#delete_qo_s_profile) | **DELETE** /infra/qos-profiles/{qos-profile-id} | Delete QoS profile
[**delete_segment_qo_s_binding**](PolicyQosApi.md#delete_segment_qo_s_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Delete Segment QoS Profile Binding Profile
[**get_infra_port_qo_s_binding**](PolicyQosApi.md#get_infra_port_qo_s_binding) | **GET** /infra/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Get Port QoS Profile Binding Map
[**get_infra_segment_qo_s_binding**](PolicyQosApi.md#get_infra_segment_qo_s_binding) | **GET** /infra/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Get Segment QoS Profile Binding Map
[**get_port_qo_s_binding**](PolicyQosApi.md#get_port_qo_s_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Get Port QoS Profile Binding Map
[**get_segment_qo_s_binding**](PolicyQosApi.md#get_segment_qo_s_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Get Segment QoS Profile Binding Map
[**list_infra_port_qo_s_bindings**](PolicyQosApi.md#list_infra_port_qo_s_bindings) | **GET** /infra/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps | List Port QoS Profile Binding Maps
[**list_infra_segment_qo_s_bindings**](PolicyQosApi.md#list_infra_segment_qo_s_bindings) | **GET** /infra/segments/{segment-id}/segment-qos-profile-binding-maps | List Segment QoS Profile Binding Maps
[**list_port_qo_s_bindings**](PolicyQosApi.md#list_port_qo_s_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps | List Port QoS Profile Binding Maps
[**list_qo_s_profiles**](PolicyQosApi.md#list_qo_s_profiles) | **GET** /infra/qos-profiles | List QoS Profiles
[**list_segment_qo_s_bindings**](PolicyQosApi.md#list_segment_qo_s_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-qos-profile-binding-maps | List Segment QoS Profile Binding Maps
[**patch_infra_port_qo_s_binding**](PolicyQosApi.md#patch_infra_port_qo_s_binding) | **PATCH** /infra/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Create Port QoS Profile Binding Map
[**patch_infra_segment_qo_s_binding**](PolicyQosApi.md#patch_infra_segment_qo_s_binding) | **PATCH** /infra/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Create Segment QoS Profile Binding Map
[**patch_port_qo_s_binding**](PolicyQosApi.md#patch_port_qo_s_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Create Port QoS Profile Binding Map
[**patch_qo_s_profile**](PolicyQosApi.md#patch_qo_s_profile) | **PATCH** /infra/qos-profiles/{qos-profile-id} | Patch QoS profile.
[**patch_segment_qo_s_binding**](PolicyQosApi.md#patch_segment_qo_s_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Create Segment QoS Profile Binding Map
[**read_qo_s_profile**](PolicyQosApi.md#read_qo_s_profile) | **GET** /infra/qos-profiles/{qos-profile-id} | Details of QoS profile 
[**update_infra_port_qo_s_binding**](PolicyQosApi.md#update_infra_port_qo_s_binding) | **PUT** /infra/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Update Port QoS Profile Binding Map
[**update_infra_segment_qo_s_binding**](PolicyQosApi.md#update_infra_segment_qo_s_binding) | **PUT** /infra/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Update Segment QoS Profile Binding Map
[**update_port_qo_s_binding**](PolicyQosApi.md#update_port_qo_s_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-qos-profile-binding-maps/{port-qos-profile-binding-map-id} | Update Port QoS Profile Binding Map
[**update_segment_qo_s_binding**](PolicyQosApi.md#update_segment_qo_s_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-qos-profile-binding-maps/{segment-qos-profile-binding-map-id} | Update Segment QoS Profile Binding Map


# **create_or_replace_qo_s_profile**
> QoSProfile create_or_replace_qo_s_profile(qos_profile_id, qo_s_profile)

Create or Replace QoS profile.

Create or Replace QoS profile. 

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

api_instance = SwaggerClient::PolicyQosApi.new

qos_profile_id = 'qos_profile_id_example' # String | QoS profile Id

qo_s_profile = SwaggerClient::QoSProfile.new # QoSProfile | 


begin
  #Create or Replace QoS profile.
  result = api_instance.create_or_replace_qo_s_profile(qos_profile_id, qo_s_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->create_or_replace_qo_s_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **qos_profile_id** | **String**| QoS profile Id | 
 **qo_s_profile** | [**QoSProfile**](QoSProfile.md)|  | 

### Return type

[**QoSProfile**](QoSProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_port_qo_s_binding**
> delete_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id)

Delete Port QoS Profile Binding Profile

API will delete Port QoS Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID


begin
  #Delete Port QoS Profile Binding Profile
  api_instance.delete_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->delete_infra_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment_qo_s_binding**
> delete_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id)

Delete Segment QoS Profile Binding Profile

API will delete Segment QoS Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID


begin
  #Delete Segment QoS Profile Binding Profile
  api_instance.delete_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->delete_infra_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_port_qo_s_binding**
> delete_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id)

Delete Port QoS Profile Binding Profile

API will delete Port QoS Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID


begin
  #Delete Port QoS Profile Binding Profile
  api_instance.delete_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->delete_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_qo_s_profile**
> delete_qo_s_profile(qos_profile_id)

Delete QoS profile

API will delete QoS profile. 

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

api_instance = SwaggerClient::PolicyQosApi.new

qos_profile_id = 'qos_profile_id_example' # String | QoS profile Id


begin
  #Delete QoS profile
  api_instance.delete_qo_s_profile(qos_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->delete_qo_s_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **qos_profile_id** | **String**| QoS profile Id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_segment_qo_s_binding**
> delete_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id)

Delete Segment QoS Profile Binding Profile

API will delete Segment QoS Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID


begin
  #Delete Segment QoS Profile Binding Profile
  api_instance.delete_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->delete_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_port_qo_s_binding**
> PortQoSProfileBindingMap get_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id)

Get Port QoS Profile Binding Map

API will get Port QoS Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID


begin
  #Get Port QoS Profile Binding Map
  result = api_instance.get_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->get_infra_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 

### Return type

[**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_qo_s_binding**
> SegmentQoSProfileBindingMap get_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id)

Get Segment QoS Profile Binding Map

API will get Segment QoS Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID


begin
  #Get Segment QoS Profile Binding Map
  result = api_instance.get_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->get_infra_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 

### Return type

[**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_port_qo_s_binding**
> PortQoSProfileBindingMap get_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id)

Get Port QoS Profile Binding Map

API will get Port QoS Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID


begin
  #Get Port QoS Profile Binding Map
  result = api_instance.get_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->get_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 

### Return type

[**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_qo_s_binding**
> SegmentQoSProfileBindingMap get_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id)

Get Segment QoS Profile Binding Map

API will get Segment QoS Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID


begin
  #Get Segment QoS Profile Binding Map
  result = api_instance.get_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->get_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 

### Return type

[**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_port_qo_s_bindings**
> PortQoSProfileBindingMapListResult list_infra_port_qo_s_bindings(segment_id, port_id, opts)

List Port QoS Profile Binding Maps

API will list all Port QoS Profile Binding Maps in current port id. 

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Port QoS Profile Binding Maps
  result = api_instance.list_infra_port_qo_s_bindings(segment_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->list_infra_port_qo_s_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortQoSProfileBindingMapListResult**](PortQoSProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_segment_qo_s_bindings**
> SegmentQoSProfileBindingMapListResult list_infra_segment_qo_s_bindings(segment_id, opts)

List Segment QoS Profile Binding Maps

API will list all Segment QoS Profile Binding Maps in current segment id. 

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Segment QoS Profile Binding Maps
  result = api_instance.list_infra_segment_qo_s_bindings(segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->list_infra_segment_qo_s_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentQoSProfileBindingMapListResult**](SegmentQoSProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_port_qo_s_bindings**
> PortQoSProfileBindingMapListResult list_port_qo_s_bindings(tier_1_id, segment_id, port_id, opts)

List Port QoS Profile Binding Maps

API will list all Port QoS Profile Binding Maps in current port id. 

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Port QoS Profile Binding Maps
  result = api_instance.list_port_qo_s_bindings(tier_1_id, segment_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->list_port_qo_s_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortQoSProfileBindingMapListResult**](PortQoSProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_qo_s_profiles**
> QoSProfileListResult list_qo_s_profiles(opts)

List QoS Profiles

API will list all QoS profiles. 

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

api_instance = SwaggerClient::PolicyQosApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List QoS Profiles
  result = api_instance.list_qo_s_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->list_qo_s_profiles: #{e}"
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

[**QoSProfileListResult**](QoSProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_segment_qo_s_bindings**
> SegmentQoSProfileBindingMapListResult list_segment_qo_s_bindings(tier_1_id, segment_id, opts)

List Segment QoS Profile Binding Maps

API will list all Segment QoS Profile Binding Maps in current segment id. 

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Segment QoS Profile Binding Maps
  result = api_instance.list_segment_qo_s_bindings(tier_1_id, segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->list_segment_qo_s_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentQoSProfileBindingMapListResult**](SegmentQoSProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_port_qo_s_binding**
> patch_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)

Create Port QoS Profile Binding Map

API will create Port QoS Profile Binding Map.

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID

port_qo_s_profile_binding_map = SwaggerClient::PortQoSProfileBindingMap.new # PortQoSProfileBindingMap | 


begin
  #Create Port QoS Profile Binding Map
  api_instance.patch_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->patch_infra_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 
 **port_qo_s_profile_binding_map** | [**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment_qo_s_binding**
> patch_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)

Create Segment QoS Profile Binding Map

API will create segment QoS profile binding map.

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID

segment_qo_s_profile_binding_map = SwaggerClient::SegmentQoSProfileBindingMap.new # SegmentQoSProfileBindingMap | 


begin
  #Create Segment QoS Profile Binding Map
  api_instance.patch_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->patch_infra_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 
 **segment_qo_s_profile_binding_map** | [**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_port_qo_s_binding**
> patch_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)

Create Port QoS Profile Binding Map

API will create Port QoS Profile Binding Map.

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID

port_qo_s_profile_binding_map = SwaggerClient::PortQoSProfileBindingMap.new # PortQoSProfileBindingMap | 


begin
  #Create Port QoS Profile Binding Map
  api_instance.patch_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->patch_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 
 **port_qo_s_profile_binding_map** | [**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_qo_s_profile**
> patch_qo_s_profile(qos_profile_id, qo_s_profile)

Patch QoS profile.

Create a new QoS profile if the QoS profile with given id does not already exist. If the QoS profile with the given id already exists, patch with the existing QoS profile. 

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

api_instance = SwaggerClient::PolicyQosApi.new

qos_profile_id = 'qos_profile_id_example' # String | QoS profile Id

qo_s_profile = SwaggerClient::QoSProfile.new # QoSProfile | 


begin
  #Patch QoS profile.
  api_instance.patch_qo_s_profile(qos_profile_id, qo_s_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->patch_qo_s_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **qos_profile_id** | **String**| QoS profile Id | 
 **qo_s_profile** | [**QoSProfile**](QoSProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_segment_qo_s_binding**
> patch_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)

Create Segment QoS Profile Binding Map

API will create segment QoS profile binding map.

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID

segment_qo_s_profile_binding_map = SwaggerClient::SegmentQoSProfileBindingMap.new # SegmentQoSProfileBindingMap | 


begin
  #Create Segment QoS Profile Binding Map
  api_instance.patch_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->patch_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 
 **segment_qo_s_profile_binding_map** | [**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_qo_s_profile**
> QoSProfile read_qo_s_profile(qos_profile_id)

Details of QoS profile 

API will return details of QoS profile. 

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

api_instance = SwaggerClient::PolicyQosApi.new

qos_profile_id = 'qos_profile_id_example' # String | QoS profile Id


begin
  #Details of QoS profile 
  result = api_instance.read_qo_s_profile(qos_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->read_qo_s_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **qos_profile_id** | **String**| QoS profile Id | 

### Return type

[**QoSProfile**](QoSProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra_port_qo_s_binding**
> PortQoSProfileBindingMap update_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)

Update Port QoS Profile Binding Map

API will update Port QoS Profile Binding Map.

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID

port_qo_s_profile_binding_map = SwaggerClient::PortQoSProfileBindingMap.new # PortQoSProfileBindingMap | 


begin
  #Update Port QoS Profile Binding Map
  result = api_instance.update_infra_port_qo_s_binding(segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->update_infra_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 
 **port_qo_s_profile_binding_map** | [**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)|  | 

### Return type

[**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra_segment_qo_s_binding**
> SegmentQoSProfileBindingMap update_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)

Update Segment QoS Profile Binding Map

API will update Segment QoS Profile Binding Map.

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

api_instance = SwaggerClient::PolicyQosApi.new

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID

segment_qo_s_profile_binding_map = SwaggerClient::SegmentQoSProfileBindingMap.new # SegmentQoSProfileBindingMap | 


begin
  #Update Segment QoS Profile Binding Map
  result = api_instance.update_infra_segment_qo_s_binding(segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->update_infra_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 
 **segment_qo_s_profile_binding_map** | [**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)|  | 

### Return type

[**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_port_qo_s_binding**
> PortQoSProfileBindingMap update_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)

Update Port QoS Profile Binding Map

API will update Port QoS Profile Binding Map.

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_qos_profile_binding_map_id = 'port_qos_profile_binding_map_id_example' # String | Port QoS Profile Binding Map ID

port_qo_s_profile_binding_map = SwaggerClient::PortQoSProfileBindingMap.new # PortQoSProfileBindingMap | 


begin
  #Update Port QoS Profile Binding Map
  result = api_instance.update_port_qo_s_binding(tier_1_id, segment_id, port_id, port_qos_profile_binding_map_id, port_qo_s_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->update_port_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_qos_profile_binding_map_id** | **String**| Port QoS Profile Binding Map ID | 
 **port_qo_s_profile_binding_map** | [**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)|  | 

### Return type

[**PortQoSProfileBindingMap**](PortQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_segment_qo_s_binding**
> SegmentQoSProfileBindingMap update_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)

Update Segment QoS Profile Binding Map

API will update Segment QoS Profile Binding Map.

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

api_instance = SwaggerClient::PolicyQosApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_qos_profile_binding_map_id = 'segment_qos_profile_binding_map_id_example' # String | Segment QoS Profile Binding Map ID

segment_qo_s_profile_binding_map = SwaggerClient::SegmentQoSProfileBindingMap.new # SegmentQoSProfileBindingMap | 


begin
  #Update Segment QoS Profile Binding Map
  result = api_instance.update_segment_qo_s_binding(tier_1_id, segment_id, segment_qos_profile_binding_map_id, segment_qo_s_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyQosApi->update_segment_qo_s_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_qos_profile_binding_map_id** | **String**| Segment QoS Profile Binding Map ID | 
 **segment_qo_s_profile_binding_map** | [**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)|  | 

### Return type

[**SegmentQoSProfileBindingMap**](SegmentQoSProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



