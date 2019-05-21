# SwaggerClient::PolicyVpnIpsecServicesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_ip_sec_vpn_service**](PolicyVpnIpsecServicesApi.md#create_or_patch_ip_sec_vpn_service) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id} | Create or patch IPSec VPN service
[**create_or_patch_l3_vpn_context**](PolicyVpnIpsecServicesApi.md#create_or_patch_l3_vpn_context) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpn-context | Create or patch the L3Vpn Context
[**create_or_replace_l3_vpn_context**](PolicyVpnIpsecServicesApi.md#create_or_replace_l3_vpn_context) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpn-context | Create or replace the L3Vpn Context
[**create_or_update_ip_sec_vpn_service**](PolicyVpnIpsecServicesApi.md#create_or_update_ip_sec_vpn_service) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id} | Create or fully replace IPSec VPN service
[**delete_ip_sec_vpn_service**](PolicyVpnIpsecServicesApi.md#delete_ip_sec_vpn_service) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id} | Delete IPSec VPN service
[**get_ip_sec_vpn_service**](PolicyVpnIpsecServicesApi.md#get_ip_sec_vpn_service) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id} | Get IPSec VPN service
[**list_ip_sec_vpn_services**](PolicyVpnIpsecServicesApi.md#list_ip_sec_vpn_services) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services | Get IPSec VPN service list result
[**read_l3_vpn_context**](PolicyVpnIpsecServicesApi.md#read_l3_vpn_context) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpn-context | Read the L3Vpn Context


# **create_or_patch_ip_sec_vpn_service**
> create_or_patch_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id, ip_sec_vpn_service)

Create or patch IPSec VPN service

Create or patch IPSec VPN service for given locale service.

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

ip_sec_vpn_service = SwaggerClient::IPSecVpnService.new # IPSecVpnService | 


begin
  #Create or patch IPSec VPN service
  api_instance.create_or_patch_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id, ip_sec_vpn_service)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->create_or_patch_ip_sec_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **ip_sec_vpn_service** | [**IPSecVpnService**](IPSecVpnService.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_l3_vpn_context**
> create_or_patch_l3_vpn_context(tier_0_id, locale_service_id, l3_vpn_context)

Create or patch the L3Vpn Context

Create the new L3Vpn Context under tier-0 if it does not exist. If the L3Vpn Context already exists under tier-0, merge with the the existing one. This is a patch. If the passed L3VpnContext has new L3VpnRules, add them to the existing L3VpnContext. If the passed L3VpnContext also has existing L3VpnRules, update the existing L3VpnRules. This API is deprecated. Please use PATCH /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/ipsec-vpn-services/default instead. If used, this deprecated API will result in an IPSecVpnService being internally created/patched: - IPSecVpnService: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ ipsec-vpn-services/default. 

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3_vpn_context = SwaggerClient::L3VpnContext.new # L3VpnContext | 


begin
  #Create or patch the L3Vpn Context
  api_instance.create_or_patch_l3_vpn_context(tier_0_id, locale_service_id, l3_vpn_context)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->create_or_patch_l3_vpn_context: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3_vpn_context** | [**L3VpnContext**](L3VpnContext.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_l3_vpn_context**
> L3VpnContext create_or_replace_l3_vpn_context(tier_0_id, locale_service_id, l3_vpn_context)

Create or replace the L3Vpn Context

Create the new L3Vpn Context under tier-0 if it does not exist. If the L3Vpn Context already exists under tier-0, replace the the existing one. This is a full replace. This API is deprecated. Please use PUT /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/ipsec-vpn-services/default instead. If used, this deprecated API will result in an IPSecVpnService being internally created/updated: - IPSecVpnService: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ ipsec-vpn-services/default. 

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3_vpn_context = SwaggerClient::L3VpnContext.new # L3VpnContext | 


begin
  #Create or replace the L3Vpn Context
  result = api_instance.create_or_replace_l3_vpn_context(tier_0_id, locale_service_id, l3_vpn_context)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->create_or_replace_l3_vpn_context: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3_vpn_context** | [**L3VpnContext**](L3VpnContext.md)|  | 

### Return type

[**L3VpnContext**](L3VpnContext.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_ip_sec_vpn_service**
> IPSecVpnService create_or_update_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id, ip_sec_vpn_service)

Create or fully replace IPSec VPN service

Create or fully replace IPSec VPN service for given locale service. Revision is optional for creation and required for update.

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

ip_sec_vpn_service = SwaggerClient::IPSecVpnService.new # IPSecVpnService | 


begin
  #Create or fully replace IPSec VPN service
  result = api_instance.create_or_update_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id, ip_sec_vpn_service)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->create_or_update_ip_sec_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **ip_sec_vpn_service** | [**IPSecVpnService**](IPSecVpnService.md)|  | 

### Return type

[**IPSecVpnService**](IPSecVpnService.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_sec_vpn_service**
> delete_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id)

Delete IPSec VPN service

Delete IPSec VPN service for given locale service.

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 


begin
  #Delete IPSec VPN service
  api_instance.delete_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->delete_ip_sec_vpn_service: #{e}"
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



# **get_ip_sec_vpn_service**
> IPSecVpnService get_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id)

Get IPSec VPN service

Get IPSec VPN service for given locale service.

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 


begin
  #Get IPSec VPN service
  result = api_instance.get_ip_sec_vpn_service(tier_0_id, locale_service_id, service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->get_ip_sec_vpn_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 

### Return type

[**IPSecVpnService**](IPSecVpnService.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_sec_vpn_services**
> IPSecVpnServiceListResult list_ip_sec_vpn_services(tier_0_id, locale_service_id, opts)

Get IPSec VPN service list result

Get paginated list of all IPSec VPN services.

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

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
  #Get IPSec VPN service list result
  result = api_instance.list_ip_sec_vpn_services(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->list_ip_sec_vpn_services: #{e}"
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

[**IPSecVpnServiceListResult**](IPSecVpnServiceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_l3_vpn_context**
> L3VpnContext read_l3_vpn_context(tier_0_id, locale_service_id)

Read the L3Vpn Context

Read the L3Vpn Context under tier-0. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/ipsec-vpn-services/default instead. 

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

api_instance = SwaggerClient::PolicyVpnIpsecServicesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 


begin
  #Read the L3Vpn Context
  result = api_instance.read_l3_vpn_context(tier_0_id, locale_service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecServicesApi->read_l3_vpn_context: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 

### Return type

[**L3VpnContext**](L3VpnContext.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



