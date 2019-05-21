# SwaggerClient::PolicyInfraDeploymentZonesApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**list_deployment_zones_for_infra**](PolicyInfraDeploymentZonesApi.md#list_deployment_zones_for_infra) | **GET** /infra/deployment-zones | List Deployment Zones for infra
[**read_deployment_zone_infra**](PolicyInfraDeploymentZonesApi.md#read_deployment_zone_infra) | **GET** /infra/deployment-zones/{deployment-zone-id} | Read a DeploymentZone


# **list_deployment_zones_for_infra**
> DeploymentZoneListResult list_deployment_zones_for_infra(opts)

List Deployment Zones for infra

Paginated list of all Deployment zones for infra. This is a deprecated API. DeploymentZone has been renamed to Site. Use GET /infra/sites. 

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

api_instance = SwaggerClient::PolicyInfraDeploymentZonesApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Deployment Zones for infra
  result = api_instance.list_deployment_zones_for_infra(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDeploymentZonesApi->list_deployment_zones_for_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**DeploymentZoneListResult**](DeploymentZoneListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_deployment_zone_infra**
> DeploymentZone read_deployment_zone_infra(deployment_zone_id)

Read a DeploymentZone

Read a Deployment Zone. This is a deprecated API. DeploymentZone has been renamed to Site. Use GET /infra/sites/site-id. 

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

api_instance = SwaggerClient::PolicyInfraDeploymentZonesApi.new

deployment_zone_id = 'deployment_zone_id_example' # String | Deployment Zone id


begin
  #Read a DeploymentZone
  result = api_instance.read_deployment_zone_infra(deployment_zone_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraDeploymentZonesApi->read_deployment_zone_infra: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deployment_zone_id** | **String**| Deployment Zone id | 

### Return type

[**DeploymentZone**](DeploymentZone.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



