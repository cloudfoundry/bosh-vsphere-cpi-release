# SwaggerClient::PolicyVpnL2VpnSessionsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_l2_vpn**](PolicyVpnL2VpnSessionsApi.md#create_or_patch_l2_vpn) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns/{l2vpn-id} | Create or patch an L2Vpn
[**create_or_patch_l2_vpn_session**](PolicyVpnL2VpnSessionsApi.md#create_or_patch_l2_vpn_session) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id} | Create or patch an L2VPN session
[**create_or_patch_l2_vpn_session_from_peer_codes_create_with_peer_code**](PolicyVpnL2VpnSessionsApi.md#create_or_patch_l2_vpn_session_from_peer_codes_create_with_peer_code) | **POST** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id}?action&#x3D;create_with_peer_code | Create or patch an L2VPN session from Peer Codes
[**create_or_replace_l2_vpn**](PolicyVpnL2VpnSessionsApi.md#create_or_replace_l2_vpn) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns/{l2vpn-id} | Create or replace an L2Vpn
[**create_or_update_l2_vpn_session**](PolicyVpnL2VpnSessionsApi.md#create_or_update_l2_vpn_session) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id} | Create or fully replace L2VPN session
[**delete_l2_vpn**](PolicyVpnL2VpnSessionsApi.md#delete_l2_vpn) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns/{l2vpn-id} | Delete an L2Vpn
[**delete_l2_vpn_session**](PolicyVpnL2VpnSessionsApi.md#delete_l2_vpn_session) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id} | Delete L2VPN session
[**get_l2_vpn_session**](PolicyVpnL2VpnSessionsApi.md#get_l2_vpn_session) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id} | Get L2VPN Session
[**get_l2_vpn_session_peer_config**](PolicyVpnL2VpnSessionsApi.md#get_l2_vpn_session_peer_config) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions/{session-id}/peer-config | Get L2VPN session configuration for the peer site
[**list_l2_vpn_sessions**](PolicyVpnL2VpnSessionsApi.md#list_l2_vpn_sessions) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-services/{service-id}/sessions | Get L2VPN sessions list result
[**list_l2_vpns**](PolicyVpnL2VpnSessionsApi.md#list_l2_vpns) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns | List L2Vpns
[**read_l2_vpn**](PolicyVpnL2VpnSessionsApi.md#read_l2_vpn) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns/{l2vpn-id} | Read an L2Vpn
[**read_l2_vpn_peer_config**](PolicyVpnL2VpnSessionsApi.md#read_l2_vpn_peer_config) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/l2vpn-context/l2vpns/{l2vpn-id}/peer-config | Get Peer Config for L2Vpn


# **create_or_patch_l2_vpn**
> create_or_patch_l2_vpn(tier_0_id, locale_service_id, l2vpn_id, l2_vpn)

Create or patch an L2Vpn

Create a new L2Vpn if the L2Vpn with given id does not already exist. If the L2Vpn with the given id already exists, merge with the existing L2Vpn. This is a patch. This API is deprecated. Please use PATCH /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions/<l2vpn-id> instead. If used, this deprecated API will result in an L2VPNSession being internally created/patched: - L2VPNSession: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/l2vpn-services/   default/sessions/L2VPN_<l2vpn-id>. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l2vpn_id = 'l2vpn_id_example' # String | 

l2_vpn = SwaggerClient::L2Vpn.new # L2Vpn | 


begin
  #Create or patch an L2Vpn
  api_instance.create_or_patch_l2_vpn(tier_0_id, locale_service_id, l2vpn_id, l2_vpn)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->create_or_patch_l2_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l2vpn_id** | **String**|  | 
 **l2_vpn** | [**L2Vpn**](L2Vpn.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_l2_vpn_session**
> create_or_patch_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id, l2_vpn_session)

Create or patch an L2VPN session

Create or patch an L2VPN session. API supported only when L2VPN Service is in Server Mode. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

l2_vpn_session = SwaggerClient::L2VPNSession.new # L2VPNSession | 


begin
  #Create or patch an L2VPN session
  api_instance.create_or_patch_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id, l2_vpn_session)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->create_or_patch_l2_vpn_session: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 
 **l2_vpn_session** | [**L2VPNSession**](L2VPNSession.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_l2_vpn_session_from_peer_codes_create_with_peer_code**
> create_or_patch_l2_vpn_session_from_peer_codes_create_with_peer_code(tier_0_id, locale_service_id, service_id, session_id, l2_vpn_session_data)

Create or patch an L2VPN session from Peer Codes

Create or patch an L2VPN session from Peer Codes. In addition to the L2VPN Session, the IPSec VPN Session, along with the IKE, Tunnel, and DPD Profiles are created and owned by the system. IPSec VPN Service and Local Endpoint are created only when required, i.e., an IPSec VPN Service does not already exist, or an IPSec VPN Local Endpoint with same local address does not already exist. Updating the L2VPN Session can be performed only through this API by specifying new peer codes. Use of specific APIs to update the L2VPN Session and the different resources associated with it is not allowed, except for IPSec VPN Service and Local Endpoint, resources that are not system owned. API supported only when L2VPN Service is in Client Mode. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

l2_vpn_session_data = SwaggerClient::L2VPNSessionData.new # L2VPNSessionData | 


begin
  #Create or patch an L2VPN session from Peer Codes
  api_instance.create_or_patch_l2_vpn_session_from_peer_codes_create_with_peer_code(tier_0_id, locale_service_id, service_id, session_id, l2_vpn_session_data)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->create_or_patch_l2_vpn_session_from_peer_codes_create_with_peer_code: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 
 **l2_vpn_session_data** | [**L2VPNSessionData**](L2VPNSessionData.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_l2_vpn**
> L2Vpn create_or_replace_l2_vpn(tier_0_id, locale_service_id, l2vpn_id, l2_vpn)

Create or replace an L2Vpn

Create a new L2Vpn if the L2Vpn with given id does not already exist. If the L2Vpn with the given id already exists, update the existing L2Vpn. This is a full replace. This API is deprecated. Please use PUT /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions/<l2vpn-id> instead. If used, this deprecated API will result in an L2VPNSession being internally created/updated: - L2VPNSession: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/l2vpn-services/   default/sessions/L2VPN_<l2vpn-id>. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l2vpn_id = 'l2vpn_id_example' # String | 

l2_vpn = SwaggerClient::L2Vpn.new # L2Vpn | 


begin
  #Create or replace an L2Vpn
  result = api_instance.create_or_replace_l2_vpn(tier_0_id, locale_service_id, l2vpn_id, l2_vpn)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->create_or_replace_l2_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l2vpn_id** | **String**|  | 
 **l2_vpn** | [**L2Vpn**](L2Vpn.md)|  | 

### Return type

[**L2Vpn**](L2Vpn.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_l2_vpn_session**
> L2VPNSession create_or_update_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id, l2_vpn_session)

Create or fully replace L2VPN session

Create or fully replace L2VPN session. API supported only when L2VPN Service is in Server Mode. Revision is optional for creation and required for update. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

l2_vpn_session = SwaggerClient::L2VPNSession.new # L2VPNSession | 


begin
  #Create or fully replace L2VPN session
  result = api_instance.create_or_update_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id, l2_vpn_session)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->create_or_update_l2_vpn_session: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **service_id** | **String**|  | 
 **session_id** | **String**|  | 
 **l2_vpn_session** | [**L2VPNSession**](L2VPNSession.md)|  | 

### Return type

[**L2VPNSession**](L2VPNSession.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_l2_vpn**
> delete_l2_vpn(tier_0_id, locale_service_id, l2vpn_id)

Delete an L2Vpn

Delete the L2Vpn with the given id. This API is deprecated. Please use DELETE /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions/<l2vpn-id> instead. If used, this deprecated API will result in the L2VPNSession being deleted: - L2VPNSession: /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/l2vpn-services/   default/sessions/L2VPN_<l2vpn-id>. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l2vpn_id = 'l2vpn_id_example' # String | 


begin
  #Delete an L2Vpn
  api_instance.delete_l2_vpn(tier_0_id, locale_service_id, l2vpn_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->delete_l2_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l2vpn_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_l2_vpn_session**
> delete_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id)

Delete L2VPN session

Delete L2VPN session. When L2VPN Service is in CLIENT Mode, the L2VPN Session is deleted along with its transpot tunnels and related resources.

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 


begin
  #Delete L2VPN session
  api_instance.delete_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->delete_l2_vpn_session: #{e}"
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



# **get_l2_vpn_session**
> L2VPNSession get_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id)

Get L2VPN Session

Get L2VPN session.

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 


begin
  #Get L2VPN Session
  result = api_instance.get_l2_vpn_session(tier_0_id, locale_service_id, service_id, session_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->get_l2_vpn_session: #{e}"
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

[**L2VPNSession**](L2VPNSession.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_l2_vpn_session_peer_config**
> AggregateL2VPNSessionPeerConfig get_l2_vpn_session_peer_config(tier_0_id, locale_service_id, service_id, session_id, opts)

Get L2VPN session configuration for the peer site

Get peer config for the L2VPN session to configure the remote side of the tunnel. - no enforcement point path specified: L2VPN Session Peer Codes will be evaluated on each enforcement point. - enforcement point paths specified: L2VPN Session Peer Codes are evaluated only on the given enforcement points. API supported only when L2VPN Service is in Server Mode. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

service_id = 'service_id_example' # String | 

session_id = 'session_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get L2VPN session configuration for the peer site
  result = api_instance.get_l2_vpn_session_peer_config(tier_0_id, locale_service_id, service_id, session_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->get_l2_vpn_session_peer_config: #{e}"
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

[**AggregateL2VPNSessionPeerConfig**](AggregateL2VPNSessionPeerConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_l2_vpn_sessions**
> L2VPNSessionListResult list_l2_vpn_sessions(tier_0_id, locale_service_id, service_id, opts)

Get L2VPN sessions list result

Get paginated list of all L2VPN sessions.

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

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
  #Get L2VPN sessions list result
  result = api_instance.list_l2_vpn_sessions(tier_0_id, locale_service_id, service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->list_l2_vpn_sessions: #{e}"
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

[**L2VPNSessionListResult**](L2VPNSessionListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_l2_vpns**
> L2VpnListResult list_l2_vpns(tier_0_id, locale_service_id, opts)

List L2Vpns

Paginated list of L2Vpns. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions instead. If used, this deprecated API will only return L2Vpns that were created through the deprecated PATCH and PUT /infra/tier-0s/<tier-0-id>/locale-services/<locale-service-id>/l2vpn-context/ l2vpns/<l2vpn-id> APIs. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

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
  #List L2Vpns
  result = api_instance.list_l2_vpns(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->list_l2_vpns: #{e}"
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

[**L2VpnListResult**](L2VpnListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_l2_vpn**
> L2Vpn read_l2_vpn(tier_0_id, locale_service_id, l2vpn_id)

Read an L2Vpn

Read the L2Vpn with the given id. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions/L2VPN_<l2vpn-id> instead. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l2vpn_id = 'l2vpn_id_example' # String | 


begin
  #Read an L2Vpn
  result = api_instance.read_l2_vpn(tier_0_id, locale_service_id, l2vpn_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->read_l2_vpn: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **l2vpn_id** | **String**|  | 

### Return type

[**L2Vpn**](L2Vpn.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_l2_vpn_peer_config**
> AggregateL2VpnPeerConfig read_l2_vpn_peer_config(tier_0_id, locale_service_id, l2vpn_id, opts)

Get Peer Config for L2Vpn

Get peer config for the L2Vpn to configure the remote side of the tunnel. - no enforcement point path specified: L2Vpn Peer Codes will be evaluated on each enforcement point. - {enforcement_point_path}: L2Vpn Peer Codes are evaluated only on the given enforcement point. This API is deprecated. Please use GET /infra/tier-0s/<tier-0-id>/locale-services/ <locale-service-id>/l2vpn-services/default/sessions/L2VPN_<l2vpn-id>/peer-config  instead. 

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

api_instance = SwaggerClient::PolicyVpnL2VpnSessionsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

l2vpn_id = 'l2vpn_id_example' # String | 

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get Peer Config for L2Vpn
  result = api_instance.read_l2_vpn_peer_config(tier_0_id, locale_service_id, l2vpn_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnL2VpnSessionsApi->read_l2_vpn_peer_config: #{e}"
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

[**AggregateL2VpnPeerConfig**](AggregateL2VpnPeerConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



