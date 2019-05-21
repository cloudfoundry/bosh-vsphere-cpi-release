# SwaggerClient::PolicyOperationsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_ipfix_collector_profile**](PolicyOperationsApi.md#create_or_replace_ipfix_collector_profile) | **PUT** /infra/ipfix-collector-profiles/{ipfix-collector-profile-id} | Create or Replace IPFIX collector profile
[**create_or_replace_ipfix_switch_collection_instance**](PolicyOperationsApi.md#create_or_replace_ipfix_switch_collection_instance) | **PUT** /infra/tier-1s/{tier-1-id}/ipfix-switch-collection-instances/{ipfix-switch-collection-instance-id} | Create or Replace IPFIX switch collection instance
[**create_or_replace_port_mirroring_instance**](PolicyOperationsApi.md#create_or_replace_port_mirroring_instance) | **PUT** /infra/domains/{domain-id}/groups/{group-id}/port-mirroring-instances/{port-mirroring-instance-id} | Create or Replace Port Mirroring Instance.
[**delete_ipfix_collector_profile**](PolicyOperationsApi.md#delete_ipfix_collector_profile) | **DELETE** /infra/ipfix-collector-profiles/{ipfix-collector-profile-id} | Delete IPFIX Collector profile
[**delete_ipfix_switch_collection_instance**](PolicyOperationsApi.md#delete_ipfix_switch_collection_instance) | **DELETE** /infra/tier-1s/{tier-1-id}/ipfix-switch-collection-instances/{ipfix-switch-collection-instance-id} | Delete IPFIX Switch Collection Instance
[**delete_port_mirroring_instance**](PolicyOperationsApi.md#delete_port_mirroring_instance) | **DELETE** /infra/domains/{domain-id}/groups/{group-id}/port-mirroring-instances/{port-mirroring-instance-id} | Delete Port Mirroring Instance
[**list_ipfix_collector_profiles**](PolicyOperationsApi.md#list_ipfix_collector_profiles) | **GET** /infra/ipfix-collector-profiles | List IPFIX Collector profiles.
[**list_ipfix_switch_collection_instances**](PolicyOperationsApi.md#list_ipfix_switch_collection_instances) | **GET** /infra/tier-1s/{tier-1-id}/ipfix-switch-collection-instances | List IPFIX Switch Collection Instances
[**list_port_mirroring_instances**](PolicyOperationsApi.md#list_port_mirroring_instances) | **GET** /infra/domains/{domain-id}/groups/{group-id}/port-mirroring-instances | List Port Mirroring Instances
[**list_resource_info**](PolicyOperationsApi.md#list_resource_info) | **GET** /fine-tuning/resources | For each type of entity what are the attributes owned by policy.
[**patch_ipfix_collector_profile**](PolicyOperationsApi.md#patch_ipfix_collector_profile) | **PATCH** /infra/ipfix-collector-profiles/{ipfix-collector-profile-id} | Patch IPFIX collector profile
[**patch_ipfix_switch_collection_instance**](PolicyOperationsApi.md#patch_ipfix_switch_collection_instance) | **PATCH** /infra/tier-1s/{tier-1-id}/ipfix-switch-collection-instances/{ipfix-switch-collection-instance-id} | Patch IPFIX switch collection instance
[**patch_port_mirroring_instance**](PolicyOperationsApi.md#patch_port_mirroring_instance) | **PATCH** /infra/domains/{domain-id}/groups/{group-id}/port-mirroring-instances/{port-mirroring-instance-id} | Patch Port Mirroring Instance.
[**read_ipfix_collector_profile**](PolicyOperationsApi.md#read_ipfix_collector_profile) | **GET** /infra/ipfix-collector-profiles/{ipfix-collector-profile-id} | Get IPFIX Collector profile
[**read_ipfix_switch_collection_instance**](PolicyOperationsApi.md#read_ipfix_switch_collection_instance) | **GET** /infra/tier-1s/{tier-1-id}/ipfix-switch-collection-instances/{ipfix-switch-collection-instance-id} | Get IPFIX Switch Collection Instance
[**read_port_mirroring_instance**](PolicyOperationsApi.md#read_port_mirroring_instance) | **GET** /infra/domains/{domain-id}/groups/{group-id}/port-mirroring-instances/{port-mirroring-instance-id} | Details of Port Mirroring Instance 


# **create_or_replace_ipfix_collector_profile**
> IPFIXCollectorProfile create_or_replace_ipfix_collector_profile(ipfix_collector_profile_id, ipfix_collector_profile)

Create or Replace IPFIX collector profile

Create or Replace IPFIX collector profile. IPFIX data will be sent to IPFIX collector port. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

ipfix_collector_profile_id = 'ipfix_collector_profile_id_example' # String | IPFIX collector profile id

ipfix_collector_profile = SwaggerClient::IPFIXCollectorProfile.new # IPFIXCollectorProfile | 


begin
  #Create or Replace IPFIX collector profile
  result = api_instance.create_or_replace_ipfix_collector_profile(ipfix_collector_profile_id, ipfix_collector_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->create_or_replace_ipfix_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_collector_profile_id** | **String**| IPFIX collector profile id | 
 **ipfix_collector_profile** | [**IPFIXCollectorProfile**](IPFIXCollectorProfile.md)|  | 

### Return type

[**IPFIXCollectorProfile**](IPFIXCollectorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ipfix_switch_collection_instance**
> IPFIXSwitchCollectionInstance create_or_replace_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id, ipfix_switch_collection_instance)

Create or Replace IPFIX switch collection instance

Create or replace IPFIX switch collection instance. Instance will start forwarding data to provided IPFIX collector. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

ipfix_switch_collection_instance_id = 'ipfix_switch_collection_instance_id_example' # String | IPFIX Switch Collection Instance ID

ipfix_switch_collection_instance = SwaggerClient::IPFIXSwitchCollectionInstance.new # IPFIXSwitchCollectionInstance | 


begin
  #Create or Replace IPFIX switch collection instance
  result = api_instance.create_or_replace_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id, ipfix_switch_collection_instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->create_or_replace_ipfix_switch_collection_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **ipfix_switch_collection_instance_id** | **String**| IPFIX Switch Collection Instance ID | 
 **ipfix_switch_collection_instance** | [**IPFIXSwitchCollectionInstance**](IPFIXSwitchCollectionInstance.md)|  | 

### Return type

[**IPFIXSwitchCollectionInstance**](IPFIXSwitchCollectionInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_port_mirroring_instance**
> PortMirroringInstance create_or_replace_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id, port_mirroring_instance)

Create or Replace Port Mirroring Instance.

Create or Replace port mirroring instance. Packets will be mirrored from source group to destination group. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

port_mirroring_instance_id = 'port_mirroring_instance_id_example' # String | Port Mirroring Instance Id

port_mirroring_instance = SwaggerClient::PortMirroringInstance.new # PortMirroringInstance | 


begin
  #Create or Replace Port Mirroring Instance.
  result = api_instance.create_or_replace_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id, port_mirroring_instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->create_or_replace_port_mirroring_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **port_mirroring_instance_id** | **String**| Port Mirroring Instance Id | 
 **port_mirroring_instance** | [**PortMirroringInstance**](PortMirroringInstance.md)|  | 

### Return type

[**PortMirroringInstance**](PortMirroringInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ipfix_collector_profile**
> delete_ipfix_collector_profile(ipfix_collector_profile_id)

Delete IPFIX Collector profile

API deletes IPFIX collector profile. Flow forwarding to collector will be stopped. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

ipfix_collector_profile_id = 'ipfix_collector_profile_id_example' # String | IPFIX collector Profile id


begin
  #Delete IPFIX Collector profile
  api_instance.delete_ipfix_collector_profile(ipfix_collector_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->delete_ipfix_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_collector_profile_id** | **String**| IPFIX collector Profile id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ipfix_switch_collection_instance**
> delete_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id)

Delete IPFIX Switch Collection Instance

API deletes IPFIX Switch Collection Instance.Flow forwarding to selected collector will be stopped. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

ipfix_switch_collection_instance_id = 'ipfix_switch_collection_instance_id_example' # String | IPFIX Switch Collection Instance ID


begin
  #Delete IPFIX Switch Collection Instance
  api_instance.delete_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->delete_ipfix_switch_collection_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **ipfix_switch_collection_instance_id** | **String**| IPFIX Switch Collection Instance ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_port_mirroring_instance**
> delete_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id)

Delete Port Mirroring Instance

API will delete port mirroring instance. Mirroring from source to destination ports will be stopped. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

port_mirroring_instance_id = 'port_mirroring_instance_id_example' # String | Port Mirroring Instance Id


begin
  #Delete Port Mirroring Instance
  api_instance.delete_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->delete_port_mirroring_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **port_mirroring_instance_id** | **String**| Port Mirroring Instance Id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ipfix_collector_profiles**
> IPFIXCollectorProfileListResult list_ipfix_collector_profiles(opts)

List IPFIX Collector profiles.

API will provide list of all IPFIX collector profiles and their details. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IPFIX Collector profiles.
  result = api_instance.list_ipfix_collector_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->list_ipfix_collector_profiles: #{e}"
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

[**IPFIXCollectorProfileListResult**](IPFIXCollectorProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ipfix_switch_collection_instances**
> IPFIXSwitchCollectionInstanceListResult list_ipfix_switch_collection_instances(tier_1_id, opts)

List IPFIX Switch Collection Instances

API provides list IPFIX Switch collection instances available on selected logical switch. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IPFIX Switch Collection Instances
  result = api_instance.list_ipfix_switch_collection_instances(tier_1_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->list_ipfix_switch_collection_instances: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**IPFIXSwitchCollectionInstanceListResult**](IPFIXSwitchCollectionInstanceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_port_mirroring_instances**
> PortMirroringInstanceListResult list_port_mirroring_instances(domain_id, group_id, opts)

List Port Mirroring Instances

API will list all port mirroring instances active on current group. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Port Mirroring Instances
  result = api_instance.list_port_mirroring_instances(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->list_port_mirroring_instances: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortMirroringInstanceListResult**](PortMirroringInstanceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_resource_info**
> ResourceInfoListResult list_resource_info(opts)

For each type of entity what are the attributes owned by policy.

This API provides field names of attributes in NSX types that are owned by Policy, as opposed to those owned by the enforcement point. For any type on NSX, some of the attributes of that type may be owned and set by Policy when realizing the intent, while some others may be owned and set by the enforcement point itself. This information can be used to disable updates to Policy owned attributes by the advanced networking UI, while allowing tweaking to the attributes owned by the management plane. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example', # String | Field by which records are sorted
  type: 'type_example' # String | Type query
}

begin
  #For each type of entity what are the attributes owned by policy.
  result = api_instance.list_resource_info(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->list_resource_info: #{e}"
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
 **type** | **String**| Type query | [optional] 

### Return type

[**ResourceInfoListResult**](ResourceInfoListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_ipfix_collector_profile**
> patch_ipfix_collector_profile(ipfix_collector_profile_id, ipfix_collector_profile)

Patch IPFIX collector profile

Create a new IPFIX collector profile if the IPFIX collector profile with given id does not already exist. If the IPFIX collector profile with the given id already exists, patch with the existing IPFIX collector profile. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

ipfix_collector_profile_id = 'ipfix_collector_profile_id_example' # String | IPFIX collector profile id

ipfix_collector_profile = SwaggerClient::IPFIXCollectorProfile.new # IPFIXCollectorProfile | 


begin
  #Patch IPFIX collector profile
  api_instance.patch_ipfix_collector_profile(ipfix_collector_profile_id, ipfix_collector_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->patch_ipfix_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_collector_profile_id** | **String**| IPFIX collector profile id | 
 **ipfix_collector_profile** | [**IPFIXCollectorProfile**](IPFIXCollectorProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_ipfix_switch_collection_instance**
> patch_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id, ipfix_switch_collection_instance)

Patch IPFIX switch collection instance

Create a new IPFIX switch collection instance if the IPFIX switch collection instance  with given id does not already exist. If the IPFIX switch collection instance with the given id already exists, patch with the existing IPFIX switch collection instance. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

ipfix_switch_collection_instance_id = 'ipfix_switch_collection_instance_id_example' # String | IPFIX Switch Collection Instance ID

ipfix_switch_collection_instance = SwaggerClient::IPFIXSwitchCollectionInstance.new # IPFIXSwitchCollectionInstance | 


begin
  #Patch IPFIX switch collection instance
  api_instance.patch_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id, ipfix_switch_collection_instance)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->patch_ipfix_switch_collection_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **ipfix_switch_collection_instance_id** | **String**| IPFIX Switch Collection Instance ID | 
 **ipfix_switch_collection_instance** | [**IPFIXSwitchCollectionInstance**](IPFIXSwitchCollectionInstance.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_port_mirroring_instance**
> patch_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id, port_mirroring_instance)

Patch Port Mirroring Instance.

Create a new Port Mirroring Instance if the Port Mirroring Instance with given id does not already exist. If the Port Mirroring Instance with the given id already exists, patch with the existing Port Mirroring Instance. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

port_mirroring_instance_id = 'port_mirroring_instance_id_example' # String | Port Mirroring Instance Id

port_mirroring_instance = SwaggerClient::PortMirroringInstance.new # PortMirroringInstance | 


begin
  #Patch Port Mirroring Instance.
  api_instance.patch_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id, port_mirroring_instance)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->patch_port_mirroring_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **port_mirroring_instance_id** | **String**| Port Mirroring Instance Id | 
 **port_mirroring_instance** | [**PortMirroringInstance**](PortMirroringInstance.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ipfix_collector_profile**
> IPFIXCollectorProfile read_ipfix_collector_profile(ipfix_collector_profile_id)

Get IPFIX Collector profile

API will return details of IPFIX collector profile. If profile does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

ipfix_collector_profile_id = 'ipfix_collector_profile_id_example' # String | IPFIX collector profile id


begin
  #Get IPFIX Collector profile
  result = api_instance.read_ipfix_collector_profile(ipfix_collector_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->read_ipfix_collector_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipfix_collector_profile_id** | **String**| IPFIX collector profile id | 

### Return type

[**IPFIXCollectorProfile**](IPFIXCollectorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ipfix_switch_collection_instance**
> IPFIXSwitchCollectionInstance read_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id)

Get IPFIX Switch Collection Instance

API will return details of IPFIX switch collection. If instance does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

tier_1_id = 'tier_1_id_example' # String | Tier-1 ID

ipfix_switch_collection_instance_id = 'ipfix_switch_collection_instance_id_example' # String | IPFIX switch collection id


begin
  #Get IPFIX Switch Collection Instance
  result = api_instance.read_ipfix_switch_collection_instance(tier_1_id, ipfix_switch_collection_instance_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->read_ipfix_switch_collection_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| Tier-1 ID | 
 **ipfix_switch_collection_instance_id** | **String**| IPFIX switch collection id | 

### Return type

[**IPFIXSwitchCollectionInstance**](IPFIXSwitchCollectionInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_port_mirroring_instance**
> PortMirroringInstance read_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id)

Details of Port Mirroring Instance 

API will return details of port mirroring instance. If instance does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicyOperationsApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

port_mirroring_instance_id = 'port_mirroring_instance_id_example' # String | Port Mirroring Instance Id


begin
  #Details of Port Mirroring Instance 
  result = api_instance.read_port_mirroring_instance(domain_id, group_id, port_mirroring_instance_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyOperationsApi->read_port_mirroring_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **port_mirroring_instance_id** | **String**| Port Mirroring Instance Id | 

### Return type

[**PortMirroringInstance**](PortMirroringInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



