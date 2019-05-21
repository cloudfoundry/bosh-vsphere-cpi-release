# SwaggerClient::PolicyConnectivitySegmentsPortsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_infra_segment_port**](PolicyConnectivitySegmentsPortsApi.md#create_or_replace_infra_segment_port) | **PUT** /infra/segments/{segment-id}/ports/{port-id} | Create or update an infra segment port
[**create_or_replace_tier1_segment_port**](PolicyConnectivitySegmentsPortsApi.md#create_or_replace_tier1_segment_port) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id} | Create or update a Tier-1 segment port
[**delete_infra_segment_port**](PolicyConnectivitySegmentsPortsApi.md#delete_infra_segment_port) | **DELETE** /infra/segments/{segment-id}/ports/{port-id} | Delete an infra segment port
[**delete_tier1_segment_port**](PolicyConnectivitySegmentsPortsApi.md#delete_tier1_segment_port) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id} | Delete a Tier-1 segment port
[**get_infra_segment_port**](PolicyConnectivitySegmentsPortsApi.md#get_infra_segment_port) | **GET** /infra/segments/{segment-id}/ports/{port-id} | Get infra segment port by ID
[**get_tier1_segment_port**](PolicyConnectivitySegmentsPortsApi.md#get_tier1_segment_port) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id} | Get Tier-1 segment port by ID
[**list_infra_segment_ports**](PolicyConnectivitySegmentsPortsApi.md#list_infra_segment_ports) | **GET** /infra/segments/{segment-id}/ports | List infra segment ports
[**list_tier1_segment_ports**](PolicyConnectivitySegmentsPortsApi.md#list_tier1_segment_ports) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports | List Tier-1 segment ports
[**patch_infra_segment_port**](PolicyConnectivitySegmentsPortsApi.md#patch_infra_segment_port) | **PATCH** /infra/segments/{segment-id}/ports/{port-id} | Patch an infra segment port
[**patch_tier1_segment_port**](PolicyConnectivitySegmentsPortsApi.md#patch_tier1_segment_port) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id} | Patch a Tier-1 segment port


# **create_or_replace_infra_segment_port**
> SegmentPort create_or_replace_infra_segment_port(segment_id, port_id, segment_port)

Create or update an infra segment port

Create an infra segment port if it does not exist based on the IDs, or update existing port information by replacing the port object already exists. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

segment_port = SwaggerClient::SegmentPort.new # SegmentPort | 


begin
  #Create or update an infra segment port
  result = api_instance.create_or_replace_infra_segment_port(segment_id, port_id, segment_port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->create_or_replace_infra_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **segment_port** | [**SegmentPort**](SegmentPort.md)|  | 

### Return type

[**SegmentPort**](SegmentPort.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_tier1_segment_port**
> SegmentPort create_or_replace_tier1_segment_port(tier_1_id, segment_id, port_id, segment_port)

Create or update a Tier-1 segment port

Create a Tier-1 segment port if it does not exist based on the IDs, or update existing port information by replacing the port object already exists. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

segment_port = SwaggerClient::SegmentPort.new # SegmentPort | 


begin
  #Create or update a Tier-1 segment port
  result = api_instance.create_or_replace_tier1_segment_port(tier_1_id, segment_id, port_id, segment_port)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->create_or_replace_tier1_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **segment_port** | [**SegmentPort**](SegmentPort.md)|  | 

### Return type

[**SegmentPort**](SegmentPort.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment_port**
> delete_infra_segment_port(segment_id, port_id)

Delete an infra segment port

Delete an infra segment port by giving ID. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 


begin
  #Delete an infra segment port
  api_instance.delete_infra_segment_port(segment_id, port_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->delete_infra_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier1_segment_port**
> delete_tier1_segment_port(tier_1_id, segment_id, port_id)

Delete a Tier-1 segment port

Delete a Tier-1 segment port by giving ID. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 


begin
  #Delete a Tier-1 segment port
  api_instance.delete_tier1_segment_port(tier_1_id, segment_id, port_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->delete_tier1_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_port**
> SegmentPort get_infra_segment_port(segment_id, port_id)

Get infra segment port by ID

Get detail information on an infra segment port by giving ID. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 


begin
  #Get infra segment port by ID
  result = api_instance.get_infra_segment_port(segment_id, port_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->get_infra_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 

### Return type

[**SegmentPort**](SegmentPort.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier1_segment_port**
> SegmentPort get_tier1_segment_port(tier_1_id, segment_id, port_id)

Get Tier-1 segment port by ID

Get detail information on a Tier-1 segment port by giving ID. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 


begin
  #Get Tier-1 segment port by ID
  result = api_instance.get_tier1_segment_port(tier_1_id, segment_id, port_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->get_tier1_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 

### Return type

[**SegmentPort**](SegmentPort.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_segment_ports**
> SegmentPortListResult list_infra_segment_ports(segment_id, opts)

List infra segment ports

List all the ports for an infra. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

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
  #List infra segment ports
  result = api_instance.list_infra_segment_ports(segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->list_infra_segment_ports: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentPortListResult**](SegmentPortListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier1_segment_ports**
> SegmentPortListResult list_tier1_segment_ports(tier_1_id, segment_id, opts)

List Tier-1 segment ports

List all the ports for a Tier-1 segment. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

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
  #List Tier-1 segment ports
  result = api_instance.list_tier1_segment_ports(tier_1_id, segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->list_tier1_segment_ports: #{e}"
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

[**SegmentPortListResult**](SegmentPortListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment_port**
> patch_infra_segment_port(segment_id, port_id, segment_port)

Patch an infra segment port

Create an infra segment port if it does not exist based on the IDs, or update existing port information by replacing the port object fields which presents in the request body. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

segment_port = SwaggerClient::SegmentPort.new # SegmentPort | 


begin
  #Patch an infra segment port
  api_instance.patch_infra_segment_port(segment_id, port_id, segment_port)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->patch_infra_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **segment_port** | [**SegmentPort**](SegmentPort.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier1_segment_port**
> patch_tier1_segment_port(tier_1_id, segment_id, port_id, segment_port)

Patch a Tier-1 segment port

Create a Tier-1 segment port if it does not exist based on the IDs, or update existing port information by replacing the port object fields which presents in the request body. 

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

api_instance = SwaggerClient::PolicyConnectivitySegmentsPortsApi.new

tier_1_id = 'tier_1_id_example' # String | 

segment_id = 'segment_id_example' # String | 

port_id = 'port_id_example' # String | 

segment_port = SwaggerClient::SegmentPort.new # SegmentPort | 


begin
  #Patch a Tier-1 segment port
  api_instance.patch_tier1_segment_port(tier_1_id, segment_id, port_id, segment_port)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivitySegmentsPortsApi->patch_tier1_segment_port: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **segment_id** | **String**|  | 
 **port_id** | **String**|  | 
 **segment_port** | [**SegmentPort**](SegmentPort.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



