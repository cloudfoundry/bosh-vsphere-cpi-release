# SwaggerClient::ApiServicesApiRequestBatchingApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**register_batch_request**](ApiServicesApiRequestBatchingApi.md#register_batch_request) | **POST** /batch | Register a Collection of API Calls at a Single End Point


# **register_batch_request**
> BatchResponse register_batch_request(batch_request, opts)

Register a Collection of API Calls at a Single End Point

Enables you to make multiple API requests using a single request. The batch API takes in an array of logical HTTP requests represented as JSON arrays. Each request has a method (GET, PUT, POST, or DELETE), a relative_url (the portion of the URL after https://&lt;nsx-mgr&gt;/api/), optional headers array (corresponding to HTTP headers) and an optional body (for POST and PUT requests). The batch API returns an array of logical HTTP responses represented as JSON arrays. Each response has a status code, an optional headers array and an optional body (which is a JSON-encoded string). 

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

api_instance = SwaggerClient::ApiServicesApiRequestBatchingApi.new

batch_request = SwaggerClient::BatchRequest.new # BatchRequest | 

opts = { 
  atomic: false # BOOLEAN | transactional atomicity for the batch of requests embedded in the batch list
}

begin
  #Register a Collection of API Calls at a Single End Point
  result = api_instance.register_batch_request(batch_request, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling ApiServicesApiRequestBatchingApi->register_batch_request: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **batch_request** | [**BatchRequest**](BatchRequest.md)|  | 
 **atomic** | **BOOLEAN**| transactional atomicity for the batch of requests embedded in the batch list | [optional] [default to false]

### Return type

[**BatchResponse**](BatchResponse.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



