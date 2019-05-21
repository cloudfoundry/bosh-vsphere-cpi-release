# SwaggerClient::LBPoolStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**status** | **String** | UP means that all primary members are in UP status. PARTIALLY_UP means that some(not all) primary members are in UP status, the number of these active members is larger or equal to certain number(min_active_members) which is defined in LBPool. When there are no backup members which are in the UP status, the number(min_active_members) would be ignored. PRIMARY_DOWN means that less than certain(min_active_members) primary members are in UP status but backup members are in UP status, connections to this pool would be dispatched to backup members. DOWN means that all primary and backup members are DOWN. DETACHED means that the pool is not bound to any virtual server. UNKOWN means that no status reported from transport-nodes. The associated load balancer service may be working(or not working).  | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**pool_path** | **String** | Load balancer pool object path. | [optional] 
**members** | [**Array&lt;LBPoolMemberStatus&gt;**](LBPoolMemberStatus.md) | Status of load balancer pool members. | [optional] 


