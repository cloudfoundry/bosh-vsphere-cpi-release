# SwaggerClient::LicensingApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**accept_eula**](LicensingApi.md#accept_eula) | **POST** /eula/accept | Accept end user license agreement 
[**get_eula_acceptance**](LicensingApi.md#get_eula_acceptance) | **GET** /eula/acceptance | Return the acceptance status of end user license agreement 
[**get_eula_content**](LicensingApi.md#get_eula_content) | **GET** /eula/content | Return the content of end user license agreement 


# **accept_eula**
> accept_eula

Accept end user license agreement 

Accept end user license agreement 

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

api_instance = SwaggerClient::LicensingApi.new

begin
  #Accept end user license agreement 
  api_instance.accept_eula
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LicensingApi->accept_eula: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_eula_acceptance**
> EULAAcceptance get_eula_acceptance

Return the acceptance status of end user license agreement 

Return the acceptance status of end user license agreement 

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

api_instance = SwaggerClient::LicensingApi.new

begin
  #Return the acceptance status of end user license agreement 
  result = api_instance.get_eula_acceptance
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LicensingApi->get_eula_acceptance: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**EULAAcceptance**](EULAAcceptance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_eula_content**
> EULAContent get_eula_content(opts)

Return the content of end user license agreement 

Return the content of end user license agreement in the specified format. By default, it's pure string without line break 

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

api_instance = SwaggerClient::LicensingApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example', # String | Field by which records are sorted
  value_format: 'value_format_example' # String | End User License Agreement content output format
}

begin
  #Return the content of end user license agreement 
  result = api_instance.get_eula_content(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling LicensingApi->get_eula_content: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 
 **value_format** | **String**| End User License Agreement content output format | [optional] 

### Return type

[**EULAContent**](EULAContent.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



