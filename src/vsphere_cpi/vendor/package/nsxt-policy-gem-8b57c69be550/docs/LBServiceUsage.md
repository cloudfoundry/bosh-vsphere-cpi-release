# SwaggerClient::LBServiceUsage

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**pool_capacity** | **Integer** | Pool capacity means maximum number of pools which could be configured in the given load balancer service.  | [optional] 
**service_size** | **String** | The size of load balancer service. | [optional] 
**pool_member_capacity** | **Integer** | Pool member capacity means maximum number of pool members which could be configured in the given load balancer service.  | [optional] 
**current_virtual_server_count** | **Integer** | The current number of virtual servers which has been configured in the given load balancer service.  | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**current_pool_count** | **Integer** | The current number of pools which has been configured in the given load balancer service.  | [optional] 
**virtual_server_capacity** | **Integer** | Virtual server capacity means maximum number of virtual servers which could be configured in the given load balancer service.  | [optional] 
**current_pool_member_count** | **Integer** | The current number of pool members which has been configured in the given load balancer service.  | [optional] 
**service_path** | **String** | LBService object path. | [optional] 


