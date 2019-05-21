# SwaggerClient::PolicyConnectivityTier0Api

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_tier0**](PolicyConnectivityTier0Api.md#create_or_replace_tier0) | **PUT** /infra/tier-0s/{tier-0-id} | Create or update a Tier-0
[**create_or_replace_tier0_locale_services**](PolicyConnectivityTier0Api.md#create_or_replace_tier0_locale_services) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-services-id} | Create or update a Tier-0 locale-services
[**delete_tier0**](PolicyConnectivityTier0Api.md#delete_tier0) | **DELETE** /infra/tier-0s/{tier-0-id} | Delete Tier-0
[**delete_tier0_locale_services**](PolicyConnectivityTier0Api.md#delete_tier0_locale_services) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-services-id} | Delete Tier-0 locale-services
[**get_tier0_interface_statistics**](PolicyConnectivityTier0Api.md#get_tier0_interface_statistics) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/interfaces/{interface-id}/statistics | Get segment statistics information
[**list_tier0_locale_services**](PolicyConnectivityTier0Api.md#list_tier0_locale_services) | **GET** /infra/tier-0s/{tier-0-id}/locale-services | List Tier-0 locale-services
[**list_tier0s**](PolicyConnectivityTier0Api.md#list_tier0s) | **GET** /infra/tier-0s | List Tier-0s
[**patch_tier0**](PolicyConnectivityTier0Api.md#patch_tier0) | **PATCH** /infra/tier-0s/{tier-0-id} | Create or update a Tier-0
[**patch_tier0_locale_services**](PolicyConnectivityTier0Api.md#patch_tier0_locale_services) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-services-id} | Create or update a tier-0 locale-services
[**read_tier0**](PolicyConnectivityTier0Api.md#read_tier0) | **GET** /infra/tier-0s/{tier-0-id} | Read Tier-0
[**read_tier0_locale_services**](PolicyConnectivityTier0Api.md#read_tier0_locale_services) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-services-id} | Read Tier-0 locale-services


# **create_or_replace_tier0**
> Tier0 create_or_replace_tier0(tier_0_id, tier0)

Create or update a Tier-0

If a Tier-0 with the tier-0-id is not already present, create a new Tier-0. If it already exists, replace the Tier-0 instance with the new object. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

tier0 = SwaggerClient::Tier0.new # Tier0 | 


begin
  #Create or update a Tier-0
  result = api_instance.create_or_replace_tier0(tier_0_id, tier0)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->create_or_replace_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **tier0** | [**Tier0**](Tier0.md)|  | 

### Return type

[**Tier0**](Tier0.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_tier0_locale_services**
> LocaleServices create_or_replace_tier0_locale_services(tier_0_id, locale_services_id, locale_services)

Create or update a Tier-0 locale-services

If a Tier-0 locale-services with the locale-services-id is not already present, create a new locale-services. If it already exists, replace the Tier-0 locale-services instance with the new object. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

locale_services = SwaggerClient::LocaleServices.new # LocaleServices | 


begin
  #Create or update a Tier-0 locale-services
  result = api_instance.create_or_replace_tier0_locale_services(tier_0_id, locale_services_id, locale_services)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->create_or_replace_tier0_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **locale_services** | [**LocaleServices**](LocaleServices.md)|  | 

### Return type

[**LocaleServices**](LocaleServices.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier0**
> delete_tier0(tier_0_id)

Delete Tier-0

Delete Tier-0

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 


begin
  #Delete Tier-0
  api_instance.delete_tier0(tier_0_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->delete_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier0_locale_services**
> delete_tier0_locale_services(tier_0_id, locale_services_id)

Delete Tier-0 locale-services

Delete Tier-0 locale-services

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 


begin
  #Delete Tier-0 locale-services
  api_instance.delete_tier0_locale_services(tier_0_id, locale_services_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->delete_tier0_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_services_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier0_interface_statistics**
> PolicyInterfaceStatistics get_tier0_interface_statistics(tier_0_id, locale_service_id, interface_id, opts)

Get segment statistics information

Get tier0 interface statistics information. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

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
  result = api_instance.get_tier0_interface_statistics(tier_0_id, locale_service_id, interface_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->get_tier0_interface_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
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



# **list_tier0_locale_services**
> LocaleServicesListResult list_tier0_locale_services(tier_0_id, opts)

List Tier-0 locale-services

Paginated list of all Tier-0 locale-services 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Tier-0 locale-services
  result = api_instance.list_tier0_locale_services(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->list_tier0_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
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



# **list_tier0s**
> Tier0ListResult list_tier0s(opts)

List Tier-0s

Paginated list of all Tier-0s 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Tier-0s
  result = api_instance.list_tier0s(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->list_tier0s: #{e}"
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

[**Tier0ListResult**](Tier0ListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier0**
> patch_tier0(tier_0_id, tier0)

Create or update a Tier-0

If a Tier-0 with the tier-0-id is not already present, create a new Tier-0. If it already exists, update the Tier-0 for specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

tier0 = SwaggerClient::Tier0.new # Tier0 | 


begin
  #Create or update a Tier-0
  api_instance.patch_tier0(tier_0_id, tier0)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->patch_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **tier0** | [**Tier0**](Tier0.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier0_locale_services**
> patch_tier0_locale_services(tier_0_id, locale_services_id, locale_services)

Create or update a tier-0 locale-services

If a Tier-0 locale-services with the locale-services-id is not already present, create a new locale-services. If it already exists, update Tier-0 locale-services with specified attributes. 

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 

locale_services = SwaggerClient::LocaleServices.new # LocaleServices | 


begin
  #Create or update a tier-0 locale-services
  api_instance.patch_tier0_locale_services(tier_0_id, locale_services_id, locale_services)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->patch_tier0_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_services_id** | **String**|  | 
 **locale_services** | [**LocaleServices**](LocaleServices.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier0**
> Tier0 read_tier0(tier_0_id)

Read Tier-0

Read Tier-0

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 


begin
  #Read Tier-0
  result = api_instance.read_tier0(tier_0_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->read_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 

### Return type

[**Tier0**](Tier0.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier0_locale_services**
> LocaleServices read_tier0_locale_services(tier_0_id, locale_services_id)

Read Tier-0 locale-services

Read Tier-0 locale-services

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

api_instance = SwaggerClient::PolicyConnectivityTier0Api.new

tier_0_id = 'tier_0_id_example' # String | 

locale_services_id = 'locale_services_id_example' # String | 


begin
  #Read Tier-0 locale-services
  result = api_instance.read_tier0_locale_services(tier_0_id, locale_services_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityTier0Api->read_tier0_locale_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_services_id** | **String**|  | 

### Return type

[**LocaleServices**](LocaleServices.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



