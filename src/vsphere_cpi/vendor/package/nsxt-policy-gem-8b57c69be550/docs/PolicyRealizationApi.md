# SwaggerClient::PolicyRealizationApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**list_alarms**](PolicyRealizationApi.md#list_alarms) | **GET** /infra/realized-state/alarms | List All alarms in the system
[**list_enforcement_point_realized_states**](PolicyRealizationApi.md#list_enforcement_point_realized_states) | **GET** /infra/realized-state/enforcement-points | List Enforcement Points
[**list_firewall_section_realized_states**](PolicyRealizationApi.md#list_firewall_section_realized_states) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/firewalls/firewall-sections | List Firewall Sections
[**list_ip_set_realized_states**](PolicyRealizationApi.md#list_ip_set_realized_states) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/ip-sets/ip-sets-nsxt | List IPSets
[**list_mac_set_realized_states**](PolicyRealizationApi.md#list_mac_set_realized_states) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/mac-sets/mac-sets-nsxt | List MACSets
[**list_ns_group_realized_states**](PolicyRealizationApi.md#list_ns_group_realized_states) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/groups/nsgroups | List NS Groups
[**list_ns_service_realized_states**](PolicyRealizationApi.md#list_ns_service_realized_states) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/services/nsservices | List Realized NSServices
[**list_realized_entities**](PolicyRealizationApi.md#list_realized_entities) | **GET** /infra/realized-state/realized-entities | Get list of realized objects associated with intent object
[**list_security_group_realized_states**](PolicyRealizationApi.md#list_security_group_realized_states) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/groups/securitygroups | List Security Groups
[**list_vifs_on_enforcement_point**](PolicyRealizationApi.md#list_vifs_on_enforcement_point) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/vifs | Listing of VIFs on the NSX Manager
[**list_virtual_machines_on_enforcement_point**](PolicyRealizationApi.md#list_virtual_machines_on_enforcement_point) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/virtual-machines | Listing of Virtual machines on the NSX Manager
[**read_enforcement_point_realized_state**](PolicyRealizationApi.md#read_enforcement_point_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name} | Read Enforcement Point
[**read_firewall_section_realized_state**](PolicyRealizationApi.md#read_firewall_section_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/firewalls/firewall-sections/{firewall-section-id} | Read Firewall
[**read_intent_status**](PolicyRealizationApi.md#read_intent_status) | **GET** /infra/realized-state/status | Get consolidated status for intent object
[**read_ip_set_realized_state**](PolicyRealizationApi.md#read_ip_set_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/ip-sets/ip-sets-nsxt/{ip-set-name} | Read IPSet Realized state
[**read_mac_set_realized_state**](PolicyRealizationApi.md#read_mac_set_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/mac-sets/mac-sets-nsxt/{mac-set-name} | Read MACSet Realized state
[**read_ns_group_realized_state**](PolicyRealizationApi.md#read_ns_group_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/groups/nsgroups/{nsgroup-name} | Read Group
[**read_ns_service_realized_state**](PolicyRealizationApi.md#read_ns_service_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/services/nsservices/{nsservice-name} | Read NSService
[**read_realized_entity**](PolicyRealizationApi.md#read_realized_entity) | **GET** /infra/realized-state/realized-entity | Get realized entity uniquely identified by realized path
[**read_security_group_realized_state**](PolicyRealizationApi.md#read_security_group_realized_state) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/groups/securitygroups/{securitygroup-name} | Read Group
[**read_virtual_machine_details**](PolicyRealizationApi.md#read_virtual_machine_details) | **GET** /infra/realized-state/enforcement-points/{enforcement-point-name}/virtual-machines/{virtual-machine-id}/details | Read the details of a virtual machine on the NSX Manager
[**refresh_realized_state_refresh**](PolicyRealizationApi.md#refresh_realized_state_refresh) | **POST** /infra/realized-state/realized-entity?action&#x3D;refresh | Refresh all realized entities associated with the intent-path
[**tag_virtual_machine_update_tags**](PolicyRealizationApi.md#tag_virtual_machine_update_tags) | **POST** /infra/realized-state/enforcement-points/{enforcement-point-name}/virtual-machines?action&#x3D;update_tags | Apply tags on virtual machine


# **list_alarms**
> PolicyAlarmResourceListResult list_alarms(opts)

List All alarms in the system

Paginated list of all alarms. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List All alarms in the system
  result = api_instance.list_alarms(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_alarms: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyAlarmResourceListResult**](PolicyAlarmResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_enforcement_point_realized_states**
> RealizedEnforcementPointListResult list_enforcement_point_realized_states(opts)

List Enforcement Points

Paginated list of all enforcement points. Returns the populated enforcement points. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Enforcement Points
  result = api_instance.list_enforcement_point_realized_states(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_enforcement_point_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RealizedEnforcementPointListResult**](RealizedEnforcementPointListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_firewall_section_realized_states**
> RealizedFirewallSectionListResult list_firewall_section_realized_states(enforcement_point_name, opts)

List Firewall Sections

Paginated list of all Firewalls. Returns populated Firewalls. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Firewall Sections
  result = api_instance.list_firewall_section_realized_states(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_firewall_section_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RealizedFirewallSectionListResult**](RealizedFirewallSectionListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_set_realized_states**
> GenericPolicyRealizedResourceListResult list_ip_set_realized_states(enforcement_point_name, opts)

List IPSets

Paginated list of all Realized IPSets 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IPSets
  result = api_instance.list_ip_set_realized_states(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_ip_set_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GenericPolicyRealizedResourceListResult**](GenericPolicyRealizedResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_mac_set_realized_states**
> GenericPolicyRealizedResourceListResult list_mac_set_realized_states(enforcement_point_name, opts)

List MACSets

Paginated list of all Realized MACSets 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List MACSets
  result = api_instance.list_mac_set_realized_states(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_mac_set_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GenericPolicyRealizedResourceListResult**](GenericPolicyRealizedResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ns_group_realized_states**
> GenericPolicyRealizedResourceListResult list_ns_group_realized_states(enforcement_point_name, opts)

List NS Groups

Paginated list of all NSGroups. Returns populated NSGroups. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List NS Groups
  result = api_instance.list_ns_group_realized_states(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_ns_group_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GenericPolicyRealizedResourceListResult**](GenericPolicyRealizedResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ns_service_realized_states**
> GenericPolicyRealizedResourceListResult list_ns_service_realized_states(enforcement_point_name, opts)

List Realized NSServices

Paginated list of all Realized NSService. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Realized NSServices
  result = api_instance.list_ns_service_realized_states(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_ns_service_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**GenericPolicyRealizedResourceListResult**](GenericPolicyRealizedResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_realized_entities**
> GenericPolicyRealizedResourceListResult list_realized_entities(intent_path)

Get list of realized objects associated with intent object

Get list of realized entities associated with intent object, specified by path in query parameter 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

intent_path = 'intent_path_example' # String | String Path of the intent object


begin
  #Get list of realized objects associated with intent object
  result = api_instance.list_realized_entities(intent_path)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_realized_entities: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **intent_path** | **String**| String Path of the intent object | 

### Return type

[**GenericPolicyRealizedResourceListResult**](GenericPolicyRealizedResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_security_group_realized_states**
> RealizedSecurityGroupListResult list_security_group_realized_states(enforcement_point_name, opts)

List Security Groups

Paginated list of all Security Groups. Returns populated Security Groups. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Security Groups
  result = api_instance.list_security_group_realized_states(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_security_group_realized_states: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RealizedSecurityGroupListResult**](RealizedSecurityGroupListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_vifs_on_enforcement_point**
> VirtualNetworkInterfaceListResult list_vifs_on_enforcement_point(enforcement_point_name, opts)

Listing of VIFs on the NSX Manager

This API lists VIFs from the specified NSX Manager. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  lport_attachment_id: 'lport_attachment_id_example', # String | LPort attachment ID of the VIF.
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Listing of VIFs on the NSX Manager
  result = api_instance.list_vifs_on_enforcement_point(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_vifs_on_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **lport_attachment_id** | **String**| LPort attachment ID of the VIF. | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**VirtualNetworkInterfaceListResult**](VirtualNetworkInterfaceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_virtual_machines_on_enforcement_point**
> SearchResponse list_virtual_machines_on_enforcement_point(enforcement_point_name, opts)

Listing of Virtual machines on the NSX Manager

This API filters objects of type virtual machines from the specified NSX Manager. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  dsl: 'dsl_example', # String | Search DSL (domain specific language) query
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  query: 'query_example', # String | Search query
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Listing of Virtual machines on the NSX Manager
  result = api_instance.list_virtual_machines_on_enforcement_point(enforcement_point_name, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->list_virtual_machines_on_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **dsl** | **String**| Search DSL (domain specific language) query | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **query** | **String**| Search query | [optional] 
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**SearchResponse**](SearchResponse.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_enforcement_point_realized_state**
> RealizedEnforcementPoint read_enforcement_point_realized_state(enforcement_point_name)

Read Enforcement Point

Read a Enforcement Point and the complete tree underneath. Returns the populated enforcement point object. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name


begin
  #Read Enforcement Point
  result = api_instance.read_enforcement_point_realized_state(enforcement_point_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_enforcement_point_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 

### Return type

[**RealizedEnforcementPoint**](RealizedEnforcementPoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_firewall_section_realized_state**
> RealizedFirewallSection read_firewall_section_realized_state(enforcement_point_name, firewall_section_id)

Read Firewall

Read a Firewall and the complete tree underneath. Returns the populated Firewall object. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

firewall_section_id = 'firewall_section_id_example' # String | Firewall Section Id


begin
  #Read Firewall
  result = api_instance.read_firewall_section_realized_state(enforcement_point_name, firewall_section_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_firewall_section_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **firewall_section_id** | **String**| Firewall Section Id | 

### Return type

[**RealizedFirewallSection**](RealizedFirewallSection.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_intent_status**
> ConsolidatedRealizedStatus read_intent_status(intent_path)

Get consolidated status for intent object

Get consolidated status of an intent object, specified by path in query parameter 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

intent_path = 'intent_path_example' # String | String Path of the intent object


begin
  #Get consolidated status for intent object
  result = api_instance.read_intent_status(intent_path)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_intent_status: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **intent_path** | **String**| String Path of the intent object | 

### Return type

[**ConsolidatedRealizedStatus**](ConsolidatedRealizedStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ip_set_realized_state**
> GenericPolicyRealizedResource read_ip_set_realized_state(enforcement_point_name, ip_set_name)

Read IPSet Realized state

Read an IPSet 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

ip_set_name = 'ip_set_name_example' # String | IPSet name


begin
  #Read IPSet Realized state
  result = api_instance.read_ip_set_realized_state(enforcement_point_name, ip_set_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_ip_set_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **ip_set_name** | **String**| IPSet name | 

### Return type

[**GenericPolicyRealizedResource**](GenericPolicyRealizedResource.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_mac_set_realized_state**
> GenericPolicyRealizedResource read_mac_set_realized_state(enforcement_point_name, mac_set_name)

Read MACSet Realized state

Read an MACSet 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

mac_set_name = 'mac_set_name_example' # String | MACSet name


begin
  #Read MACSet Realized state
  result = api_instance.read_mac_set_realized_state(enforcement_point_name, mac_set_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_mac_set_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **mac_set_name** | **String**| MACSet name | 

### Return type

[**GenericPolicyRealizedResource**](GenericPolicyRealizedResource.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ns_group_realized_state**
> GenericPolicyRealizedResource read_ns_group_realized_state(enforcement_point_name, nsgroup_name)

Read Group

Read a NSGroup and the complete tree underneath. Returns the populated NSgroup object. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

nsgroup_name = 'nsgroup_name_example' # String | Group Name


begin
  #Read Group
  result = api_instance.read_ns_group_realized_state(enforcement_point_name, nsgroup_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_ns_group_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **nsgroup_name** | **String**| Group Name | 

### Return type

[**GenericPolicyRealizedResource**](GenericPolicyRealizedResource.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ns_service_realized_state**
> GenericPolicyRealizedResource read_ns_service_realized_state(enforcement_point_name, nsservice_name)

Read NSService

Read a NSService. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

nsservice_name = 'nsservice_name_example' # String | NSService Name


begin
  #Read NSService
  result = api_instance.read_ns_service_realized_state(enforcement_point_name, nsservice_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_ns_service_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **nsservice_name** | **String**| NSService Name | 

### Return type

[**GenericPolicyRealizedResource**](GenericPolicyRealizedResource.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_realized_entity**
> GenericPolicyRealizedResource read_realized_entity(realized_path)

Get realized entity uniquely identified by realized path

Get realized entity uniquely identified by realized path, specified by query parameter 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

realized_path = 'realized_path_example' # String | String Path of the realized object


begin
  #Get realized entity uniquely identified by realized path
  result = api_instance.read_realized_entity(realized_path)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_realized_entity: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **realized_path** | **String**| String Path of the realized object | 

### Return type

[**GenericPolicyRealizedResource**](GenericPolicyRealizedResource.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_security_group_realized_state**
> RealizedSecurityGroup read_security_group_realized_state(enforcement_point_name, securitygroup_name)

Read Group

Read a Security Group and the complete tree underneath. Returns the populated Security Group object. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | Enforcement Point Name

securitygroup_name = 'securitygroup_name_example' # String | Group Name


begin
  #Read Group
  result = api_instance.read_security_group_realized_state(enforcement_point_name, securitygroup_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_security_group_realized_state: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**| Enforcement Point Name | 
 **securitygroup_name** | **String**| Group Name | 

### Return type

[**RealizedSecurityGroup**](RealizedSecurityGroup.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_virtual_machine_details**
> VirtualMachineDetails read_virtual_machine_details(enforcement_point_name, virtual_machine_id)

Read the details of a virtual machine on the NSX Manager

This API return optional details about a virtual machines (e.g. user login session) from the specified enforcement point. In case of NSXT, virtual-machine-id would be the value of the external_id of the virtual machine. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | 

virtual_machine_id = 'virtual_machine_id_example' # String | 


begin
  #Read the details of a virtual machine on the NSX Manager
  result = api_instance.read_virtual_machine_details(enforcement_point_name, virtual_machine_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->read_virtual_machine_details: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**|  | 
 **virtual_machine_id** | **String**|  | 

### Return type

[**VirtualMachineDetails**](VirtualMachineDetails.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **refresh_realized_state_refresh**
> refresh_realized_state_refresh(intent_path, opts)

Refresh all realized entities associated with the intent-path

Refresh the status and statistics of all realized entities associated with given intent path synchronously. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

intent_path = 'intent_path_example' # String | String Path of the intent object

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Refresh all realized entities associated with the intent-path
  api_instance.refresh_realized_state_refresh(intent_path, opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->refresh_realized_state_refresh: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **intent_path** | **String**| String Path of the intent object | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **tag_virtual_machine_update_tags**
> tag_virtual_machine_update_tags(enforcement_point_name, virtual_machine_tags_update)

Apply tags on virtual machine

Allows an admin to apply multiple tags to a virtual machine. This operation does not store the intent on the policy side. It applies the tag directly on the specified enforcement point. This operation will replace the existing tags on the virtual machine with the ones that have been passed. If the application of tag fails on the enforcement point, then an error is reported. The admin will have to retry the operation again. Policy framework does not perform a retry. Failure could occur due to multiple reasons. For e.g enforcement point is down, Enforcement point could not apply the tag due to constraints like max tags limit exceeded, etc. 

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

api_instance = SwaggerClient::PolicyRealizationApi.new

enforcement_point_name = 'enforcement_point_name_example' # String | 

virtual_machine_tags_update = SwaggerClient::VirtualMachineTagsUpdate.new # VirtualMachineTagsUpdate | 


begin
  #Apply tags on virtual machine
  api_instance.tag_virtual_machine_update_tags(enforcement_point_name, virtual_machine_tags_update)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyRealizationApi->tag_virtual_machine_update_tags: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_name** | **String**|  | 
 **virtual_machine_tags_update** | [**VirtualMachineTagsUpdate**](VirtualMachineTagsUpdate.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



