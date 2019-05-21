# SwaggerClient::PolicyGlobalConfigApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**patch_global_config**](PolicyGlobalConfigApi.md#patch_global_config) | **PATCH** /infra/global-config | Update the global configuration
[**read_global_config**](PolicyGlobalConfigApi.md#read_global_config) | **GET** /infra/global-config | Read global configuration
[**update_global_config**](PolicyGlobalConfigApi.md#update_global_config) | **PUT** /infra/global-config | Update the global configuration


# **patch_global_config**
> patch_global_config(global_config)

Update the global configuration

Update the global configuration

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

api_instance = SwaggerClient::PolicyGlobalConfigApi.new

global_config = SwaggerClient::GlobalConfig.new # GlobalConfig | 


begin
  #Update the global configuration
  api_instance.patch_global_config(global_config)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGlobalConfigApi->patch_global_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **global_config** | [**GlobalConfig**](GlobalConfig.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_global_config**
> GlobalConfig read_global_config

Read global configuration

Read global configuration 

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

api_instance = SwaggerClient::PolicyGlobalConfigApi.new

begin
  #Read global configuration
  result = api_instance.read_global_config
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGlobalConfigApi->read_global_config: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GlobalConfig**](GlobalConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_global_config**
> GlobalConfig update_global_config(global_config)

Update the global configuration

Update the global configuration

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

api_instance = SwaggerClient::PolicyGlobalConfigApi.new

global_config = SwaggerClient::GlobalConfig.new # GlobalConfig | 


begin
  #Update the global configuration
  result = api_instance.update_global_config(global_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyGlobalConfigApi->update_global_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **global_config** | [**GlobalConfig**](GlobalConfig.md)|  | 

### Return type

[**GlobalConfig**](GlobalConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



