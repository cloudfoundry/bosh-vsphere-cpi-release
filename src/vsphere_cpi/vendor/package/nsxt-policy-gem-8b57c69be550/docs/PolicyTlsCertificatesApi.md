# SwaggerClient::PolicyTlsCertificatesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**add_tls_certificate**](PolicyTlsCertificatesApi.md#add_tls_certificate) | **PUT** /infra/certificates/{certificate-id} | Add a New Certificate
[**delete_tls_certificate**](PolicyTlsCertificatesApi.md#delete_tls_certificate) | **DELETE** /infra/certificates/{certificate-id} | Delete Certificate for the Given Certificate ID
[**get_tls_certificate**](PolicyTlsCertificatesApi.md#get_tls_certificate) | **GET** /infra/certificates/{certificate-id} | Show Certificate Data for the Given Certificate ID
[**list_tls_certificates**](PolicyTlsCertificatesApi.md#list_tls_certificates) | **GET** /infra/certificates | Return All the User-Facing Components&#39; Certificates
[**patch_tls_certificate**](PolicyTlsCertificatesApi.md#patch_tls_certificate) | **PATCH** /infra/certificates/{certificate-id} | Add a New Certificate


# **add_tls_certificate**
> TlsCertificate add_tls_certificate(certificate_id, tls_trust_data)

Add a New Certificate

Adds a new private-public certificate and, optionally, a private key that can be applied to one of the user-facing components (appliance management or edge). The certificate and the key should be stored in PEM format. If no private key is provided, the certificate is used as a client certificate in the trust store.  A certificate chain will not be expanded into separate certificate instances for reference, but would be pushed to the enforcement point as a single certificate. 

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

api_instance = SwaggerClient::PolicyTlsCertificatesApi.new

certificate_id = 'certificate_id_example' # String | 

tls_trust_data = SwaggerClient::TlsTrustData.new # TlsTrustData | 


begin
  #Add a New Certificate
  result = api_instance.add_tls_certificate(certificate_id, tls_trust_data)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCertificatesApi->add_tls_certificate: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **certificate_id** | **String**|  | 
 **tls_trust_data** | [**TlsTrustData**](TlsTrustData.md)|  | 

### Return type

[**TlsCertificate**](TlsCertificate.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tls_certificate**
> delete_tls_certificate(certificate_id)

Delete Certificate for the Given Certificate ID

Removes the specified certificate. The private key associated with the certificate is also deleted. 

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

api_instance = SwaggerClient::PolicyTlsCertificatesApi.new

certificate_id = 'certificate_id_example' # String | ID of certificate to delete


begin
  #Delete Certificate for the Given Certificate ID
  api_instance.delete_tls_certificate(certificate_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCertificatesApi->delete_tls_certificate: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **certificate_id** | **String**| ID of certificate to delete | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_tls_certificate**
> TlsCertificate get_tls_certificate(certificate_id, opts)

Show Certificate Data for the Given Certificate ID

Returns information for the specified certificate ID, including the certificate's id; resource_type (for example, certificate_self_signed, certificate_ca, or certificate_signed); pem_encoded data; and history of the certificate (who created or modified it and when). For additional information, include the ?details=true modifier at the end of the request URI. 

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

api_instance = SwaggerClient::PolicyTlsCertificatesApi.new

certificate_id = 'certificate_id_example' # String | ID of certificate to read

opts = { 
  details: false # BOOLEAN | whether to expand the pem data and show all its details
}

begin
  #Show Certificate Data for the Given Certificate ID
  result = api_instance.get_tls_certificate(certificate_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCertificatesApi->get_tls_certificate: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **certificate_id** | **String**| ID of certificate to read | 
 **details** | **BOOLEAN**| whether to expand the pem data and show all its details | [optional] [default to false]

### Return type

[**TlsCertificate**](TlsCertificate.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tls_certificates**
> TlsCertificateList list_tls_certificates(opts)

Return All the User-Facing Components' Certificates

Returns all certificate information viewable by the user, including each certificate's id; resource_type (for example, certificate_self_signed, certificate_ca, or certificate_signed); pem_encoded data; and history of the certificate (who created or modified it and when). For additional information, include the ?details=true modifier at the end of the request URI. 

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

api_instance = SwaggerClient::PolicyTlsCertificatesApi.new

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
  #Return All the User-Facing Components' Certificates
  result = api_instance.list_tls_certificates(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCertificatesApi->list_tls_certificates: #{e}"
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

[**TlsCertificateList**](TlsCertificateList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tls_certificate**
> patch_tls_certificate(certificate_id, tls_trust_data)

Add a New Certificate

Adds a new private-public certificate and, optionally, a private key that can be applied to one of the user-facing components (appliance management or edge). The certificate and the key should be stored in PEM format. If no private key is provided, the certificate is used as a client certificate in the trust store.  A certificate chain will not be expanded into separate certificate instances for reference, but would be pushed to the enforcement point as a single certificate.  This patch method does not modify an existing certificate. 

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

api_instance = SwaggerClient::PolicyTlsCertificatesApi.new

certificate_id = 'certificate_id_example' # String | 

tls_trust_data = SwaggerClient::TlsTrustData.new # TlsTrustData | 


begin
  #Add a New Certificate
  api_instance.patch_tls_certificate(certificate_id, tls_trust_data)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyTlsCertificatesApi->patch_tls_certificate: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **certificate_id** | **String**|  | 
 **tls_trust_data** | [**TlsTrustData**](TlsTrustData.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



