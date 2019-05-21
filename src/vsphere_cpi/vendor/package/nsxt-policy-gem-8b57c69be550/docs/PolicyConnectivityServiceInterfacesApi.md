# SwaggerClient::PolicyConnectivityServiceInterfacesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_service_interface**](PolicyConnectivityServiceInterfacesApi.md#create_service_interface) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-interfaces/{interface-id} | Create a service interface


# **create_service_interface**
> ServiceInterface create_service_interface(tier_0_id, locale_service_id, interface_id, service_interface)

Create a service interface

If an interface with the interface-id is not already present, create a new interface. Modification of service interface is not allowed. 

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

api_instance = SwaggerClient::PolicyConnectivityServiceInterfacesApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

interface_id = 'interface_id_example' # String | 

service_interface = SwaggerClient::ServiceInterface.new # ServiceInterface | 


begin
  #Create a service interface
  result = api_instance.create_service_interface(tier_0_id, locale_service_id, interface_id, service_interface)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyConnectivityServiceInterfacesApi->create_service_interface: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **interface_id** | **String**|  | 
 **service_interface** | [**ServiceInterface**](ServiceInterface.md)|  | 

### Return type

[**ServiceInterface**](ServiceInterface.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



