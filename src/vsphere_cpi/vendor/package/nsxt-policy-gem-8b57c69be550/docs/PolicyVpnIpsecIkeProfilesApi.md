# SwaggerClient::PolicyVpnIpsecIkeProfilesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_ip_sec_vpn_ike_profile**](PolicyVpnIpsecIkeProfilesApi.md#create_or_patch_ip_sec_vpn_ike_profile) | **PATCH** /infra/ipsec-vpn-ike-profiles/{ike-profile-id} | Create or patch a custom internet key exchange (IKE) Profile
[**create_or_update_ip_sec_vpn_ike_profile**](PolicyVpnIpsecIkeProfilesApi.md#create_or_update_ip_sec_vpn_ike_profile) | **PUT** /infra/ipsec-vpn-ike-profiles/{ike-profile-id} | Create or fully replace a custom internet key exchange (IKE) Profile
[**delete_ip_sec_vpn_ike_profile**](PolicyVpnIpsecIkeProfilesApi.md#delete_ip_sec_vpn_ike_profile) | **DELETE** /infra/ipsec-vpn-ike-profiles/{ike-profile-id} | Delete custom IKE Profile
[**get_ip_sec_vpn_ike_profile**](PolicyVpnIpsecIkeProfilesApi.md#get_ip_sec_vpn_ike_profile) | **GET** /infra/ipsec-vpn-ike-profiles/{ike-profile-id} | Get IKE Profile
[**list_ip_sec_vpn_ike_profiles**](PolicyVpnIpsecIkeProfilesApi.md#list_ip_sec_vpn_ike_profiles) | **GET** /infra/ipsec-vpn-ike-profiles | List IKE profiles


# **create_or_patch_ip_sec_vpn_ike_profile**
> create_or_patch_ip_sec_vpn_ike_profile(ike_profile_id, ip_sec_vpn_ike_profile)

Create or patch a custom internet key exchange (IKE) Profile

Create or patch custom internet key exchange (IKE) Profile. IKE Profile is a reusable profile that captures IKE and phase one negotiation parameters. System will be pre provisioned with system owned editable default IKE profile and suggested set of profiles that can be used for peering with popular remote peers like AWS VPN. User can create custom profiles as needed. Any change in profile affects all sessions consuming this profile.

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

api_instance = SwaggerClient::PolicyVpnIpsecIkeProfilesApi.new

ike_profile_id = 'ike_profile_id_example' # String | 

ip_sec_vpn_ike_profile = SwaggerClient::IPSecVpnIkeProfile.new # IPSecVpnIkeProfile | 


begin
  #Create or patch a custom internet key exchange (IKE) Profile
  api_instance.create_or_patch_ip_sec_vpn_ike_profile(ike_profile_id, ip_sec_vpn_ike_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecIkeProfilesApi->create_or_patch_ip_sec_vpn_ike_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ike_profile_id** | **String**|  | 
 **ip_sec_vpn_ike_profile** | [**IPSecVpnIkeProfile**](IPSecVpnIkeProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_ip_sec_vpn_ike_profile**
> IPSecVpnIkeProfile create_or_update_ip_sec_vpn_ike_profile(ike_profile_id, ip_sec_vpn_ike_profile)

Create or fully replace a custom internet key exchange (IKE) Profile

Create or fully replace custom internet key exchange (IKE) Profile. IKE Profile is a reusable profile that captures IKE and phase one negotiation parameters. System will be pre provisioned with system owned editable default IKE profile and suggested set of profiles that can be used for peering with popular remote peers like AWS VPN. User can create custom profiles as needed. Any change in profile affects all sessions consuming this profile. Revision is optional for creation and required for update.

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

api_instance = SwaggerClient::PolicyVpnIpsecIkeProfilesApi.new

ike_profile_id = 'ike_profile_id_example' # String | 

ip_sec_vpn_ike_profile = SwaggerClient::IPSecVpnIkeProfile.new # IPSecVpnIkeProfile | 


begin
  #Create or fully replace a custom internet key exchange (IKE) Profile
  result = api_instance.create_or_update_ip_sec_vpn_ike_profile(ike_profile_id, ip_sec_vpn_ike_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecIkeProfilesApi->create_or_update_ip_sec_vpn_ike_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ike_profile_id** | **String**|  | 
 **ip_sec_vpn_ike_profile** | [**IPSecVpnIkeProfile**](IPSecVpnIkeProfile.md)|  | 

### Return type

[**IPSecVpnIkeProfile**](IPSecVpnIkeProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_sec_vpn_ike_profile**
> delete_ip_sec_vpn_ike_profile(ike_profile_id)

Delete custom IKE Profile

Delete custom IKE Profile. Profile can not be deleted if profile has references to it.

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

api_instance = SwaggerClient::PolicyVpnIpsecIkeProfilesApi.new

ike_profile_id = 'ike_profile_id_example' # String | 


begin
  #Delete custom IKE Profile
  api_instance.delete_ip_sec_vpn_ike_profile(ike_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecIkeProfilesApi->delete_ip_sec_vpn_ike_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ike_profile_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ip_sec_vpn_ike_profile**
> IPSecVpnIkeProfile get_ip_sec_vpn_ike_profile(ike_profile_id)

Get IKE Profile

Get custom IKE Profile, given the particular id.

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

api_instance = SwaggerClient::PolicyVpnIpsecIkeProfilesApi.new

ike_profile_id = 'ike_profile_id_example' # String | 


begin
  #Get IKE Profile
  result = api_instance.get_ip_sec_vpn_ike_profile(ike_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecIkeProfilesApi->get_ip_sec_vpn_ike_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ike_profile_id** | **String**|  | 

### Return type

[**IPSecVpnIkeProfile**](IPSecVpnIkeProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_sec_vpn_ike_profiles**
> IPSecVpnIkeProfileListResult list_ip_sec_vpn_ike_profiles(opts)

List IKE profiles

Get paginated list of all IKE Profiles.

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

api_instance = SwaggerClient::PolicyVpnIpsecIkeProfilesApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IKE profiles
  result = api_instance.list_ip_sec_vpn_ike_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyVpnIpsecIkeProfilesApi->list_ip_sec_vpn_ike_profiles: #{e}"
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

[**IPSecVpnIkeProfileListResult**](IPSecVpnIkeProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



