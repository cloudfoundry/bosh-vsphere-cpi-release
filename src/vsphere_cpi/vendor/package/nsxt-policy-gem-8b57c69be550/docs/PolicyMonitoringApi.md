# SwaggerClient::PolicyMonitoringApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_group_monitoring_binding**](PolicyMonitoringApi.md#delete_group_monitoring_binding) | **DELETE** /infra/domains/{domain-id}/groups/{group-id}/group-monitoring-profile-binding-maps/{group-monitoring-profile-binding-map-id} | Delete Group Monitoring Profile Binding
[**delete_infra_port_monitoring_binding**](PolicyMonitoringApi.md#delete_infra_port_monitoring_binding) | **DELETE** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Delete Infra Port Monitoring Profile Binding Profile
[**delete_infra_segment_monitoring_binding**](PolicyMonitoringApi.md#delete_infra_segment_monitoring_binding) | **DELETE** /infra/segments/{infra-segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Delete Infra Segment Monitoring Profile Binding Profile
[**delete_port_monitoring_binding**](PolicyMonitoringApi.md#delete_port_monitoring_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Delete Port Monitoring Profile Binding Profile
[**delete_segment_monitoring_binding**](PolicyMonitoringApi.md#delete_segment_monitoring_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Delete Segment Monitoring Profile Binding Profile
[**get_group_monitoring_binding**](PolicyMonitoringApi.md#get_group_monitoring_binding) | **GET** /infra/domains/{domain-id}/groups/{group-id}/group-monitoring-profile-binding-maps/{group-monitoring-profile-binding-map-id} | Get Group Monitoring Profile Binding Map
[**get_infra_port_monitoring_binding**](PolicyMonitoringApi.md#get_infra_port_monitoring_binding) | **GET** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Get Infra Port Monitoring Profile Binding Map
[**get_infra_segment_monitoring_binding**](PolicyMonitoringApi.md#get_infra_segment_monitoring_binding) | **GET** /infra/segments/{infra-segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Get Infra Segment Monitoring Profile Binding Map
[**get_port_monitoring_binding**](PolicyMonitoringApi.md#get_port_monitoring_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Get Port Monitoring Profile Binding Map
[**get_segment_monitoring_binding**](PolicyMonitoringApi.md#get_segment_monitoring_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Get Segment Monitoring Profile Binding Map
[**list_group_monitoring_bindings**](PolicyMonitoringApi.md#list_group_monitoring_bindings) | **GET** /infra/domains/{domain-id}/groups/{group-id}/group-monitoring-profile-binding-maps | List Group Monitoring Profile Binding Maps
[**list_infra_port_monitoring_bindings**](PolicyMonitoringApi.md#list_infra_port_monitoring_bindings) | **GET** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-monitoring-profile-binding-maps | List Infra Port Monitoring Profile Binding Maps
[**list_infra_segment_monitoring_bindings**](PolicyMonitoringApi.md#list_infra_segment_monitoring_bindings) | **GET** /infra/segments/{infra-segment-id}/segment-monitoring-profile-binding-maps | List Infra Segment Monitoring Profile Binding Maps
[**list_port_monitoring_bindings**](PolicyMonitoringApi.md#list_port_monitoring_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-monitoring-profile-binding-maps | List Port Monitoring Profile Binding Maps
[**list_segment_monitoring_bindings**](PolicyMonitoringApi.md#list_segment_monitoring_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-monitoring-profile-binding-maps | List Segment Monitoring Profile Binding Maps
[**patch_group_monitoring_binding**](PolicyMonitoringApi.md#patch_group_monitoring_binding) | **PATCH** /infra/domains/{domain-id}/groups/{group-id}/group-monitoring-profile-binding-maps/{group-monitoring-profile-binding-map-id} | Create Group Monitoring Profile Binding Map
[**patch_infra_port_monitoring_binding**](PolicyMonitoringApi.md#patch_infra_port_monitoring_binding) | **PATCH** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Create Infra Port Monitoring Profile Binding Map
[**patch_infra_segment_monitoring_binding**](PolicyMonitoringApi.md#patch_infra_segment_monitoring_binding) | **PATCH** /infra/segments/{infra-segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Create Infra Segment Monitoring Profile Binding Map
[**patch_port_monitoring_binding**](PolicyMonitoringApi.md#patch_port_monitoring_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Create Port Monitoring Profile Binding Map
[**patch_segment_monitoring_binding**](PolicyMonitoringApi.md#patch_segment_monitoring_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Create Segment Monitoring Profile Binding Map
[**update_group_monitoring_binding**](PolicyMonitoringApi.md#update_group_monitoring_binding) | **PUT** /infra/domains/{domain-id}/groups/{group-id}/group-monitoring-profile-binding-maps/{group-monitoring-profile-binding-map-id} | Update Group Monitoring Profile Binding Map
[**update_infra_port_monitoring_binding**](PolicyMonitoringApi.md#update_infra_port_monitoring_binding) | **PUT** /infra/segments/{infra-segment-id}/ports/{infra-port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Update Infra Port Monitoring Profile Binding Map
[**update_infra_segment_monitoring_binding**](PolicyMonitoringApi.md#update_infra_segment_monitoring_binding) | **PUT** /infra/segments/{infra-segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Update Infra Segment Monitoring Profile Binding Map
[**update_port_monitoring_binding**](PolicyMonitoringApi.md#update_port_monitoring_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-monitoring-profile-binding-maps/{port-monitoring-profile-binding-map-id} | Update Port Monitoring Profile Binding Map
[**update_segment_monitoring_binding**](PolicyMonitoringApi.md#update_segment_monitoring_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-monitoring-profile-binding-maps/{segment-monitoring-profile-binding-map-id} | Update Segment Monitoring Profile Binding Map


# **delete_group_monitoring_binding**
> delete_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id)

Delete Group Monitoring Profile Binding

API will delete Group Monitoring Profile Binding

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

group_monitoring_profile_binding_map_id = 'group_monitoring_profile_binding_map_id_example' # String | Group Monitoring Profile Binding Map ID


begin
  #Delete Group Monitoring Profile Binding
  api_instance.delete_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->delete_group_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **group_monitoring_profile_binding_map_id** | **String**| Group Monitoring Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_port_monitoring_binding**
> delete_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id)

Delete Infra Port Monitoring Profile Binding Profile

API will delete Infra Port Monitoring Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID


begin
  #Delete Infra Port Monitoring Profile Binding Profile
  api_instance.delete_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->delete_infra_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment_monitoring_binding**
> delete_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id)

Delete Infra Segment Monitoring Profile Binding Profile

API will delete Infra Segment Monitoring Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID


begin
  #Delete Infra Segment Monitoring Profile Binding Profile
  api_instance.delete_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->delete_infra_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_port_monitoring_binding**
> delete_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id)

Delete Port Monitoring Profile Binding Profile

API will delete Port Monitoring Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID


begin
  #Delete Port Monitoring Profile Binding Profile
  api_instance.delete_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->delete_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_segment_monitoring_binding**
> delete_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id)

Delete Segment Monitoring Profile Binding Profile

API will delete Segment Monitoring Profile Binding Profile.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID


begin
  #Delete Segment Monitoring Profile Binding Profile
  api_instance.delete_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->delete_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_monitoring_binding**
> GroupMonitoringProfileBindingMap get_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id)

Get Group Monitoring Profile Binding Map

API will get Group Monitoring Profile Binding Map 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

domain_id = 'domain_id_example' # String | Domain-ID

group_id = 'group_id_example' # String | Group ID

group_monitoring_profile_binding_map_id = 'group_monitoring_profile_binding_map_id_example' # String | Group Monitoring Profile Binding Map ID


begin
  #Get Group Monitoring Profile Binding Map
  result = api_instance.get_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->get_group_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain-ID | 
 **group_id** | **String**| Group ID | 
 **group_monitoring_profile_binding_map_id** | **String**| Group Monitoring Profile Binding Map ID | 

### Return type

[**GroupMonitoringProfileBindingMap**](GroupMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_port_monitoring_binding**
> PortMonitoringProfileBindingMap get_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id)

Get Infra Port Monitoring Profile Binding Map

API will get Infra Port Monitoring Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID


begin
  #Get Infra Port Monitoring Profile Binding Map
  result = api_instance.get_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->get_infra_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 

### Return type

[**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_monitoring_binding**
> SegmentMonitoringProfileBindingMap get_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id)

Get Infra Segment Monitoring Profile Binding Map

API will get Infra Segment Monitoring Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID


begin
  #Get Infra Segment Monitoring Profile Binding Map
  result = api_instance.get_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->get_infra_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 

### Return type

[**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_port_monitoring_binding**
> PortMonitoringProfileBindingMap get_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id)

Get Port Monitoring Profile Binding Map

API will get Port Monitoring Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID


begin
  #Get Port Monitoring Profile Binding Map
  result = api_instance.get_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->get_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 

### Return type

[**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_monitoring_binding**
> SegmentMonitoringProfileBindingMap get_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id)

Get Segment Monitoring Profile Binding Map

API will get Segment Monitoring Profile Binding Map. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID


begin
  #Get Segment Monitoring Profile Binding Map
  result = api_instance.get_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->get_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 

### Return type

[**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_group_monitoring_bindings**
> GroupMonitoringProfileBindingMapListResult list_group_monitoring_bindings(domain_id, group_id, opts)

List Group Monitoring Profile Binding Maps

API will list all Group Monitoring Profile Binding Maps in current group id. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

domain_id = 'domain_id_example' # String | 

group_id = 'group_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Group Monitoring Profile Binding Maps
  result = api_instance.list_group_monitoring_bindings(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->list_group_monitoring_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **group_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GroupMonitoringProfileBindingMapListResult**](GroupMonitoringProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_port_monitoring_bindings**
> PortMonitoringProfileBindingMapListResult list_infra_port_monitoring_bindings(infra_segment_id, infra_port_id, opts)

List Infra Port Monitoring Profile Binding Maps

API will list all Infra Port Monitoring Profile Binding Maps in current port id. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

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
  #List Infra Port Monitoring Profile Binding Maps
  result = api_instance.list_infra_port_monitoring_bindings(infra_segment_id, infra_port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->list_infra_port_monitoring_bindings: #{e}"
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

[**PortMonitoringProfileBindingMapListResult**](PortMonitoringProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_segment_monitoring_bindings**
> SegmentMonitoringProfileBindingMapListResult list_infra_segment_monitoring_bindings(infra_segment_id, opts)

List Infra Segment Monitoring Profile Binding Maps

API will list all Infra Segment Monitoring Profile Binding Maps in current segment id. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

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
  #List Infra Segment Monitoring Profile Binding Maps
  result = api_instance.list_infra_segment_monitoring_bindings(infra_segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->list_infra_segment_monitoring_bindings: #{e}"
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

[**SegmentMonitoringProfileBindingMapListResult**](SegmentMonitoringProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_port_monitoring_bindings**
> PortMonitoringProfileBindingMapListResult list_port_monitoring_bindings(tier_1_id, segment_id, port_id, opts)

List Port Monitoring Profile Binding Maps

API will list all Port Monitoring Profile Binding Maps in current port id. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

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
  #List Port Monitoring Profile Binding Maps
  result = api_instance.list_port_monitoring_bindings(tier_1_id, segment_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->list_port_monitoring_bindings: #{e}"
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

[**PortMonitoringProfileBindingMapListResult**](PortMonitoringProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_segment_monitoring_bindings**
> SegmentMonitoringProfileBindingMapListResult list_segment_monitoring_bindings(tier_1_id, segment_id, opts)

List Segment Monitoring Profile Binding Maps

API will list all Segment Monitoring Profile Binding Maps in current segment id. 

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

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
  #List Segment Monitoring Profile Binding Maps
  result = api_instance.list_segment_monitoring_bindings(tier_1_id, segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->list_segment_monitoring_bindings: #{e}"
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

[**SegmentMonitoringProfileBindingMapListResult**](SegmentMonitoringProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_group_monitoring_binding**
> patch_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id, group_monitoring_profile_binding_map)

Create Group Monitoring Profile Binding Map

API will create group monitoring profile binding map

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

group_monitoring_profile_binding_map_id = 'group_monitoring_profile_binding_map_id_example' # String | Group Monitoring Profile Binding Map ID

group_monitoring_profile_binding_map = SwaggerClient::GroupMonitoringProfileBindingMap.new # GroupMonitoringProfileBindingMap | 


begin
  #Create Group Monitoring Profile Binding Map
  api_instance.patch_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id, group_monitoring_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->patch_group_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **group_monitoring_profile_binding_map_id** | **String**| Group Monitoring Profile Binding Map ID | 
 **group_monitoring_profile_binding_map** | [**GroupMonitoringProfileBindingMap**](GroupMonitoringProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_port_monitoring_binding**
> patch_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)

Create Infra Port Monitoring Profile Binding Map

API will create Infra Port Monitoring Profile Binding Map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID

port_monitoring_profile_binding_map = SwaggerClient::PortMonitoringProfileBindingMap.new # PortMonitoringProfileBindingMap | 


begin
  #Create Infra Port Monitoring Profile Binding Map
  api_instance.patch_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->patch_infra_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 
 **port_monitoring_profile_binding_map** | [**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment_monitoring_binding**
> patch_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)

Create Infra Segment Monitoring Profile Binding Map

API will create infra segment monitoring profile binding map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID

segment_monitoring_profile_binding_map = SwaggerClient::SegmentMonitoringProfileBindingMap.new # SegmentMonitoringProfileBindingMap | 


begin
  #Create Infra Segment Monitoring Profile Binding Map
  api_instance.patch_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->patch_infra_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 
 **segment_monitoring_profile_binding_map** | [**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_port_monitoring_binding**
> patch_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)

Create Port Monitoring Profile Binding Map

API will create Port Monitoring Profile Binding Map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID

port_monitoring_profile_binding_map = SwaggerClient::PortMonitoringProfileBindingMap.new # PortMonitoringProfileBindingMap | 


begin
  #Create Port Monitoring Profile Binding Map
  api_instance.patch_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->patch_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 
 **port_monitoring_profile_binding_map** | [**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_segment_monitoring_binding**
> patch_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)

Create Segment Monitoring Profile Binding Map

API will create segment monitoring profile binding map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID

segment_monitoring_profile_binding_map = SwaggerClient::SegmentMonitoringProfileBindingMap.new # SegmentMonitoringProfileBindingMap | 


begin
  #Create Segment Monitoring Profile Binding Map
  api_instance.patch_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->patch_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 
 **segment_monitoring_profile_binding_map** | [**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_group_monitoring_binding**
> GroupMonitoringProfileBindingMap update_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id, group_monitoring_profile_binding_map)

Update Group Monitoring Profile Binding Map

API will update Group Monitoring Profile Binding Map

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

domain_id = 'domain_id_example' # String | DomainID

group_id = 'group_id_example' # String | Group ID

group_monitoring_profile_binding_map_id = 'group_monitoring_profile_binding_map_id_example' # String | Group Monitoring Profile Binding Map ID

group_monitoring_profile_binding_map = SwaggerClient::GroupMonitoringProfileBindingMap.new # GroupMonitoringProfileBindingMap | 


begin
  #Update Group Monitoring Profile Binding Map
  result = api_instance.update_group_monitoring_binding(domain_id, group_id, group_monitoring_profile_binding_map_id, group_monitoring_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->update_group_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| DomainID | 
 **group_id** | **String**| Group ID | 
 **group_monitoring_profile_binding_map_id** | **String**| Group Monitoring Profile Binding Map ID | 
 **group_monitoring_profile_binding_map** | [**GroupMonitoringProfileBindingMap**](GroupMonitoringProfileBindingMap.md)|  | 

### Return type

[**GroupMonitoringProfileBindingMap**](GroupMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra_port_monitoring_binding**
> PortMonitoringProfileBindingMap update_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)

Update Infra Port Monitoring Profile Binding Map

API will update Infra Port Monitoring Profile Binding Map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | InfraSegment ID

infra_port_id = 'infra_port_id_example' # String | Infra Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID

port_monitoring_profile_binding_map = SwaggerClient::PortMonitoringProfileBindingMap.new # PortMonitoringProfileBindingMap | 


begin
  #Update Infra Port Monitoring Profile Binding Map
  result = api_instance.update_infra_port_monitoring_binding(infra_segment_id, infra_port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->update_infra_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| InfraSegment ID | 
 **infra_port_id** | **String**| Infra Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 
 **port_monitoring_profile_binding_map** | [**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)|  | 

### Return type

[**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra_segment_monitoring_binding**
> SegmentMonitoringProfileBindingMap update_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)

Update Infra Segment Monitoring Profile Binding Map

API will update Infra Segment Monitoring Profile Binding Map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

infra_segment_id = 'infra_segment_id_example' # String | Infra Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID

segment_monitoring_profile_binding_map = SwaggerClient::SegmentMonitoringProfileBindingMap.new # SegmentMonitoringProfileBindingMap | 


begin
  #Update Infra Segment Monitoring Profile Binding Map
  result = api_instance.update_infra_segment_monitoring_binding(infra_segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->update_infra_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra_segment_id** | **String**| Infra Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 
 **segment_monitoring_profile_binding_map** | [**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)|  | 

### Return type

[**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_port_monitoring_binding**
> PortMonitoringProfileBindingMap update_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)

Update Port Monitoring Profile Binding Map

API will update Port Monitoring Profile Binding Map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

port_id = 'port_id_example' # String | Port ID

port_monitoring_profile_binding_map_id = 'port_monitoring_profile_binding_map_id_example' # String | Port Monitoring Profile Binding Map ID

port_monitoring_profile_binding_map = SwaggerClient::PortMonitoringProfileBindingMap.new # PortMonitoringProfileBindingMap | 


begin
  #Update Port Monitoring Profile Binding Map
  result = api_instance.update_port_monitoring_binding(tier_1_id, segment_id, port_id, port_monitoring_profile_binding_map_id, port_monitoring_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->update_port_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **port_id** | **String**| Port ID | 
 **port_monitoring_profile_binding_map_id** | **String**| Port Monitoring Profile Binding Map ID | 
 **port_monitoring_profile_binding_map** | [**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)|  | 

### Return type

[**PortMonitoringProfileBindingMap**](PortMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_segment_monitoring_binding**
> SegmentMonitoringProfileBindingMap update_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)

Update Segment Monitoring Profile Binding Map

API will update Segment Monitoring Profile Binding Map.

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

api_instance = SwaggerClient::PolicyMonitoringApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

segment_id = 'segment_id_example' # String | Segment ID

segment_monitoring_profile_binding_map_id = 'segment_monitoring_profile_binding_map_id_example' # String | Segment Monitoring Profile Binding Map ID

segment_monitoring_profile_binding_map = SwaggerClient::SegmentMonitoringProfileBindingMap.new # SegmentMonitoringProfileBindingMap | 


begin
  #Update Segment Monitoring Profile Binding Map
  result = api_instance.update_segment_monitoring_binding(tier_1_id, segment_id, segment_monitoring_profile_binding_map_id, segment_monitoring_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyMonitoringApi->update_segment_monitoring_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **segment_id** | **String**| Segment ID | 
 **segment_monitoring_profile_binding_map_id** | **String**| Segment Monitoring Profile Binding Map ID | 
 **segment_monitoring_profile_binding_map** | [**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)|  | 

### Return type

[**SegmentMonitoringProfileBindingMap**](SegmentMonitoringProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



