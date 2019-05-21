# SwaggerClient::LBServiceStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**active_transport_nodes** | **Array&lt;String&gt;** | Ids of load balancer service related active transport nodes. | [optional] 
**pools** | [**Array&lt;LBPoolStatus&gt;**](LBPoolStatus.md) | status of load balancer pools. | [optional] 
**cpu_usage** | **Integer** | Cpu usage in percentage. | [optional] 
**standby_transport_nodes** | **Array&lt;String&gt;** | Ids of load balancer service related standby transport nodes. | [optional] 
**memory_usage** | **Integer** | Memory usage in percentage. | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**service_status** | **String** | UP means the load balancer service is working fine on both transport-nodes(if have); DOWN means the load balancer service is down on both transport-nodes (if have), hence the load balancer will not respond to any requests; ERROR means error happens on transport-node(s) or no status is reported from transport-node(s). The load balancer service may be working (or not working); NO_STANDBY means load balancer service is working in one of the transport node while not in the other transport-node (if have). Hence if the load balancer service in the working transport-node goes down, the load balancer service will go down; DETACHED means that the load balancer service has no attachment setting and is not instantiated in any transport nodes; DISABLED means that admin state of load balancer service is DISABLED; UNKNOWN means that no status reported from transport-nodes.The load balancer service may be working(or not working).  | [optional] 
**error_message** | **String** | Error message, if available. | [optional] 
**virtual_servers** | [**Array&lt;LBVirtualServerStatus&gt;**](LBVirtualServerStatus.md) | status of load balancer virtual servers. | [optional] 
**service_path** | **String** | Load balancer service object path. | [optional] 


