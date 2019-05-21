# SwaggerClient::PolicyDnsForwarderApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_policy_dns_forwarder_on_tier0**](PolicyDnsForwarderApi.md#delete_policy_dns_forwarder_on_tier0) | **DELETE** /infra/tier-0s/{tier-0-id}/dns-forwarder | Delete DNS configuration for tier-0 instance
[**delete_policy_dns_forwarder_on_tier1**](PolicyDnsForwarderApi.md#delete_policy_dns_forwarder_on_tier1) | **DELETE** /infra/tier-1s/{tier-1-id}/dns-forwarder | Delete DNS configuration for tier-1 instance
[**delete_policy_dns_forwarder_zone**](PolicyDnsForwarderApi.md#delete_policy_dns_forwarder_zone) | **DELETE** /infra/dns-forwarder-zones/{dns-forwarder-zone-id} | Delete the DNS Forwarder Zone
[**get_tier0_dns_forwarder_statistics**](PolicyDnsForwarderApi.md#get_tier0_dns_forwarder_statistics) | **GET** /infra/tier-0s/{tier-0-id}/dns-forwarder/statistics | Get tier-0 DNS forwarder statistics
[**get_tier0_dns_forwarder_status**](PolicyDnsForwarderApi.md#get_tier0_dns_forwarder_status) | **GET** /infra/tier-0s/{tier-0-id}/dns-forwarder/status | Get current status of tier-0 DNS forwarder
[**get_tier1_dns_forwarder_statistics**](PolicyDnsForwarderApi.md#get_tier1_dns_forwarder_statistics) | **GET** /infra/tier-1s/{tier-1-id}/dns-forwarder/statistics | Get tier-1 DNS forwarder statistics
[**get_tier1_dns_forwarder_status**](PolicyDnsForwarderApi.md#get_tier1_dns_forwarder_status) | **GET** /infra/tier-1s/{tier-1-id}/dns-forwarder/status | Get current status of tier-1 DNS forwarder
[**list_policy_dns_forwarder_zone**](PolicyDnsForwarderApi.md#list_policy_dns_forwarder_zone) | **GET** /infra/dns-forwarder-zones | List Dns Forwarder Zones
[**lookup_address_via_tier0_dns_forwarder**](PolicyDnsForwarderApi.md#lookup_address_via_tier0_dns_forwarder) | **GET** /infra/tier-0s/{tier-0-id}/dns-forwarder/nslookup | Resolve a given address via the dns forwarder at Tier0
[**lookup_address_via_tier1_dns_forwarder**](PolicyDnsForwarderApi.md#lookup_address_via_tier1_dns_forwarder) | **GET** /infra/tier-1s/{tier-1-id}/dns-forwarder/nslookup | Resolve a given address via the dns forwarder at Tier1
[**patch_policy_dns_forwarder_on_tier0**](PolicyDnsForwarderApi.md#patch_policy_dns_forwarder_on_tier0) | **PATCH** /infra/tier-0s/{tier-0-id}/dns-forwarder | Update the DNS Forwarder
[**patch_policy_dns_forwarder_on_tier1**](PolicyDnsForwarderApi.md#patch_policy_dns_forwarder_on_tier1) | **PATCH** /infra/tier-1s/{tier-1-id}/dns-forwarder | Create or update the DNS Forwarder
[**patch_policy_dns_forwarder_zone**](PolicyDnsForwarderApi.md#patch_policy_dns_forwarder_zone) | **PATCH** /infra/dns-forwarder-zones/{dns-forwarder-zone-id} | Create or update the DNS Forwarder Zone
[**perform_ep_action_for_dns_forwarder_at_tier0**](PolicyDnsForwarderApi.md#perform_ep_action_for_dns_forwarder_at_tier0) | **POST** /infra/tier-0s/{tier-0-id}/dns-forwarder | Perform the specified DNS forwarder action
[**perform_ep_action_for_dns_forwarder_at_tier1**](PolicyDnsForwarderApi.md#perform_ep_action_for_dns_forwarder_at_tier1) | **POST** /infra/tier-1s/{tier-1-id}/dns-forwarder | Perform the specified DNS forwarder action
[**read_policy_dns_forwarder_on_tier0**](PolicyDnsForwarderApi.md#read_policy_dns_forwarder_on_tier0) | **GET** /infra/tier-0s/{tier-0-id}/dns-forwarder | Read the DNS Forwarder for the given tier-0 instance
[**read_policy_dns_forwarder_on_tier1**](PolicyDnsForwarderApi.md#read_policy_dns_forwarder_on_tier1) | **GET** /infra/tier-1s/{tier-1-id}/dns-forwarder | Read the DNS Forwarder for the given tier-1 instance
[**read_policy_dns_forwarder_zone**](PolicyDnsForwarderApi.md#read_policy_dns_forwarder_zone) | **GET** /infra/dns-forwarder-zones/{dns-forwarder-zone-id} | Read the DNS Forwarder Zone
[**update_policy_dns_forwarder_on_tier0**](PolicyDnsForwarderApi.md#update_policy_dns_forwarder_on_tier0) | **PUT** /infra/tier-0s/{tier-0-id}/dns-forwarder | Update the DNS Forwarder
[**update_policy_dns_forwarder_on_tier1**](PolicyDnsForwarderApi.md#update_policy_dns_forwarder_on_tier1) | **PUT** /infra/tier-1s/{tier-1-id}/dns-forwarder | Create or update the DNS Forwarder
[**update_policy_dns_forwarder_zone**](PolicyDnsForwarderApi.md#update_policy_dns_forwarder_zone) | **PUT** /infra/dns-forwarder-zones/{dns-forwarder-zone-id} | Create or update the DNS Forwarder Zone


# **delete_policy_dns_forwarder_on_tier0**
> delete_policy_dns_forwarder_on_tier0(tier_0_id)

Delete DNS configuration for tier-0 instance

Delete DNS configuration for tier-0 instance

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID


begin
  #Delete DNS configuration for tier-0 instance
  api_instance.delete_policy_dns_forwarder_on_tier0(tier_0_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->delete_policy_dns_forwarder_on_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_dns_forwarder_on_tier1**
> delete_policy_dns_forwarder_on_tier1(tier_1_id)

Delete DNS configuration for tier-1 instance

Delete DNS configuration for tier-1 instance

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID


begin
  #Delete DNS configuration for tier-1 instance
  api_instance.delete_policy_dns_forwarder_on_tier1(tier_1_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->delete_policy_dns_forwarder_on_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_dns_forwarder_zone**
> delete_policy_dns_forwarder_zone(dns_forwarder_zone_id)

Delete the DNS Forwarder Zone

Delete the DNS Forwarder Zone

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

dns_forwarder_zone_id = 'dns_forwarder_zone_id_example' # String | DNS Forwarder Zone ID


begin
  #Delete the DNS Forwarder Zone
  api_instance.delete_policy_dns_forwarder_zone(dns_forwarder_zone_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->delete_policy_dns_forwarder_zone: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dns_forwarder_zone_id** | **String**| DNS Forwarder Zone ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier0_dns_forwarder_statistics**
> AggregateDNSForwarderStatistics get_tier0_dns_forwarder_statistics(tier_0_id, opts)

Get tier-0 DNS forwarder statistics

Get statistics of tier-0 DNS forwarder. - no enforcement point path specified: Statistics will be evaluated on each enforcement point. - {enforcement_point_path}: Statistics are evaluated only on the given enforcement point. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get tier-0 DNS forwarder statistics
  result = api_instance.get_tier0_dns_forwarder_statistics(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->get_tier0_dns_forwarder_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregateDNSForwarderStatistics**](AggregateDNSForwarderStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier0_dns_forwarder_status**
> AggregateDNSForwarderStatus get_tier0_dns_forwarder_status(tier_0_id, opts)

Get current status of tier-0 DNS forwarder

Get current status of tier-0 DNS forwarder. - no enforcement point path specified: Status will be evaluated on each enforcement point. - {enforcement_point_path}: Status will be evaluated only on the given enforcement point. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get current status of tier-0 DNS forwarder
  result = api_instance.get_tier0_dns_forwarder_status(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->get_tier0_dns_forwarder_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregateDNSForwarderStatus**](AggregateDNSForwarderStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier1_dns_forwarder_statistics**
> AggregateDNSForwarderStatistics get_tier1_dns_forwarder_statistics(tier_1_id, opts)

Get tier-1 DNS forwarder statistics

Get statistics of tier-1 DNS forwarder. - no enforcement point path specified: Statistics will be evaluated on each enforcement point. - {enforcement_point_path}: Statistics are evaluated only on the given enforcement point. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get tier-1 DNS forwarder statistics
  result = api_instance.get_tier1_dns_forwarder_statistics(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->get_tier1_dns_forwarder_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregateDNSForwarderStatistics**](AggregateDNSForwarderStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tier1_dns_forwarder_status**
> AggregateDNSForwarderStatus get_tier1_dns_forwarder_status(tier_1_id, opts)

Get current status of tier-1 DNS forwarder

Get current status of tier-1 DNS forwarder. - no enforcement point path specified: Status will be evaluated on each enforcement point. - {enforcement_point_path}: Status will be evaluated only on the given enforcement point. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get current status of tier-1 DNS forwarder
  result = api_instance.get_tier1_dns_forwarder_status(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->get_tier1_dns_forwarder_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregateDNSForwarderStatus**](AggregateDNSForwarderStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_dns_forwarder_zone**
> PolicyDnsForwarderZoneListResult list_policy_dns_forwarder_zone(opts)

List Dns Forwarder Zones

Paginated list of all Dns Forwarder Zones 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Dns Forwarder Zones
  result = api_instance.list_policy_dns_forwarder_zone(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->list_policy_dns_forwarder_zone: #{e}"
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

[**PolicyDnsForwarderZoneListResult**](PolicyDnsForwarderZoneListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **lookup_address_via_tier0_dns_forwarder**
> AggregatePolicyDnsAnswer lookup_address_via_tier0_dns_forwarder(tier_0_id, opts)

Resolve a given address via the dns forwarder at Tier0

Query the nameserver for an ip-address or a FQDN of the given an address optionally using an specified DNS server. If the address is a fqdn, nslookup will resolve ip-address with it. If the address is an ip-address, do a reverse lookup and answer fqdn(s). If enforcement point is specified, then DNS forwarder nslookup answer will get fetched from specified enforcement point. Otherwise from all enforcement points. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | 

opts = { 
  address: 'address_example', # String | IP address or FQDN for nslookup
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Resolve a given address via the dns forwarder at Tier0
  result = api_instance.lookup_address_via_tier0_dns_forwarder(tier_0_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->lookup_address_via_tier0_dns_forwarder: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **address** | **String**| IP address or FQDN for nslookup | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregatePolicyDnsAnswer**](AggregatePolicyDnsAnswer.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **lookup_address_via_tier1_dns_forwarder**
> AggregatePolicyDnsAnswer lookup_address_via_tier1_dns_forwarder(tier_1_id, opts)

Resolve a given address via the dns forwarder at Tier1

Query the nameserver for an ip-address or a FQDN of the given an address optionally using an specified DNS server. If the address is a fqdn, nslookup will resolve ip-address with it. If the address is an ip-address, do a reverse lookup and answer fqdn(s). If enforcement point is specified, then DNS forwarder nslookup answer will get fetched from specified enforcement point. Otherwise from all enforcement points. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | 

opts = { 
  address: 'address_example', # String | IP address or FQDN for nslookup
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Resolve a given address via the dns forwarder at Tier1
  result = api_instance.lookup_address_via_tier1_dns_forwarder(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->lookup_address_via_tier1_dns_forwarder: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **address** | **String**| IP address or FQDN for nslookup | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**AggregatePolicyDnsAnswer**](AggregatePolicyDnsAnswer.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_dns_forwarder_on_tier0**
> patch_policy_dns_forwarder_on_tier0(tier_0_id, policy_dns_forwarder)

Update the DNS Forwarder

Update the DNS Forwarder

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

policy_dns_forwarder = SwaggerClient::PolicyDnsForwarder.new # PolicyDnsForwarder | 


begin
  #Update the DNS Forwarder
  api_instance.patch_policy_dns_forwarder_on_tier0(tier_0_id, policy_dns_forwarder)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->patch_policy_dns_forwarder_on_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **policy_dns_forwarder** | [**PolicyDnsForwarder**](PolicyDnsForwarder.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_dns_forwarder_on_tier1**
> patch_policy_dns_forwarder_on_tier1(tier_1_id, policy_dns_forwarder)

Create or update the DNS Forwarder

Create or update the DNS Forwarder

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

policy_dns_forwarder = SwaggerClient::PolicyDnsForwarder.new # PolicyDnsForwarder | 


begin
  #Create or update the DNS Forwarder
  api_instance.patch_policy_dns_forwarder_on_tier1(tier_1_id, policy_dns_forwarder)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->patch_policy_dns_forwarder_on_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **policy_dns_forwarder** | [**PolicyDnsForwarder**](PolicyDnsForwarder.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_dns_forwarder_zone**
> patch_policy_dns_forwarder_zone(dns_forwarder_zone_id, policy_dns_forwarder_zone)

Create or update the DNS Forwarder Zone

Create or update the DNS Forwarder Zone

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

dns_forwarder_zone_id = 'dns_forwarder_zone_id_example' # String | DNS Forwarder Zone ID

policy_dns_forwarder_zone = SwaggerClient::PolicyDnsForwarderZone.new # PolicyDnsForwarderZone | 


begin
  #Create or update the DNS Forwarder Zone
  api_instance.patch_policy_dns_forwarder_zone(dns_forwarder_zone_id, policy_dns_forwarder_zone)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->patch_policy_dns_forwarder_zone: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dns_forwarder_zone_id** | **String**| DNS Forwarder Zone ID | 
 **policy_dns_forwarder_zone** | [**PolicyDnsForwarderZone**](PolicyDnsForwarderZone.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **perform_ep_action_for_dns_forwarder_at_tier0**
> perform_ep_action_for_dns_forwarder_at_tier0(tier_0_id, action, opts)

Perform the specified DNS forwarder action

Perform the specified action for Tier0 DNS forwarder on specified enforcement point. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | 

action = 'action_example' # String | An action to be performed for DNS forwarder on EP

opts = { 
  enforcement_point_path: '/infra/sites/default/enforcement-points/default' # String | An enforcement point path, on which the action is to be performed
}

begin
  #Perform the specified DNS forwarder action
  api_instance.perform_ep_action_for_dns_forwarder_at_tier0(tier_0_id, action, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->perform_ep_action_for_dns_forwarder_at_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **action** | **String**| An action to be performed for DNS forwarder on EP | 
 **enforcement_point_path** | **String**| An enforcement point path, on which the action is to be performed | [optional] [default to /infra/sites/default/enforcement-points/default]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **perform_ep_action_for_dns_forwarder_at_tier1**
> perform_ep_action_for_dns_forwarder_at_tier1(tier_1_id, action, opts)

Perform the specified DNS forwarder action

Perform the specified action for Tier0 DNS forwarder on specified enforcement point. 

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | 

action = 'action_example' # String | An action to be performed for DNS forwarder on EP

opts = { 
  enforcement_point_path: '/infra/sites/default/enforcement-points/default' # String | An enforcement point path, on which the action is to be performed
}

begin
  #Perform the specified DNS forwarder action
  api_instance.perform_ep_action_for_dns_forwarder_at_tier1(tier_1_id, action, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->perform_ep_action_for_dns_forwarder_at_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**|  | 
 **action** | **String**| An action to be performed for DNS forwarder on EP | 
 **enforcement_point_path** | **String**| An enforcement point path, on which the action is to be performed | [optional] [default to /infra/sites/default/enforcement-points/default]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_dns_forwarder_on_tier0**
> PolicyDnsForwarder read_policy_dns_forwarder_on_tier0(tier_0_id)

Read the DNS Forwarder for the given tier-0 instance

Read the DNS Forwarder for the given tier-0 instance

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID


begin
  #Read the DNS Forwarder for the given tier-0 instance
  result = api_instance.read_policy_dns_forwarder_on_tier0(tier_0_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->read_policy_dns_forwarder_on_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 

### Return type

[**PolicyDnsForwarder**](PolicyDnsForwarder.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_dns_forwarder_on_tier1**
> PolicyDnsForwarder read_policy_dns_forwarder_on_tier1(tier_1_id)

Read the DNS Forwarder for the given tier-1 instance

Read the DNS Forwarder for the given tier-1 instance

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID


begin
  #Read the DNS Forwarder for the given tier-1 instance
  result = api_instance.read_policy_dns_forwarder_on_tier1(tier_1_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->read_policy_dns_forwarder_on_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 

### Return type

[**PolicyDnsForwarder**](PolicyDnsForwarder.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_dns_forwarder_zone**
> PolicyDnsForwarderZone read_policy_dns_forwarder_zone(dns_forwarder_zone_id)

Read the DNS Forwarder Zone

Read the DNS Forwarder Zone

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

dns_forwarder_zone_id = 'dns_forwarder_zone_id_example' # String | DNS Forwarder Zone ID


begin
  #Read the DNS Forwarder Zone
  result = api_instance.read_policy_dns_forwarder_zone(dns_forwarder_zone_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->read_policy_dns_forwarder_zone: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dns_forwarder_zone_id** | **String**| DNS Forwarder Zone ID | 

### Return type

[**PolicyDnsForwarderZone**](PolicyDnsForwarderZone.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_policy_dns_forwarder_on_tier0**
> PolicyDnsForwarder update_policy_dns_forwarder_on_tier0(tier_0_id, policy_dns_forwarder)

Update the DNS Forwarder

Update the DNS Forwarder

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 ID

policy_dns_forwarder = SwaggerClient::PolicyDnsForwarder.new # PolicyDnsForwarder | 


begin
  #Update the DNS Forwarder
  result = api_instance.update_policy_dns_forwarder_on_tier0(tier_0_id, policy_dns_forwarder)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->update_policy_dns_forwarder_on_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 ID | 
 **policy_dns_forwarder** | [**PolicyDnsForwarder**](PolicyDnsForwarder.md)|  | 

### Return type

[**PolicyDnsForwarder**](PolicyDnsForwarder.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_policy_dns_forwarder_on_tier1**
> PolicyDnsForwarder update_policy_dns_forwarder_on_tier1(tier_1_id, policy_dns_forwarder)

Create or update the DNS Forwarder

Create or update the DNS Forwarder

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

policy_dns_forwarder = SwaggerClient::PolicyDnsForwarder.new # PolicyDnsForwarder | 


begin
  #Create or update the DNS Forwarder
  result = api_instance.update_policy_dns_forwarder_on_tier1(tier_1_id, policy_dns_forwarder)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->update_policy_dns_forwarder_on_tier1: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **policy_dns_forwarder** | [**PolicyDnsForwarder**](PolicyDnsForwarder.md)|  | 

### Return type

[**PolicyDnsForwarder**](PolicyDnsForwarder.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_policy_dns_forwarder_zone**
> PolicyDnsForwarderZone update_policy_dns_forwarder_zone(dns_forwarder_zone_id, policy_dns_forwarder_zone)

Create or update the DNS Forwarder Zone

Create or update the DNS Forwarder Zone

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

api_instance = SwaggerClient::PolicyDnsForwarderApi.new

dns_forwarder_zone_id = 'dns_forwarder_zone_id_example' # String | DNS Forwarder Zone ID

policy_dns_forwarder_zone = SwaggerClient::PolicyDnsForwarderZone.new # PolicyDnsForwarderZone | 


begin
  #Create or update the DNS Forwarder Zone
  result = api_instance.update_policy_dns_forwarder_zone(dns_forwarder_zone_id, policy_dns_forwarder_zone)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyDnsForwarderApi->update_policy_dns_forwarder_zone: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dns_forwarder_zone_id** | **String**| DNS Forwarder Zone ID | 
 **policy_dns_forwarder_zone** | [**PolicyDnsForwarderZone**](PolicyDnsForwarderZone.md)|  | 

### Return type

[**PolicyDnsForwarderZone**](PolicyDnsForwarderZone.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



