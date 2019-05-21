# SwaggerClient::ClusterRestoreStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | [**GlobalRestoreStatus**](GlobalRestoreStatus.md) |  | [optional] 
**step** | [**RestoreStep**](RestoreStep.md) |  | [optional] 
**endpoints** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The list of allowed endpoints, based on the current state of the restore process  | [optional] 
**total_steps** | **Integer** | Total number of steps in the entire restore process | [optional] 
**restore_start_time** | **Integer** | Timestamp when restore was started in epoch millisecond | [optional] 
**restore_end_time** | **Integer** | Timestamp when restore was completed in epoch millisecond | [optional] 
**backup_timestamp** | **Integer** | Timestamp when backup was initiated in epoch millisecond | [optional] 
**id** | **String** | Unique id for backup request | [optional] 
**instructions** | [**Array&lt;InstructionInfo&gt;**](InstructionInfo.md) | Instructions for users to reconcile Restore operations | [optional] 


