# SwaggerClient::LBServiceStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**pools** | [**Array&lt;LBPoolStatistics&gt;**](LBPoolStatistics.md) | Statistics of load balancer pools | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**virtual_servers** | [**Array&lt;LBVirtualServerStatistics&gt;**](LBVirtualServerStatistics.md) | Statistics of load balancer virtual servers. | [optional] 
**service_path** | **String** | load balancer service identifier. | [optional] 
**statistics** | [**LBServiceStatisticsCounter**](LBServiceStatisticsCounter.md) | Load balancer service statistics counter. | [optional] 


