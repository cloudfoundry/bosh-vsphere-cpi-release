# SwaggerClient::PolicyInfraEnforcementPointsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_enforcement_point_for_infra**](PolicyInfraEnforcementPointsApi.md#create_or_update_enforcement_point_for_infra) | **PUT** /infra/deployment-zones/{deployment-zone-id}/enforcement-points/{enforcementpoint-id} | Create/update a new Enforcement Point under infra
[**create_or_update_enforcement_point_for_site**](PolicyInfraEnforcementPointsApi.md#create_or_update_enforcement_point_for_site) | **PUT** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id} | Create/update a new Enforcement Point under Site
[**delete_enforcement_point**](PolicyInfraEnforcementPointsApi.md#delete_enforcement_point) | **DELETE** /infra/deployment-zones/{deployment-zone-id}/enforcement-points/{enforcementpoint-id} | Delete EnforcementPoint
[**delete_enforcement_point_for_site**](PolicyInfraEnforcementPointsApi.md#delete_enforcement_point_for_site) | **DELETE** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id} | Delete EnforcementPoint from Site
[**full_sync_enforcement_point_for_site_full_sync**](PolicyInfraEnforcementPointsApi.md#full_sync_enforcement_point_for_site_full_sync) | **POST** /infra/sites/{site-id}/enforcement-points/{enforcement-point-id}?action&#x3D;full-sync | Full sync EnforcementPoint from Site
[**list_enforcement_point_for_infra**](PolicyInfraEnforcementPointsApi.md#list_enforcement_point_for_infra) | **GET** /infra/deployment-zones/{deployment-zone-id}/enforcement-points | List enforcementpoints for infra
[**list_enforcement_point_for_site**](PolicyInfraEnforcementPointsApi.md#list_enforcement_point_for_site) | **GET** /infra/sites/{site-id}/enforcement-points | List enforcementpoints under Site
[**patch_enforcement_point_for_infra**](PolicyInfraEnforcementPointsApi.md#patch_enforcement_point_for_infra) | **PATCH** /infra/deployment-zones/{deployment-zone-id}/enforcement-points/{enforcementpoint-id} | Patch a new Enforcement Point under infra
[**patch_enforcement_point_for_site**](PolicyInfraEnforcementPointsApi.md#patch_enforcement_point_for_site) | **PATCH** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id} | Patch a new Enforcement Point under Site
[**read_enforcement_point_for_infra**](PolicyInfraEnforcementPointsApi.md#read_enforcement_point_for_infra) | **GET** /infra/deployment-zones/{deployment-zone-id}/enforcement-points/{enforcementpoint-id} | Read an Enforcement Point
[**read_enforcement_point_for_site**](PolicyInfraEnforcementPointsApi.md#read_enforcement_point_for_site) | **GET** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id} | Read an Enforcement Point under Infra/Site
[**reload_enforcement_point_for_site_reload**](PolicyInfraEnforcementPointsApi.md#reload_enforcement_point_for_site_reload) | **POST** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id}?action&#x3D;reload | Reload an Enforcement Point under Site


# **create_or_update_enforcement_point_for_infra**
> EnforcementPoint create_or_update_enforcement_point_for_infra(deployment_zone_id, enforcementpoint_id, enforcement_point)

Create/update a new Enforcement Point under infra

If the passed Enforcement Point does not already exist, create a new Enforcement Point. If it already exists, replace it. This is a deprecated API. DeploymentZone has been renamed to Site. Use PUT /infra/sites/site-id/enforcement-points/enforcementpoint-id. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

deployment_zone_id = 'deployment_zone_id_example' # String | Deployment zone id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id

enforcement_point = SwaggerClient::EnforcementPoint.new # EnforcementPoint | 


begin
  #Create/update a new Enforcement Point under infra
  result = api_instance.create_or_update_enforcement_point_for_infra(deployment_zone_id, enforcementpoint_id, enforcement_point)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->create_or_update_enforcement_point_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deployment_zone_id** | **String**| Deployment zone id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 
 **enforcement_point** | [**EnforcementPoint**](EnforcementPoint.md)|  | 

### Return type

[**EnforcementPoint**](EnforcementPoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_enforcement_point_for_site**
> EnforcementPoint create_or_update_enforcement_point_for_site(site_id, enforcementpoint_id, enforcement_point)

Create/update a new Enforcement Point under Site

If the passed Enforcement Point does not already exist, create a new Enforcement Point. If it already exists, replace it. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id

enforcement_point = SwaggerClient::EnforcementPoint.new # EnforcementPoint | 


begin
  #Create/update a new Enforcement Point under Site
  result = api_instance.create_or_update_enforcement_point_for_site(site_id, enforcementpoint_id, enforcement_point)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->create_or_update_enforcement_point_for_site: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 
 **enforcement_point** | [**EnforcementPoint**](EnforcementPoint.md)|  | 

### Return type

[**EnforcementPoint**](EnforcementPoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_enforcement_point**
> delete_enforcement_point(deployment_zone_id, enforcementpoint_id)

Delete EnforcementPoint

Delete EnforcementPoint. This is a deprecated API. DeploymentZone has been renamed to Site. Use DELETE /infra/sites/site-id/enforcement-points/enforcementpoint-id. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

deployment_zone_id = 'deployment_zone_id_example' # String | Deployment zone id

enforcementpoint_id = 'enforcementpoint_id_example' # String | enforcementpoint-id


begin
  #Delete EnforcementPoint
  api_instance.delete_enforcement_point(deployment_zone_id, enforcementpoint_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->delete_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deployment_zone_id** | **String**| Deployment zone id | 
 **enforcementpoint_id** | **String**| enforcementpoint-id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_enforcement_point_for_site**
> delete_enforcement_point_for_site(site_id, enforcementpoint_id)

Delete EnforcementPoint from Site

Delete EnforcementPoint from Site

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | enforcementpoint-id


begin
  #Delete EnforcementPoint from Site
  api_instance.delete_enforcement_point_for_site(site_id, enforcementpoint_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->delete_enforcement_point_for_site: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| enforcementpoint-id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **full_sync_enforcement_point_for_site_full_sync**
> full_sync_enforcement_point_for_site_full_sync(site_id, enforcement_point_id)

Full sync EnforcementPoint from Site

Full sync EnforcementPoint from Site

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | 

enforcement_point_id = 'enforcement_point_id_example' # String | 


begin
  #Full sync EnforcementPoint from Site
  api_instance.full_sync_enforcement_point_for_site_full_sync(site_id, enforcement_point_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->full_sync_enforcement_point_for_site_full_sync: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**|  | 
 **enforcement_point_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_enforcement_point_for_infra**
> EnforcementPointListResult list_enforcement_point_for_infra(deployment_zone_id, opts)

List enforcementpoints for infra

Paginated list of all enforcementpoints for infra. This is a deprecated API. DeploymentZone has been renamed to Site. Use GET /infra/sites/site-id/enforcement-points. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

deployment_zone_id = 'deployment_zone_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List enforcementpoints for infra
  result = api_instance.list_enforcement_point_for_infra(deployment_zone_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->list_enforcement_point_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deployment_zone_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**EnforcementPointListResult**](EnforcementPointListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_enforcement_point_for_site**
> EnforcementPointListResult list_enforcement_point_for_site(site_id, opts)

List enforcementpoints under Site

Paginated list of all enforcementpoints under Site. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List enforcementpoints under Site
  result = api_instance.list_enforcement_point_for_site(site_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->list_enforcement_point_for_site: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**EnforcementPointListResult**](EnforcementPointListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_enforcement_point_for_infra**
> patch_enforcement_point_for_infra(deployment_zone_id, enforcementpoint_id, enforcement_point)

Patch a new Enforcement Point under infra

If the passed Enforcement Point does not already exist, create a new Enforcement Point. If it already exists, patch it. This is a deprecated API. DeploymentZone has been renamed to Site. Use PATCH /infra/sites/site-1/enforcement-points/enforcementpoint-1. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

deployment_zone_id = 'deployment_zone_id_example' # String | Deployment zone id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id

enforcement_point = SwaggerClient::EnforcementPoint.new # EnforcementPoint | 


begin
  #Patch a new Enforcement Point under infra
  api_instance.patch_enforcement_point_for_infra(deployment_zone_id, enforcementpoint_id, enforcement_point)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->patch_enforcement_point_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deployment_zone_id** | **String**| Deployment zone id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 
 **enforcement_point** | [**EnforcementPoint**](EnforcementPoint.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_enforcement_point_for_site**
> patch_enforcement_point_for_site(site_id, enforcementpoint_id, enforcement_point)

Patch a new Enforcement Point under Site

If the passed Enforcement Point does not already exist, create a new Enforcement Point. If it already exists, patch it. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id

enforcement_point = SwaggerClient::EnforcementPoint.new # EnforcementPoint | 


begin
  #Patch a new Enforcement Point under Site
  api_instance.patch_enforcement_point_for_site(site_id, enforcementpoint_id, enforcement_point)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->patch_enforcement_point_for_site: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 
 **enforcement_point** | [**EnforcementPoint**](EnforcementPoint.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_enforcement_point_for_infra**
> EnforcementPoint read_enforcement_point_for_infra(deployment_zone_id, enforcementpoint_id)

Read an Enforcement Point

Read an Enforcement Point. This is a deprecated API. DeploymentZone has been renamed to Site. Use GET /infra/sites/site-id/enforcement-points/enforcementpoint-id. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

deployment_zone_id = 'deployment_zone_id_example' # String | Deployment zone id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id


begin
  #Read an Enforcement Point
  result = api_instance.read_enforcement_point_for_infra(deployment_zone_id, enforcementpoint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->read_enforcement_point_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deployment_zone_id** | **String**| Deployment zone id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 

### Return type

[**EnforcementPoint**](EnforcementPoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_enforcement_point_for_site**
> EnforcementPoint read_enforcement_point_for_site(site_id, enforcementpoint_id)

Read an Enforcement Point under Infra/Site

Read an Enforcement Point under Infra/Site 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id


begin
  #Read an Enforcement Point under Infra/Site
  result = api_instance.read_enforcement_point_for_site(site_id, enforcementpoint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->read_enforcement_point_for_site: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 

### Return type

[**EnforcementPoint**](EnforcementPoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **reload_enforcement_point_for_site_reload**
> EnforcementPoint reload_enforcement_point_for_site_reload(site_id, enforcementpoint_id)

Reload an Enforcement Point under Site

Reload an Enforcement Point under Site. This will read and update fabric configs from enforcement point. 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id


begin
  #Reload an Enforcement Point under Site
  result = api_instance.reload_enforcement_point_for_site_reload(site_id, enforcementpoint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsApi->reload_enforcement_point_for_site_reload: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 

### Return type

[**EnforcementPoint**](EnforcementPoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



