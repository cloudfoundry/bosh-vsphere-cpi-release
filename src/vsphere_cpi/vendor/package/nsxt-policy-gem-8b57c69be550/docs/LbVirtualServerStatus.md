# SwaggerClient::LBVirtualServerStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**status** | **String** | UP means that all primary members in default pool are in UP status. For L7 virtual server, if there is no default pool, the virtual server would be treated as UP. PARTIALLY_UP means that some(not all) primary members in default pool are in UP status. The size of these active primary members should be larger than or equal to the certain number(min_active_members) which is defined in LBPool. When there are no backup members which are in the UP status, the number(min_active_members) would be ignored. PRIMARY_DOWN means that less than certain(min_active_members) primary members in default pool are in UP status but backup members are in UP status, the connections would be dispatched to backup members. DOWN means that all primary and backup members are in DOWN status. DETACHED means that the virtual server is not bound to any service. DISABLED means that the admin state of the virtual server is disabled. UNKOWN means that no status reported from transport-nodes. The associated load balancer service may be working(or not working).  | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**virtual_server_path** | **String** | load balancer virtual server object path. | [optional] 


