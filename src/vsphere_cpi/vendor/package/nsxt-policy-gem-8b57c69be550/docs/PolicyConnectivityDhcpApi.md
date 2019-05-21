# SwaggerClient::PolicyConnectivityDhcpApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_dhcp_relay_config**](PolicyConnectivityDhcpApi.md#create_or_replace_dhcp_relay_config) | **PUT** /infra/dhcp-relay-configs/{dhcp-relay-config-id} | Create or update DHCP relay configuration
[**create_or_replace_dhcp_server_config**](PolicyConnectivityDhcpApi.md#create_or_replace_dhcp_server_config) | **PUT** /infra/dhcp-server-configs/{dhcp-server-config-id} | Create or update DHCP server configuration
[**delete_dhcp_relay_config**](PolicyConnectivityDhcpApi.md#delete_dhcp_relay_config) | **DELETE** /infra/dhcp-relay-configs/{dhcp-relay-config-id} | Delete DHCP relay configuration
[**delete_dhcp_server_config**](PolicyConnectivityDhcpApi.md#delete_dhcp_server_config) | **DELETE** /infra/dhcp-server-configs/{dhcp-server-config-id} | Delete DHCP server configuration
[**list_dhcp_relay_config**](PolicyConnectivityDhcpApi.md#list_dhcp_relay_config) | **GET** /infra/dhcp-relay-configs | List DHCP relay config instances
[**list_dhcp_server_config**](PolicyConnectivityDhcpApi.md#list_dhcp_server_config) | **GET** /infra/dhcp-server-configs | List DHCP server config instances
[**patch_dhcp_relay_config**](PolicyConnectivityDhcpApi.md#patch_dhcp_relay_config) | **PATCH** /infra/dhcp-relay-configs/{dhcp-relay-config-id} | Create or update DHCP relay configuration
[**patch_dhcp_server_config**](PolicyConnectivityDhcpApi.md#patch_dhcp_server_config) | **PATCH** /infra/dhcp-server-configs/{dhcp-server-config-id} | Create or update DHCP server configuration
[**read_dhcp_relay_config**](PolicyConnectivityDhcpApi.md#read_dhcp_relay_config) | **GET** /infra/dhcp-relay-configs/{dhcp-relay-config-id} | Read DHCP relay configuration
[**read_dhcp_server_config**](PolicyConnectivityDhcpApi.md#read_dhcp_server_config) | **GET** /infra/dhcp-server-configs/{dhcp-server-config-id} | Read DHCP server configuration


# **create_or_replace_dhcp_relay_config**
> DhcpRelayConfig create_or_replace_dhcp_relay_config(dhcp_relay_config_id, dhcp_relay_config)

Create or update DHCP relay configuration

If DHCP relay config with the dhcp-relay-config-id is not already present, create a new DHCP relay config instance. If it already exists, replace the DHCP relay config instance with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_relay_config_id = 'dhcp_relay_config_id_example' # String | DHCP relay config ID

dhcp_relay_config = SwaggerClient::DhcpRelayConfig.new # DhcpRelayConfig | 


begin
  #Create or update DHCP relay configuration
  result = api_instance.create_or_replace_dhcp_relay_config(dhcp_relay_config_id, dhcp_relay_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->create_or_replace_dhcp_relay_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_relay_config_id** | **String**| DHCP relay config ID | 
 **dhcp_relay_config** | [**DhcpRelayConfig**](DhcpRelayConfig.md)|  | 

### Return type

[**DhcpRelayConfig**](DhcpRelayConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_dhcp_server_config**
> DhcpServerConfig create_or_replace_dhcp_server_config(dhcp_server_config_id, dhcp_server_config)

Create or update DHCP server configuration

If DHCP server config with the dhcp-server-config-id is not already present, create a new DHCP server config instance. If it already exists, replace the DHCP server config instance with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_server_config_id = 'dhcp_server_config_id_example' # String | DHCP server config ID

dhcp_server_config = SwaggerClient::DhcpServerConfig.new # DhcpServerConfig | 


begin
  #Create or update DHCP server configuration
  result = api_instance.create_or_replace_dhcp_server_config(dhcp_server_config_id, dhcp_server_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->create_or_replace_dhcp_server_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_server_config_id** | **String**| DHCP server config ID | 
 **dhcp_server_config** | [**DhcpServerConfig**](DhcpServerConfig.md)|  | 

### Return type

[**DhcpServerConfig**](DhcpServerConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_dhcp_relay_config**
> delete_dhcp_relay_config(dhcp_relay_config_id)

Delete DHCP relay configuration

Delete DHCP relay configuration

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_relay_config_id = 'dhcp_relay_config_id_example' # String | DHCP relay config ID


begin
  #Delete DHCP relay configuration
  api_instance.delete_dhcp_relay_config(dhcp_relay_config_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->delete_dhcp_relay_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_relay_config_id** | **String**| DHCP relay config ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_dhcp_server_config**
> delete_dhcp_server_config(dhcp_server_config_id)

Delete DHCP server configuration

Delete DHCP server configuration

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_server_config_id = 'dhcp_server_config_id_example' # String | DHCP server config ID


begin
  #Delete DHCP server configuration
  api_instance.delete_dhcp_server_config(dhcp_server_config_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->delete_dhcp_server_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_server_config_id** | **String**| DHCP server config ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_dhcp_relay_config**
> DhcpRelayConfigListResult list_dhcp_relay_config(opts)

List DHCP relay config instances

Paginated list of all DHCP relay config instances 

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List DHCP relay config instances
  result = api_instance.list_dhcp_relay_config(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->list_dhcp_relay_config: #{e}"
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

[**DhcpRelayConfigListResult**](DhcpRelayConfigListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_dhcp_server_config**
> DhcpServerConfigListResult list_dhcp_server_config(opts)

List DHCP server config instances

Paginated list of all DHCP server config instances 

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List DHCP server config instances
  result = api_instance.list_dhcp_server_config(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->list_dhcp_server_config: #{e}"
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

[**DhcpServerConfigListResult**](DhcpServerConfigListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_dhcp_relay_config**
> patch_dhcp_relay_config(dhcp_relay_config_id, dhcp_relay_config)

Create or update DHCP relay configuration

If DHCP relay config with the dhcp-relay-config-id is not already present, create a new DHCP relay config instance. If it already exists, update the DHCP relay config instance with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_relay_config_id = 'dhcp_relay_config_id_example' # String | DHCP relay config ID

dhcp_relay_config = SwaggerClient::DhcpRelayConfig.new # DhcpRelayConfig | 


begin
  #Create or update DHCP relay configuration
  api_instance.patch_dhcp_relay_config(dhcp_relay_config_id, dhcp_relay_config)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->patch_dhcp_relay_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_relay_config_id** | **String**| DHCP relay config ID | 
 **dhcp_relay_config** | [**DhcpRelayConfig**](DhcpRelayConfig.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_dhcp_server_config**
> patch_dhcp_server_config(dhcp_server_config_id, dhcp_server_config)

Create or update DHCP server configuration

If DHCP server config with the dhcp-server-config-id is not already present, create a new DHCP server config instance. If it already exists, update the DHCP server config instance with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_server_config_id = 'dhcp_server_config_id_example' # String | DHCP server config ID

dhcp_server_config = SwaggerClient::DhcpServerConfig.new # DhcpServerConfig | 


begin
  #Create or update DHCP server configuration
  api_instance.patch_dhcp_server_config(dhcp_server_config_id, dhcp_server_config)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->patch_dhcp_server_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_server_config_id** | **String**| DHCP server config ID | 
 **dhcp_server_config** | [**DhcpServerConfig**](DhcpServerConfig.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_dhcp_relay_config**
> DhcpRelayConfig read_dhcp_relay_config(dhcp_relay_config_id)

Read DHCP relay configuration

Read DHCP relay configuration

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_relay_config_id = 'dhcp_relay_config_id_example' # String | DHCP relay config ID


begin
  #Read DHCP relay configuration
  result = api_instance.read_dhcp_relay_config(dhcp_relay_config_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->read_dhcp_relay_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_relay_config_id** | **String**| DHCP relay config ID | 

### Return type

[**DhcpRelayConfig**](DhcpRelayConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_dhcp_server_config**
> DhcpServerConfig read_dhcp_server_config(dhcp_server_config_id)

Read DHCP server configuration

Read DHCP server configuration

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

api_instance = SwaggerClient::PolicyConnectivityDhcpApi.new

dhcp_server_config_id = 'dhcp_server_config_id_example' # String | DHCP server config ID


begin
  #Read DHCP server configuration
  result = api_instance.read_dhcp_server_config(dhcp_server_config_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityDhcpApi->read_dhcp_server_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dhcp_server_config_id** | **String**| DHCP server config ID | 

### Return type

[**DhcpServerConfig**](DhcpServerConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



