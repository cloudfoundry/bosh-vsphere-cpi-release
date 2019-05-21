# SwaggerClient::PolicyVpnIpsecDpdProfilesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_ip_sec_vpn_dpd_profile**](PolicyVpnIpsecDpdProfilesApi.md#create_or_patch_ip_sec_vpn_dpd_profile) | **PATCH** /infra/ipsec-vpn-dpd-profiles/{dpd-profile-id} | Create or patch a custom DPD Profile
[**create_or_update_ip_sec_vpn_dpd_profile**](PolicyVpnIpsecDpdProfilesApi.md#create_or_update_ip_sec_vpn_dpd_profile) | **PUT** /infra/ipsec-vpn-dpd-profiles/{dpd-profile-id} | Create or fully replace a custom IPSec tunnel Profile
[**delete_ip_sec_vpn_dpd_profile**](PolicyVpnIpsecDpdProfilesApi.md#delete_ip_sec_vpn_dpd_profile) | **DELETE** /infra/ipsec-vpn-dpd-profiles/{dpd-profile-id} | Delete custom dead peer detection (DPD) profile
[**get_ip_sec_vpn_dpd_profile**](PolicyVpnIpsecDpdProfilesApi.md#get_ip_sec_vpn_dpd_profile) | **GET** /infra/ipsec-vpn-dpd-profiles/{dpd-profile-id} | Get dead peer detection (DPD) profile
[**list_ip_sec_vpn_dpd_profiles**](PolicyVpnIpsecDpdProfilesApi.md#list_ip_sec_vpn_dpd_profiles) | **GET** /infra/ipsec-vpn-dpd-profiles | List DPD profiles


# **create_or_patch_ip_sec_vpn_dpd_profile**
> create_or_patch_ip_sec_vpn_dpd_profile(dpd_profile_id, ip_sec_vpn_dpd_profile)

Create or patch a custom DPD Profile

Create or patch dead peer detection (DPD) profile. Any change in profile affects all sessions consuming this profile. System will be provisioned with system owned editable default DPD profile. Any change in profile affects all sessions consuming this profile.

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

api_instance = SwaggerClient::PolicyVpnIpsecDpdProfilesApi.new

dpd_profile_id = 'dpd_profile_id_example' # String | 

ip_sec_vpn_dpd_profile = SwaggerClient::IPSecVpnDpdProfile.new # IPSecVpnDpdProfile | 


begin
  #Create or patch a custom DPD Profile
  api_instance.create_or_patch_ip_sec_vpn_dpd_profile(dpd_profile_id, ip_sec_vpn_dpd_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecDpdProfilesApi->create_or_patch_ip_sec_vpn_dpd_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dpd_profile_id** | **String**|  | 
 **ip_sec_vpn_dpd_profile** | [**IPSecVpnDpdProfile**](IPSecVpnDpdProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_ip_sec_vpn_dpd_profile**
> IPSecVpnDpdProfile create_or_update_ip_sec_vpn_dpd_profile(dpd_profile_id, ip_sec_vpn_dpd_profile)

Create or fully replace a custom IPSec tunnel Profile

Create or patch dead peer detection (DPD) profile. Any change in profile affects all sessions consuming this profile. System will be provisioned with system owned editable default DPD profile. Any change in profile affects all sessions consuming this profile. Revision is optional for creation and required for update.

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

api_instance = SwaggerClient::PolicyVpnIpsecDpdProfilesApi.new

dpd_profile_id = 'dpd_profile_id_example' # String | 

ip_sec_vpn_dpd_profile = SwaggerClient::IPSecVpnDpdProfile.new # IPSecVpnDpdProfile | 


begin
  #Create or fully replace a custom IPSec tunnel Profile
  result = api_instance.create_or_update_ip_sec_vpn_dpd_profile(dpd_profile_id, ip_sec_vpn_dpd_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecDpdProfilesApi->create_or_update_ip_sec_vpn_dpd_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dpd_profile_id** | **String**|  | 
 **ip_sec_vpn_dpd_profile** | [**IPSecVpnDpdProfile**](IPSecVpnDpdProfile.md)|  | 

### Return type

[**IPSecVpnDpdProfile**](IPSecVpnDpdProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_sec_vpn_dpd_profile**
> delete_ip_sec_vpn_dpd_profile(dpd_profile_id)

Delete custom dead peer detection (DPD) profile

Delete custom dead peer detection (DPD) profile. Profile can not be deleted if profile has references to it.

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

api_instance = SwaggerClient::PolicyVpnIpsecDpdProfilesApi.new

dpd_profile_id = 'dpd_profile_id_example' # String | 


begin
  #Delete custom dead peer detection (DPD) profile
  api_instance.delete_ip_sec_vpn_dpd_profile(dpd_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecDpdProfilesApi->delete_ip_sec_vpn_dpd_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dpd_profile_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_sec_vpn_dpd_profile**
> IPSecVpnDpdProfile get_ip_sec_vpn_dpd_profile(dpd_profile_id)

Get dead peer detection (DPD) profile

Get custom dead peer detection (DPD) profile, given the particular id.

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

api_instance = SwaggerClient::PolicyVpnIpsecDpdProfilesApi.new

dpd_profile_id = 'dpd_profile_id_example' # String | 


begin
  #Get dead peer detection (DPD) profile
  result = api_instance.get_ip_sec_vpn_dpd_profile(dpd_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecDpdProfilesApi->get_ip_sec_vpn_dpd_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dpd_profile_id** | **String**|  | 

### Return type

[**IPSecVpnDpdProfile**](IPSecVpnDpdProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_sec_vpn_dpd_profiles**
> IPSecVpnDpdProfileListResult list_ip_sec_vpn_dpd_profiles(opts)

List DPD profiles

Get paginated list of all DPD Profiles.

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

api_instance = SwaggerClient::PolicyVpnIpsecDpdProfilesApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List DPD profiles
  result = api_instance.list_ip_sec_vpn_dpd_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecDpdProfilesApi->list_ip_sec_vpn_dpd_profiles: #{e}"
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

[**IPSecVpnDpdProfileListResult**](IPSecVpnDpdProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



