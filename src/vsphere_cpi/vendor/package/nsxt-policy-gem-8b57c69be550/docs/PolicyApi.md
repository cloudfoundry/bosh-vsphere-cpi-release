# SwaggerClient::PolicyApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_domain**](PolicyApi.md#delete_domain) | **DELETE** /infra/domains/{domain-id} | Delete Domain and all the entities contained by this domain
[**delete_group**](PolicyApi.md#delete_group) | **DELETE** /infra/domains/{domain-id}/groups/{group-id} | Delete Group
[**delete_service_entry**](PolicyApi.md#delete_service_entry) | **DELETE** /infra/services/{service-id}/service-entries/{service-entry-id} | Delete Service entry
[**delete_service_for_tenant**](PolicyApi.md#delete_service_for_tenant) | **DELETE** /infra/services/{service-id} | Delete Service
[**list_domain_for_infra**](PolicyApi.md#list_domain_for_infra) | **GET** /infra/domains | List domains for infra
[**list_gateway_policies_for_domain**](PolicyApi.md#list_gateway_policies_for_domain) | **GET** /infra/domains/{domain-id}/gateway-policies | List gateway policies
[**list_group_for_domain**](PolicyApi.md#list_group_for_domain) | **GET** /infra/domains/{domain-id}/groups | List Groups for a domain
[**list_service_entries**](PolicyApi.md#list_service_entries) | **GET** /infra/services/{service-id}/service-entries | List Service entries for the given service
[**list_services_for_tenant**](PolicyApi.md#list_services_for_tenant) | **GET** /infra/services | List Services for infra
[**patch_domain_for_infra**](PolicyApi.md#patch_domain_for_infra) | **PATCH** /infra/domains/{domain-id} | Patch a domain
[**patch_group_for_domain**](PolicyApi.md#patch_group_for_domain) | **PATCH** /infra/domains/{domain-id}/groups/{group-id} | Patch a group
[**patch_infra**](PolicyApi.md#patch_infra) | **PATCH** /infra | Update the infra including all the nested entities
[**patch_service_entry**](PolicyApi.md#patch_service_entry) | **PATCH** /infra/services/{service-id}/service-entries/{service-entry-id} | Patch a ServiceEntry
[**patch_service_for_tenant**](PolicyApi.md#patch_service_for_tenant) | **PATCH** /infra/services/{service-id} | Patch a Service
[**read_domain_for_infra**](PolicyApi.md#read_domain_for_infra) | **GET** /infra/domains/{domain-id} | Read domain
[**read_group_for_domain**](PolicyApi.md#read_group_for_domain) | **GET** /infra/domains/{domain-id}/groups/{group-id} | Read group
[**read_infra**](PolicyApi.md#read_infra) | **GET** /infra | Read infra
[**read_service_entry**](PolicyApi.md#read_service_entry) | **GET** /infra/services/{service-id}/service-entries/{service-entry-id} | Service entry
[**read_service_for_tenant**](PolicyApi.md#read_service_for_tenant) | **GET** /infra/services/{service-id} | Read a service
[**revise_gateway_policy_revise**](PolicyApi.md#revise_gateway_policy_revise) | **POST** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}?action&#x3D;revise | Revise the positioning of gateway policy
[**revise_gateway_rule_revise**](PolicyApi.md#revise_gateway_rule_revise) | **POST** /infra/domains/{domain-id}/gateway-policies/{gateway-policy-id}/rules/{rule-id}?action&#x3D;revise | Revise the positioning of gateway rule
[**update_domain_for_infra**](PolicyApi.md#update_domain_for_infra) | **PUT** /infra/domains/{domain-id} | Create or update a domain
[**update_group_for_domain**](PolicyApi.md#update_group_for_domain) | **PUT** /infra/domains/{domain-id}/groups/{group-id} | Create or update a group
[**update_infra**](PolicyApi.md#update_infra) | **PUT** /infra | Update the infra including all the nested entities
[**update_service_entry**](PolicyApi.md#update_service_entry) | **PUT** /infra/services/{service-id}/service-entries/{service-entry-id} | Create or update a ServiceEntry
[**update_service_for_tenant**](PolicyApi.md#update_service_for_tenant) | **PUT** /infra/services/{service-id} | Create or update a Service


# **delete_domain**
> delete_domain(domain_id)

Delete Domain and all the entities contained by this domain

Delete the domain along with all the entities contained by this domain. The groups that are a part of this domain are also deleted along with the domain. 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID


begin
  #Delete Domain and all the entities contained by this domain
  api_instance.delete_domain(domain_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->delete_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_group**
> delete_group(domain_id, group_id, opts)

Delete Group

Delete Group

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete Group
  api_instance.delete_group(domain_id, group_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->delete_group: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_service_entry**
> delete_service_entry(service_id, service_entry_id)

Delete Service entry

Delete Service entry

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

service_entry_id = 'service_entry_id_example' # String | Service entry ID


begin
  #Delete Service entry
  api_instance.delete_service_entry(service_id, service_entry_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->delete_service_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **service_entry_id** | **String**| Service entry ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_service_for_tenant**
> delete_service_for_tenant(service_id)

Delete Service

Delete Service

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID


begin
  #Delete Service
  api_instance.delete_service_for_tenant(service_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->delete_service_for_tenant: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_domain_for_infra**
> DomainListResult list_domain_for_infra(opts)

List domains for infra

Paginated list of all domains for infra. 

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

api_instance = SwaggerClient::PolicyApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List domains for infra
  result = api_instance.list_domain_for_infra(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->list_domain_for_infra: #{e}"
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

[**DomainListResult**](DomainListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_gateway_policies_for_domain**
> GatewayPolicyListResult list_gateway_policies_for_domain(domain_id, opts)

List gateway policies

List all gateway policies for specified Domain.

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List gateway policies
  result = api_instance.list_gateway_policies_for_domain(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->list_gateway_policies_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GatewayPolicyListResult**](GatewayPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_group_for_domain**
> GroupListResult list_group_for_domain(domain_id, opts)

List Groups for a domain

List Groups for a domain

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Groups for a domain
  result = api_instance.list_group_for_domain(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->list_group_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GroupListResult**](GroupListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_service_entries**
> ServiceEntryListResult list_service_entries(service_id, opts)

List Service entries for the given service

Paginated list of Service entries for the given service 

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Service entries for the given service
  result = api_instance.list_service_entries(service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->list_service_entries: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ServiceEntryListResult**](ServiceEntryListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_services_for_tenant**
> ServiceListResult list_services_for_tenant(opts)

List Services for infra

Paginated list of Services for infra. 

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

api_instance = SwaggerClient::PolicyApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  default_service: true, # BOOLEAN | Fetch all default services
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Services for infra
  result = api_instance.list_services_for_tenant(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->list_services_for_tenant: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **default_service** | **BOOLEAN**| Fetch all default services | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ServiceListResult**](ServiceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_domain_for_infra**
> patch_domain_for_infra(domain_id, domain)

Patch a domain

If a domain with the domain-id is not already present, create a new domain. If it already exists, patch the domain 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

domain = SwaggerClient::Domain.new # Domain | 


begin
  #Patch a domain
  api_instance.patch_domain_for_infra(domain_id, domain)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->patch_domain_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **domain** | [**Domain**](Domain.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_group_for_domain**
> patch_group_for_domain(domain_id, group_id, group)

Patch a group

If a group with the group-id is not already present, create a new group. If it already exists, patch the group. 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

group = SwaggerClient::Group.new # Group | 


begin
  #Patch a group
  api_instance.patch_group_for_domain(domain_id, group_id, group)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->patch_group_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **group** | [**Group**](Group.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra**
> patch_infra(infra, opts)

Update the infra including all the nested entities

Patch API at infra level can be used in two flavours 1. Like a regular API to update Infra object 2. Hierarchical API: To create/update/delete entire or part of intent    hierarchy Hierarchical API: Provides users a way to create entire or part of intent in single API invocation. Input is expressed in a tree format. Each node in tree can have multiple children of different types. System will resolve the dependecies of nodes within the intent tree and will create the model. Children for any node can be specified using ChildResourceReference or ChildPolicyConfigResource. If a resource is specified using ChildResourceReference then it will not be updated only its children will be updated. If Object is specified using ChildPolicyConfigResource, object along with its children will be updated. Hierarchical API can also be used to delete any sub-branch of entire tree. 

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

api_instance = SwaggerClient::PolicyApi.new

infra = SwaggerClient::Infra.new # Infra | 

opts = { 
  enforce_revision_check: false # BOOLEAN | Force revision check
}

begin
  #Update the infra including all the nested entities
  api_instance.patch_infra(infra, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->patch_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra** | [**Infra**](Infra.md)|  | 
 **enforce_revision_check** | **BOOLEAN**| Force revision check | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_entry**
> patch_service_entry(service_id, service_entry_id, service_entry)

Patch a ServiceEntry

If a service entry with the service-entry-id is not already present, create a new service entry. If it already exists, patch the service entry. 

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

service_entry_id = 'service_entry_id_example' # String | Service entry ID

service_entry = SwaggerClient::ServiceEntry.new # ServiceEntry | 


begin
  #Patch a ServiceEntry
  api_instance.patch_service_entry(service_id, service_entry_id, service_entry)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->patch_service_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **service_entry_id** | **String**| Service entry ID | 
 **service_entry** | [**ServiceEntry**](ServiceEntry.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_for_tenant**
> patch_service_for_tenant(service_id, service)

Patch a Service

Create a new service if a service with the given ID does not already exist. Creates new service entries if populated in the service. If a service with the given ID already exists, patch the service including the nested service entries. 

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

service = SwaggerClient::Service.new # Service | 


begin
  #Patch a Service
  api_instance.patch_service_for_tenant(service_id, service)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->patch_service_for_tenant: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **service** | [**Service**](Service.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_domain_for_infra**
> Domain read_domain_for_infra(domain_id)

Read domain

Read a domain. 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID


begin
  #Read domain
  result = api_instance.read_domain_for_infra(domain_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->read_domain_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 

### Return type

[**Domain**](Domain.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_group_for_domain**
> Group read_group_for_domain(domain_id, group_id)

Read group

Read group

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID


begin
  #Read group
  result = api_instance.read_group_for_domain(domain_id, group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->read_group_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 

### Return type

[**Group**](Group.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_infra**
> Infra read_infra(opts)

Read infra

Read infra. Returns only the infra related properties. Inner object are not populated. 

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

api_instance = SwaggerClient::PolicyApi.new

opts = { 
  filter: 'filter_example' # String | Filter string as java regex
}

begin
  #Read infra
  result = api_instance.read_infra(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->read_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **filter** | **String**| Filter string as java regex | [optional] 

### Return type

[**Infra**](Infra.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_entry**
> ServiceEntry read_service_entry(service_id, service_entry_id)

Service entry

Service entry

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

service_entry_id = 'service_entry_id_example' # String | Service entry ID


begin
  #Service entry
  result = api_instance.read_service_entry(service_id, service_entry_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->read_service_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **service_entry_id** | **String**| Service entry ID | 

### Return type

[**ServiceEntry**](ServiceEntry.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_for_tenant**
> Service read_service_for_tenant(service_id)

Read a service

Read a service

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID


begin
  #Read a service
  result = api_instance.read_service_for_tenant(service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->read_service_for_tenant: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 

### Return type

[**Service**](Service.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **revise_gateway_policy_revise**
> GatewayPolicy revise_gateway_policy_revise(domain_id, gateway_policy_id, gateway_policy, opts)

Revise the positioning of gateway policy

This is used to set a precedence of a gateway policy w.r.t others. 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

gateway_policy = SwaggerClient::GatewayPolicy.new # GatewayPolicy | 

opts = { 
  anchor_path: 'anchor_path_example', # String | The security policy/rule path if operation is 'insert_after' or 'insert_before' 
  operation: 'insert_top' # String | Operation
}

begin
  #Revise the positioning of gateway policy
  result = api_instance.revise_gateway_policy_revise(domain_id, gateway_policy_id, gateway_policy, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->revise_gateway_policy_revise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **gateway_policy** | [**GatewayPolicy**](GatewayPolicy.md)|  | 
 **anchor_path** | **String**| The security policy/rule path if operation is &#39;insert_after&#39; or &#39;insert_before&#39;  | [optional] 
 **operation** | **String**| Operation | [optional] [default to insert_top]

### Return type

[**GatewayPolicy**](GatewayPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **revise_gateway_rule_revise**
> Rule revise_gateway_rule_revise(domain_id, gateway_policy_id, rule_id, rule, opts)

Revise the positioning of gateway rule

This is used to re-order a gateway rule within a gateway policy. 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | 

gateway_policy_id = 'gateway_policy_id_example' # String | 

rule_id = 'rule_id_example' # String | 

rule = SwaggerClient::Rule.new # Rule | 

opts = { 
  anchor_path: 'anchor_path_example', # String | The security policy/rule path if operation is 'insert_after' or 'insert_before' 
  operation: 'insert_top' # String | Operation
}

begin
  #Revise the positioning of gateway rule
  result = api_instance.revise_gateway_rule_revise(domain_id, gateway_policy_id, rule_id, rule, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->revise_gateway_rule_revise: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**|  | 
 **gateway_policy_id** | **String**|  | 
 **rule_id** | **String**|  | 
 **rule** | [**Rule**](Rule.md)|  | 
 **anchor_path** | **String**| The security policy/rule path if operation is &#39;insert_after&#39; or &#39;insert_before&#39;  | [optional] 
 **operation** | **String**| Operation | [optional] [default to insert_top]

### Return type

[**Rule**](Rule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_domain_for_infra**
> Domain update_domain_for_infra(domain_id, domain)

Create or update a domain

If a domain with the domain-id is not already present, create a new domain. If it already exists, update the domain including the nested groups. This is a full replace 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

domain = SwaggerClient::Domain.new # Domain | 


begin
  #Create or update a domain
  result = api_instance.update_domain_for_infra(domain_id, domain)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->update_domain_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **domain** | [**Domain**](Domain.md)|  | 

### Return type

[**Domain**](Domain.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_group_for_domain**
> Group update_group_for_domain(domain_id, group_id, group)

Create or update a group

If a group with the group-id is not already present, create a new group. If it already exists, update the group. 

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

api_instance = SwaggerClient::PolicyApi.new

domain_id = 'domain_id_example' # String | Domain ID

group_id = 'group_id_example' # String | Group ID

group = SwaggerClient::Group.new # Group | 


begin
  #Create or update a group
  result = api_instance.update_group_for_domain(domain_id, group_id, group)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->update_group_for_domain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **group_id** | **String**| Group ID | 
 **group** | [**Group**](Group.md)|  | 

### Return type

[**Group**](Group.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_infra**
> Infra update_infra(infra)

Update the infra including all the nested entities

Update the infra including all the nested entities

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

api_instance = SwaggerClient::PolicyApi.new

infra = SwaggerClient::Infra.new # Infra | 


begin
  #Update the infra including all the nested entities
  result = api_instance.update_infra(infra)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->update_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **infra** | [**Infra**](Infra.md)|  | 

### Return type

[**Infra**](Infra.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_service_entry**
> ServiceEntry update_service_entry(service_id, service_entry_id, service_entry)

Create or update a ServiceEntry

If a service entry with the service-entry-id is not already present, create a new service entry. If it already exists, update the service entry. 

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

service_entry_id = 'service_entry_id_example' # String | Service entry ID

service_entry = SwaggerClient::ServiceEntry.new # ServiceEntry | 


begin
  #Create or update a ServiceEntry
  result = api_instance.update_service_entry(service_id, service_entry_id, service_entry)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->update_service_entry: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **service_entry_id** | **String**| Service entry ID | 
 **service_entry** | [**ServiceEntry**](ServiceEntry.md)|  | 

### Return type

[**ServiceEntry**](ServiceEntry.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_service_for_tenant**
> Service update_service_for_tenant(service_id, service)

Create or update a Service

Create a new service if a service with the given ID does not already exist. Creates new service entries if populated in the service. If a service with the given ID already exists, update the service including the nested service entries. This is a full replace. 

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

api_instance = SwaggerClient::PolicyApi.new

service_id = 'service_id_example' # String | Service ID

service = SwaggerClient::Service.new # Service | 


begin
  #Create or update a Service
  result = api_instance.update_service_for_tenant(service_id, service)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyApi->update_service_for_tenant: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_id** | **String**| Service ID | 
 **service** | [**Service**](Service.md)|  | 

### Return type

[**Service**](Service.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



