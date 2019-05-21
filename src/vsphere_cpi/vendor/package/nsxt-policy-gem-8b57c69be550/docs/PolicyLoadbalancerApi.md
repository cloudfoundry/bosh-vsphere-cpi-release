# SwaggerClient::PolicyLoadbalancerApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**delete_lb_app_profile**](PolicyLoadbalancerApi.md#delete_lb_app_profile) | **DELETE** /infra/lb-app-profiles/{lb-app-profile-id} | Delete LBAppProfile and all the entities contained by this LBAppProfile
[**delete_lb_client_ssl_profile**](PolicyLoadbalancerApi.md#delete_lb_client_ssl_profile) | **DELETE** /infra/lb-client-ssl-profiles/{lb-client-ssl-profile-id} | Delete LBClientSslProfile and all the entities contained by this LBClientSslProfile 
[**delete_lb_monitor_profile**](PolicyLoadbalancerApi.md#delete_lb_monitor_profile) | **DELETE** /infra/lb-monitor-profiles/{lb-monitor-profile-id} | Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile
[**delete_lb_persistence_profile**](PolicyLoadbalancerApi.md#delete_lb_persistence_profile) | **DELETE** /infra/lb-persistence-profiles/{lb-persistence-profile-id} | Delete LBPersistenceProfile and all the entities contained by this LBPersistenceProfile
[**delete_lb_pool**](PolicyLoadbalancerApi.md#delete_lb_pool) | **DELETE** /infra/lb-pools/{lb-pool-id} | Delete LBPool and all the entities contained by this LBPool
[**delete_lb_server_ssl_profile**](PolicyLoadbalancerApi.md#delete_lb_server_ssl_profile) | **DELETE** /infra/lb-server-ssl-profiles/{lb-server-ssl-profile-id} | Delete LBServerSslProfile and all the entities contained by this LBServerSslProfile 
[**delete_lb_service**](PolicyLoadbalancerApi.md#delete_lb_service) | **DELETE** /infra/lb-services/{lb-service-id} | Delete LBService and all the entities contained by this LBService
[**delete_lb_virtual_server**](PolicyLoadbalancerApi.md#delete_lb_virtual_server) | **DELETE** /infra/lb-virtual-servers/{lb-virtual-server-id} | Delete LBVirtualServer and all the entities contained by this LBVirtualServer
[**list_lb_app_profiles**](PolicyLoadbalancerApi.md#list_lb_app_profiles) | **GET** /infra/lb-app-profiles | List LBAppProfiles
[**list_lb_client_ssl_profiles**](PolicyLoadbalancerApi.md#list_lb_client_ssl_profiles) | **GET** /infra/lb-client-ssl-profiles | List LBClientSslProfiles
[**list_lb_monitor_profiles**](PolicyLoadbalancerApi.md#list_lb_monitor_profiles) | **GET** /infra/lb-monitor-profiles | List LBMonitorProfiles for infra
[**list_lb_persistence_profiles**](PolicyLoadbalancerApi.md#list_lb_persistence_profiles) | **GET** /infra/lb-persistence-profiles | List LBPersistenceProfiles for infra
[**list_lb_pools**](PolicyLoadbalancerApi.md#list_lb_pools) | **GET** /infra/lb-pools | List LBPools
[**list_lb_server_ssl_profiles**](PolicyLoadbalancerApi.md#list_lb_server_ssl_profiles) | **GET** /infra/lb-server-ssl-profiles | List LBServerSslProfiles
[**list_lb_services**](PolicyLoadbalancerApi.md#list_lb_services) | **GET** /infra/lb-services | List LBService
[**list_lb_virtual_servers**](PolicyLoadbalancerApi.md#list_lb_virtual_servers) | **GET** /infra/lb-virtual-servers | List LBVirtualServers
[**list_ssl_ciphers_and_protocols**](PolicyLoadbalancerApi.md#list_ssl_ciphers_and_protocols) | **GET** /infra/lb-ssl-ciphers-and-protocols | Retrieve a list of supported SSL ciphers and protocols
[**patch_lb_app_profile**](PolicyLoadbalancerApi.md#patch_lb_app_profile) | **PATCH** /infra/lb-app-profiles/{lb-app-profile-id} | Create or update a LBAppProfile
[**patch_lb_client_ssl_profile**](PolicyLoadbalancerApi.md#patch_lb_client_ssl_profile) | **PATCH** /infra/lb-client-ssl-profiles/{lb-client-ssl-profile-id} | Create or update a LBClientSslProfile
[**patch_lb_monitor_profile**](PolicyLoadbalancerApi.md#patch_lb_monitor_profile) | **PATCH** /infra/lb-monitor-profiles/{lb-monitor-profile-id} | Create or update a LBMonitorProfile
[**patch_lb_persistence_profile**](PolicyLoadbalancerApi.md#patch_lb_persistence_profile) | **PATCH** /infra/lb-persistence-profiles/{lb-persistence-profile-id} | Create or update a LBPersistenceProfile
[**patch_lb_pool**](PolicyLoadbalancerApi.md#patch_lb_pool) | **PATCH** /infra/lb-pools/{lb-pool-id} | Create or update a LBPool
[**patch_lb_server_ssl_profile**](PolicyLoadbalancerApi.md#patch_lb_server_ssl_profile) | **PATCH** /infra/lb-server-ssl-profiles/{lb-server-ssl-profile-id} | Create or update a LBServerSslProfile
[**patch_lb_service**](PolicyLoadbalancerApi.md#patch_lb_service) | **PATCH** /infra/lb-services/{lb-service-id} | Create or update a LBVirtualServer
[**patch_lb_virtual_server**](PolicyLoadbalancerApi.md#patch_lb_virtual_server) | **PATCH** /infra/lb-virtual-servers/{lb-virtual-server-id} | Create or update a LBVirtualServer
[**read_lb_app_profile**](PolicyLoadbalancerApi.md#read_lb_app_profile) | **GET** /infra/lb-app-profiles/{lb-app-profile-id} | Read LBAppProfile
[**read_lb_client_ssl_profile**](PolicyLoadbalancerApi.md#read_lb_client_ssl_profile) | **GET** /infra/lb-client-ssl-profiles/{lb-client-ssl-profile-id} | Read LBClientSslProfile
[**read_lb_monitor_profile**](PolicyLoadbalancerApi.md#read_lb_monitor_profile) | **GET** /infra/lb-monitor-profiles/{lb-monitor-profile-id} | Read LBMonitorProfile
[**read_lb_persistence_profile**](PolicyLoadbalancerApi.md#read_lb_persistence_profile) | **GET** /infra/lb-persistence-profiles/{lb-persistence-profile-id} | Read LBPersistenceProfile
[**read_lb_pool**](PolicyLoadbalancerApi.md#read_lb_pool) | **GET** /infra/lb-pools/{lb-pool-id} | Read LBPool
[**read_lb_server_ssl_profile**](PolicyLoadbalancerApi.md#read_lb_server_ssl_profile) | **GET** /infra/lb-server-ssl-profiles/{lb-server-ssl-profile-id} | Read LBServerSslProfile
[**read_lb_service**](PolicyLoadbalancerApi.md#read_lb_service) | **GET** /infra/lb-services/{lb-service-id} | Read LBService
[**read_lb_virtual_server**](PolicyLoadbalancerApi.md#read_lb_virtual_server) | **GET** /infra/lb-virtual-servers/{lb-virtual-server-id} | Read LBVirtualServer
[**update_lb_app_profile**](PolicyLoadbalancerApi.md#update_lb_app_profile) | **PUT** /infra/lb-app-profiles/{lb-app-profile-id} | Create or update a LBAppProfile
[**update_lb_client_ssl_profile**](PolicyLoadbalancerApi.md#update_lb_client_ssl_profile) | **PUT** /infra/lb-client-ssl-profiles/{lb-client-ssl-profile-id} | Create or update a LBClientSslProfile
[**update_lb_monitor_profile**](PolicyLoadbalancerApi.md#update_lb_monitor_profile) | **PUT** /infra/lb-monitor-profiles/{lb-monitor-profile-id} | Create or update a LBMonitorProfile
[**update_lb_persistence_profile**](PolicyLoadbalancerApi.md#update_lb_persistence_profile) | **PUT** /infra/lb-persistence-profiles/{lb-persistence-profile-id} | Create or update a LBPersistenceProfile
[**update_lb_pool**](PolicyLoadbalancerApi.md#update_lb_pool) | **PUT** /infra/lb-pools/{lb-pool-id} | Create or update a LBPool
[**update_lb_server_ssl_profile**](PolicyLoadbalancerApi.md#update_lb_server_ssl_profile) | **PUT** /infra/lb-server-ssl-profiles/{lb-server-ssl-profile-id} | Create or update a LBServerSslProfile
[**update_lb_service**](PolicyLoadbalancerApi.md#update_lb_service) | **PUT** /infra/lb-services/{lb-service-id} | Create or update a LBService
[**update_lb_virtual_server**](PolicyLoadbalancerApi.md#update_lb_virtual_server) | **PUT** /infra/lb-virtual-servers/{lb-virtual-server-id} | Create or update a LBVirtualServer


# **delete_lb_app_profile**
> delete_lb_app_profile(lb_app_profile_id, opts)

Delete LBAppProfile and all the entities contained by this LBAppProfile

Delete the LBAppProfile along with all the entities contained by this LBAppProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_app_profile_id = 'lb_app_profile_id_example' # String | LBAppProfile ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBAppProfile and all the entities contained by this LBAppProfile
  api_instance.delete_lb_app_profile(lb_app_profile_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_app_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_app_profile_id** | **String**| LBAppProfile ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_client_ssl_profile**
> delete_lb_client_ssl_profile(lb_client_ssl_profile_id, opts)

Delete LBClientSslProfile and all the entities contained by this LBClientSslProfile 

Delete the LBClientSslProfile along with all the entities contained by this LBClientSslProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_client_ssl_profile_id = 'lb_client_ssl_profile_id_example' # String | LBClientSslProfile ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBClientSslProfile and all the entities contained by this LBClientSslProfile 
  api_instance.delete_lb_client_ssl_profile(lb_client_ssl_profile_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_client_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_client_ssl_profile_id** | **String**| LBClientSslProfile ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_monitor_profile**
> delete_lb_monitor_profile(lb_monitor_profile_id, opts)

Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile

Delete the LBMonitorProfile along with all the entities contained by this LBMonitorProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_monitor_profile_id = 'lb_monitor_profile_id_example' # String | LBMonitorProfile ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile
  api_instance.delete_lb_monitor_profile(lb_monitor_profile_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_monitor_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_monitor_profile_id** | **String**| LBMonitorProfile ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_persistence_profile**
> delete_lb_persistence_profile(lb_persistence_profile_id, opts)

Delete LBPersistenceProfile and all the entities contained by this LBPersistenceProfile

Delete the LBPersistenceProfile along with all the entities contained by this LBPersistenceProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_persistence_profile_id = 'lb_persistence_profile_id_example' # String | LBPersistenceProfile ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBPersistenceProfile and all the entities contained by this LBPersistenceProfile
  api_instance.delete_lb_persistence_profile(lb_persistence_profile_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_persistence_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_persistence_profile_id** | **String**| LBPersistenceProfile ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_pool**
> delete_lb_pool(lb_pool_id, opts)

Delete LBPool and all the entities contained by this LBPool

Delete the LBPool along with all the entities contained by this LBPool. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_pool_id = 'lb_pool_id_example' # String | LBPool ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBPool and all the entities contained by this LBPool
  api_instance.delete_lb_pool(lb_pool_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_pool_id** | **String**| LBPool ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_server_ssl_profile**
> delete_lb_server_ssl_profile(lb_server_ssl_profile_id, opts)

Delete LBServerSslProfile and all the entities contained by this LBServerSslProfile 

Delete the LBServerSslProfile along with all the entities contained by this LBServerSslProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_server_ssl_profile_id = 'lb_server_ssl_profile_id_example' # String | LBServerSslProfile ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBServerSslProfile and all the entities contained by this LBServerSslProfile 
  api_instance.delete_lb_server_ssl_profile(lb_server_ssl_profile_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_server_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_server_ssl_profile_id** | **String**| LBServerSslProfile ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_service**
> delete_lb_service(lb_service_id, opts)

Delete LBService and all the entities contained by this LBService

Delete the LBService along with all the entities contained by this LBService. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_service_id = 'lb_service_id_example' # String | LBService ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBService and all the entities contained by this LBService
  api_instance.delete_lb_service(lb_service_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_lb_virtual_server**
> delete_lb_virtual_server(lb_virtual_server_id, opts)

Delete LBVirtualServer and all the entities contained by this LBVirtualServer

Delete the LBVirtualServer along with all the entities contained by this LBVirtualServer. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_virtual_server_id = 'lb_virtual_server_id_example' # String | LBVirtualServer ID

opts = { 
  force: false # BOOLEAN | Force delete the resource even if it is being used somewhere 
}

begin
  #Delete LBVirtualServer and all the entities contained by this LBVirtualServer
  api_instance.delete_lb_virtual_server(lb_virtual_server_id, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->delete_lb_virtual_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_virtual_server_id** | **String**| LBVirtualServer ID | 
 **force** | **BOOLEAN**| Force delete the resource even if it is being used somewhere  | [optional] [default to false]

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_app_profiles**
> LBAppProfileListResult list_lb_app_profiles(opts)

List LBAppProfiles

Paginated list of all LBAppProfiles. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBAppProfiles
  result = api_instance.list_lb_app_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_app_profiles: #{e}"
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

[**LBAppProfileListResult**](LBAppProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_client_ssl_profiles**
> LBClientSslProfileListResult list_lb_client_ssl_profiles(opts)

List LBClientSslProfiles

Paginated list of all LBClientSslProfiles. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBClientSslProfiles
  result = api_instance.list_lb_client_ssl_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_client_ssl_profiles: #{e}"
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

[**LBClientSslProfileListResult**](LBClientSslProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_monitor_profiles**
> LBMonitorProfileListResult list_lb_monitor_profiles(opts)

List LBMonitorProfiles for infra

Paginated list of all LBMonitorProfiles for infra. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBMonitorProfiles for infra
  result = api_instance.list_lb_monitor_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_monitor_profiles: #{e}"
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

[**LBMonitorProfileListResult**](LBMonitorProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_persistence_profiles**
> LBPersistenceProfileListResult list_lb_persistence_profiles(opts)

List LBPersistenceProfiles for infra

Paginated list of all LBPersistenceProfiles for infra. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBPersistenceProfiles for infra
  result = api_instance.list_lb_persistence_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_persistence_profiles: #{e}"
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

[**LBPersistenceProfileListResult**](LBPersistenceProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_pools**
> LBPoolListResult list_lb_pools(opts)

List LBPools

Paginated list of all LBPools. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBPools
  result = api_instance.list_lb_pools(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_pools: #{e}"
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

[**LBPoolListResult**](LBPoolListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_server_ssl_profiles**
> LBServerSslProfileListResult list_lb_server_ssl_profiles(opts)

List LBServerSslProfiles

Paginated list of all LBServerSslProfiles. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBServerSslProfiles
  result = api_instance.list_lb_server_ssl_profiles(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_server_ssl_profiles: #{e}"
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

[**LBServerSslProfileListResult**](LBServerSslProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_services**
> LBServiceListResult list_lb_services(opts)

List LBService

Paginated list of all LBService. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBService
  result = api_instance.list_lb_services(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_services: #{e}"
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

[**LBServiceListResult**](LBServiceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_lb_virtual_servers**
> LBVirtualServerListResult list_lb_virtual_servers(opts)

List LBVirtualServers

Paginated list of all LBVirtualServers. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List LBVirtualServers
  result = api_instance.list_lb_virtual_servers(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_lb_virtual_servers: #{e}"
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

[**LBVirtualServerListResult**](LBVirtualServerListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ssl_ciphers_and_protocols**
> LbSslCipherAndProtocolListResult list_ssl_ciphers_and_protocols(opts)

Retrieve a list of supported SSL ciphers and protocols

Retrieve a list of supported SSL ciphers and protocols. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Retrieve a list of supported SSL ciphers and protocols
  result = api_instance.list_ssl_ciphers_and_protocols(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->list_ssl_ciphers_and_protocols: #{e}"
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

[**LbSslCipherAndProtocolListResult**](LbSslCipherAndProtocolListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_app_profile**
> patch_lb_app_profile(lb_app_profile_id, lb_app_profile)

Create or update a LBAppProfile

If a LBAppProfile with the lb-app-profile-id is not already present, create a new LBAppProfile. If it already exists, update the LBAppProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_app_profile_id = 'lb_app_profile_id_example' # String | LBAppProfile ID

lb_app_profile = SwaggerClient::LBAppProfile.new # LBAppProfile | 


begin
  #Create or update a LBAppProfile
  api_instance.patch_lb_app_profile(lb_app_profile_id, lb_app_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_app_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_app_profile_id** | **String**| LBAppProfile ID | 
 **lb_app_profile** | [**LBAppProfile**](LBAppProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_client_ssl_profile**
> patch_lb_client_ssl_profile(lb_client_ssl_profile_id, lb_client_ssl_profile)

Create or update a LBClientSslProfile

If a LBClientSslProfile with the lb-client-ssl-profile-id is not already present, create a new LBClientSslProfile. If it already exists, update the LBClientSslProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_client_ssl_profile_id = 'lb_client_ssl_profile_id_example' # String | LBClientSslProfile ID

lb_client_ssl_profile = SwaggerClient::LBClientSslProfile.new # LBClientSslProfile | 


begin
  #Create or update a LBClientSslProfile
  api_instance.patch_lb_client_ssl_profile(lb_client_ssl_profile_id, lb_client_ssl_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_client_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_client_ssl_profile_id** | **String**| LBClientSslProfile ID | 
 **lb_client_ssl_profile** | [**LBClientSslProfile**](LBClientSslProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_monitor_profile**
> patch_lb_monitor_profile(lb_monitor_profile_id, lb_monitor_profile)

Create or update a LBMonitorProfile

If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_monitor_profile_id = 'lb_monitor_profile_id_example' # String | LBMonitorProfile ID

lb_monitor_profile = SwaggerClient::LBMonitorProfile.new # LBMonitorProfile | 


begin
  #Create or update a LBMonitorProfile
  api_instance.patch_lb_monitor_profile(lb_monitor_profile_id, lb_monitor_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_monitor_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_monitor_profile_id** | **String**| LBMonitorProfile ID | 
 **lb_monitor_profile** | [**LBMonitorProfile**](LBMonitorProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_persistence_profile**
> patch_lb_persistence_profile(lb_persistence_profile_id, lb_persistence_profile)

Create or update a LBPersistenceProfile

If a LBPersistenceProfile with the lb-persistence-profile-id is not already present, create a new LBPersistenceProfile. If it already exists, update the LBPersistenceProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_persistence_profile_id = 'lb_persistence_profile_id_example' # String | LBPersistenceProfile ID

lb_persistence_profile = SwaggerClient::LBPersistenceProfile.new # LBPersistenceProfile | 


begin
  #Create or update a LBPersistenceProfile
  api_instance.patch_lb_persistence_profile(lb_persistence_profile_id, lb_persistence_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_persistence_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_persistence_profile_id** | **String**| LBPersistenceProfile ID | 
 **lb_persistence_profile** | [**LBPersistenceProfile**](LBPersistenceProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_pool**
> patch_lb_pool(lb_pool_id, lb_pool)

Create or update a LBPool

If a LBPool with the lb-pool-id is not already present, create a new LBPool. If it already exists, update the LBPool. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_pool_id = 'lb_pool_id_example' # String | LBPool ID

lb_pool = SwaggerClient::LBPool.new # LBPool | 


begin
  #Create or update a LBPool
  api_instance.patch_lb_pool(lb_pool_id, lb_pool)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_pool_id** | **String**| LBPool ID | 
 **lb_pool** | [**LBPool**](LBPool.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_server_ssl_profile**
> patch_lb_server_ssl_profile(lb_server_ssl_profile_id, lb_server_ssl_profile)

Create or update a LBServerSslProfile

If a LBServerSslProfile with the lb-server-ssl-profile-id is not already present, create a new LBServerSslProfile. If it already exists, update the LBServerSslProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_server_ssl_profile_id = 'lb_server_ssl_profile_id_example' # String | LBServerSslProfile ID

lb_server_ssl_profile = SwaggerClient::LBServerSslProfile.new # LBServerSslProfile | 


begin
  #Create or update a LBServerSslProfile
  api_instance.patch_lb_server_ssl_profile(lb_server_ssl_profile_id, lb_server_ssl_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_server_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_server_ssl_profile_id** | **String**| LBServerSslProfile ID | 
 **lb_server_ssl_profile** | [**LBServerSslProfile**](LBServerSslProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_service**
> patch_lb_service(lb_service_id, lb_service)

Create or update a LBVirtualServer

If a LBService with the lb-service-id is not already present, create a new LBService. If it already exists, update the LBService. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_service_id = 'lb_service_id_example' # String | LBService ID

lb_service = SwaggerClient::LBService.new # LBService | 


begin
  #Create or update a LBVirtualServer
  api_instance.patch_lb_service(lb_service_id, lb_service)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService ID | 
 **lb_service** | [**LBService**](LBService.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_lb_virtual_server**
> patch_lb_virtual_server(lb_virtual_server_id, lb_virtual_server)

Create or update a LBVirtualServer

If a LBVirtualServer with the lb-virtual-server-id is not already present, create a new LBVirtualServer. If it already exists, update the LBVirtualServer. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_virtual_server_id = 'lb_virtual_server_id_example' # String | LBVirtualServer ID

lb_virtual_server = SwaggerClient::LBVirtualServer.new # LBVirtualServer | 


begin
  #Create or update a LBVirtualServer
  api_instance.patch_lb_virtual_server(lb_virtual_server_id, lb_virtual_server)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->patch_lb_virtual_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_virtual_server_id** | **String**| LBVirtualServer ID | 
 **lb_virtual_server** | [**LBVirtualServer**](LBVirtualServer.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_app_profile**
> LBAppProfile read_lb_app_profile(lb_app_profile_id)

Read LBAppProfile

Read a LBAppProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_app_profile_id = 'lb_app_profile_id_example' # String | LBAppProfile ID


begin
  #Read LBAppProfile
  result = api_instance.read_lb_app_profile(lb_app_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_app_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_app_profile_id** | **String**| LBAppProfile ID | 

### Return type

[**LBAppProfile**](LBAppProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_client_ssl_profile**
> LBClientSslProfile read_lb_client_ssl_profile(lb_client_ssl_profile_id)

Read LBClientSslProfile

Read a LBClientSslProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_client_ssl_profile_id = 'lb_client_ssl_profile_id_example' # String | LBClientSslProfile ID


begin
  #Read LBClientSslProfile
  result = api_instance.read_lb_client_ssl_profile(lb_client_ssl_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_client_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_client_ssl_profile_id** | **String**| LBClientSslProfile ID | 

### Return type

[**LBClientSslProfile**](LBClientSslProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_monitor_profile**
> LBMonitorProfile read_lb_monitor_profile(lb_monitor_profile_id)

Read LBMonitorProfile

Read a LBMonitorProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_monitor_profile_id = 'lb_monitor_profile_id_example' # String | LBMonitorProfile ID


begin
  #Read LBMonitorProfile
  result = api_instance.read_lb_monitor_profile(lb_monitor_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_monitor_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_monitor_profile_id** | **String**| LBMonitorProfile ID | 

### Return type

[**LBMonitorProfile**](LBMonitorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_persistence_profile**
> LBPersistenceProfile read_lb_persistence_profile(lb_persistence_profile_id)

Read LBPersistenceProfile

Read a LBPersistenceProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_persistence_profile_id = 'lb_persistence_profile_id_example' # String | LBPersistenceProfile ID


begin
  #Read LBPersistenceProfile
  result = api_instance.read_lb_persistence_profile(lb_persistence_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_persistence_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_persistence_profile_id** | **String**| LBPersistenceProfile ID | 

### Return type

[**LBPersistenceProfile**](LBPersistenceProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_pool**
> LBPool read_lb_pool(lb_pool_id)

Read LBPool

Read a LBPool. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_pool_id = 'lb_pool_id_example' # String | LBPool ID


begin
  #Read LBPool
  result = api_instance.read_lb_pool(lb_pool_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_pool_id** | **String**| LBPool ID | 

### Return type

[**LBPool**](LBPool.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_server_ssl_profile**
> LBServerSslProfile read_lb_server_ssl_profile(lb_server_ssl_profile_id)

Read LBServerSslProfile

Read a LBServerSslProfile. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_server_ssl_profile_id = 'lb_server_ssl_profile_id_example' # String | LBServerSslProfile ID


begin
  #Read LBServerSslProfile
  result = api_instance.read_lb_server_ssl_profile(lb_server_ssl_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_server_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_server_ssl_profile_id** | **String**| LBServerSslProfile ID | 

### Return type

[**LBServerSslProfile**](LBServerSslProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_service**
> LBService read_lb_service(lb_service_id)

Read LBService

Read an LBService. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_service_id = 'lb_service_id_example' # String | LBService ID


begin
  #Read LBService
  result = api_instance.read_lb_service(lb_service_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService ID | 

### Return type

[**LBService**](LBService.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_lb_virtual_server**
> LBVirtualServer read_lb_virtual_server(lb_virtual_server_id)

Read LBVirtualServer

Read a LBVirtualServer. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_virtual_server_id = 'lb_virtual_server_id_example' # String | LBVirtualServer ID


begin
  #Read LBVirtualServer
  result = api_instance.read_lb_virtual_server(lb_virtual_server_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->read_lb_virtual_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_virtual_server_id** | **String**| LBVirtualServer ID | 

### Return type

[**LBVirtualServer**](LBVirtualServer.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_app_profile**
> LBAppProfile update_lb_app_profile(lb_app_profile_id, lb_app_profile)

Create or update a LBAppProfile

If a LBAppProfile with the lb-app-profile-id is not already present, create a new LBAppProfile. If it already exists, update the LBAppProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_app_profile_id = 'lb_app_profile_id_example' # String | LBAppProfile ID

lb_app_profile = SwaggerClient::LBAppProfile.new # LBAppProfile | 


begin
  #Create or update a LBAppProfile
  result = api_instance.update_lb_app_profile(lb_app_profile_id, lb_app_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_app_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_app_profile_id** | **String**| LBAppProfile ID | 
 **lb_app_profile** | [**LBAppProfile**](LBAppProfile.md)|  | 

### Return type

[**LBAppProfile**](LBAppProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_client_ssl_profile**
> LBClientSslProfile update_lb_client_ssl_profile(lb_client_ssl_profile_id, lb_client_ssl_profile)

Create or update a LBClientSslProfile

If a LBClientSslProfile with the lb-client-ssl-profile-id is not already present, create a new LBClientSslProfile. If it already exists, update the LBClientSslProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_client_ssl_profile_id = 'lb_client_ssl_profile_id_example' # String | LBClientSslProfile ID

lb_client_ssl_profile = SwaggerClient::LBClientSslProfile.new # LBClientSslProfile | 


begin
  #Create or update a LBClientSslProfile
  result = api_instance.update_lb_client_ssl_profile(lb_client_ssl_profile_id, lb_client_ssl_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_client_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_client_ssl_profile_id** | **String**| LBClientSslProfile ID | 
 **lb_client_ssl_profile** | [**LBClientSslProfile**](LBClientSslProfile.md)|  | 

### Return type

[**LBClientSslProfile**](LBClientSslProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_monitor_profile**
> LBMonitorProfile update_lb_monitor_profile(lb_monitor_profile_id, lb_monitor_profile)

Create or update a LBMonitorProfile

If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_monitor_profile_id = 'lb_monitor_profile_id_example' # String | LBMonitorProfile ID

lb_monitor_profile = SwaggerClient::LBMonitorProfile.new # LBMonitorProfile | 


begin
  #Create or update a LBMonitorProfile
  result = api_instance.update_lb_monitor_profile(lb_monitor_profile_id, lb_monitor_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_monitor_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_monitor_profile_id** | **String**| LBMonitorProfile ID | 
 **lb_monitor_profile** | [**LBMonitorProfile**](LBMonitorProfile.md)|  | 

### Return type

[**LBMonitorProfile**](LBMonitorProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_persistence_profile**
> LBPersistenceProfile update_lb_persistence_profile(lb_persistence_profile_id, lb_persistence_profile)

Create or update a LBPersistenceProfile

If a LBPersistenceProfile with the lb-persistence-profile-id is not already present, create a new LBPersistenceProfile. If it already exists, update the LBPersistenceProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_persistence_profile_id = 'lb_persistence_profile_id_example' # String | LBPersistenceProfile ID

lb_persistence_profile = SwaggerClient::LBPersistenceProfile.new # LBPersistenceProfile | 


begin
  #Create or update a LBPersistenceProfile
  result = api_instance.update_lb_persistence_profile(lb_persistence_profile_id, lb_persistence_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_persistence_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_persistence_profile_id** | **String**| LBPersistenceProfile ID | 
 **lb_persistence_profile** | [**LBPersistenceProfile**](LBPersistenceProfile.md)|  | 

### Return type

[**LBPersistenceProfile**](LBPersistenceProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_pool**
> LBPool update_lb_pool(lb_pool_id, lb_pool)

Create or update a LBPool

If a LBPool with the lb-pool-id is not already present, create a new LBPool. If it already exists, update the LBPool. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_pool_id = 'lb_pool_id_example' # String | LBPool ID

lb_pool = SwaggerClient::LBPool.new # LBPool | 


begin
  #Create or update a LBPool
  result = api_instance.update_lb_pool(lb_pool_id, lb_pool)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_pool_id** | **String**| LBPool ID | 
 **lb_pool** | [**LBPool**](LBPool.md)|  | 

### Return type

[**LBPool**](LBPool.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_server_ssl_profile**
> LBServerSslProfile update_lb_server_ssl_profile(lb_server_ssl_profile_id, lb_server_ssl_profile)

Create or update a LBServerSslProfile

If a LBServerSslProfile with the lb-server-ssl-profile-id is not already present, create a new LBServerSslProfile. If it already exists, update the LBServerSslProfile. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_server_ssl_profile_id = 'lb_server_ssl_profile_id_example' # String | LBServerSslProfile ID

lb_server_ssl_profile = SwaggerClient::LBServerSslProfile.new # LBServerSslProfile | 


begin
  #Create or update a LBServerSslProfile
  result = api_instance.update_lb_server_ssl_profile(lb_server_ssl_profile_id, lb_server_ssl_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_server_ssl_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_server_ssl_profile_id** | **String**| LBServerSslProfile ID | 
 **lb_server_ssl_profile** | [**LBServerSslProfile**](LBServerSslProfile.md)|  | 

### Return type

[**LBServerSslProfile**](LBServerSslProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_service**
> LBService update_lb_service(lb_service_id, lb_service)

Create or update a LBService

If a LBService with the lb-service-id is not already present, create a new LBService. If it already exists, update the LBService. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_service_id = 'lb_service_id_example' # String | LBService ID

lb_service = SwaggerClient::LBService.new # LBService | 


begin
  #Create or update a LBService
  result = api_instance.update_lb_service(lb_service_id, lb_service)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_service_id** | **String**| LBService ID | 
 **lb_service** | [**LBService**](LBService.md)|  | 

### Return type

[**LBService**](LBService.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_lb_virtual_server**
> LBVirtualServer update_lb_virtual_server(lb_virtual_server_id, lb_virtual_server)

Create or update a LBVirtualServer

If a LBVirtualServer with the lb-virtual-server-id is not already present, create a new LBVirtualServer. If it already exists, update the LBVirtualServer. This is a full replace. 

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

api_instance = SwaggerClient::PolicyLoadbalancerApi.new

lb_virtual_server_id = 'lb_virtual_server_id_example' # String | LBVirtualServer ID

lb_virtual_server = SwaggerClient::LBVirtualServer.new # LBVirtualServer | 


begin
  #Create or update a LBVirtualServer
  result = api_instance.update_lb_virtual_server(lb_virtual_server_id, lb_virtual_server)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyLoadbalancerApi->update_lb_virtual_server: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lb_virtual_server_id** | **String**| LBVirtualServer ID | 
 **lb_virtual_server** | [**LBVirtualServer**](LBVirtualServer.md)|  | 

### Return type

[**LBVirtualServer**](LBVirtualServer.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



