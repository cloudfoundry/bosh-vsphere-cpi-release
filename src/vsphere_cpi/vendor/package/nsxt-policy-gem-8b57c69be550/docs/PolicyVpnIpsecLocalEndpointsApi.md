# SwaggerClient::PolicyVpnIpsecLocalEndpointsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_ip_sec_vpn_local_endpoint**](PolicyVpnIpsecLocalEndpointsApi.md#create_or_patch_ip_sec_vpn_local_endpoint) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/local-endpoints/{local-endpoint-id} | Create or patch a custom IPSec VPN local endpoint
[**create_or_update_ip_sec_vpn_local_endpoint**](PolicyVpnIpsecLocalEndpointsApi.md#create_or_update_ip_sec_vpn_local_endpoint) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/local-endpoints/{local-endpoint-id} | Create or fully replace IPSec VPN local endpoint
[**delete_ip_sec_vpn_local_endpoint**](PolicyVpnIpsecLocalEndpointsApi.md#delete_ip_sec_vpn_local_endpoint) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/local-endpoints/{local-endpoint-id} | Delete IPSec VPN local endpoint
[**get_ip_sec_vpn_local_endpoint**](PolicyVpnIpsecLocalEndpointsApi.md#get_ip_sec_vpn_local_endpoint) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/local-endpoints/{local-endpoint-id} | Get IPSec VPN local endpoint
[**list_ip_sec_vpn_local_endpoints**](PolicyVpnIpsecLocalEndpointsApi.md#list_ip_sec_vpn_local_endpoints) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/local-endpoints | Get IPSec VPN local endpoint list result


# **create_or_patch_ip_sec_vpn_local_endpoint**
> create_or_patch_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id, ip_sec_vpn_local_endpoint)

Create or patch a custom IPSec VPN local endpoint

Create or patch a custom IPSec VPN local endpoint for a given locale service.

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

api_instance = SwaggerClient::PolicyVpnIpsecLocalEndpointsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

local_endpoint_id = 'local_endpoint_id_example' # String | 

ip_sec_vpn_local_endpoint = SwaggerClient::IPSecVpnLocalEndpoint.new # IPSecVpnLocalEndpoint | 


begin
  #Create or patch a custom IPSec VPN local endpoint
  api_instance.create_or_patch_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id, ip_sec_vpn_local_endpoint)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecLocalEndpointsApi->create_or_patch_ip_sec_vpn_local_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **local_endpoint_id** | **String**|  | 
 **ip_sec_vpn_local_endpoint** | [**IPSecVpnLocalEndpoint**](IPSecVpnLocalEndpoint.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_ip_sec_vpn_local_endpoint**
> IPSecVpnLocalEndpoint create_or_update_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id, ip_sec_vpn_local_endpoint)

Create or fully replace IPSec VPN local endpoint

Create or fully replace IPSec VPN local endpoint. Revision is optional for creation and required for update.

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

api_instance = SwaggerClient::PolicyVpnIpsecLocalEndpointsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

local_endpoint_id = 'local_endpoint_id_example' # String | 

ip_sec_vpn_local_endpoint = SwaggerClient::IPSecVpnLocalEndpoint.new # IPSecVpnLocalEndpoint | 


begin
  #Create or fully replace IPSec VPN local endpoint
  result = api_instance.create_or_update_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id, ip_sec_vpn_local_endpoint)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecLocalEndpointsApi->create_or_update_ip_sec_vpn_local_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **local_endpoint_id** | **String**|  | 
 **ip_sec_vpn_local_endpoint** | [**IPSecVpnLocalEndpoint**](IPSecVpnLocalEndpoint.md)|  | 

### Return type

[**IPSecVpnLocalEndpoint**](IPSecVpnLocalEndpoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_sec_vpn_local_endpoint**
> delete_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id)

Delete IPSec VPN local endpoint

Delete IPSec VPN local endpoint.

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

api_instance = SwaggerClient::PolicyVpnIpsecLocalEndpointsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

local_endpoint_id = 'local_endpoint_id_example' # String | 


begin
  #Delete IPSec VPN local endpoint
  api_instance.delete_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecLocalEndpointsApi->delete_ip_sec_vpn_local_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **local_endpoint_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_sec_vpn_local_endpoint**
> IPSecVpnLocalEndpoint get_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id)

Get IPSec VPN local endpoint

Get IPSec VPN local endpoint.

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

api_instance = SwaggerClient::PolicyVpnIpsecLocalEndpointsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

local_endpoint_id = 'local_endpoint_id_example' # String | 


begin
  #Get IPSec VPN local endpoint
  result = api_instance.get_ip_sec_vpn_local_endpoint(tier_0_id, locale_service_id, service_id, local_endpoint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecLocalEndpointsApi->get_ip_sec_vpn_local_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **local_endpoint_id** | **String**|  | 

### Return type

[**IPSecVpnLocalEndpoint**](IPSecVpnLocalEndpoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_sec_vpn_local_endpoints**
> IPSecVpnLocalEndpointListResult list_ip_sec_vpn_local_endpoints(tier_0_id, locale_service_id, service_id, opts)

Get IPSec VPN local endpoint list result

Get paginated list of all IPSec VPN local endpoints.

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

api_instance = SwaggerClient::PolicyVpnIpsecLocalEndpointsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get IPSec VPN local endpoint list result
  result = api_instance.list_ip_sec_vpn_local_endpoints(tier_0_id, locale_service_id, service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecLocalEndpointsApi->list_ip_sec_vpn_local_endpoints: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**IPSecVpnLocalEndpointListResult**](IPSecVpnLocalEndpointListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



