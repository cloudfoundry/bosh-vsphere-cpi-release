# SwaggerClient::PolicyLabelsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_replace_policy_label_for_infra**](PolicyLabelsApi.md#create_or_replace_policy_label_for_infra) | **PUT** /infra/labels/{label-id} | Create or replace label
[**delete_policy_label_for_infra**](PolicyLabelsApi.md#delete_policy_label_for_infra) | **DELETE** /infra/labels/{label-id} | Delete PolicyLabel object
[**list_policy_label_for_infra**](PolicyLabelsApi.md#list_policy_label_for_infra) | **GET** /infra/labels | List labels for infra
[**read_policy_label_for_infra**](PolicyLabelsApi.md#read_policy_label_for_infra) | **GET** /infra/labels/{label-id} | Read lable
[**update_policy_label_for_infra**](PolicyLabelsApi.md#update_policy_label_for_infra) | **PATCH** /infra/labels/{label-id} | Patch an existing label object


# **create_or_replace_policy_label_for_infra**
> PolicyLabel create_or_replace_policy_label_for_infra(label_id, policy_label)

Create or replace label

Create label if not exists, otherwise replaces the existing label. If label already exists then type attribute cannot be changed. 

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

api_instance = SwaggerClient::PolicyLabelsApi.new

label_id = 'label_id_example' # String | 

policy_label = SwaggerClient::PolicyLabel.new # PolicyLabel | 


begin
  #Create or replace label
  result = api_instance.create_or_replace_policy_label_for_infra(label_id, policy_label)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLabelsApi->create_or_replace_policy_label_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **label_id** | **String**|  | 
 **policy_label** | [**PolicyLabel**](PolicyLabel.md)|  | 

### Return type

[**PolicyLabel**](PolicyLabel.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_label_for_infra**
> delete_policy_label_for_infra(label_id)

Delete PolicyLabel object

Delete PolicyLabel object

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

api_instance = SwaggerClient::PolicyLabelsApi.new

label_id = 'label_id_example' # String | 


begin
  #Delete PolicyLabel object
  api_instance.delete_policy_label_for_infra(label_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLabelsApi->delete_policy_label_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **label_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_label_for_infra**
> PolicyLabelListResult list_policy_label_for_infra(opts)

List labels for infra

Paginated list of all labels for infra. 

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

api_instance = SwaggerClient::PolicyLabelsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List labels for infra
  result = api_instance.list_policy_label_for_infra(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLabelsApi->list_policy_label_for_infra: #{e}"
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

[**PolicyLabelListResult**](PolicyLabelListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_label_for_infra**
> PolicyLabel read_policy_label_for_infra(label_id)

Read lable

Read a label. 

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

api_instance = SwaggerClient::PolicyLabelsApi.new

label_id = 'label_id_example' # String | 


begin
  #Read lable
  result = api_instance.read_policy_label_for_infra(label_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLabelsApi->read_policy_label_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **label_id** | **String**|  | 

### Return type

[**PolicyLabel**](PolicyLabel.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_policy_label_for_infra**
> update_policy_label_for_infra(label_id, policy_label)

Patch an existing label object

Create label if not exists, otherwise take the partial updates. Note, once the label is created type attribute can not be changed. 

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

api_instance = SwaggerClient::PolicyLabelsApi.new

label_id = 'label_id_example' # String | 

policy_label = SwaggerClient::PolicyLabel.new # PolicyLabel | 


begin
  #Patch an existing label object
  api_instance.update_policy_label_for_infra(label_id, policy_label)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLabelsApi->update_policy_label_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **label_id** | **String**|  | 
 **policy_label** | [**PolicyLabel**](PolicyLabel.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



