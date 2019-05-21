# SwaggerClient::PolicyConnectivityTier1InterfacesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_tier1_interface**](PolicyConnectivityTier1InterfacesApi.md#create_or_replace_tier1_interface) | **PUT** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id}/interfaces/{interface-id} | Create or update a tier-1 interface
[**delete_tier1_interface**](PolicyConnectivityTier1InterfacesApi.md#delete_tier1_interface) | **DELETE** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id}/interfaces/{interface-id} | Delete Tier-1 interface
[**list_tier1_interfaces**](PolicyConnectivityTier1InterfacesApi.md#list_tier1_interfaces) | **GET** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id}/interfaces | List Tier-1 interfaces
[**patch_tier1_interface**](PolicyConnectivityTier1InterfacesApi.md#patch_tier1_interface) | **PATCH** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id}/interfaces/{interface-id} | Create or update a Tier-1 interface
[**read_tier1_interface**](PolicyConnectivityTier1InterfacesApi.md#read_tier1_interface) | **GET** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id}/interfaces/{interface-id} | Read Tier-1 interface


# **create_or_replace_tier1_interface**
> Tier1Interface create_or_replace_tier1_interface(tier_1_id, locale_services_id, interface_id, tier1_interface)

Create or update a tier-1 interface

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

api_instance = SwaggerClient::PolicyConnectivityTier1InterfacesApi.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

interface_id = 'interface_id_example' # String | 

tier1_interface = SwaggerClient::Tier1Interface.new # Tier1Interface | 


begin
  #Create or update a tier-1 interface
  result = api_instance.create_or_replace_tier1_interface(tier_1_id, locale_services_id, interface_id, tier1_interface)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1InterfacesApi->create_or_replace_tier1_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **tier1_interface** | [**Tier1Interface**](Tier1Interface.md)|  | 

### Return type

[**Tier1Interface**](Tier1Interface.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier1_interface**
> delete_tier1_interface(tier_1_id, locale_services_id, interface_id)

Delete Tier-1 interface

Delete Tier-1 interface

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

api_instance = SwaggerClient::PolicyConnectivityTier1InterfacesApi.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

interface_id = 'interface_id_example' # String | 


begin
  #Delete Tier-1 interface
  api_instance.delete_tier1_interface(tier_1_id, locale_services_id, interface_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1InterfacesApi->delete_tier1_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **interface_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier1_interfaces**
> Tier1InterfaceListResult list_tier1_interfaces(tier_1_id, locale_services_id, opts)

List Tier-1 interfaces

Paginated list of all Tier-1 interfaces 

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

api_instance = SwaggerClient::PolicyConnectivityTier1InterfacesApi.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Tier-1 interfaces
  result = api_instance.list_tier1_interfaces(tier_1_id, locale_services_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1InterfacesApi->list_tier1_interfaces: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**Tier1InterfaceListResult**](Tier1InterfaceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier1_interface**
> patch_tier1_interface(tier_1_id, locale_services_id, interface_id, tier1_interface)

Create or update a Tier-1 interface

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

api_instance = SwaggerClient::PolicyConnectivityTier1InterfacesApi.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

interface_id = 'interface_id_example' # String | 

tier1_interface = SwaggerClient::Tier1Interface.new # Tier1Interface | 


begin
  #Create or update a Tier-1 interface
  api_instance.patch_tier1_interface(tier_1_id, locale_services_id, interface_id, tier1_interface)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1InterfacesApi->patch_tier1_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **tier1_interface** | [**Tier1Interface**](Tier1Interface.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier1_interface**
> Tier1Interface read_tier1_interface(tier_1_id, locale_services_id, interface_id)

Read Tier-1 interface

Read Tier-1 interface

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

api_instance = SwaggerClient::PolicyConnectivityTier1InterfacesApi.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

interface_id = 'interface_id_example' # String | 


begin
  #Read Tier-1 interface
  result = api_instance.read_tier1_interface(tier_1_id, locale_services_id, interface_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1InterfacesApi->read_tier1_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **interface_id** | **String**|  | 

### Return type

[**Tier1Interface**](Tier1Interface.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



