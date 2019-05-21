# SwaggerClient::BackupConfiguration

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**remote_file_server** | [**RemoteFileServer**](RemoteFileServer.md) | The server to which backups will be sent. | 
**backup_enabled** | **BOOLEAN** | true if automated backup is enabled | [optional] [default to false]
**passphrase** | **String** | Passphrase used to encrypt backup files. The passphrase specified must be at least 8 characters in length and must contain at least one lowercase, one uppercase, one numeric character and one special character (any other non-space character).  | [optional] 
**backup_schedule** | [**BackupSchedule**](BackupSchedule.md) | Set when backups should be taken - on a weekly schedule or at regular intervals. | [optional] 
**after_inventory_update_interval** | **Integer** | A number of seconds after a last backup, that needs to pass, before a topology change will trigger a generation of a new cluster/node backups. If parameter is not provided, then changes in a topology will not trigger a generation of cluster/node backups. | [optional] 
**inventory_summary_interval** | **Integer** | The minimum number of seconds between each upload of the inventory summary to backup server. | [optional] [default to 240]


