# SwaggerClient::PolicyVpnL2VpnServicesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_l2_vpn_service**](PolicyVpnL2VpnServicesApi.md#create_or_patch_l2_vpn_service) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id} | Create or patch L2VPN service
[**create_or_update_l2_vpn_service**](PolicyVpnL2VpnServicesApi.md#create_or_update_l2_vpn_service) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id} | Create or fully replace L2VPN service
[**delete_l2_vpn_service**](PolicyVpnL2VpnServicesApi.md#delete_l2_vpn_service) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id} | Delete L2VPN service
[**get_l2_vpn_service**](PolicyVpnL2VpnServicesApi.md#get_l2_vpn_service) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id} | Get L2VPN service
[**list_l2_vpn_services**](PolicyVpnL2VpnServicesApi.md#list_l2_vpn_services) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services | Get L2VPN service list result
[**read_l2_vpn_context**](PolicyVpnL2VpnServicesApi.md#read_l2_vpn_context) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context | Read an L2Vpn Context


# **create_or_patch_l2_vpn_service**
> create_or_patch_l2_vpn_service(tier_0_id, locale_service_id, service_id, l2_vpn_service)

Create or patch L2VPN service

Create or patch L2VPN service for given locale service.

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

api_instance = SwaggerClient::PolicyVpnL2VpnServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

l2_vpn_service = SwaggerClient::L2VPNService.new # L2VPNService | 


begin
  #Create or patch L2VPN service
  api_instance.create_or_patch_l2_vpn_service(tier_0_id, locale_service_id, service_id, l2_vpn_service)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnServicesApi->create_or_patch_l2_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **l2_vpn_service** | [**L2VPNService**](L2VPNService.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_l2_vpn_service**
> L2VPNService create_or_update_l2_vpn_service(tier_0_id, locale_service_id, service_id, l2_vpn_service)

Create or fully replace L2VPN service

Create or fully replace L2VPN service for given locale service. Revision is optional for creation and required for update.

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

api_instance = SwaggerClient::PolicyVpnL2VpnServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

l2_vpn_service = SwaggerClient::L2VPNService.new # L2VPNService | 


begin
  #Create or fully replace L2VPN service
  result = api_instance.create_or_update_l2_vpn_service(tier_0_id, locale_service_id, service_id, l2_vpn_service)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnServicesApi->create_or_update_l2_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **l2_vpn_service** | [**L2VPNService**](L2VPNService.md)|  | 

### Return type

[**L2VPNService**](L2VPNService.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_l2_vpn_service**
> delete_l2_vpn_service(tier_0_id, locale_service_id, service_id)

Delete L2VPN service

Delete L2VPN service for given locale service.

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

api_instance = SwaggerClient::PolicyVpnL2VpnServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 


begin
  #Delete L2VPN service
  api_instance.delete_l2_vpn_service(tier_0_id, locale_service_id, service_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnServicesApi->delete_l2_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_l2_vpn_service**
> L2VPNService get_l2_vpn_service(tier_0_id, locale_service_id, service_id)

Get L2VPN service

Get L2VPN service for given locale service.

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

api_instance = SwaggerClient::PolicyVpnL2VpnServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 


begin
  #Get L2VPN service
  result = api_instance.get_l2_vpn_service(tier_0_id, locale_service_id, service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnServicesApi->get_l2_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 

### Return type

[**L2VPNService**](L2VPNService.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_l2_vpn_services**
> L2VPNServiceListResult list_l2_vpn_services(tier_0_id, locale_service_id, opts)

Get L2VPN service list result

Get paginated list of all L2VPN services.

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

api_instance = SwaggerClient::PolicyVpnL2VpnServicesApi.new

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
  #Get L2VPN service list result
  result = api_instance.list_l2_vpn_services(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnServicesApi->list_l2_vpn_services: #{e}"
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

[**L2VPNServiceListResult**](L2VPNServiceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_l2_vpn_context**
> L2VpnContext read_l2_vpn_context(tier_0_id, locale_service_id)

Read an L2Vpn Context

Read L2Vpn Context. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default instead. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 


begin
  #Read an L2Vpn Context
  result = api_instance.read_l2_vpn_context(tier_0_id, locale_service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnServicesApi->read_l2_vpn_context: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 

### Return type

[**L2VpnContext**](L2VpnContext.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



