# SwaggerClient::DashboardApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_view**](DashboardApi.md#create_view) | **POST** /ui-views | Creates a new View.
[**create_widget_configuration**](DashboardApi.md#create_widget_configuration) | **POST** /ui-views/{view-id}/widgetconfigurations | Creates a new Widget Configuration.
[**delet_view**](DashboardApi.md#delet_view) | **DELETE** /ui-views/{view-id} | Delete View
[**delete_widget_configuration**](DashboardApi.md#delete_widget_configuration) | **DELETE** /ui-views/{view-id}/widgetconfigurations/{widgetconfiguration-id} | Delete Widget Configuration
[**get_view**](DashboardApi.md#get_view) | **GET** /ui-views/{view-id} | Returns View Information
[**get_widget_configuration**](DashboardApi.md#get_widget_configuration) | **GET** /ui-views/{view-id}/widgetconfigurations/{widgetconfiguration-id} | Returns Widget Configuration Information
[**list_views**](DashboardApi.md#list_views) | **GET** /ui-views | Returns the Views based on query criteria defined in ViewQueryParameters.
[**list_widget_configurations**](DashboardApi.md#list_widget_configurations) | **GET** /ui-views/{view-id}/widgetconfigurations | Returns the Widget Configurations based on query criteria defined in WidgetQueryParameters.
[**update_view**](DashboardApi.md#update_view) | **PUT** /ui-views/{view-id} | Update View
[**update_widget_configuration**](DashboardApi.md#update_widget_configuration) | **PUT** /ui-views/{view-id}/widgetconfigurations/{widgetconfiguration-id} | Update Widget Configuration


# **create_view**
> View create_view(view)

Creates a new View.

Creates a new View.

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

api_instance = SwaggerClient::DashboardApi.new

view = SwaggerClient::View.new # View | 


begin
  #Creates a new View.
  result = api_instance.create_view(view)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->create_view: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view** | [**View**](View.md)|  | 

### Return type

[**View**](View.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_widget_configuration**
> WidgetConfiguration create_widget_configuration(view_id, widget_configuration)

Creates a new Widget Configuration.

Creates a new Widget Configuration and adds it to the specified view. Supported resource_types are LabelValueConfiguration, DonutConfiguration, GridConfiguration, StatsConfiguration, MultiWidgetConfiguration, GraphConfiguration and ContainerConfiguration.  Note: Expressions should be given in a single line. If an expression spans   multiple lines, then form the expression in a single line. For label-value pairs, expressions are evaluated as follows:   a. First, render configurations are evaluated in their order of      appearance in the widget config. The 'field' is evaluated at the end.   b. Second, when render configuration is provided then the order of      evaluation is      1. If expressions provided in 'condition' and 'display value' are         well-formed and free of runtime-errors such as 'null pointers' and         evaluates to 'true'; Then remaining render configurations are not         evaluated, and the current render configuration's 'display value'         is taken as the final value.      2. If expression provided in 'condition' of render configuration is         false, then next render configuration is evaluated.      3. Finally, 'field' is evaluated only when every render configuration         evaluates to false and no error occurs during steps 1 and 2 above.  If an error occurs during evaluation of render configuration, then an   error message is shown. The display value corresponding to that label is   not shown and evaluation of the remaining render configurations continues   to collect and show all the error messages (marked with the 'Label' for   identification) as 'Error_Messages: {}'.  If during evaluation of expressions for any label-value pair an error   occurs, then it is marked with error. The errors are shown in the report,   along with the label value pairs that are error-free.  Important: For elements that take expressions, strings should be provided   by escaping them with a back-slash. These elements are - condition, field,   tooltip text and render_configuration's display_value. 

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 

widget_configuration = SwaggerClient::WidgetConfiguration.new # WidgetConfiguration | 


begin
  #Creates a new Widget Configuration.
  result = api_instance.create_widget_configuration(view_id, widget_configuration)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->create_widget_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 
 **widget_configuration** | [**WidgetConfiguration**](WidgetConfiguration.md)|  | 

### Return type

[**WidgetConfiguration**](WidgetConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delet_view**
> delet_view(view_id)

Delete View

Delete View

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 


begin
  #Delete View
  api_instance.delet_view(view_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->delet_view: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_widget_configuration**
> delete_widget_configuration(view_id, widgetconfiguration_id)

Delete Widget Configuration

Detaches widget from a given view. If the widget is no longer part of any view, then it will be purged. 

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 

widgetconfiguration_id = 'widgetconfiguration_id_example' # String | 


begin
  #Delete Widget Configuration
  api_instance.delete_widget_configuration(view_id, widgetconfiguration_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->delete_widget_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 
 **widgetconfiguration_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_view**
> View get_view(view_id)

Returns View Information

Returns Information about a specific View. 

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 


begin
  #Returns View Information
  result = api_instance.get_view(view_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->get_view: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 

### Return type

[**View**](View.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_widget_configuration**
> WidgetConfiguration get_widget_configuration(view_id, widgetconfiguration_id)

Returns Widget Configuration Information

Returns Information about a specific Widget Configuration. 

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 

widgetconfiguration_id = 'widgetconfiguration_id_example' # String | 


begin
  #Returns Widget Configuration Information
  result = api_instance.get_widget_configuration(view_id, widgetconfiguration_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->get_widget_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 
 **widgetconfiguration_id** | **String**|  | 

### Return type

[**WidgetConfiguration**](WidgetConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_views**
> ViewList list_views(opts)

Returns the Views based on query criteria defined in ViewQueryParameters.

If no query params are specified then all the views entitled for the user are returned. The views to which a user is entitled to include the views created by the user and the shared views. 

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

api_instance = SwaggerClient::DashboardApi.new

opts = { 
  tag: 'tag_example', # String | The tag for which associated views to be queried.
  view_ids: 'view_ids_example', # String | Ids of the Views
  widget_id: 'widget_id_example' # String | Id of widget configuration
}

begin
  #Returns the Views based on query criteria defined in ViewQueryParameters.
  result = api_instance.list_views(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->list_views: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tag** | **String**| The tag for which associated views to be queried. | [optional] 
 **view_ids** | **String**| Ids of the Views | [optional] 
 **widget_id** | **String**| Id of widget configuration | [optional] 

### Return type

[**ViewList**](ViewList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_widget_configurations**
> WidgetConfigurationList list_widget_configurations(view_id, opts)

Returns the Widget Configurations based on query criteria defined in WidgetQueryParameters.

If no query params are specified then all the Widget Configurations of the specified view are returned. 

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 

opts = { 
  container: 'container_example', # String | Id of the container
  widget_ids: 'widget_ids_example' # String | Ids of the WidgetConfigurations
}

begin
  #Returns the Widget Configurations based on query criteria defined in WidgetQueryParameters.
  result = api_instance.list_widget_configurations(view_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->list_widget_configurations: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 
 **container** | **String**| Id of the container | [optional] 
 **widget_ids** | **String**| Ids of the WidgetConfigurations | [optional] 

### Return type

[**WidgetConfigurationList**](WidgetConfigurationList.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_view**
> View update_view(view_id, view)

Update View

Update View

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 

view = SwaggerClient::View.new # View | 


begin
  #Update View
  result = api_instance.update_view(view_id, view)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->update_view: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 
 **view** | [**View**](View.md)|  | 

### Return type

[**View**](View.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_widget_configuration**
> WidgetConfiguration update_widget_configuration(view_id, widgetconfiguration_id, widget_configuration)

Update Widget Configuration

Updates the widget at the given view. If the widget is referenced by other views, then the widget will be updated in all the views that it is part of. 

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

api_instance = SwaggerClient::DashboardApi.new

view_id = 'view_id_example' # String | 

widgetconfiguration_id = 'widgetconfiguration_id_example' # String | 

widget_configuration = SwaggerClient::WidgetConfiguration.new # WidgetConfiguration | 


begin
  #Update Widget Configuration
  result = api_instance.update_widget_configuration(view_id, widgetconfiguration_id, widget_configuration)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DashboardApi->update_widget_configuration: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view_id** | **String**|  | 
 **widgetconfiguration_id** | **String**|  | 
 **widget_configuration** | [**WidgetConfiguration**](WidgetConfiguration.md)|  | 

### Return type

[**WidgetConfiguration**](WidgetConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



