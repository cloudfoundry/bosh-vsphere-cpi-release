# SwaggerClient::PolicyVpnL2VpnStatusApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_l2_vpn_session_status**](PolicyVpnL2VpnStatusApi.md#get_l2_vpn_session_status) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id}/detailed-status | Get L2VPN session detailed status.


# **get_l2_vpn_session_status**
> AggregateL2VPNSessionStatus get_l2_vpn_session_status(tier_0_id, locale_service_id, service_id, session_id, opts)

Get L2VPN session detailed status.

- no enforcement point path specified: detailed tatus is evaluated on each enforcement point. - an enforcement point path is specified: detailed status is evaluated only on the given enforcement point. - source=realtime: detailed tatus is fetched realtime from the enforcement point. - source=cached: cached detailed status is returned. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnStatusApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get L2VPN session detailed status.
  result = api_instance.get_l2_vpn_session_status(tier_0_id, locale_service_id, service_id, session_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnStatusApi->get_l2_vpn_session_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **source** | **String**| Data source type. | [optional] 

### Return type

[**AggregateL2VPNSessionStatus**](AggregateL2VPNSessionStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



