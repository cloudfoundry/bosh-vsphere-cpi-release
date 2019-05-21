# SwaggerClient::UpgradeNodesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_version_whitelist**](UpgradeNodesApi.md#get_version_whitelist) | **GET** /upgrade/version-whitelist | Get the version whitelist
[**get_version_whitelist_by_component**](UpgradeNodesApi.md#get_version_whitelist_by_component) | **GET** /upgrade/version-whitelist/{component_type} | Get the version whitelist for the specified component
[**update_version_whitelist**](UpgradeNodesApi.md#update_version_whitelist) | **PUT** /upgrade/version-whitelist/{component_type} | Update the version whitelist for the specified component type


# **get_version_whitelist**
> AcceptableComponentVersionList get_version_whitelist

Get the version whitelist

Get whitelist of versions for different components

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

api_instance = SwaggerClient::UpgradeNodesApi.new

begin
  #Get the version whitelist
  result = api_instance.get_version_whitelist
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UpgradeNodesApi->get_version_whitelist: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AcceptableComponentVersionList**](AcceptableComponentVersionList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_version_whitelist_by_component**
> AcceptableComponentVersion get_version_whitelist_by_component(component_type)

Get the version whitelist for the specified component

Get whitelist of versions for a component. Component can include HOST, EDGE, CCP, MP

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

api_instance = SwaggerClient::UpgradeNodesApi.new

component_type = 'component_type_example' # String | 


begin
  #Get the version whitelist for the specified component
  result = api_instance.get_version_whitelist_by_component(component_type)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UpgradeNodesApi->get_version_whitelist_by_component: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **component_type** | **String**|  | 

### Return type

[**AcceptableComponentVersion**](AcceptableComponentVersion.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_version_whitelist**
> update_version_whitelist(component_type, version_list)

Update the version whitelist for the specified component type

Update the version whitelist for the specified component type (HOST, EDGE, CCP, MP).

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

api_instance = SwaggerClient::UpgradeNodesApi.new

component_type = 'component_type_example' # String | 

version_list = SwaggerClient::VersionList.new # VersionList | 


begin
  #Update the version whitelist for the specified component type
  api_instance.update_version_whitelist(component_type, version_list)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling UpgradeNodesApi->update_version_whitelist: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **component_type** | **String**|  | 
 **version_list** | [**VersionList**](VersionList.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



