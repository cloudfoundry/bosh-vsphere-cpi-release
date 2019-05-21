# SwaggerClient::PolicyInfraTier0DeploymentMapsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_tier0_deployment_map**](PolicyInfraTier0DeploymentMapsApi.md#create_or_update_tier0_deployment_map) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/tier-0-deployment-maps/{tier-0-deployment-map-id} | Create a new Tier-0 Deployment Map under Tier-0
[**delete_tier0_deployment_map**](PolicyInfraTier0DeploymentMapsApi.md#delete_tier0_deployment_map) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/tier-0-deployment-maps/{tier-0-deployment-map-id} | Delete Tier-0 Deployment Map
[**list_tier0_deployment_maps**](PolicyInfraTier0DeploymentMapsApi.md#list_tier0_deployment_maps) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/tier-0-deployment-maps | List Tier-0 Deployment maps
[**patch_tier0_deployment_map**](PolicyInfraTier0DeploymentMapsApi.md#patch_tier0_deployment_map) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/tier-0-deployment-maps/{tier-0-deployment-map-id} | Patch a Tier-0 Deployment Map under Tier-0
[**read_tier0_deployment_map**](PolicyInfraTier0DeploymentMapsApi.md#read_tier0_deployment_map) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/tier-0-deployment-maps/{tier-0-deployment-map-id} | Read a Tier-0 Deployment Map


# **create_or_update_tier0_deployment_map**
> Tier0DeploymentMap create_or_update_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id, tier0_deployment_map)

Create a new Tier-0 Deployment Map under Tier-0

If the passed Tier-0 Deployment Map does not already exist, create a new Tier-0 Deployment Map. If it already exists, replace it. This API has been deprecated. Use new API PUT /infra/tier-0s/tier-0-id/locale-services/locale-services-id/tier-0-deployment-maps/tier-0-deployment-map-id 

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

api_instance = SwaggerClient::PolicyInfraTier0DeploymentMapsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

tier_0_deployment_map_id = 'tier_0_deployment_map_id_example' # String | 

tier0_deployment_map = SwaggerClient::Tier0DeploymentMap.new # Tier0DeploymentMap | 


begin
  #Create a new Tier-0 Deployment Map under Tier-0
  result = api_instance.create_or_update_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id, tier0_deployment_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraTier0DeploymentMapsApi->create_or_update_tier0_deployment_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **tier_0_deployment_map_id** | **String**|  | 
 **tier0_deployment_map** | [**Tier0DeploymentMap**](Tier0DeploymentMap.md)|  | 

### Return type

[**Tier0DeploymentMap**](Tier0DeploymentMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_tier0_deployment_map**
> delete_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id)

Delete Tier-0 Deployment Map

Delete Tier-0 Deployment Map This API has been deprecated. Use new API GET /infra/tier-0s/tier-0-id/locale-services/locale-services-id/tier-0-deployment-maps

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

api_instance = SwaggerClient::PolicyInfraTier0DeploymentMapsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

tier_0_deployment_map_id = 'tier_0_deployment_map_id_example' # String | 


begin
  #Delete Tier-0 Deployment Map
  api_instance.delete_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraTier0DeploymentMapsApi->delete_tier0_deployment_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **tier_0_deployment_map_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_tier0_deployment_maps**
> Tier0DeploymentMapListResult list_tier0_deployment_maps(tier_0_id, locale_service_id, opts)

List Tier-0 Deployment maps

Paginated list of all Tier-0 Deployment Entries. This API has been deprecated. Use new API GET /infra/tier-0s/tier-0-id/locale-services/locale-services-id/tier-0-deployment-maps 

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

api_instance = SwaggerClient::PolicyInfraTier0DeploymentMapsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Tier-0 Deployment maps
  result = api_instance.list_tier0_deployment_maps(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraTier0DeploymentMapsApi->list_tier0_deployment_maps: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**Tier0DeploymentMapListResult**](Tier0DeploymentMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_tier0_deployment_map**
> Tier0DeploymentMap patch_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id, tier0_deployment_map)

Patch a Tier-0 Deployment Map under Tier-0

If the passed Tier-0 Deployment Map does not already exist, create a new Tier-0 Deployment Map. If it already exists, patch it. This API has been deprecated. Use new API PATCH /infra/tier-0s/<tier-0-id>/locale-services/locale-services-id/tier-0-deployment-maps/tier-0-deployment-map-id 

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

api_instance = SwaggerClient::PolicyInfraTier0DeploymentMapsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

tier_0_deployment_map_id = 'tier_0_deployment_map_id_example' # String | 

tier0_deployment_map = SwaggerClient::Tier0DeploymentMap.new # Tier0DeploymentMap | 


begin
  #Patch a Tier-0 Deployment Map under Tier-0
  result = api_instance.patch_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id, tier0_deployment_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraTier0DeploymentMapsApi->patch_tier0_deployment_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **tier_0_deployment_map_id** | **String**|  | 
 **tier0_deployment_map** | [**Tier0DeploymentMap**](Tier0DeploymentMap.md)|  | 

### Return type

[**Tier0DeploymentMap**](Tier0DeploymentMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_tier0_deployment_map**
> Tier0DeploymentMap read_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id)

Read a Tier-0 Deployment Map

Read a Tier-0 Deployment Map This API has been deprecated. Use new API GET /infra/tier-0s/tier-0-1/locale-services/locale-services-1/tier-0-deployment-maps/tier-0-deployment-map-1 

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

api_instance = SwaggerClient::PolicyInfraTier0DeploymentMapsApi.new

tier_0_id = 'tier_0_id_example' # String | 

locale_service_id = 'locale_service_id_example' # String | 

tier_0_deployment_map_id = 'tier_0_deployment_map_id_example' # String | 


begin
  #Read a Tier-0 Deployment Map
  result = api_instance.read_tier0_deployment_map(tier_0_id, locale_service_id, tier_0_deployment_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraTier0DeploymentMapsApi->read_tier0_deployment_map: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**|  | 
 **locale_service_id** | **String**|  | 
 **tier_0_deployment_map_id** | **String**|  | 

### Return type

[**Tier0DeploymentMap**](Tier0DeploymentMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



