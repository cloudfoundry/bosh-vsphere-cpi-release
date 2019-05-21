# SwaggerClient::DefaultApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_policy_compliance_status**](DefaultApi.md#get_policy_compliance_status) | **GET** /compliance/status | Returns the compliance status


# **get_policy_compliance_status**
> PolicyComplianceStatus get_policy_compliance_status

Returns the compliance status

Returns the compliance status and details of non compliant configuration

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

api_instance = SwaggerClient::DefaultApi.new

begin
  #Returns the compliance status
  result = api_instance.get_policy_compliance_status
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DefaultApi->get_policy_compliance_status: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PolicyComplianceStatus**](PolicyComplianceStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



