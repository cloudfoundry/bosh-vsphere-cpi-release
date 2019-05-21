# SwaggerClient::PolicyInfraEnforcementPointsTransportZoneApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**list_transport_zones_for_enforcement_point**](PolicyInfraEnforcementPointsTransportZoneApi.md#list_transport_zones_for_enforcement_point) | **GET** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id}/transport-zones | List Transport Zones under an Enforcement Point
[**read_transport_zone_for_enforcement_point**](PolicyInfraEnforcementPointsTransportZoneApi.md#read_transport_zone_for_enforcement_point) | **GET** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id}/transport-zones/{transport-zone-id} | Read a Transport Zone under an Enforcement Point


# **list_transport_zones_for_enforcement_point**
> PolicyTransportZoneListResult list_transport_zones_for_enforcement_point(site_id, enforcementpoint_id, opts)

List Transport Zones under an Enforcement Point

Paginated list of all Transport Zones under an Enforcement Point 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsTransportZoneApi.new

site_id = 'site_id_example' # String | 

enforcementpoint_id = 'enforcementpoint_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Transport Zones under an Enforcement Point
  result = api_instance.list_transport_zones_for_enforcement_point(site_id, enforcementpoint_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsTransportZoneApi->list_transport_zones_for_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**|  | 
 **enforcementpoint_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyTransportZoneListResult**](PolicyTransportZoneListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_transport_zone_for_enforcement_point**
> PolicyTransportZone read_transport_zone_for_enforcement_point(site_id, enforcementpoint_id, transport_zone_id)

Read a Transport Zone under an Enforcement Point

Read a Transport Zone under an Enforcement Point 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsTransportZoneApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id

transport_zone_id = 'transport_zone_id_example' # String | Transport Zone id


begin
  #Read a Transport Zone under an Enforcement Point
  result = api_instance.read_transport_zone_for_enforcement_point(site_id, enforcementpoint_id, transport_zone_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsTransportZoneApi->read_transport_zone_for_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 
 **transport_zone_id** | **String**| Transport Zone id | 

### Return type

[**PolicyTransportZone**](PolicyTransportZone.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



