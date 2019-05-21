# SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_update_infra_segment_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#create_or_update_infra_segment_port_security_profile_binding) | **PUT** /infra/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Create or replace the infra segment port security profile binding map
[**create_or_update_infra_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#create_or_update_infra_segment_security_profile_binding) | **PUT** /infra/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Create or replace infra segment security profile binding map
[**create_or_update_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#create_or_update_port_security_profile_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Create or replace the port security profile binding map
[**create_or_update_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#create_or_update_segment_security_profile_binding) | **PUT** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Create or replace segment security profile binding map
[**delete_infra_segment_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#delete_infra_segment_port_security_profile_binding) | **DELETE** /infra/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Delete the infra segment port security profile binding map
[**delete_infra_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#delete_infra_segment_security_profile_binding) | **DELETE** /infra/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Delete infra segment security profile binding map
[**delete_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#delete_port_security_profile_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Delete the port security profile binding map
[**delete_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#delete_segment_security_profile_binding) | **DELETE** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Delete segment security profile binding map
[**get_infra_segment_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#get_infra_segment_port_security_profile_binding) | **GET** /infra/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Get infra segment port security profile binding map
[**get_infra_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#get_infra_segment_security_profile_binding) | **GET** /infra/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Get infra segment security profile binding map
[**get_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#get_port_security_profile_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Get port security profile binding map
[**get_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#get_segment_security_profile_binding) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Get segment security profile binding map
[**list_infra_segment_port_security_profile_bindings**](PolicySecurityProfilesSecurityProfileBindingApi.md#list_infra_segment_port_security_profile_bindings) | **GET** /infra/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps | List infra segment port security profile binding maps
[**list_infra_segment_security_profile_bindings**](PolicySecurityProfilesSecurityProfileBindingApi.md#list_infra_segment_security_profile_bindings) | **GET** /infra/segments/{segment-id}/segment-security-profile-binding-maps | List infra segment security profile binding maps
[**list_port_security_profile_bindings**](PolicySecurityProfilesSecurityProfileBindingApi.md#list_port_security_profile_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps | List port security profile binding maps
[**list_segment_security_profile_bindings**](PolicySecurityProfilesSecurityProfileBindingApi.md#list_segment_security_profile_bindings) | **GET** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-security-profile-binding-maps | List segment security profile binding maps
[**patch_infra_segment_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#patch_infra_segment_port_security_profile_binding) | **PATCH** /infra/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Patch infra segment port security profile binding map
[**patch_infra_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#patch_infra_segment_security_profile_binding) | **PATCH** /infra/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Patch infra segment security profile binding map
[**patch_port_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#patch_port_security_profile_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/ports/{port-id}/port-security-profile-binding-maps/{port-security-profile-binding-map-id} | Patch port security profile binding map
[**patch_segment_security_profile_binding**](PolicySecurityProfilesSecurityProfileBindingApi.md#patch_segment_security_profile_binding) | **PATCH** /infra/tier-1s/{tier-1-id}/segments/{segment-id}/segment-security-profile-binding-maps/{segment-security-profile-binding-map-id} | Patch segment security profile binding map


# **create_or_update_infra_segment_port_security_profile_binding**
> PortSecurityProfileBindingMap create_or_update_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)

Create or replace the infra segment port security profile binding map

API will create or replace the port security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id

port_security_profile_binding_map = SwaggerClient::PortSecurityProfileBindingMap.new # PortSecurityProfileBindingMap | 


begin
  #Create or replace the infra segment port security profile binding map
  result = api_instance.create_or_update_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->create_or_update_infra_segment_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 
 **port_security_profile_binding_map** | [**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)|  | 

### Return type

[**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_infra_segment_security_profile_binding**
> SegmentSecurityProfileBindingMap create_or_update_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)

Create or replace infra segment security profile binding map

API will create or replace segment security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id

segment_security_profile_binding_map = SwaggerClient::SegmentSecurityProfileBindingMap.new # SegmentSecurityProfileBindingMap | 


begin
  #Create or replace infra segment security profile binding map
  result = api_instance.create_or_update_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->create_or_update_infra_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 
 **segment_security_profile_binding_map** | [**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)|  | 

### Return type

[**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_port_security_profile_binding**
> PortSecurityProfileBindingMap create_or_update_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)

Create or replace the port security profile binding map

API will create or replace the port security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id

port_security_profile_binding_map = SwaggerClient::PortSecurityProfileBindingMap.new # PortSecurityProfileBindingMap | 


begin
  #Create or replace the port security profile binding map
  result = api_instance.create_or_update_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->create_or_update_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 
 **port_security_profile_binding_map** | [**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)|  | 

### Return type

[**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_segment_security_profile_binding**
> SegmentSecurityProfileBindingMap create_or_update_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)

Create or replace segment security profile binding map

API will create or replace segment security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id

segment_security_profile_binding_map = SwaggerClient::SegmentSecurityProfileBindingMap.new # SegmentSecurityProfileBindingMap | 


begin
  #Create or replace segment security profile binding map
  result = api_instance.create_or_update_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->create_or_update_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 
 **segment_security_profile_binding_map** | [**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)|  | 

### Return type

[**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment_port_security_profile_binding**
> delete_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id)

Delete the infra segment port security profile binding map

API will delete the port security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id


begin
  #Delete the infra segment port security profile binding map
  api_instance.delete_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->delete_infra_segment_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_infra_segment_security_profile_binding**
> delete_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id)

Delete infra segment security profile binding map

API will delete segment security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id


begin
  #Delete infra segment security profile binding map
  api_instance.delete_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->delete_infra_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_port_security_profile_binding**
> delete_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id)

Delete the port security profile binding map

API will delete the port security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id


begin
  #Delete the port security profile binding map
  api_instance.delete_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->delete_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_segment_security_profile_binding**
> delete_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id)

Delete segment security profile binding map

API will delete segment security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id


begin
  #Delete segment security profile binding map
  api_instance.delete_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->delete_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_port_security_profile_binding**
> PortSecurityProfileBindingMap get_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id)

Get infra segment port security profile binding map

API will return details of the port security profile binding map. If the security profile binding map does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id


begin
  #Get infra segment port security profile binding map
  result = api_instance.get_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->get_infra_segment_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 

### Return type

[**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_infra_segment_security_profile_binding**
> SegmentSecurityProfileBindingMap get_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id)

Get infra segment security profile binding map

API will return details of the segment security profile binding map. If the binding map does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id


begin
  #Get infra segment security profile binding map
  result = api_instance.get_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->get_infra_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 

### Return type

[**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_port_security_profile_binding**
> PortSecurityProfileBindingMap get_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id)

Get port security profile binding map

API will return details of the port security profile binding map. If the security profile binding map does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id


begin
  #Get port security profile binding map
  result = api_instance.get_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->get_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 

### Return type

[**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_segment_security_profile_binding**
> SegmentSecurityProfileBindingMap get_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id)

Get segment security profile binding map

API will return details of the segment security profile binding map. If the binding map does not exist, it will return 404. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id


begin
  #Get segment security profile binding map
  result = api_instance.get_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->get_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 

### Return type

[**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_segment_port_security_profile_bindings**
> PortSecurityProfileBindingMapListResult list_infra_segment_port_security_profile_bindings(segment_id, port_id, opts)

List infra segment port security profile binding maps

API will list all port security profile binding maps. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List infra segment port security profile binding maps
  result = api_instance.list_infra_segment_port_security_profile_bindings(segment_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->list_infra_segment_port_security_profile_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortSecurityProfileBindingMapListResult**](PortSecurityProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_infra_segment_security_profile_bindings**
> SegmentSecurityProfileBindingMapListResult list_infra_segment_security_profile_bindings(segment_id, opts)

List infra segment security profile binding maps

API will list all segment security profile binding maps. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List infra segment security profile binding maps
  result = api_instance.list_infra_segment_security_profile_bindings(segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->list_infra_segment_security_profile_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentSecurityProfileBindingMapListResult**](SegmentSecurityProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_port_security_profile_bindings**
> PortSecurityProfileBindingMapListResult list_port_security_profile_bindings(tier_1_id, segment_id, port_id, opts)

List port security profile binding maps

API will list all port security profile binding maps. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List port security profile binding maps
  result = api_instance.list_port_security_profile_bindings(tier_1_id, segment_id, port_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->list_port_security_profile_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PortSecurityProfileBindingMapListResult**](PortSecurityProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_segment_security_profile_bindings**
> SegmentSecurityProfileBindingMapListResult list_segment_security_profile_bindings(tier_1_id, segment_id, opts)

List segment security profile binding maps

API will list all segment security profile binding maps. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List segment security profile binding maps
  result = api_instance.list_segment_security_profile_bindings(tier_1_id, segment_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->list_segment_security_profile_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SegmentSecurityProfileBindingMapListResult**](SegmentSecurityProfileBindingMapListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment_port_security_profile_binding**
> patch_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)

Patch infra segment port security profile binding map

Create a new port security profile binding map if the given security profile binding map does not exist. Otherwise, patch the existing port security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id

port_security_profile_binding_map = SwaggerClient::PortSecurityProfileBindingMap.new # PortSecurityProfileBindingMap | 


begin
  #Patch infra segment port security profile binding map
  api_instance.patch_infra_segment_port_security_profile_binding(segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->patch_infra_segment_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 
 **port_security_profile_binding_map** | [**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_infra_segment_security_profile_binding**
> patch_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)

Patch infra segment security profile binding map

Create a new segment security profile binding map if the given security profile binding map does not exist. Otherwise, patch the existing segment security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id

segment_security_profile_binding_map = SwaggerClient::SegmentSecurityProfileBindingMap.new # SegmentSecurityProfileBindingMap | 


begin
  #Patch infra segment security profile binding map
  api_instance.patch_infra_segment_security_profile_binding(segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->patch_infra_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 
 **segment_security_profile_binding_map** | [**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_port_security_profile_binding**
> patch_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)

Patch port security profile binding map

Create a new port security profile binding map if the given security profile binding map does not exist. Otherwise, patch the existing port security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

port_id = 'port_id_example' # String | port id

port_security_profile_binding_map_id = 'port_security_profile_binding_map_id_example' # String | port security profile binding map id

port_security_profile_binding_map = SwaggerClient::PortSecurityProfileBindingMap.new # PortSecurityProfileBindingMap | 


begin
  #Patch port security profile binding map
  api_instance.patch_port_security_profile_binding(tier_1_id, segment_id, port_id, port_security_profile_binding_map_id, port_security_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->patch_port_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **port_id** | **String**| port id | 
 **port_security_profile_binding_map_id** | **String**| port security profile binding map id | 
 **port_security_profile_binding_map** | [**PortSecurityProfileBindingMap**](PortSecurityProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_segment_security_profile_binding**
> patch_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)

Patch segment security profile binding map

Create a new segment security profile binding map if the given security profile binding map does not exist. Otherwise, patch the existing segment security profile binding map. 

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

api_instance = SwaggerClient::PolicySecurityProfilesSecurityProfileBindingApi.new

tier_1_id = 'tier_1_id_example' # String | tier-1 gateway id

segment_id = 'segment_id_example' # String | segment id

segment_security_profile_binding_map_id = 'segment_security_profile_binding_map_id_example' # String | segment security profile binding map id

segment_security_profile_binding_map = SwaggerClient::SegmentSecurityProfileBindingMap.new # SegmentSecurityProfileBindingMap | 


begin
  #Patch segment security profile binding map
  api_instance.patch_segment_security_profile_binding(tier_1_id, segment_id, segment_security_profile_binding_map_id, segment_security_profile_binding_map)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySecurityProfilesSecurityProfileBindingApi->patch_segment_security_profile_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_1_id** | **String**| tier-1 gateway id | 
 **segment_id** | **String**| segment id | 
 **segment_security_profile_binding_map_id** | **String**| segment security profile binding map id | 
 **segment_security_profile_binding_map** | [**SegmentSecurityProfileBindingMap**](SegmentSecurityProfileBindingMap.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



