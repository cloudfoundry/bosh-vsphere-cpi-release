# SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**advance_cluster_restore_advance**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#advance_cluster_restore_advance) | **POST** /cluster/restore?action&#x3D;advance | Advance any suspended restore operation
[**cancel_cluster_restore_cancel**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#cancel_cluster_restore_cancel) | **POST** /cluster/restore?action&#x3D;cancel | Cancel any running restore operation
[**configure_restore_config**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#configure_restore_config) | **PUT** /cluster/restore/config | Configure Restore SFTP server credentials
[**get_restore_config**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#get_restore_config) | **GET** /cluster/restore/config | Get Restore configuration
[**initiate_cluster_restore_start**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#initiate_cluster_restore_start) | **POST** /cluster/restore?action&#x3D;start | Initiate a restore operation
[**list_cluster_backup_timestamps**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#list_cluster_backup_timestamps) | **GET** /cluster/restore/backuptimestamps | List timestamps of all available Cluster Backups.
[**list_restore_instruction_resources**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#list_restore_instruction_resources) | **GET** /cluster/restore/instruction-resources | List resources for a given instruction, to be shown to/executed by users. 
[**retry_cluster_restore_retry**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#retry_cluster_restore_retry) | **POST** /cluster/restore?action&#x3D;retry | Retry any failed restore operation
[**suspend_cluster_restore_suspend**](NsxComponentAdministrationBackupRestoreManagementRestoreApi.md#suspend_cluster_restore_suspend) | **POST** /cluster/restore?action&#x3D;suspend | Suspend any running restore operation


# **advance_cluster_restore_advance**
> ClusterRestoreStatus advance_cluster_restore_advance(advance_cluster_restore_request)

Advance any suspended restore operation

Advance any currently suspended restore operation. The operation might have been suspended because (1) the user had suspended it previously, or (2) the operation is waiting for user input, to be provided as a part of the POST request body. This operation is only valid when a GET cluster/restore/status returns a status with value SUSPENDED. Otherwise, a 409 response is returned. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

advance_cluster_restore_request = SwaggerClient::AdvanceClusterRestoreRequest.new # AdvanceClusterRestoreRequest | 


begin
  #Advance any suspended restore operation
  result = api_instance.advance_cluster_restore_advance(advance_cluster_restore_request)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->advance_cluster_restore_advance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **advance_cluster_restore_request** | [**AdvanceClusterRestoreRequest**](AdvanceClusterRestoreRequest.md)|  | 

### Return type

[**ClusterRestoreStatus**](ClusterRestoreStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **cancel_cluster_restore_cancel**
> ClusterRestoreStatus cancel_cluster_restore_cancel

Cancel any running restore operation

This operation is only valid when a restore is in suspended state. The UI user can cancel any restore operation when the restore is suspended either due to an error, or for a user input. The API user would need to monitor the progression of a restore by calling periodically \"/api/v1/cluster/restore/status\" API. The response object (ClusterRestoreStatus), contains a field \"endpoints\". The API user can cancel the restore process if 'cancel' action is shown in the endpoint field. This operation is only valid when a GET cluster/restore/status returns a status with value SUSPENDED. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

begin
  #Cancel any running restore operation
  result = api_instance.cancel_cluster_restore_cancel
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->cancel_cluster_restore_cancel: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ClusterRestoreStatus**](ClusterRestoreStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **configure_restore_config**
> RestoreConfiguration configure_restore_config(restore_configuration)

Configure Restore SFTP server credentials

Configure file server where the backed-up files used for the Restore operation are available. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

restore_configuration = SwaggerClient::RestoreConfiguration.new # RestoreConfiguration | 


begin
  #Configure Restore SFTP server credentials
  result = api_instance.configure_restore_config(restore_configuration)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->configure_restore_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **restore_configuration** | [**RestoreConfiguration**](RestoreConfiguration.md)|  | 

### Return type

[**RestoreConfiguration**](RestoreConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_restore_config**
> RestoreConfiguration get_restore_config

Get Restore configuration

Get configuration information for the file server used to store backed-up files. Fields that contain secrets (password, passphrase) are not returned. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

begin
  #Get Restore configuration
  result = api_instance.get_restore_config
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->get_restore_config: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RestoreConfiguration**](RestoreConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **initiate_cluster_restore_start**
> ClusterRestoreStatus initiate_cluster_restore_start(initiate_cluster_restore_request)

Initiate a restore operation

Start the restore of an NSX cluster, from some previously backed-up configuration. This operation is only valid when a GET cluster/restore/status returns a status with value NOT_STARTED. Otherwise, a 409 response is returned. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

initiate_cluster_restore_request = SwaggerClient::InitiateClusterRestoreRequest.new # InitiateClusterRestoreRequest | 


begin
  #Initiate a restore operation
  result = api_instance.initiate_cluster_restore_start(initiate_cluster_restore_request)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->initiate_cluster_restore_start: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **initiate_cluster_restore_request** | [**InitiateClusterRestoreRequest**](InitiateClusterRestoreRequest.md)|  | 

### Return type

[**ClusterRestoreStatus**](ClusterRestoreStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_cluster_backup_timestamps**
> ClusterBackupInfoListResult list_cluster_backup_timestamps(opts)

List timestamps of all available Cluster Backups.

Returns timestamps for all backup files that are available on the SFTP server. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List timestamps of all available Cluster Backups.
  result = api_instance.list_cluster_backup_timestamps(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->list_cluster_backup_timestamps: #{e}"
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

[**ClusterBackupInfoListResult**](ClusterBackupInfoListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_restore_instruction_resources**
> ActionableResourceListResult list_restore_instruction_resources(instruction_id, opts)

List resources for a given instruction, to be shown to/executed by users. 

For restore operations requiring user input e.g. performing an action, accepting/rejecting an action, etc. the information to be conveyed to users is provided in this call. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

instruction_id = 'instruction_id_example' # String | Id of the instruction set whose instructions are to be returned

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List resources for a given instruction, to be shown to/executed by users. 
  result = api_instance.list_restore_instruction_resources(instruction_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->list_restore_instruction_resources: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **instruction_id** | **String**| Id of the instruction set whose instructions are to be returned | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ActionableResourceListResult**](ActionableResourceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **retry_cluster_restore_retry**
> ClusterRestoreStatus retry_cluster_restore_retry

Retry any failed restore operation

Retry any currently in-progress, failed restore operation. Only the last step of the multi-step restore operation would have failed,and only that step is retried. This operation is only valid when a GET cluster/restore/status returns a status with value FAILED. Otherwise, a 409 response is returned. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

begin
  #Retry any failed restore operation
  result = api_instance.retry_cluster_restore_retry
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->retry_cluster_restore_retry: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ClusterRestoreStatus**](ClusterRestoreStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **suspend_cluster_restore_suspend**
> ClusterRestoreStatus suspend_cluster_restore_suspend

Suspend any running restore operation

Suspend any currently running restore operation. The restore operation is made up of a number of steps. When this call is issued, any currently running step is allowed to finish (successfully or with errors), and the next step (and therefore the entire restore operation) is suspended until a subsequent resume or cancel call is issued. This operation is only valid when a GET cluster/restore/status returns a status with value RUNNING. Otherwise, a 409 response is returned. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementRestoreApi.new

begin
  #Suspend any running restore operation
  result = api_instance.suspend_cluster_restore_suspend
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementRestoreApi->suspend_cluster_restore_suspend: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ClusterRestoreStatus**](ClusterRestoreStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



