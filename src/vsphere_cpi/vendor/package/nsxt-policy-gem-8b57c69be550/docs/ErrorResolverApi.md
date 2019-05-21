# SwaggerClient::ErrorResolverApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_error_resolver_info**](ErrorResolverApi.md#get_error_resolver_info) | **GET** /error-resolver/{error_id} | Fetches metadata about the given error_id
[**list_error_resolver_info**](ErrorResolverApi.md#list_error_resolver_info) | **GET** /error-resolver | Fetches a list of metadata for all the registered error resolvers
[**resolve_error_resolve_error**](ErrorResolverApi.md#resolve_error_resolve_error) | **POST** /error-resolver?action&#x3D;resolve_error | Resolves the error


# **get_error_resolver_info**
> ErrorResolverInfo get_error_resolver_info(error_id)

Fetches metadata about the given error_id

Returns some metadata about the given error_id. This includes information of whether there is a resolver present for the given error_id and its associated user input data 

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

api_instance = SwaggerClient::ErrorResolverApi.new

error_id = 'error_id_example' # String | 


begin
  #Fetches metadata about the given error_id
  result = api_instance.get_error_resolver_info(error_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ErrorResolverApi->get_error_resolver_info: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **error_id** | **String**|  | 

### Return type

[**ErrorResolverInfo**](ErrorResolverInfo.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_error_resolver_info**
> ErrorResolverInfoList list_error_resolver_info

Fetches a list of metadata for all the registered error resolvers

Returns a list of metadata for all the error resolvers registered. 

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

api_instance = SwaggerClient::ErrorResolverApi.new

begin
  #Fetches a list of metadata for all the registered error resolvers
  result = api_instance.list_error_resolver_info
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ErrorResolverApi->list_error_resolver_info: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ErrorResolverInfoList**](ErrorResolverInfoList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **resolve_error_resolve_error**
> resolve_error_resolve_error(error_resolver_metadata_list)

Resolves the error

Invokes the corresponding error resolver for the given error(s) present in the payload 

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

api_instance = SwaggerClient::ErrorResolverApi.new

error_resolver_metadata_list = SwaggerClient::ErrorResolverMetadataList.new # ErrorResolverMetadataList | 


begin
  #Resolves the error
  api_instance.resolve_error_resolve_error(error_resolver_metadata_list)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ErrorResolverApi->resolve_error_resolve_error: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **error_resolver_metadata_list** | [**ErrorResolverMetadataList**](ErrorResolverMetadataList.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



