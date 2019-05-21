# SwaggerClient::ApiServicesTaskManagementApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**list_tasks**](ApiServicesTaskManagementApi.md#list_tasks) | **GET** /tasks | Get information about all tasks
[**read_task_properties**](ApiServicesTaskManagementApi.md#read_task_properties) | **GET** /tasks/{task-id} | Get information about the specified task
[**read_task_result**](ApiServicesTaskManagementApi.md#read_task_result) | **GET** /tasks/{task-id}/response | Get the response of a task


# **list_tasks**
> TaskListResult list_tasks(opts)

Get information about all tasks

Get information about all tasks

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

api_instance = SwaggerClient::ApiServicesTaskManagementApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  request_uri: 'request_uri_example', # String | Request URI(s) to include in query result
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example', # String | Field by which records are sorted
  status: 'status_example', # String | Status(es) to include in query result
  user: 'user_example' # String | Names of users to include in query result
}

begin
  #Get information about all tasks
  result = api_instance.list_tasks(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ApiServicesTaskManagementApi->list_tasks: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **request_uri** | **String**| Request URI(s) to include in query result | [optional] 
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 
 **status** | **String**| Status(es) to include in query result | [optional] 
 **user** | **String**| Names of users to include in query result | [optional] 

### Return type

[**TaskListResult**](TaskListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_task_properties**
> TaskProperties read_task_properties(task_id)

Get information about the specified task

Get information about the specified task

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

api_instance = SwaggerClient::ApiServicesTaskManagementApi.new

task_id = 'task_id_example' # String | ID of task to read


begin
  #Get information about the specified task
  result = api_instance.read_task_properties(task_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ApiServicesTaskManagementApi->read_task_properties: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **task_id** | **String**| ID of task to read | 

### Return type

[**TaskProperties**](TaskProperties.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_task_result**
> Object read_task_result(task_id)

Get the response of a task

Get the response of a task

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

api_instance = SwaggerClient::ApiServicesTaskManagementApi.new

task_id = 'task_id_example' # String | ID of task to read


begin
  #Get the response of a task
  result = api_instance.read_task_result(task_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ApiServicesTaskManagementApi->read_task_result: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **task_id** | **String**| ID of task to read | 

### Return type

**Object**

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



