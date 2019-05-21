# SwaggerClient::PolicyInfraDomainDeploymentMapsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_domain_deployment_map_for_infra**](PolicyInfraDomainDeploymentMapsApi.md#create_or_update_domain_deployment_map_for_infra) | **PUT** /infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id} | Create a new Domain Deployment Map under infra
[**delete_domain_deployment_map**](PolicyInfraDomainDeploymentMapsApi.md#delete_domain_deployment_map) | **DELETE** /infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id} | Delete Domain Deployment Map
[**list_domain_deployment_maps_for_infra**](PolicyInfraDomainDeploymentMapsApi.md#list_domain_deployment_maps_for_infra) | **GET** /infra/domains/{domain-id}/domain-deployment-maps | List Domain Deployment maps for infra
[**patch_domain_deployment_map_for_infra**](PolicyInfraDomainDeploymentMapsApi.md#patch_domain_deployment_map_for_infra) | **PATCH** /infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id} | Patch Domain Deployment Map under infra
[**read_domain_deployment_map_for_infra**](PolicyInfraDomainDeploymentMapsApi.md#read_domain_deployment_map_for_infra) | **GET** /infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id} | Read a DomainDeploymentMap


# **create_or_update_domain_deployment_map_for_infra**
> DomainDeploymentMap create_or_update_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, domain_deployment_map)

Create a new Domain Deployment Map under infra

If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, replace it. 

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

api_instance = SwaggerClient::PolicyInfraDomainDeploymentMapsApi.new

domain_id = 'domain_id_example' # String | Domain ID

domain_deployment_map_id = 'domain_deployment_map_id_example' # String | Domain Deployment Map ID

domain_deployment_map = SwaggerClient::DomainDeploymentMap.new # DomainDeploymentMap | 


begin
  #Create a new Domain Deployment Map under infra
  result = api_instance.create_or_update_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, domain_deployment_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDomainDeploymentMapsApi->create_or_update_domain_deployment_map_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **domain_deployment_map_id** | **String**| Domain Deployment Map ID | 
 **domain_deployment_map** | [**DomainDeploymentMap**](DomainDeploymentMap.md)|  | 

### Return type

[**DomainDeploymentMap**](DomainDeploymentMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_domain_deployment_map**
> delete_domain_deployment_map(domain_id, domain_deployment_map_id)

Delete Domain Deployment Map

Delete Domain Deployment Map

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

api_instance = SwaggerClient::PolicyInfraDomainDeploymentMapsApi.new

domain_id = 'domain_id_example' # String | Domain ID

domain_deployment_map_id = 'domain_deployment_map_id_example' # String | domain-deployment-map-id


begin
  #Delete Domain Deployment Map
  api_instance.delete_domain_deployment_map(domain_id, domain_deployment_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDomainDeploymentMapsApi->delete_domain_deployment_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **domain_deployment_map_id** | **String**| domain-deployment-map-id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_domain_deployment_maps_for_infra**
> DomainDeploymentMapListResult list_domain_deployment_maps_for_infra(domain_id, opts)

List Domain Deployment maps for infra

Paginated list of all Domain Deployment Entries for infra. 

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

api_instance = SwaggerClient::PolicyInfraDomainDeploymentMapsApi.new

domain_id = 'domain_id_example' # String | Domain ID

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Domain Deployment maps for infra
  result = api_instance.list_domain_deployment_maps_for_infra(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDomainDeploymentMapsApi->list_domain_deployment_maps_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**DomainDeploymentMapListResult**](DomainDeploymentMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_domain_deployment_map_for_infra**
> patch_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, domain_deployment_map)

Patch Domain Deployment Map under infra

If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, patch it. 

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

api_instance = SwaggerClient::PolicyInfraDomainDeploymentMapsApi.new

domain_id = 'domain_id_example' # String | Domain ID

domain_deployment_map_id = 'domain_deployment_map_id_example' # String | Domain Deployment Map ID

domain_deployment_map = SwaggerClient::DomainDeploymentMap.new # DomainDeploymentMap | 


begin
  #Patch Domain Deployment Map under infra
  api_instance.patch_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, domain_deployment_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDomainDeploymentMapsApi->patch_domain_deployment_map_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **domain_deployment_map_id** | **String**| Domain Deployment Map ID | 
 **domain_deployment_map** | [**DomainDeploymentMap**](DomainDeploymentMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_domain_deployment_map_for_infra**
> DomainDeploymentMap read_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id)

Read a DomainDeploymentMap

Read a Domain Deployment Map 

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

api_instance = SwaggerClient::PolicyInfraDomainDeploymentMapsApi.new

domain_id = 'domain_id_example' # String | Domain ID

domain_deployment_map_id = 'domain_deployment_map_id_example' # String | Domain Deployment Map id


begin
  #Read a DomainDeploymentMap
  result = api_instance.read_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDomainDeploymentMapsApi->read_domain_deployment_map_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **domain_deployment_map_id** | **String**| Domain Deployment Map id | 

### Return type

[**DomainDeploymentMap**](DomainDeploymentMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



