# SwaggerClient::PolicyTemplateApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_template**](PolicyTemplateApi.md#create_or_update_template) | **PATCH** /templates/{template-id} | Create or update a template
[**delete_template**](PolicyTemplateApi.md#delete_template) | **DELETE** /templates/{template-id} | Delete template
[**deploy_template_deploy**](PolicyTemplateApi.md#deploy_template_deploy) | **POST** /templates/{template-id}?action&#x3D;deploy | Deploy template
[**list_templates**](PolicyTemplateApi.md#list_templates) | **GET** /templates | List Policy Templates
[**read_template**](PolicyTemplateApi.md#read_template) | **GET** /templates/{template-id} | Read template


# **create_or_update_template**
> create_or_update_template(template_id, policy_template)

Create or update a template

Create a new template if the specified template id does not correspond to an existing template. Update the template if otherwise. 

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

api_instance = SwaggerClient::PolicyTemplateApi.new

template_id = 'template_id_example' # String | 

policy_template = SwaggerClient::PolicyTemplate.new # PolicyTemplate | 


begin
  #Create or update a template
  api_instance.create_or_update_template(template_id, policy_template)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTemplateApi->create_or_update_template: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **template_id** | **String**|  | 
 **policy_template** | [**PolicyTemplate**](PolicyTemplate.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_template**
> delete_template(template_id)

Delete template

Delete a template.

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

api_instance = SwaggerClient::PolicyTemplateApi.new

template_id = 'template_id_example' # String | 


begin
  #Delete template
  api_instance.delete_template(template_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTemplateApi->delete_template: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **template_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **deploy_template_deploy**
> deploy_template_deploy(template_id, policy_template_parameters)

Deploy template

Read a template, populate the placeholders' fields with the parameters' values, and deploy the template body by creating or updating all the nested policy objects inside the AbstractSpace object. 

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

api_instance = SwaggerClient::PolicyTemplateApi.new

template_id = 'template_id_example' # String | 

policy_template_parameters = SwaggerClient::PolicyTemplateParameters.new # PolicyTemplateParameters | 


begin
  #Deploy template
  api_instance.deploy_template_deploy(template_id, policy_template_parameters)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTemplateApi->deploy_template_deploy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **template_id** | **String**|  | 
 **policy_template_parameters** | [**PolicyTemplateParameters**](PolicyTemplateParameters.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_templates**
> PolicyTemplateListResult list_templates(opts)

List Policy Templates

List Policy Templates.

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

api_instance = SwaggerClient::PolicyTemplateApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Policy Templates
  result = api_instance.list_templates(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTemplateApi->list_templates: #{e}"
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

[**PolicyTemplateListResult**](PolicyTemplateListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_template**
> PolicyTemplate read_template(template_id)

Read template

Read a template and returns the template properties for a given template identifier. 

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

api_instance = SwaggerClient::PolicyTemplateApi.new

template_id = 'template_id_example' # String | 


begin
  #Read template
  result = api_instance.read_template(template_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTemplateApi->read_template: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **template_id** | **String**|  | 

### Return type

[**PolicyTemplate**](PolicyTemplate.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



