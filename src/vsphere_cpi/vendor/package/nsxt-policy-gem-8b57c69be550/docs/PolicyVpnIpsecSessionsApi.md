# SwaggerClient::PolicyVpnIpsecSessionsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_ip_sec_vpn_session**](PolicyVpnIpsecSessionsApi.md#create_or_patch_ip_sec_vpn_session) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions/{session-id} | Create or patch an IPSec VPN session
[**create_or_patch_l3_vpn**](PolicyVpnIpsecSessionsApi.md#create_or_patch_l3_vpn) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns/{l3vpn-id} | Create or patch an L3Vpn
[**create_or_replace_l3_vpn**](PolicyVpnIpsecSessionsApi.md#create_or_replace_l3_vpn) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns/{l3vpn-id} | Create or replace an L3Vpn
[**create_or_update_ip_sec_vpn_session**](PolicyVpnIpsecSessionsApi.md#create_or_update_ip_sec_vpn_session) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions/{session-id} | Create or fully replace IPSec VPN session
[**delete_ip_sec_vpn_session**](PolicyVpnIpsecSessionsApi.md#delete_ip_sec_vpn_session) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions/{session-id} | Delete IPSec VPN session
[**delete_l3_vpn**](PolicyVpnIpsecSessionsApi.md#delete_l3_vpn) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns/{l3vpn-id} | Delete an L3Vpn
[**get_ip_sec_vpn_peer_config**](PolicyVpnIpsecSessionsApi.md#get_ip_sec_vpn_peer_config) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions/{session-id}/peer-config | Get IPSec VPN configuration for the peer site
[**get_ip_sec_vpn_session**](PolicyVpnIpsecSessionsApi.md#get_ip_sec_vpn_session) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions/{session-id} | Get IPSec VPN Session
[**get_ip_sec_vpn_session_with_sensitive_data_show_sensitive_data**](PolicyVpnIpsecSessionsApi.md#get_ip_sec_vpn_session_with_sensitive_data_show_sensitive_data) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions/{session-id}?action&#x3D;show_sensitive_data | Get IPSec VPN Session
[**list_ip_sec_vpn_sessions**](PolicyVpnIpsecSessionsApi.md#list_ip_sec_vpn_sessions) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/ipsec-vpn-services/{service-id}/sessions | Get IPSec VPN sessions list result
[**list_l3_vpns**](PolicyVpnIpsecSessionsApi.md#list_l3_vpns) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns | List L3Vpns
[**read_l3_vpn**](PolicyVpnIpsecSessionsApi.md#read_l3_vpn) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns/{l3vpn-id} | Read an L3Vpn
[**read_l3_vpn_peer_config**](PolicyVpnIpsecSessionsApi.md#read_l3_vpn_peer_config) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns/{l3vpn-id}/peer-config | Download L3Vpn Config for Remote Site
[**read_l3_vpn_with_sensitive_data_show_sensitive_data**](PolicyVpnIpsecSessionsApi.md#read_l3_vpn_with_sensitive_data_show_sensitive_data) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l3vpns/{l3vpn-id}?action&#x3D;show_sensitive_data | Read an L3Vpn


# **create_or_patch_ip_sec_vpn_session**
> create_or_patch_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id, ip_sec_vpn_session)

Create or patch an IPSec VPN session

Create or patch an IPSec VPN session.

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

ip_sec_vpn_session = SwaggerClient::IPSecVpnSession.new # IPSecVpnSession | 


begin
  #Create or patch an IPSec VPN session
  api_instance.create_or_patch_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id, ip_sec_vpn_session)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->create_or_patch_ip_sec_vpn_session: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 
 **ip_sec_vpn_session** | [**IPSecVpnSession**](IPSecVpnSession.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_l3_vpn**
> create_or_patch_l3_vpn(tier_0_id, locale_service_id, l3vpn_id, l3_vpn)

Create or patch an L3Vpn

Create the new L3Vpn if it does not exist. If the L3Vpn already exists, merge with the the existing one. This is a patch. - If the passed L3Vpn is a policy-based one and has new L3VpnRules, add them to the existing L3VpnRules. - If the passed L3Vpn is a policy-based one and also has existing L3VpnRules, update the existing L3VpnRules. This API is deprecated. Please use the following APIs instead: - PATCH /infra/ipsec-vpn-tunnel-profiles/<tunnel-profile-id> to patch the IPSecVpnTunnelProfile. - PATCH /infra/ipsec-vpn-ike-profiles/<ike-profile-id> to patch the IPSecVpnIkeProfile. - PATCH /infra/ipsec-vpn-dpd-profiles/<dpd-profile-id> to patch the IPSecVpnDpdProfile. - PATCH /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/local-endpoints/<local-endpoint-id> to patch the IPSecVpnLocalEndpoint. - PATCH /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/sessions/<l3vpn-id> to patch the IPSecVpnSession. If used, this deprecated API will result in the following objects being internally created/patched: - IPSecVpnTunnelProfile: /infra/ipsec-vpn-tunnel-profiles/L3VPN_<l3vpn-id>. - IPSecVpnIkeProfile: /infra/ipsec-vpn-ike-profiles/L3VPN_<l3vpn-id>. - IPSecVpnDpdProfile: /infra/ipsec-vpn-dpd-profiles/L3VPN_<l3vpn-id>. - IPSecVpnLocalEndpoint: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/   ipsec-vpn-services/default/local-endpoints/<local-endpoint-id>. If an object with the same   \"local_address\" already exists, then it will be re-used. - IPSecVpnSession: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/   ipsec-vpn-services/default/sessions/L3VPN_<l3vpn-id>. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3vpn_id = 'l3vpn_id_example' # String | 

l3_vpn = SwaggerClient::L3Vpn.new # L3Vpn | 


begin
  #Create or patch an L3Vpn
  api_instance.create_or_patch_l3_vpn(tier_0_id, locale_service_id, l3vpn_id, l3_vpn)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->create_or_patch_l3_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3vpn_id** | **String**|  | 
 **l3_vpn** | [**L3Vpn**](L3Vpn.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_l3_vpn**
> L3Vpn create_or_replace_l3_vpn(tier_0_id, locale_service_id, l3vpn_id, l3_vpn)

Create or replace an L3Vpn

Create a new L3Vpn if the L3Vpn with given id does not already exist. If the L3Vpn with the given id already exists, replace the existing L3Vpn. This a full replace. This API is deprecated. Please use the following APIs instead: - PUT /infra/ipsec-vpn-tunnel-profiles/<tunnel-profile-id> to update the IPSecVpnTunnelProfile. - PUT /infra/ipsec-vpn-ike-profiles/<ike-profile-id> to update the IPSecVpnIkeProfile. - PUT /infra/ipsec-vpn-dpd-profiles/<dpd-profile-id> to update the IPSecVpnDpdProfile. - PUT /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/local-endpoints/<local-endpoint-id> to update the IPSecVpnLocalEndpoint. - PUT /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/sessions/<l3vpn-id> to update the IPSecVpnSession. If used, this deprecated API will result in the following objects being internally created/updated: - IPSecVpnTunnelProfile: /infra/ipsec-vpn-tunnel-profiles/L3VPN_<l3vpn-id>. - IPSecVpnIkeProfile: /infra/ipsec-vpn-ike-profiles/L3VPN_<l3vpn-id>. - IPSecVpnDpdProfile: /infra/ipsec-vpn-dpd-profiles/L3VPN_<l3vpn-id>. - IPSecVpnLocalEndpoint: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/   ipsec-vpn-services/default/local-endpoints/<local-endpoint-id>. If an object with the same   \"local_address\" already exists, then it will be re-used. - IPSecVpnSession: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/   ipsec-vpn-services/default/sessions/L3VPN_<l3vpn-id>. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3vpn_id = 'l3vpn_id_example' # String | 

l3_vpn = SwaggerClient::L3Vpn.new # L3Vpn | 


begin
  #Create or replace an L3Vpn
  result = api_instance.create_or_replace_l3_vpn(tier_0_id, locale_service_id, l3vpn_id, l3_vpn)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->create_or_replace_l3_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3vpn_id** | **String**|  | 
 **l3_vpn** | [**L3Vpn**](L3Vpn.md)|  | 

### Return type

[**L3Vpn**](L3Vpn.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_ip_sec_vpn_session**
> IPSecVpnSession create_or_update_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id, ip_sec_vpn_session)

Create or fully replace IPSec VPN session

Create or fully replace IPSec VPN session. Revision is optional for creation and required for update.

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

ip_sec_vpn_session = SwaggerClient::IPSecVpnSession.new # IPSecVpnSession | 


begin
  #Create or fully replace IPSec VPN session
  result = api_instance.create_or_update_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id, ip_sec_vpn_session)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->create_or_update_ip_sec_vpn_session: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 
 **ip_sec_vpn_session** | [**IPSecVpnSession**](IPSecVpnSession.md)|  | 

### Return type

[**IPSecVpnSession**](IPSecVpnSession.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_sec_vpn_session**
> delete_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id)

Delete IPSec VPN session

Delete IPSec VPN session.

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 


begin
  #Delete IPSec VPN session
  api_instance.delete_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->delete_ip_sec_vpn_session: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_l3_vpn**
> delete_l3_vpn(tier_0_id, locale_service_id, l3vpn_id)

Delete an L3Vpn

Delete the L3Vpn with the given id. This API is deprecated. Please use the following APIs instead: - DELETE /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/ default/sessions/L3VPN_<l3vpn-id> to delete the associated IPSecVpnSession. - DELETE /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/ default/local-endpoints/<local-endpoint-id> to delete the associated IPSecVpnLocalEndpoint. - DELETE /infra/ipsec-vpn-tunnel-profiles/L3VPN_<l3vpn-id> to delete the associated IPSecVpnTunnelProfile. - DELETE /infra/ipsec-vpn-ike-profiles/L3VPN_<l3vpn-id> to delete the associated IPSecVpnIkeProfile. - DELETE /infra/ipsec-vpn-dpd-profiles/L3VPN_<l3vpn-id> to delete the associated IPSecVpnDpdProfile. If used, this deprecated API will result in the following objects being internally deleted: - IPSecVpnSession: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ ipsec-vpn-services/default/sessions/L3VPN_<l3vpn-id>. - IPSecVpnLocalEndpoint: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ ipsec-vpn-services/default/local-endpoints/<local-endpoint-id> when not used by other IPSecVpnSessions. - IPSecVpnTunnelProfile: /infra/ipsec-vpn-tunnel-profiles/L3VPN_<l3vpn-id>. - IPSecVpnIkeProfile: /infra/ipsec-vpn-ike-profiles/L3VPN_<l3vpn-id>. - IPSecVpnDpdProfile: /infra/ipsec-vpn-dpd-profiles/L3VPN_<l3vpn-id>. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3vpn_id = 'l3vpn_id_example' # String | 


begin
  #Delete an L3Vpn
  api_instance.delete_l3_vpn(tier_0_id, locale_service_id, l3vpn_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->delete_l3_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3vpn_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_sec_vpn_peer_config**
> String get_ip_sec_vpn_peer_config(tier_0_id, locale_service_id, service_id, session_id, opts)

Get IPSec VPN configuration for the peer site

Download IPSec VPN configuration for the peer site. Peer config also contains PSK; be careful when sharing or storing it. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get IPSec VPN configuration for the peer site
  result = api_instance.get_ip_sec_vpn_peer_config(tier_0_id, locale_service_id, service_id, session_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->get_ip_sec_vpn_peer_config: #{e}"
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

### Return type

**String**

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain; charset=utf-8



# **get_ip_sec_vpn_session**
> IPSecVpnSession get_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id)

Get IPSec VPN Session

Get IPSec VPN session without sensitive data.

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 


begin
  #Get IPSec VPN Session
  result = api_instance.get_ip_sec_vpn_session(tier_0_id, locale_service_id, service_id, session_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->get_ip_sec_vpn_session: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 

### Return type

[**IPSecVpnSession**](IPSecVpnSession.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_sec_vpn_session_with_sensitive_data_show_sensitive_data**
> IPSecVpnSession get_ip_sec_vpn_session_with_sensitive_data_show_sensitive_data(tier_0_id, locale_service_id, service_id, session_id)

Get IPSec VPN Session

Get IPSec VPN session with senstive data.

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 


begin
  #Get IPSec VPN Session
  result = api_instance.get_ip_sec_vpn_session_with_sensitive_data_show_sensitive_data(tier_0_id, locale_service_id, service_id, session_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->get_ip_sec_vpn_session_with_sensitive_data_show_sensitive_data: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 

### Return type

[**IPSecVpnSession**](IPSecVpnSession.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_sec_vpn_sessions**
> IPSecVpnSessionListResult list_ip_sec_vpn_sessions(tier_0_id, locale_service_id, service_id, opts)

Get IPSec VPN sessions list result

Get paginated list of all IPSec VPN sessions.

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

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
  #Get IPSec VPN sessions list result
  result = api_instance.list_ip_sec_vpn_sessions(tier_0_id, locale_service_id, service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->list_ip_sec_vpn_sessions: #{e}"
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

[**IPSecVpnSessionListResult**](IPSecVpnSessionListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_l3_vpns**
> L3VpnListResult list_l3_vpns(tier_0_id, locale_service_id, opts)

List L3Vpns

Paginated list of L3Vpns. This API is deprecated. Please use the following APIs instead: - GET /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/sessions to list all IPSecVpnSessions. - GET /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/local-endpoints to list all IPSecVpnLocalEndpoints. - GET /infra/ipsec-vpn-tunnel-profiles to list all IPSecVpnTunnelProfiles. - GET /infra/ipsec-vpn-ike-profiles to list all IPSecVpnIkeProfiles. - GET /infra/ipsec-vpn-dpd-profiles to list all IPSecVpnDpdProfiles. If used, this deprecated API will only return L3Vpns that were created through the deprecated PATCH and PUT /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/l3vpns/<l3vpn-id> APIs. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  l3vpn_session: 'l3vpn_session_example', # String | Resource type of L3Vpn Session
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List L3Vpns
  result = api_instance.list_l3_vpns(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->list_l3_vpns: #{e}"
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
 **l3vpn_session** | **String**| Resource type of L3Vpn Session | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**L3VpnListResult**](L3VpnListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_l3_vpn**
> L3Vpn read_l3_vpn(tier_0_id, locale_service_id, l3vpn_id)

Read an L3Vpn

Read the L3Vpn with the given id. No sensitive data is returned as part of the response. This API is deprecated. Please use the following APIs instead: - GET /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/sessions/L3VPN_<l3vpn-id> to get the associated IPSecVpnSession. - GET /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/local-endpoints/<local-endpoint-id> to get the associated IPSecVpnLocalEndpoint. - GET /infra/ipsec-vpn-tunnel-profiles/L3VPN_<l3vpn-id> to get the associated   IPSecVpnTunnelProfile. - GET /infra/ipsec-vpn-ike-profiles/L3VPN_<l3vpn-id> to get the associated IPSecVpnIkeProfile. - GET /infra/ipsec-vpn-dpd-profiles/L3VPN_<l3vpn-id> to get the associated IPSecVpnDpdProfile. If used, this deprecated API will not return L3Vpn with <l3vpn-id> id unless the associated IPSecVpnSession with L3VPN_<l3vpn-id> id exists. For example, if the IPSecVpnSession gets deleted using DELETE /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/ default/sessions/L3VPN_<l3vpn-id>, the deprecated API will throw an ObjectNotFoundException. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3vpn_id = 'l3vpn_id_example' # String | 


begin
  #Read an L3Vpn
  result = api_instance.read_l3_vpn(tier_0_id, locale_service_id, l3vpn_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->read_l3_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3vpn_id** | **String**|  | 

### Return type

[**L3Vpn**](L3Vpn.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_l3_vpn_peer_config**
> String read_l3_vpn_peer_config(tier_0_id, locale_service_id, l3vpn_id, opts)

Download L3Vpn Config for Remote Site

Get the L3Vpn Configuration for the peer site. Peer config contains PSK; be careful when sharing or storing it. - no enforcement point path specified: L3Vpn Peer Config will be evaluated on each enforcement point. - {enforcement_point_path}: L3Vpn Peer Config is evaluated only on the given enforcement point. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/ipsec-vpn-services/default/sessions/L3VPN_<l3vpn-id>/peer-config instead. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3vpn_id = 'l3vpn_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Download L3Vpn Config for Remote Site
  result = api_instance.read_l3_vpn_peer_config(tier_0_id, locale_service_id, l3vpn_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->read_l3_vpn_peer_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3vpn_id** | **String**|  | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

**String**

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: text/plain; charset=utf-8



# **read_l3_vpn_with_sensitive_data_show_sensitive_data**
> L3Vpn read_l3_vpn_with_sensitive_data_show_sensitive_data(tier_0_id, locale_service_id, l3vpn_id)

Read an L3Vpn

Read the L3Vpn with the given id. Sensitive data is returned as part of the response. This API is deprecated. Please use the following APIs instead: - GET /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/sessions/L3VPN_<l3vpn-id>?action=show_sensitive_data to get the associated   IPSecVpnSession. - GET /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/   default/local-endpoints/<local-endpoint-id> to get the associated IPSecVpnLocalEndpoint. - GET /infra/ipsec-vpn-tunnel-profiles/L3VPN_<l3vpn-id> to get the associated   IPSecVpnTunnelProfile. - GET /infra/ipsec-vpn-ike-profiles/L3VPN_<l3vpn-id> to get the associated IPSecVpnIkeProfile. - GET /infra/ipsec-vpn-dpd-profiles/L3VPN_<l3vpn-id> to get the associated IPSecVpnDpdProfile. If used, this deprecated API will not return L3Vpn with <l3vpn-id> id unless the associated IPSecVpnSession with L3VPN_<l3vpn-id> id exists. For example, if the IPSecVpnSession gets deleted using DELETE /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/ipsec-vpn-services/ default/sessions/L3VPN_<l3vpn-id>, the deprecated API will throw an ObjectNotFoundException. 

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

api_instance = SwaggerClient::PolicyVpnIpsecSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l3vpn_id = 'l3vpn_id_example' # String | 


begin
  #Read an L3Vpn
  result = api_instance.read_l3_vpn_with_sensitive_data_show_sensitive_data(tier_0_id, locale_service_id, l3vpn_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecSessionsApi->read_l3_vpn_with_sensitive_data_show_sensitive_data: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l3vpn_id** | **String**|  | 

### Return type

[**L3Vpn**](L3Vpn.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



