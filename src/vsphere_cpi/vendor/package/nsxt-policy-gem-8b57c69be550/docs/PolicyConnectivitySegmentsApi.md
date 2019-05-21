# SwaggerClient::PolicyConnectivitySegmentsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_infra_segment**](PolicyConnectivitySegmentsApi.md#create_or_replace_infra_segment) | **PUT** /infra/segments/{segment-id} | Create or update a infra segment
[**create_or_replace_segment**](PolicyConnectivitySegmentsApi.md#create_or_replace_segment) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id} | Create or update a segment
[**create_or_replace_static_arp_config**](PolicyConnectivitySegmentsApi.md#create_or_replace_static_arp_config) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/static-arp | Create or update a static ARP config
[**create_service_segment**](PolicyConnectivitySegmentsApi.md#create_service_segment) | **PUT** /infra/segments/service-segments/{service-segment-id} | Create service segment
[**delete_infra_segment**](PolicyConnectivitySegmentsApi.md#delete_infra_segment) | **DELETE** /infra/segments/{segment-id} | Delete infra segment
[**delete_segment**](PolicyConnectivitySegmentsApi.md#delete_segment) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id} | Delete segment
[**delete_service_segment**](PolicyConnectivitySegmentsApi.md#delete_service_segment) | **DELETE** /infra/segments/service-segments/{service-segment-id} | Delete Service Segment
[**delete_static_arp_config**](PolicyConnectivitySegmentsApi.md#delete_static_arp_config) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/static-arp | Delete static ARP config
[**get_infra_segment_port_statistics**](PolicyConnectivitySegmentsApi.md#get_infra_segment_port_statistics) | **GET** /infra/segments/{segments-id}/ports/{port-id}/statistics | Get infra segment port statistics information
[**get_infra_segment_statistics**](PolicyConnectivitySegmentsApi.md#get_infra_segment_statistics) | **GET** /infra/segments/{segments-id}/statistics | Get infra segment statistics information
[**get_segment_port_statistics**](PolicyConnectivitySegmentsApi.md#get_segment_port_statistics) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segments-id}/ports/{port-id}/statistics | Get segment port statistics information
[**get_segment_statistics**](PolicyConnectivitySegmentsApi.md#get_segment_statistics) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segments-id}/statistics | Get segment statistics information
[**list_all_infra_segments**](PolicyConnectivitySegmentsApi.md#list_all_infra_segments) | **GET** /infra/segments | List all segments under infra
[**list_segments**](PolicyConnectivitySegmentsApi.md#list_segments) | **GET** /infra/tier-1s/{tier-1-id}/segments | List all segments under tier-1 instance
[**list_service_segments**](PolicyConnectivitySegmentsApi.md#list_service_segments) | **GET** /infra/segments/service-segments | List Service Segments
[**patch_infra_segment**](PolicyConnectivitySegmentsApi.md#patch_infra_segment) | **PATCH** /infra/segments/{segment-id} | Create or update a segment
[**patch_segment**](PolicyConnectivitySegmentsApi.md#patch_segment) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id} | Create or update a segment
[**patch_service_segment**](PolicyConnectivitySegmentsApi.md#patch_service_segment) | **PATCH** /infra/segments/service-segments/{service-segment-id} | Create a service segment
[**patch_static_arp_config**](PolicyConnectivitySegmentsApi.md#patch_static_arp_config) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/static-arp | Create or update a static ARP config
[**read_infra_segment**](PolicyConnectivitySegmentsApi.md#read_infra_segment) | **GET** /infra/segments/{segment-id} | Read infra segment
[**read_segment**](PolicyConnectivitySegmentsApi.md#read_segment) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id} | Read segment
[**read_service_segment**](PolicyConnectivitySegmentsApi.md#read_service_segment) | **GET** /infra/segments/service-segments/{service-segment-id} | Read Service Segment
[**read_static_arp_config**](PolicyConnectivitySegmentsApi.md#read_static_arp_config) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/static-arp | Read static ARP config


# **create_or_replace_infra_segment**
> Segment create_or_replace_infra_segment(segment_id, segment)

Create or update a infra segment

If segment with the segment-id is not already present, create a new segment. If it already exists, replace the segment with this object. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

segment_id = 'segment_id_example' # String | Segment ID

segment = SwaggerClient::Segment.new # Segment | 


begin
  #Create or update a infra segment
  result = api_instance.create_or_replace_infra_segment(segment_id, segment)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->create_or_replace_infra_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **segment** | [**Segment**](Segment.md)|  | 

### Return type

[**Segment**](Segment.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_segment**
> Segment create_or_replace_segment(tier_1_id, segment_id, segment)

Create or update a segment

If segment with the segment-id is not already present, create a new segment. If it already exists, replace the segment with this object. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

segment = SwaggerClient::Segment.new # Segment | 


begin
  #Create or update a segment
  result = api_instance.create_or_replace_segment(tier_1_id, segment_id, segment)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->create_or_replace_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **segment** | [**Segment**](Segment.md)|  | 

### Return type

[**Segment**](Segment.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_static_arp_config**
> StaticARPConfig create_or_replace_static_arp_config(tier_1_id, segment_id, static_arp_config)

Create or update a static ARP config

Create static ARP config with Tier-1 and segment IDs provided if it doesn't exist, update with provided config if it's already created. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

static_arp_config = SwaggerClient::StaticARPConfig.new # StaticARPConfig | 


begin
  #Create or update a static ARP config
  result = api_instance.create_or_replace_static_arp_config(tier_1_id, segment_id, static_arp_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->create_or_replace_static_arp_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **static_arp_config** | [**StaticARPConfig**](StaticARPConfig.md)|  | 

### Return type

[**StaticARPConfig**](StaticARPConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_service_segment**
> ServiceSegment create_service_segment(service_segment_id, service_segment)

Create service segment

A service segment with the service-segment-id is created. Modification of service segment is not supported. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

service_segment_id = 'service_segment_id_example' # String | Service Segment ID

service_segment = SwaggerClient::ServiceSegment.new # ServiceSegment | 


begin
  #Create service segment
  result = api_instance.create_service_segment(service_segment_id, service_segment)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->create_service_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_segment_id** | **String**| Service Segment ID | 
 **service_segment** | [**ServiceSegment**](ServiceSegment.md)|  | 

### Return type

[**ServiceSegment**](ServiceSegment.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment**
> delete_infra_segment(segment_id)

Delete infra segment

Delete infra segment

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

segment_id = 'segment_id_example' # String | Segment ID


begin
  #Delete infra segment
  api_instance.delete_infra_segment(segment_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->delete_infra_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_segment**
> delete_segment(tier_1_id, segment_id)

Delete segment

Delete segment

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 


begin
  #Delete segment
  api_instance.delete_segment(tier_1_id, segment_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->delete_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_service_segment**
> delete_service_segment(service_segment_id)

Delete Service Segment

Delete Service Segment with given ID

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

service_segment_id = 'service_segment_id_example' # String | Service Segment ID


begin
  #Delete Service Segment
  api_instance.delete_service_segment(service_segment_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->delete_service_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_segment_id** | **String**| Service Segment ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_static_arp_config**
> delete_static_arp_config(tier_1_id, segment_id)

Delete static ARP config

Delete static ARP config

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 


begin
  #Delete static ARP config
  api_instance.delete_static_arp_config(tier_1_id, segment_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->delete_static_arp_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_port_statistics**
> SegmentPortStatistics get_infra_segment_port_statistics(segments_id, port_id, opts)

Get infra segment port statistics information

Get infra segment port statistics information. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

segments_id = 'segments_id_example' # String | 

port_id = 'port_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  edge_path: 'edge_path_example', # String | Policy path of edge node
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get infra segment port statistics information
  result = api_instance.get_infra_segment_port_statistics(segments_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->get_infra_segment_port_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segments_id** | **String**|  | 
 **port_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **edge_path** | **String**| Policy path of edge node | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentPortStatistics**](SegmentPortStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_statistics**
> SegmentStatistics get_infra_segment_statistics(segments_id, opts)

Get infra segment statistics information

Get infra segment statistics information. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

segments_id = 'segments_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  edge_path: 'edge_path_example', # String | Policy path of edge node
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get infra segment statistics information
  result = api_instance.get_infra_segment_statistics(segments_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->get_infra_segment_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segments_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **edge_path** | **String**| Policy path of edge node | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentStatistics**](SegmentStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_port_statistics**
> SegmentPortStatistics get_segment_port_statistics(tier_1_id, segments_id, port_id, opts)

Get segment port statistics information

Get tier1 segment port statistics information. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segments_id = 'segments_id_example' # String | 

port_id = 'port_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  edge_path: 'edge_path_example', # String | Policy path of edge node
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get segment port statistics information
  result = api_instance.get_segment_port_statistics(tier_1_id, segments_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->get_segment_port_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segments_id** | **String**|  | 
 **port_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **edge_path** | **String**| Policy path of edge node | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentPortStatistics**](SegmentPortStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_statistics**
> SegmentStatistics get_segment_statistics(tier_1_id, segments_id, opts)

Get segment statistics information

Get tier1 segment statistics information. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segments_id = 'segments_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  edge_path: 'edge_path_example', # String | Policy path of edge node
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get segment statistics information
  result = api_instance.get_segment_statistics(tier_1_id, segments_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->get_segment_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segments_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **edge_path** | **String**| Policy path of edge node | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentStatistics**](SegmentStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_all_infra_segments**
> SegmentListResult list_all_infra_segments(opts)

List all segments under infra

Paginated list of all segments under infra. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List all segments under infra
  result = api_instance.list_all_infra_segments(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->list_all_infra_segments: #{e}"
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

[**SegmentListResult**](SegmentListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_segments**
> SegmentListResult list_segments(tier_1_id, opts)

List all segments under tier-1 instance

Paginated list of all segments under Tier-1 instance 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

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
  #List all segments under tier-1 instance
  result = api_instance.list_segments(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->list_segments: #{e}"
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

[**SegmentListResult**](SegmentListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_service_segments**
> ServiceSegmentListResult list_service_segments(opts)

List Service Segments

Paginated list of all Service Segments 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Service Segments
  result = api_instance.list_service_segments(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->list_service_segments: #{e}"
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

[**ServiceSegmentListResult**](ServiceSegmentListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment**
> patch_infra_segment(segment_id, segment)

Create or update a segment

If segment with the segment-id is not already present, create a new segment. If it already exists, update the segment with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

segment_id = 'segment_id_example' # String | Segment ID

segment = SwaggerClient::Segment.new # Segment | 


begin
  #Create or update a segment
  api_instance.patch_infra_segment(segment_id, segment)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->patch_infra_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 
 **segment** | [**Segment**](Segment.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_segment**
> patch_segment(tier_1_id, segment_id, segment)

Create or update a segment

If segment with the segment-id is not already present, create a new segment. If it already exists, update the segment with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

segment = SwaggerClient::Segment.new # Segment | 


begin
  #Create or update a segment
  api_instance.patch_segment(tier_1_id, segment_id, segment)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->patch_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **segment** | [**Segment**](Segment.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_segment**
> patch_service_segment(service_segment_id, service_segment)

Create a service segment

A service segment with the service-segment-id is created. Modification of service segment is not supported. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

service_segment_id = 'service_segment_id_example' # String | Service Segment ID

service_segment = SwaggerClient::ServiceSegment.new # ServiceSegment | 


begin
  #Create a service segment
  api_instance.patch_service_segment(service_segment_id, service_segment)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->patch_service_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_segment_id** | **String**| Service Segment ID | 
 **service_segment** | [**ServiceSegment**](ServiceSegment.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_static_arp_config**
> patch_static_arp_config(tier_1_id, segment_id, static_arp_config)

Create or update a static ARP config

Create static ARP config with Tier-1 and segment IDs provided if it doesn't exist, update with provided config if it's already created. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

static_arp_config = SwaggerClient::StaticARPConfig.new # StaticARPConfig | 


begin
  #Create or update a static ARP config
  api_instance.patch_static_arp_config(tier_1_id, segment_id, static_arp_config)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->patch_static_arp_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **static_arp_config** | [**StaticARPConfig**](StaticARPConfig.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_infra_segment**
> Segment read_infra_segment(segment_id)

Read infra segment

Read infra segment

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

segment_id = 'segment_id_example' # String | Segment ID


begin
  #Read infra segment
  result = api_instance.read_infra_segment(segment_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->read_infra_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| Segment ID | 

### Return type

[**Segment**](Segment.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_segment**
> Segment read_segment(tier_1_id, segment_id)

Read segment

Read segment

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 


begin
  #Read segment
  result = api_instance.read_segment(tier_1_id, segment_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->read_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 

### Return type

[**Segment**](Segment.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_segment**
> ServiceSegment read_service_segment(service_segment_id)

Read Service Segment

Read a Service Segment with the given id

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

service_segment_id = 'service_segment_id_example' # String | Service Segment ID


begin
  #Read Service Segment
  result = api_instance.read_service_segment(service_segment_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->read_service_segment: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_segment_id** | **String**| Service Segment ID | 

### Return type

[**ServiceSegment**](ServiceSegment.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_static_arp_config**
> StaticARPConfig read_static_arp_config(tier_1_id, segment_id)

Read static ARP config

Read static ARP config

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 


begin
  #Read static ARP config
  result = api_instance.read_static_arp_config(tier_1_id, segment_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsApi->read_static_arp_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 

### Return type

[**StaticARPConfig**](StaticARPConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



