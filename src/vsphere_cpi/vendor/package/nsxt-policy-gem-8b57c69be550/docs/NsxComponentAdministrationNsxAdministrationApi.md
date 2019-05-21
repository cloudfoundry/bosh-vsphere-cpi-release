# SwaggerClient::NsxComponentAdministrationNsxAdministrationApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**read_management_config**](NsxComponentAdministrationNsxAdministrationApi.md#read_management_config) | **GET** /configs/management | Read NSX Management nodes global configuration.
[**update_management_config**](NsxComponentAdministrationNsxAdministrationApi.md#update_management_config) | **PUT** /configs/management | Update NSX Management nodes global configuration


# **read_management_config**
> ManagementConfig read_management_config

Read NSX Management nodes global configuration.

Returns the NSX Management nodes global configuration. 

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

api_instance = SwaggerClient::NsxComponentAdministrationNsxAdministrationApi.new

begin
  #Read NSX Management nodes global configuration.
  result = api_instance.read_management_config
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationNsxAdministrationApi->read_management_config: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ManagementConfig**](ManagementConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_management_config**
> ManagementConfig update_management_config(management_config)

Update NSX Management nodes global configuration

Modifies the NSX Management nodes global configuration.

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

api_instance = SwaggerClient::NsxComponentAdministrationNsxAdministrationApi.new

management_config = SwaggerClient::ManagementConfig.new # ManagementConfig | 


begin
  #Update NSX Management nodes global configuration
  result = api_instance.update_management_config(management_config)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationNsxAdministrationApi->update_management_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **management_config** | [**ManagementConfig**](ManagementConfig.md)|  | 

### Return type

[**ManagementConfig**](ManagementConfig.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



