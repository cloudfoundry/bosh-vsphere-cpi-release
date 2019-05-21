# SwaggerClient::PolicyLoadbalancerRuntimeApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_lb_pool_statistics**](PolicyLoadbalancerRuntimeApi.md#get_lb_pool_statistics) | **GET** /infra/lb-services/{lb-service-id}/lb-pools/{lb-pool-id}/statistics | Get LBPool statistics information
[**get_lb_pool_status**](PolicyLoadbalancerRuntimeApi.md#get_lb_pool_status) | **GET** /infra/lb-services/{lb-service-id}/lb-pools/{lb-pool-id}/detailed-status | Get LBPool status information
[**get_lb_service_statistics**](PolicyLoadbalancerRuntimeApi.md#get_lb_service_statistics) | **GET** /infra/lb-services/{lb-service-id}/statistics | Get LBService statistics information
[**get_lb_service_status**](PolicyLoadbalancerRuntimeApi.md#get_lb_service_status) | **GET** /infra/lb-services/{lb-service-id}/detailed-status | Get LBService status information
[**get_lb_service_usage**](PolicyLoadbalancerRuntimeApi.md#get_lb_service_usage) | **GET** /infra/lb-services/{lb-service-id}/service-usage | Get LBService usage information
[**get_lb_virtual_server_statistics**](PolicyLoadbalancerRuntimeApi.md#get_lb_virtual_server_statistics) | **GET** /infra/lb-services/{lb-service-id}/lb-virtual-servers/{lb-virtual-server-id}/statistics | Get LBVirtualServer statistics information
[**get_lb_virtual_server_status**](PolicyLoadbalancerRuntimeApi.md#get_lb_virtual_server_status) | **GET** /infra/lb-services/{lb-service-id}/lb-virtual-servers/{lb-virtual-server-id}/detailed-status | Get LBVirtualServer status information


# **get_lb_pool_statistics**
> AggregateLBPoolStatistics get_lb_pool_statistics(lb_service_id, lb_pool_id, opts)

Get LBPool statistics information

Get LBPoolStatistics information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

lb_pool_id = 'lb_pool_id_example' # String | LBPool id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBPool statistics information
  result = api_instance.get_lb_pool_statistics(lb_service_id, lb_pool_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_pool_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **lb_pool_id** | **String**| LBPool id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBPoolStatistics**](AggregateLBPoolStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_lb_pool_status**
> AggregateLBPoolStatus get_lb_pool_status(lb_service_id, lb_pool_id, opts)

Get LBPool status information

Get LBPool detailed status information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

lb_pool_id = 'lb_pool_id_example' # String | LBPool id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBPool status information
  result = api_instance.get_lb_pool_status(lb_service_id, lb_pool_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_pool_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **lb_pool_id** | **String**| LBPool id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBPoolStatus**](AggregateLBPoolStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_lb_service_statistics**
> AggregateLBServiceStatistics get_lb_service_statistics(lb_service_id, opts)

Get LBService statistics information

Get LBServiceStatistics information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBService statistics information
  result = api_instance.get_lb_service_statistics(lb_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_service_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBServiceStatistics**](AggregateLBServiceStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_lb_service_status**
> AggregateLBServiceStatus get_lb_service_status(lb_service_id, opts)

Get LBService status information

Get LBService detailed status information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBService status information
  result = api_instance.get_lb_service_status(lb_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_service_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBServiceStatus**](AggregateLBServiceStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_lb_service_usage**
> AggregateLBServiceUsage get_lb_service_usage(lb_service_id, opts)

Get LBService usage information

Get LBServiceUsage information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBService usage information
  result = api_instance.get_lb_service_usage(lb_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_service_usage: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBServiceUsage**](AggregateLBServiceUsage.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_lb_virtual_server_statistics**
> AggregateLBVirtualServerStatistics get_lb_virtual_server_statistics(lb_service_id, lb_virtual_server_id, opts)

Get LBVirtualServer statistics information

Get LBVirtualServerStatistics information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

lb_virtual_server_id = 'lb_virtual_server_id_example' # String | LBVirtualServer id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBVirtualServer statistics information
  result = api_instance.get_lb_virtual_server_statistics(lb_service_id, lb_virtual_server_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_virtual_server_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **lb_virtual_server_id** | **String**| LBVirtualServer id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBVirtualServerStatistics**](AggregateLBVirtualServerStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_lb_virtual_server_status**
> AggregateLBVirtualServerStatus get_lb_virtual_server_status(lb_service_id, lb_virtual_server_id, opts)

Get LBVirtualServer status information

Get LBVirtualServer detailed status information. - no enforcement point path specified: Information will be aggregated from each enforcement point. - {enforcement_point_path}: Information will be retrieved only from the given enforcement point. 

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

api_instance = SwaggerClient::PolicyLoadbalancerRuntimeApi.new

lb_service_id = 'lb_service_id_example' # String | LBService id

lb_virtual_server_id = 'lb_virtual_server_id_example' # String | LBVirtualServer id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get LBVirtualServer status information
  result = api_instance.get_lb_virtual_server_status(lb_service_id, lb_virtual_server_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerRuntimeApi->get_lb_virtual_server_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService id | 
 **lb_virtual_server_id** | **String**| LBVirtualServer id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateLBVirtualServerStatus**](AggregateLBVirtualServerStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



