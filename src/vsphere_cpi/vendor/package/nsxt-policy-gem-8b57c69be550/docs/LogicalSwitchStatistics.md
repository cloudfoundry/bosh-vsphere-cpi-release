# SwaggerClient::LogicalSwitchStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**tx_bytes** | [**DataCounter**](DataCounter.md) |  | [optional] 
**rx_packets** | [**DataCounter**](DataCounter.md) |  | [optional] 
**tx_packets** | [**DataCounter**](DataCounter.md) |  | [optional] 
**rx_bytes** | [**DataCounter**](DataCounter.md) |  | [optional] 
**mac_learning** | [**MacLearningCounters**](MacLearningCounters.md) |  | [optional] 
**dropped_by_security_packets** | [**PacketsDroppedBySecurity**](PacketsDroppedBySecurity.md) |  | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated; unset if data source has never updated the data. | [optional] 
**logical_switch_id** | **String** | The id of the logical Switch | [optional] 


