# SwaggerClient::AaaApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_registration_token**](AaaApi.md#create_registration_token) | **POST** /aaa/registration-token | Create registration access token
[**create_role_binding**](AaaApi.md#create_role_binding) | **POST** /aaa/role-bindings | Assign roles to User or Group
[**delete_all_stale_role_bindings_delete_stale_bindings**](AaaApi.md#delete_all_stale_role_bindings_delete_stale_bindings) | **POST** /aaa/role-bindings?action&#x3D;delete_stale_bindings | Delete all stale role assignments
[**delete_object_permissions**](AaaApi.md#delete_object_permissions) | **DELETE** /aaa/object-permissions | Delete object-permissions entries
[**delete_registration_token**](AaaApi.md#delete_registration_token) | **DELETE** /aaa/registration-token/{token} | Delete registration access token
[**delete_role_binding**](AaaApi.md#delete_role_binding) | **DELETE** /aaa/role-bindings/{binding-id} | Delete user/group&#39;s roles assignment
[**get_all_role_bindings**](AaaApi.md#get_all_role_bindings) | **GET** /aaa/role-bindings | Get all users and groups with their roles
[**get_all_roles_info**](AaaApi.md#get_all_roles_info) | **GET** /aaa/roles | Get information about all roles
[**get_current_user_info**](AaaApi.md#get_current_user_info) | **GET** /aaa/user-info | Get information about logged-in user. The permissions parameter of the NsxRole has been deprecated.
[**get_group_vidm_search_result**](AaaApi.md#get_group_vidm_search_result) | **GET** /aaa/vidm/groups | Get all the User Groups where vIDM display name matches the search key case insensitively. The search key is checked to be a substring of display name. This is a non paginated API.
[**get_object_permissions**](AaaApi.md#get_object_permissions) | **GET** /aaa/object-permissions | Get list of Object-level RBAC entries.
[**get_path_permissions**](AaaApi.md#get_path_permissions) | **GET** /aaa/effective-permissions | Get effective object permissions to object specified by path for current user.
[**get_registration_token**](AaaApi.md#get_registration_token) | **GET** /aaa/registration-token/{token} | Get registration access token
[**get_role_binding**](AaaApi.md#get_role_binding) | **GET** /aaa/role-bindings/{binding-id} | Get user/group&#39;s role information
[**get_role_info**](AaaApi.md#get_role_info) | **GET** /aaa/roles/{role} | Get role information
[**get_user_vidm_search_result**](AaaApi.md#get_user_vidm_search_result) | **GET** /aaa/vidm/users | Get all the users from vIDM whose userName, givenName or familyName matches the search key case insensitively. The search key is checked to be a substring of name or given name or family name. This is a non paginated API.
[**get_vidm_search_result**](AaaApi.md#get_vidm_search_result) | **POST** /aaa/vidm/search | Get all the users and groups from vIDM matching the search key case insensitively. The search key is checked to be a substring of name or given name or family name of user and display name of group. This is a non paginated API.
[**update_object_permissions**](AaaApi.md#update_object_permissions) | **PATCH** /aaa/object-permissions | Create/update object permission mappings
[**update_role_binding**](AaaApi.md#update_role_binding) | **PUT** /aaa/role-bindings/{binding-id} | Update User or Group&#39;s roles


# **create_registration_token**
> RegistrationToken create_registration_token

Create registration access token

The privileges of the registration token will be the same as the caller.

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

api_instance = SwaggerClient::AaaApi.new

begin
  #Create registration access token
  result = api_instance.create_registration_token
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->create_registration_token: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RegistrationToken**](RegistrationToken.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_role_binding**
> RoleBinding create_role_binding(role_binding)

Assign roles to User or Group

When assigning a user role, specify the user name with the same case as it appears in vIDM to access the NSX-T user interface. For example, if vIDM has the user name User1@example.com then the name attribute in the API call must be be User1@example.com and cannot be user1@example.com. 

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

api_instance = SwaggerClient::AaaApi.new

role_binding = SwaggerClient::RoleBinding.new # RoleBinding | 


begin
  #Assign roles to User or Group
  result = api_instance.create_role_binding(role_binding)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->create_role_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role_binding** | [**RoleBinding**](RoleBinding.md)|  | 

### Return type

[**RoleBinding**](RoleBinding.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_all_stale_role_bindings_delete_stale_bindings**
> delete_all_stale_role_bindings_delete_stale_bindings

Delete all stale role assignments

Delete all stale role assignments

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

api_instance = SwaggerClient::AaaApi.new

begin
  #Delete all stale role assignments
  api_instance.delete_all_stale_role_bindings_delete_stale_bindings
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->delete_all_stale_role_bindings_delete_stale_bindings: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_object_permissions**
> delete_object_permissions(opts)

Delete object-permissions entries

Delete object-permissions entries

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

api_instance = SwaggerClient::AaaApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  path_prefix: 'path_prefix_example', # String | Path prefix
  role_name: 'role_name_example', # String | Role name
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Delete object-permissions entries
  api_instance.delete_object_permissions(opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->delete_object_permissions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **path_prefix** | **String**| Path prefix | [optional] 
 **role_name** | **String**| Role name | [optional] 
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_registration_token**
> delete_registration_token(token)

Delete registration access token

Delete registration access token

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

api_instance = SwaggerClient::AaaApi.new

token = 'token_example' # String | Registration token


begin
  #Delete registration access token
  api_instance.delete_registration_token(token)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->delete_registration_token: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**| Registration token | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_role_binding**
> delete_role_binding(binding_id)

Delete user/group's roles assignment

Delete user/group's roles assignment

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

api_instance = SwaggerClient::AaaApi.new

binding_id = 'binding_id_example' # String | User/Group's id


begin
  #Delete user/group's roles assignment
  api_instance.delete_role_binding(binding_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->delete_role_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **binding_id** | **String**| User/Group&#39;s id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_all_role_bindings**
> RoleBindingListResult get_all_role_bindings(opts)

Get all users and groups with their roles

Get all users and groups with their roles

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

api_instance = SwaggerClient::AaaApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  name: 'name_example', # String | User/Group name
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example', # String | Field by which records are sorted
  type: 'type_example' # String | Type
}

begin
  #Get all users and groups with their roles
  result = api_instance.get_all_role_bindings(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_all_role_bindings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **name** | **String**| User/Group name | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 
 **type** | **String**| Type | [optional] 

### Return type

[**RoleBindingListResult**](RoleBindingListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_all_roles_info**
> RoleListResult get_all_roles_info

Get information about all roles

Get information about all roles

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

api_instance = SwaggerClient::AaaApi.new

begin
  #Get information about all roles
  result = api_instance.get_all_roles_info
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_all_roles_info: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RoleListResult**](RoleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_current_user_info**
> UserInfo get_current_user_info

Get information about logged-in user. The permissions parameter of the NsxRole has been deprecated.

Get information about logged-in user. The permissions parameter of the NsxRole has been deprecated.

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

api_instance = SwaggerClient::AaaApi.new

begin
  #Get information about logged-in user. The permissions parameter of the NsxRole has been deprecated.
  result = api_instance.get_current_user_info
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_current_user_info: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserInfo**](UserInfo.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_group_vidm_search_result**
> VidmInfoListResult get_group_vidm_search_result(search_string, opts)

Get all the User Groups where vIDM display name matches the search key case insensitively. The search key is checked to be a substring of display name. This is a non paginated API.

Get all the User Groups where vIDM display name matches the search key case insensitively. The search key is checked to be a substring of display name. This is a non paginated API.

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

api_instance = SwaggerClient::AaaApi.new

search_string = 'search_string_example' # String | Search string to search for. 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get all the User Groups where vIDM display name matches the search key case insensitively. The search key is checked to be a substring of display name. This is a non paginated API.
  result = api_instance.get_group_vidm_search_result(search_string, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_group_vidm_search_result: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search_string** | **String**| Search string to search for.  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**VidmInfoListResult**](VidmInfoListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_object_permissions**
> ObjectRolePermissionGroupListResult get_object_permissions(opts)

Get list of Object-level RBAC entries.

Get list of Object-level RBAC entries.

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

api_instance = SwaggerClient::AaaApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  path_prefix: 'path_prefix_example', # String | Path prefix
  role_name: 'role_name_example', # String | Role name
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get list of Object-level RBAC entries.
  result = api_instance.get_object_permissions(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_object_permissions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **path_prefix** | **String**| Path prefix | [optional] 
 **role_name** | **String**| Role name | [optional] 
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ObjectRolePermissionGroupListResult**](ObjectRolePermissionGroupListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_path_permissions**
> PathPermissionGroup get_path_permissions(feature_name, object_path)

Get effective object permissions to object specified by path for current user.

Returns none if user doesn't have access or feature_name from required request parameter is empty/invalid/doesn't match with object-path provided. 

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

api_instance = SwaggerClient::AaaApi.new

feature_name = 'feature_name_example' # String | Feature name

object_path = 'object_path_example' # String | Exact object Policy path


begin
  #Get effective object permissions to object specified by path for current user.
  result = api_instance.get_path_permissions(feature_name, object_path)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_path_permissions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **feature_name** | **String**| Feature name | 
 **object_path** | **String**| Exact object Policy path | 

### Return type

[**PathPermissionGroup**](PathPermissionGroup.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_registration_token**
> RegistrationToken get_registration_token(token)

Get registration access token

Get registration access token

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

api_instance = SwaggerClient::AaaApi.new

token = 'token_example' # String | Registration token


begin
  #Get registration access token
  result = api_instance.get_registration_token(token)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_registration_token: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**| Registration token | 

### Return type

[**RegistrationToken**](RegistrationToken.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_role_binding**
> RoleBinding get_role_binding(binding_id)

Get user/group's role information

Get user/group's role information

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

api_instance = SwaggerClient::AaaApi.new

binding_id = 'binding_id_example' # String | User/Group's id


begin
  #Get user/group's role information
  result = api_instance.get_role_binding(binding_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_role_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **binding_id** | **String**| User/Group&#39;s id | 

### Return type

[**RoleBinding**](RoleBinding.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_role_info**
> RoleWithFeatures get_role_info(role)

Get role information

Get role information

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

api_instance = SwaggerClient::AaaApi.new

role = 'role_example' # String | Role Name


begin
  #Get role information
  result = api_instance.get_role_info(role)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_role_info: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **role** | **String**| Role Name | 

### Return type

[**RoleWithFeatures**](RoleWithFeatures.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_user_vidm_search_result**
> VidmInfoListResult get_user_vidm_search_result(search_string, opts)

Get all the users from vIDM whose userName, givenName or familyName matches the search key case insensitively. The search key is checked to be a substring of name or given name or family name. This is a non paginated API.

Get all the users from vIDM whose userName, givenName or familyName matches the search key case insensitively. The search key is checked to be a substring of name or given name or family name. This is a non paginated API.

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

api_instance = SwaggerClient::AaaApi.new

search_string = 'search_string_example' # String | Search string to search for. 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get all the users from vIDM whose userName, givenName or familyName matches the search key case insensitively. The search key is checked to be a substring of name or given name or family name. This is a non paginated API.
  result = api_instance.get_user_vidm_search_result(search_string, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_user_vidm_search_result: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search_string** | **String**| Search string to search for.  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**VidmInfoListResult**](VidmInfoListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_vidm_search_result**
> VidmInfoListResult get_vidm_search_result(search_string, opts)

Get all the users and groups from vIDM matching the search key case insensitively. The search key is checked to be a substring of name or given name or family name of user and display name of group. This is a non paginated API.

Get all the users and groups from vIDM matching the search key case insensitively. The search key is checked to be a substring of name or given name or family name of user and display name of group. This is a non paginated API.

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

api_instance = SwaggerClient::AaaApi.new

search_string = 'search_string_example' # String | Search string to search for. 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Get all the users and groups from vIDM matching the search key case insensitively. The search key is checked to be a substring of name or given name or family name of user and display name of group. This is a non paginated API.
  result = api_instance.get_vidm_search_result(search_string, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->get_vidm_search_result: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search_string** | **String**| Search string to search for.  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**VidmInfoListResult**](VidmInfoListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_object_permissions**
> update_object_permissions(object_role_permission_group)

Create/update object permission mappings

Create/update object permission mappings

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

api_instance = SwaggerClient::AaaApi.new

object_role_permission_group = SwaggerClient::ObjectRolePermissionGroup.new # ObjectRolePermissionGroup | 


begin
  #Create/update object permission mappings
  api_instance.update_object_permissions(object_role_permission_group)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->update_object_permissions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **object_role_permission_group** | [**ObjectRolePermissionGroup**](ObjectRolePermissionGroup.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_role_binding**
> RoleBinding update_role_binding(binding_id, role_binding)

Update User or Group's roles

Update User or Group's roles

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

api_instance = SwaggerClient::AaaApi.new

binding_id = 'binding_id_example' # String | User/Group's id

role_binding = SwaggerClient::RoleBinding.new # RoleBinding | 


begin
  #Update User or Group's roles
  result = api_instance.update_role_binding(binding_id, role_binding)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AaaApi->update_role_binding: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **binding_id** | **String**| User/Group&#39;s id | 
 **role_binding** | [**RoleBinding**](RoleBinding.md)|  | 

### Return type

[**RoleBinding**](RoleBinding.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



