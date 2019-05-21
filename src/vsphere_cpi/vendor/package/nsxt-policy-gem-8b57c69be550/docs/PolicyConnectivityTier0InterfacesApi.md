# SwaggerClient::PolicyConnectivityTier0InterfacesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_tier0_interface**](PolicyConnectivityTier0InterfacesApi.md#create_or_replace_tier0_interface) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/interfaces/{interface-id} | Create or update a Tier-0 interface
[**delete_service_interface**](PolicyConnectivityTier0InterfacesApi.md#delete_service_interface) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-interfaces/{interface-id} | Delete service interface
[**delete_tier0_interface**](PolicyConnectivityTier0InterfacesApi.md#delete_tier0_interface) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/interfaces/{interface-id} | Delete Tier-0 interface
[**list_service_interfaces**](PolicyConnectivityTier0InterfacesApi.md#list_service_interfaces) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-interfaces | List Service Interfaces
[**list_tier0_interfaces**](PolicyConnectivityTier0InterfacesApi.md#list_tier0_interfaces) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/interfaces | List Tier-0 Interfaces
[**patch_service_interface**](PolicyConnectivityTier0InterfacesApi.md#patch_service_interface) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-interfaces/{interface-id} | Create or update a Tier-0 interface
[**patch_tier0_interface**](PolicyConnectivityTier0InterfacesApi.md#patch_tier0_interface) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/interfaces/{interface-id} | Create or update a Tier-0 interface
[**read_service_interface**](PolicyConnectivityTier0InterfacesApi.md#read_service_interface) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-interfaces/{interface-id} | Read service interface
[**read_tier0_interface**](PolicyConnectivityTier0InterfacesApi.md#read_tier0_interface) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/interfaces/{interface-id} | Read Tier-0 interface


# **create_or_replace_tier0_interface**
> Tier0Interface create_or_replace_tier0_interface(tier_0_id, locale_service_id, interface_id, tier0_interface)

Create or update a Tier-0 interface

If an interface with the interface-id is not already present, create a new interface. If it already exists, replace the interface with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 

tier0_interface = SwaggerClient::Tier0Interface.new # Tier0Interface | 


begin
  #Create or update a Tier-0 interface
  result = api_instance.create_or_replace_tier0_interface(tier_0_id, locale_service_id, interface_id, tier0_interface)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->create_or_replace_tier0_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **tier0_interface** | [**Tier0Interface**](Tier0Interface.md)|  | 

### Return type

[**Tier0Interface**](Tier0Interface.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_service_interface**
> delete_service_interface(tier_0_id, locale_service_id, interface_id)

Delete service interface

Delete service interface

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 


begin
  #Delete service interface
  api_instance.delete_service_interface(tier_0_id, locale_service_id, interface_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->delete_service_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier0_interface**
> delete_tier0_interface(tier_0_id, locale_service_id, interface_id)

Delete Tier-0 interface

Delete Tier-0 interface

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 


begin
  #Delete Tier-0 interface
  api_instance.delete_tier0_interface(tier_0_id, locale_service_id, interface_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->delete_tier0_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_service_interfaces**
> ServiceInterfaceListResult list_service_interfaces(tier_0_id, locale_service_id, opts)

List Service Interfaces

Paginated list of all Service Interfaces 

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

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
  #List Service Interfaces
  result = api_instance.list_service_interfaces(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->list_service_interfaces: #{e}"
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

[**ServiceInterfaceListResult**](ServiceInterfaceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier0_interfaces**
> Tier0InterfaceListResult list_tier0_interfaces(tier_0_id, locale_service_id, opts)

List Tier-0 Interfaces

Paginated list of all Tier-0 Interfaces 

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

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
  #List Tier-0 Interfaces
  result = api_instance.list_tier0_interfaces(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->list_tier0_interfaces: #{e}"
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

[**Tier0InterfaceListResult**](Tier0InterfaceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_interface**
> patch_service_interface(tier_0_id, locale_service_id, interface_id, service_interface)

Create or update a Tier-0 interface

If an interface with the interface-id is not already present, create a new interface. If it already exists, update the interface for specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 

service_interface = SwaggerClient::ServiceInterface.new # ServiceInterface | 


begin
  #Create or update a Tier-0 interface
  api_instance.patch_service_interface(tier_0_id, locale_service_id, interface_id, service_interface)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->patch_service_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **service_interface** | [**ServiceInterface**](ServiceInterface.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier0_interface**
> patch_tier0_interface(tier_0_id, locale_service_id, interface_id, tier0_interface)

Create or update a Tier-0 interface

If an interface with the interface-id is not already present, create a new interface. If it already exists, update the interface for specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 

tier0_interface = SwaggerClient::Tier0Interface.new # Tier0Interface | 


begin
  #Create or update a Tier-0 interface
  api_instance.patch_tier0_interface(tier_0_id, locale_service_id, interface_id, tier0_interface)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->patch_tier0_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **tier0_interface** | [**Tier0Interface**](Tier0Interface.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_interface**
> ServiceInterface read_service_interface(tier_0_id, locale_service_id, interface_id)

Read service interface

Read service interface

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 


begin
  #Read service interface
  result = api_instance.read_service_interface(tier_0_id, locale_service_id, interface_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->read_service_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 

### Return type

[**ServiceInterface**](ServiceInterface.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier0_interface**
> Tier0Interface read_tier0_interface(tier_0_id, locale_service_id, interface_id)

Read Tier-0 interface

Read Tier-0 interface

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

api_instance = SwaggerClient::PolicyConnectivityTier0InterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 


begin
  #Read Tier-0 interface
  result = api_instance.read_tier0_interface(tier_0_id, locale_service_id, interface_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0InterfacesApi->read_tier0_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 

### Return type

[**Tier0Interface**](Tier0Interface.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



