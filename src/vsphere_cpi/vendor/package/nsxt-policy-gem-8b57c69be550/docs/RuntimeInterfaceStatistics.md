# SwaggerClient::RuntimeInterfaceStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**tx_bytes** | [**SIDataCounter**](SIDataCounter.md) |  | [optional] 
**rx_packets** | [**SIDataCounter**](SIDataCounter.md) |  | [optional] 
**tx_packets** | [**SIDataCounter**](SIDataCounter.md) |  | [optional] 
**rx_bytes** | [**SIDataCounter**](SIDataCounter.md) |  | [optional] 
**mac_learning** | [**SIMacLearningCounters**](SIMacLearningCounters.md) |  | [optional] 
**dropped_by_security_packets** | [**SIPacketsDroppedBySecurity**](SIPacketsDroppedBySecurity.md) |  | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated; unset if data source has never updated the data. | [optional] 
**interface_index** | **Integer** | Index of the interface | [optional] 


