# SwaggerClient::CurrentBackupOperationStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**current_step** | **String** | Current step of operation | [optional] 
**backup_id** | **String** | Unique identifier of current backup | [optional] 
**current_step_message** | **String** | Additional human-readable status information about current step | [optional] 
**end_time** | **Integer** | Time when operation is expected to end | [optional] 
**operation_type** | **String** | Type of operation that is in progress. Returns none if no operation is in progress, in which case none of the other fields will be set.  | 
**start_time** | **Integer** | Time when operation was started | [optional] 


