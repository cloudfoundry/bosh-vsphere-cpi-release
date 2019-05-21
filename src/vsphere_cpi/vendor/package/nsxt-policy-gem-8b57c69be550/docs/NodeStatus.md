# SwaggerClient::NodeStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**mpa_connectivity_status** | **String** | Indicates the fabric node&#39;s MP&lt;-&gt;MPA channel connectivity status, UP, DOWN, UNKNOWN. | [optional] 
**lcp_connectivity_status_details** | [**Array&lt;ControlConnStatus&gt;**](ControlConnStatus.md) | Details, if any, about the current LCP&lt;-&gt;CCP channel connectivity status of the fabric node. | [optional] 
**mpa_connectivity_status_details** | **String** | Details, if any, about the current MP&lt;-&gt;MPA channel connectivity status of the fabric node. | [optional] 
**external_id** | **String** | HostNode external id | [optional] 
**software_version** | **String** | Software version of the fabric node. | [optional] 
**maintenance_mode** | **String** | Indicates the fabric node&#39;s status of maintenance mode, OFF, ENTERING, ON, EXITING. | [optional] 
**inventory_sync_paused** | **BOOLEAN** | Is true if inventory sync is paused else false | [optional] 
**system_status** | [**NodeStatusProperties**](NodeStatusProperties.md) | Node status properties | [optional] 
**inventory_sync_reenable_time** | **Integer** | Inventory sync auto re-enable target time, in epoch milis | [optional] 
**lcp_connectivity_status** | **String** | Indicates the fabric node&#39;s LCP&lt;-&gt;CCP channel connectivity status, UP, DOWN, DEGRADED, UNKNOWN. | [optional] [default to &#39;UNKNOWN&#39;]
**last_heartbeat_timestamp** | **Integer** | Timestamp of the last heartbeat status change, in epoch milliseconds. | [optional] 
**last_sync_time** | **Integer** | Timestamp of the last successful update of Inventory, in epoch milliseconds. | [optional] 
**host_node_deployment_status** | **String** | This enum specifies the current nsx install state for host node or current deployment and ready state for edge node. The ready status &#39;NODE_READY&#39; indicates whether edge node is ready to become a transport node. The status &#39;EDGE_CONFIG_ERROR&#39; indicates that edge hardware or underlying host is not supported. After all fabric level operations are done for an edge node, this value indicates transport node related configuration issues and state as relevant.  | [optional] 


