# SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**configure_backup_config**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#configure_backup_config) | **PUT** /cluster/backups/config | Configure backup
[**get_backup_config**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#get_backup_config) | **GET** /cluster/backups/config | Get backup configuration
[**get_backup_history**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#get_backup_history) | **GET** /cluster/backups/history | Get backup history
[**get_backup_status**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#get_backup_status) | **GET** /cluster/backups/status | Get backup status
[**get_ssh_fingerprint_of_server_retrieve_ssh_fingerprint**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#get_ssh_fingerprint_of_server_retrieve_ssh_fingerprint) | **POST** /cluster/backups?action&#x3D;retrieve_ssh_fingerprint | Get ssh fingerprint of remote(backup) server
[**request_onetime_backup_backup_to_remote**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#request_onetime_backup_backup_to_remote) | **POST** /cluster?action&#x3D;backup_to_remote | Request one-time backup
[**request_onetime_inventory_summary_summarize_inventory_to_remote**](NsxComponentAdministrationBackupRestoreManagementBackupApi.md#request_onetime_inventory_summary_summarize_inventory_to_remote) | **POST** /cluster?action&#x3D;summarize_inventory_to_remote | Request one-time inventory summary.


# **configure_backup_config**
> BackupConfiguration configure_backup_config(backup_configuration)

Configure backup

Configure file server and timers for automated backup. If secret fields are omitted (password, passphrase) then use the previously set value. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

backup_configuration = SwaggerClient::BackupConfiguration.new # BackupConfiguration | 


begin
  #Configure backup
  result = api_instance.configure_backup_config(backup_configuration)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->configure_backup_config: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **backup_configuration** | [**BackupConfiguration**](BackupConfiguration.md)|  | 

### Return type

[**BackupConfiguration**](BackupConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_backup_config**
> BackupConfiguration get_backup_config

Get backup configuration

Get a configuration of a file server and timers for automated backup. Fields that contain secrets (password, passphrase) are not returned. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

begin
  #Get backup configuration
  result = api_instance.get_backup_config
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->get_backup_config: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BackupConfiguration**](BackupConfiguration.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_backup_history**
> BackupOperationHistory get_backup_history

Get backup history

Get history of previous backup operations 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

begin
  #Get backup history
  result = api_instance.get_backup_history
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->get_backup_history: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BackupOperationHistory**](BackupOperationHistory.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_backup_status**
> CurrentBackupOperationStatus get_backup_status

Get backup status

Get status of active backup operations 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

begin
  #Get backup status
  result = api_instance.get_backup_status
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->get_backup_status: #{e}"
end
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CurrentBackupOperationStatus**](CurrentBackupOperationStatus.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_ssh_fingerprint_of_server_retrieve_ssh_fingerprint**
> RemoteServerFingerprint get_ssh_fingerprint_of_server_retrieve_ssh_fingerprint(remote_server_fingerprint_request)

Get ssh fingerprint of remote(backup) server

Get SHA256 fingerprint of ECDSA key of remote server. The caller should independently verify that the key is trusted. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

remote_server_fingerprint_request = SwaggerClient::RemoteServerFingerprintRequest.new # RemoteServerFingerprintRequest | 


begin
  #Get ssh fingerprint of remote(backup) server
  result = api_instance.get_ssh_fingerprint_of_server_retrieve_ssh_fingerprint(remote_server_fingerprint_request)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->get_ssh_fingerprint_of_server_retrieve_ssh_fingerprint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **remote_server_fingerprint_request** | [**RemoteServerFingerprintRequest**](RemoteServerFingerprintRequest.md)|  | 

### Return type

[**RemoteServerFingerprint**](RemoteServerFingerprint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **request_onetime_backup_backup_to_remote**
> request_onetime_backup_backup_to_remote

Request one-time backup

Request one-time backup. The backup will be uploaded using the same server configuration as for automatic backup. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

begin
  #Request one-time backup
  api_instance.request_onetime_backup_backup_to_remote
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->request_onetime_backup_backup_to_remote: #{e}"
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



# **request_onetime_inventory_summary_summarize_inventory_to_remote**
> request_onetime_inventory_summary_summarize_inventory_to_remote

Request one-time inventory summary.

Request one-time inventory summary. The backup will be uploaded using the same server configuration as for an automatic backup. 

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

api_instance = SwaggerClient::NsxComponentAdministrationBackupRestoreManagementBackupApi.new

begin
  #Request one-time inventory summary.
  api_instance.request_onetime_inventory_summary_summarize_inventory_to_remote
rescue SwaggerClient::ApiError => e
  puts "Exception when calling NsxComponentAdministrationBackupRestoreManagementBackupApi->request_onetime_inventory_summary_summarize_inventory_to_remote: #{e}"
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



