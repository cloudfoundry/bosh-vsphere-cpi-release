# SwaggerClient::PolicyConnectivityTier1Api

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_tier1**](PolicyConnectivityTier1Api.md#create_or_replace_tier1) | **PUT** /infra/tier-1s/{tier-1-id} | Create or update tier-1 configuration
[**create_or_replace_tier1_locale_services**](PolicyConnectivityTier1Api.md#create_or_replace_tier1_locale_services) | **PUT** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id} | Create or update a Tier-1 locale-services
[**delete_tier1**](PolicyConnectivityTier1Api.md#delete_tier1) | **DELETE** /infra/tier-1s/{tier-1-id} | Delete Tier-1 configuration
[**delete_tier1_locale_services**](PolicyConnectivityTier1Api.md#delete_tier1_locale_services) | **DELETE** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id} | Delete Tier-1 locale-services
[**get_tier1_interface_statistics**](PolicyConnectivityTier1Api.md#get_tier1_interface_statistics) | **GET** /infra/tier-1s/{tier-1-id}/locale-services/{locale-service-id}/interfaces/{interface-id}/statistics | Get segment statistics information
[**list_tier1**](PolicyConnectivityTier1Api.md#list_tier1) | **GET** /infra/tier-1s | List Tier-1 instances
[**list_tier1_locale_services**](PolicyConnectivityTier1Api.md#list_tier1_locale_services) | **GET** /infra/tier-1s/{tier-1-id}/locale-services | List Tier-1 locale-services
[**patch_tier1**](PolicyConnectivityTier1Api.md#patch_tier1) | **PATCH** /infra/tier-1s/{tier-1-id} | Create or update Tier-1 configuration
[**patch_tier1_locale_services**](PolicyConnectivityTier1Api.md#patch_tier1_locale_services) | **PATCH** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id} | Create or update a Tier-1 locale-services
[**read_tier1**](PolicyConnectivityTier1Api.md#read_tier1) | **GET** /infra/tier-1s/{tier-1-id} | Read Tier-1 configuration
[**read_tier1_locale_services**](PolicyConnectivityTier1Api.md#read_tier1_locale_services) | **GET** /infra/tier-1s/{tier-1-id}/locale-services/{locale-services-id} | Read Tier-1 locale-services


# **create_or_replace_tier1**
> Tier1 create_or_replace_tier1(tier_1_id, tier1)

Create or update tier-1 configuration

If Tier-1 with the tier-1-id is not already present, create a new Tier-1 instance. If it already exists, replace the Tier-1 instance with this object. 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

tier1 = SwaggerClient::Tier1.new # Tier1 | 


begin
  #Create or update tier-1 configuration
  result = api_instance.create_or_replace_tier1(tier_1_id, tier1)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->create_or_replace_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **tier1** | [**Tier1**](Tier1.md)|  | 

### Return type

[**Tier1**](Tier1.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_tier1_locale_services**
> LocaleServices create_or_replace_tier1_locale_services(tier_1_id, locale_services_id, locale_services)

Create or update a Tier-1 locale-services

If a Tier-1 locale services with the locale-services-id is not already present, create a new locale-services. If it already exists, replace the Tier-1 locale services instance with the new object. 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

locale_services = SwaggerClient::LocaleServices.new # LocaleServices | 


begin
  #Create or update a Tier-1 locale-services
  result = api_instance.create_or_replace_tier1_locale_services(tier_1_id, locale_services_id, locale_services)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->create_or_replace_tier1_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **locale_services** | [**LocaleServices**](LocaleServices.md)|  | 

### Return type

[**LocaleServices**](LocaleServices.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier1**
> delete_tier1(tier_1_id)

Delete Tier-1 configuration

Delete Tier-1 configuration

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 


begin
  #Delete Tier-1 configuration
  api_instance.delete_tier1(tier_1_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->delete_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier1_locale_services**
> delete_tier1_locale_services(tier_1_id, locale_services_id)

Delete Tier-1 locale-services

Delete Tier-1 locale-services

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 


begin
  #Delete Tier-1 locale-services
  api_instance.delete_tier1_locale_services(tier_1_id, locale_services_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->delete_tier1_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier1_interface_statistics**
> PolicyInterfaceStatistics get_tier1_interface_statistics(tier_1_id, locale_service_id, interface_id, opts)

Get segment statistics information

Get tier1 interface statistics information. 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 

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
  result = api_instance.get_tier1_interface_statistics(tier_1_id, locale_service_id, interface_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->get_tier1_interface_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **edge_path** | **String**| Policy path of edge node | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyInterfaceStatistics**](PolicyInterfaceStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier1**
> Tier1ListResult list_tier1(opts)

List Tier-1 instances

Paginated list of all Tier-1 instances 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Tier-1 instances
  result = api_instance.list_tier1(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->list_tier1: #{e}"
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

[**Tier1ListResult**](Tier1ListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier1_locale_services**
> LocaleServicesListResult list_tier1_locale_services(tier_1_id, opts)

List Tier-1 locale-services

Paginated list of all Tier-1 locale-services 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

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
  #List Tier-1 locale-services
  result = api_instance.list_tier1_locale_services(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->list_tier1_locale_services: #{e}"
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

[**LocaleServicesListResult**](LocaleServicesListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier1**
> patch_tier1(tier_1_id, tier1)

Create or update Tier-1 configuration

If Tier-1 with the tier-1-id is not already present, create a new Tier-1 instance. If it already exists, update the tier-1 instance with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

tier1 = SwaggerClient::Tier1.new # Tier1 | 


begin
  #Create or update Tier-1 configuration
  api_instance.patch_tier1(tier_1_id, tier1)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->patch_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **tier1** | [**Tier1**](Tier1.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier1_locale_services**
> patch_tier1_locale_services(tier_1_id, locale_services_id, locale_services)

Create or update a Tier-1 locale-services

If a Tier-1 locale services with the locale-services-id is not already present, create a new locale services. If it already exists, update Tier-1 locale services with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

locale_services = SwaggerClient::LocaleServices.new # LocaleServices | 


begin
  #Create or update a Tier-1 locale-services
  api_instance.patch_tier1_locale_services(tier_1_id, locale_services_id, locale_services)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->patch_tier1_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **locale_services** | [**LocaleServices**](LocaleServices.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier1**
> Tier1 read_tier1(tier_1_id)

Read Tier-1 configuration

Read Tier-1 configuration

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 


begin
  #Read Tier-1 configuration
  result = api_instance.read_tier1(tier_1_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->read_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 

### Return type

[**Tier1**](Tier1.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier1_locale_services**
> LocaleServices read_tier1_locale_services(tier_1_id, locale_services_id)

Read Tier-1 locale-services

Read Tier-1 locale-services

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

api_instance = SwaggerClient::PolicyConnectivityTier1Api.new

tier_1_id = 'tier_1_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 


begin
  #Read Tier-1 locale-services
  result = api_instance.read_tier1_locale_services(tier_1_id, locale_services_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier1Api->read_tier1_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **locale_services_id** | **String**|  | 

### Return type

[**LocaleServices**](LocaleServices.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



