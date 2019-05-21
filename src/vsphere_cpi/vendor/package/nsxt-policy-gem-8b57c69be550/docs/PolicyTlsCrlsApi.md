# SwaggerClient::PolicyTlsCrlsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_tls_crl**](PolicyTlsCrlsApi.md#create_or_patch_tls_crl) | **PATCH** /infra/crls/{crl-id} | Create or patch a Certificate Revocation List
[**create_or_update_tls_crl**](PolicyTlsCrlsApi.md#create_or_update_tls_crl) | **PUT** /infra/crls/{crl-id} | Create or fully replace a Certificate Revocation List
[**create_tls_crl_import**](PolicyTlsCrlsApi.md#create_tls_crl_import) | **POST** /infra/crls/{crl-id}?action&#x3D;import | Create a new Certificate Revocation List
[**delete_tls_crl**](PolicyTlsCrlsApi.md#delete_tls_crl) | **DELETE** /infra/crls/{crl-id} | Delete a CRL
[**get_tls_crl**](PolicyTlsCrlsApi.md#get_tls_crl) | **GET** /infra/crls/{crl-id} | Show CRL Data for the Given CRL id.
[**list_tls_crls**](PolicyTlsCrlsApi.md#list_tls_crls) | **GET** /infra/crls | Return All Added CRLs


# **create_or_patch_tls_crl**
> create_or_patch_tls_crl(crl_id, tls_crl)

Create or patch a Certificate Revocation List

Create or patch a Certificate Revocation List for the given id. The CRL is used to verify the client certificate status against the revocation lists published by the CA. For this reason, the administrator needs to add the CRL in certificate repository as well. The CRL must contain PEM data for a single CRL. 

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

api_instance = SwaggerClient::PolicyTlsCrlsApi.new

crl_id = 'crl_id_example' # String | 

tls_crl = SwaggerClient::TlsCrl.new # TlsCrl | 


begin
  #Create or patch a Certificate Revocation List
  api_instance.create_or_patch_tls_crl(crl_id, tls_crl)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCrlsApi->create_or_patch_tls_crl: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **crl_id** | **String**|  | 
 **tls_crl** | [**TlsCrl**](TlsCrl.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_tls_crl**
> TlsCrl create_or_update_tls_crl(crl_id, tls_crl)

Create or fully replace a Certificate Revocation List

Create or replace a Certificate Revocation List for the given id. The CRL is used to verify the client certificate status against the revocation lists published by the CA. For this reason, the administrator needs to add the CRL in certificate repository as well. The CRL must contain PEM data for a single CRL. Revision is required. 

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

api_instance = SwaggerClient::PolicyTlsCrlsApi.new

crl_id = 'crl_id_example' # String | 

tls_crl = SwaggerClient::TlsCrl.new # TlsCrl | 


begin
  #Create or fully replace a Certificate Revocation List
  result = api_instance.create_or_update_tls_crl(crl_id, tls_crl)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCrlsApi->create_or_update_tls_crl: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **crl_id** | **String**|  | 
 **tls_crl** | [**TlsCrl**](TlsCrl.md)|  | 

### Return type

[**TlsCrl**](TlsCrl.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_tls_crl_import**
> TlsCrlListResult create_tls_crl_import(crl_id, tls_crl)

Create a new Certificate Revocation List

Adds a new certificate revocation list (CRLs). The CRL is used to verify the client certificate status against the revocation lists published by the CA. For this reason, the administrator needs to add the CRL in certificate repository as well. The CRL can contain a single CRL or multiple CRLs depending on the PEM data. - Single CRL: a single CRL is created with the given id. - Composite CRL: multiple CRLs are generated. Each of the CRL is created with an id generated based on the given id. First CRL is created with crl-id, second with crl-id-1, third with crl-id-2, etc. 

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

api_instance = SwaggerClient::PolicyTlsCrlsApi.new

crl_id = 'crl_id_example' # String | 

tls_crl = SwaggerClient::TlsCrl.new # TlsCrl | 


begin
  #Create a new Certificate Revocation List
  result = api_instance.create_tls_crl_import(crl_id, tls_crl)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCrlsApi->create_tls_crl_import: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **crl_id** | **String**|  | 
 **tls_crl** | [**TlsCrl**](TlsCrl.md)|  | 

### Return type

[**TlsCrlListResult**](TlsCrlListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tls_crl**
> delete_tls_crl(crl_id)

Delete a CRL

Deletes an existing CRL.

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

api_instance = SwaggerClient::PolicyTlsCrlsApi.new

crl_id = 'crl_id_example' # String | 


begin
  #Delete a CRL
  api_instance.delete_tls_crl(crl_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCrlsApi->delete_tls_crl: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **crl_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tls_crl**
> TlsCrl get_tls_crl(crl_id, opts)

Show CRL Data for the Given CRL id.

Returns information about the specified CRL. For additional information, include the ?details=true modifier at the end of the request URI. 

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

api_instance = SwaggerClient::PolicyTlsCrlsApi.new

crl_id = 'crl_id_example' # String | 

opts = { 
  details: false # BOOLEAN | whether to expand the pem data and show all its details
}

begin
  #Show CRL Data for the Given CRL id.
  result = api_instance.get_tls_crl(crl_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCrlsApi->get_tls_crl: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **crl_id** | **String**|  | 
 **details** | **BOOLEAN**| whether to expand the pem data and show all its details | [optional] [default to false]

### Return type

[**TlsCrl**](TlsCrl.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tls_crls**
> TlsCrlListResult list_tls_crls(opts)

Return All Added CRLs

Returns information about all CRLs. For additional information, include the ?details=true modifier at the end of the request URI. 

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

api_instance = SwaggerClient::PolicyTlsCrlsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  details: false, # BOOLEAN | whether to expand the pem data and show all its details
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example', # String | Field by which records are sorted
  type: 'type_example' # String | Type of certificate to return
}

begin
  #Return All Added CRLs
  result = api_instance.list_tls_crls(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCrlsApi->list_tls_crls: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **details** | **BOOLEAN**| whether to expand the pem data and show all its details | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 
 **type** | **String**| Type of certificate to return | [optional] 

### Return type

[**TlsCrlListResult**](TlsCrlListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



