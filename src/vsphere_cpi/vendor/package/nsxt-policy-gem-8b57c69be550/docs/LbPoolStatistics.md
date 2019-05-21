# SwaggerClient::LBPoolStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**statistics** | [**LBStatisticsCounter**](LBStatisticsCounter.md) | Virtual server statistics counter. | [optional] 
**pool_path** | **String** | Load balancer pool object path. | [optional] 
**members** | [**Array&lt;LBPoolMemberStatistics&gt;**](LBPoolMemberStatistics.md) | Statistics of load balancer pool members. | [optional] 


