# SwaggerClient::PolicyVpnL2VpnStatisticsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_l2_vpn_session_statistics**](PolicyVpnL2VpnStatisticsApi.md#get_l2_vpn_session_statistics) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id}/statistics | Get L2VPN session statistics.
[**get_l2_vpn_statistics**](PolicyVpnL2VpnStatisticsApi.md#get_l2_vpn_statistics) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns/{l2vpn-id}/statistics | Get L2Vpn statistics


# **get_l2_vpn_session_statistics**
> AggregateL2VPNSessionStatistics get_l2_vpn_session_statistics(tier_0_id, locale_service_id, service_id, session_id, opts)

Get L2VPN session statistics.

- no enforcement point path specified: statistics are evaluated on each enforcement point. - an enforcement point path is specified: statistics are evaluated only on the given enforcement point. - source=realtime: statistics are fetched realtime from the enforcement point. - source=cached: cached statistics from the enforcement point are returned. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnStatisticsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  source: 'source_example' # String | Data source type.
}

begin
  #Get L2VPN session statistics.
  result = api_instance.get_l2_vpn_session_statistics(tier_0_id, locale_service_id, service_id, session_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnStatisticsApi->get_l2_vpn_session_statistics: #{e}"
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

[**AggregateL2VPNSessionStatistics**](AggregateL2VPNSessionStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_l2_vpn_statistics**
> AggregateL2VpnStatistics get_l2_vpn_statistics(tier_0_id, locale_service_id, l2vpn_id, opts)

Get L2Vpn statistics

Get statistics of an L2Vpn. - no enforcement point path specified: Stats will be evaluated on each enforcement point. - {enforcement_point_path}: Stats are evaluated only on the given enforcement point. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions/L2VPN_<l2vpn-id>/statistics instead. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnStatisticsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l2vpn_id = 'l2vpn_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get L2Vpn statistics
  result = api_instance.get_l2_vpn_statistics(tier_0_id, locale_service_id, l2vpn_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnStatisticsApi->get_l2_vpn_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l2vpn_id** | **String**|  | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregateL2VpnStatistics**](AggregateL2VpnStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



