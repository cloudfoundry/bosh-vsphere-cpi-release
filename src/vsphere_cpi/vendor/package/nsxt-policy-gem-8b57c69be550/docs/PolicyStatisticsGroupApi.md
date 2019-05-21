# SwaggerClient::PolicyStatisticsGroupApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_group_ip_members**](PolicyStatisticsGroupApi.md#get_group_ip_members) | **GET** /infra/domains/{domain-id}/groups/{group-id}/members/ip-addresses | Get IP addresses that belong to this Group
[**get_group_lp_members**](PolicyStatisticsGroupApi.md#get_group_lp_members) | **GET** /infra/domains/{domain-id}/groups/{group-id}/members/logical-ports | Get logical ports that belong to this Group
[**get_group_ls_members**](PolicyStatisticsGroupApi.md#get_group_ls_members) | **GET** /infra/domains/{domain-id}/groups/{group-id}/members/logical-switches | Get logical switches that belong to this Group
[**get_group_tags**](PolicyStatisticsGroupApi.md#get_group_tags) | **GET** /infra/domains/{domain-id}/groups/{group-id}/tags | Get tags used to define conditions inside a Group
[**get_group_vm_members**](PolicyStatisticsGroupApi.md#get_group_vm_members) | **GET** /infra/domains/{domain-id}/groups/{group-id}/members/virtual-machines | Get Virtual machines that belong to this Group
[**get_group_vm_statistics**](PolicyStatisticsGroupApi.md#get_group_vm_statistics) | **GET** /infra/domains/{domain-id}/groups/{group-id}/statistics/virtual-machines | Get effective VMs for the Group
[**get_groups_for_object**](PolicyStatisticsGroupApi.md#get_groups_for_object) | **GET** /infra/group-associations | Get groups for which the given object is a member


# **get_group_ip_members**
> PolicyGroupIPMembersListResult get_group_ip_members(domain_id, group_id, opts)

Get IP addresses that belong to this Group

Get IP addresses that belong to this Group 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

domain_id = 'domain_id_example' # String | Domain id

group_id = 'group_id_example' # String | Group Id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get IP addresses that belong to this Group
  result = api_instance.get_group_ip_members(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_group_ip_members: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **group_id** | **String**| Group Id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyGroupIPMembersListResult**](PolicyGroupIPMembersListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_lp_members**
> PolicyGroupMembersListResult get_group_lp_members(domain_id, group_id, opts)

Get logical ports that belong to this Group

Get logical ports that belong to this Group 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

domain_id = 'domain_id_example' # String | Domain id

group_id = 'group_id_example' # String | Group Id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get logical ports that belong to this Group
  result = api_instance.get_group_lp_members(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_group_lp_members: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **group_id** | **String**| Group Id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyGroupMembersListResult**](PolicyGroupMembersListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_ls_members**
> PolicyGroupMembersListResult get_group_ls_members(domain_id, group_id, opts)

Get logical switches that belong to this Group

Get logical switches that belong to this Group 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

domain_id = 'domain_id_example' # String | Domain id

group_id = 'group_id_example' # String | Group Id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get logical switches that belong to this Group
  result = api_instance.get_group_ls_members(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_group_ls_members: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **group_id** | **String**| Group Id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyGroupMembersListResult**](PolicyGroupMembersListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_tags**
> GroupTagsList get_group_tags(domain_id, group_id)

Get tags used to define conditions inside a Group

Get tags used to define conditions inside a Group. Also includes tags inside nested groups. 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

domain_id = 'domain_id_example' # String | Domain id

group_id = 'group_id_example' # String | Group Id


begin
  #Get tags used to define conditions inside a Group
  result = api_instance.get_group_tags(domain_id, group_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_group_tags: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **group_id** | **String**| Group Id | 

### Return type

[**GroupTagsList**](GroupTagsList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_vm_members**
> RealizedVirtualMachineListResult get_group_vm_members(domain_id, group_id, opts)

Get Virtual machines that belong to this Group

Get Virtual machines that belong to this Group 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

domain_id = 'domain_id_example' # String | Domain id

group_id = 'group_id_example' # String | Group Id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get Virtual machines that belong to this Group
  result = api_instance.get_group_vm_members(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_group_vm_members: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **group_id** | **String**| Group Id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RealizedVirtualMachineListResult**](RealizedVirtualMachineListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_vm_statistics**
> RealizedVirtualMachineListResult get_group_vm_statistics(domain_id, group_id, opts)

Get effective VMs for the Group

Get the effective VM membership for the Group. This API also gives some VM details such as VM name, IDs and the current state of the VMs. 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

domain_id = 'domain_id_example' # String | Domain id

group_id = 'group_id_example' # String | Group Id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get effective VMs for the Group
  result = api_instance.get_group_vm_statistics(domain_id, group_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_group_vm_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **group_id** | **String**| Group Id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RealizedVirtualMachineListResult**](RealizedVirtualMachineListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_groups_for_object**
> PolicyResourceReferenceForEPListResult get_groups_for_object(intent_path, opts)

Get groups for which the given object is a member

Get policy groups for which the given object is a member. 

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

api_instance = SwaggerClient::PolicyStatisticsGroupApi.new

intent_path = 'intent_path_example' # String | String path of the intent object

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  enforcement_point_path: 'enforcement_point_path_example', # String | String Path of the enforcement point
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get groups for which the given object is a member
  result = api_instance.get_groups_for_object(intent_path, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyStatisticsGroupApi->get_groups_for_object: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **intent_path** | **String**| String path of the intent object | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyResourceReferenceForEPListResult**](PolicyResourceReferenceForEPListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



