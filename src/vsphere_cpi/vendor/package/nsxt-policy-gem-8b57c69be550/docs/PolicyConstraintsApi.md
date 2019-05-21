# SwaggerClient::PolicyConstraintsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_tenant_constraint**](PolicyConstraintsApi.md#create_or_replace_tenant_constraint) | **PUT** /infra/constraints/{constraint-id} | Create or update tenant Constraint
[**delete_tenant_constraint**](PolicyConstraintsApi.md#delete_tenant_constraint) | **DELETE** /infra/constraints/{constraint-id} | Delete tenant Constraint.
[**list_tenant_constraints**](PolicyConstraintsApi.md#list_tenant_constraints) | **GET** /infra/constraints | List tenant Constraints.
[**patch_tenant_constraint**](PolicyConstraintsApi.md#patch_tenant_constraint) | **PATCH** /infra/constraints/{constraint-id} | Create or update tenant Constraint
[**read_tenant_constraint**](PolicyConstraintsApi.md#read_tenant_constraint) | **GET** /infra/constraints/{constraint-id} | Read tenant Constraint.


# **create_or_replace_tenant_constraint**
> Constraint create_or_replace_tenant_constraint(constraint_id, constraint)

Create or update tenant Constraint

Create tenant constraint if it does not exist, otherwise replace the existing constraint. 

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

api_instance = SwaggerClient::PolicyConstraintsApi.new

constraint_id = 'constraint_id_example' # String | 

constraint = SwaggerClient::Constraint.new # Constraint | 


begin
  #Create or update tenant Constraint
  result = api_instance.create_or_replace_tenant_constraint(constraint_id, constraint)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConstraintsApi->create_or_replace_tenant_constraint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **constraint_id** | **String**|  | 
 **constraint** | [**Constraint**](Constraint.md)|  | 

### Return type

[**Constraint**](Constraint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tenant_constraint**
> delete_tenant_constraint(constraint_id)

Delete tenant Constraint.

Delete tenant constraint.

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

api_instance = SwaggerClient::PolicyConstraintsApi.new

constraint_id = 'constraint_id_example' # String | 


begin
  #Delete tenant Constraint.
  api_instance.delete_tenant_constraint(constraint_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConstraintsApi->delete_tenant_constraint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **constraint_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tenant_constraints**
> ConstraintListResult list_tenant_constraints(opts)

List tenant Constraints.

List tenant constraints.

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

api_instance = SwaggerClient::PolicyConstraintsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List tenant Constraints.
  result = api_instance.list_tenant_constraints(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConstraintsApi->list_tenant_constraints: #{e}"
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

[**ConstraintListResult**](ConstraintListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tenant_constraint**
> patch_tenant_constraint(constraint_id, constraint)

Create or update tenant Constraint

Create tenant constraint if not exists, otherwise update the existing constraint. 

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

api_instance = SwaggerClient::PolicyConstraintsApi.new

constraint_id = 'constraint_id_example' # String | 

constraint = SwaggerClient::Constraint.new # Constraint | 


begin
  #Create or update tenant Constraint
  api_instance.patch_tenant_constraint(constraint_id, constraint)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConstraintsApi->patch_tenant_constraint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **constraint_id** | **String**|  | 
 **constraint** | [**Constraint**](Constraint.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tenant_constraint**
> Constraint read_tenant_constraint(constraint_id)

Read tenant Constraint.

Read tenant constraint.

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

api_instance = SwaggerClient::PolicyConstraintsApi.new

constraint_id = 'constraint_id_example' # String | 


begin
  #Read tenant Constraint.
  result = api_instance.read_tenant_constraint(constraint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConstraintsApi->read_tenant_constraint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **constraint_id** | **String**|  | 

### Return type

[**Constraint**](Constraint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



