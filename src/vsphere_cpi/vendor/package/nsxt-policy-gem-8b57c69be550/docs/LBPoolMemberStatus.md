# SwaggerClient::LbPoolMemberStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** | UP means that pool member is enabled and monitors have marked the pool member as UP. If the pool member has no monitor configured, it would be treated as UP. DOWN means that pool member is enabled and monitors have marked the pool member as DOWN. DISABLED means that admin state of pool member is set to DISABLED. GRACEFUL_DISABLED means that admin state of pool member is set to GRACEFUL_DISABLED. UNUSED means that the pool member is not used when the IP list size of member group exceeds the maximum setting. The remaining IP addresses would not be used as available backend servers, hence mark the status as UNUSED.  | 
**failure_cause** | **String** | The healthcheck failure cause when status is DOWN | [optional] 
**last_check_time** | **Integer** | Timestamp in milliseconds since epoch | [optional] 
**ip_address** | **String** | Pool member IP address | 
**last_state_change_time** | **Integer** | Timestamp in milliseconds since epoch | [optional] 
**port** | **String** | The port is configured in pool member. For virtual server port range case, pool member port must be null.  | [optional] 


