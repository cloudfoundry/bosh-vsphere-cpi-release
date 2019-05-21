# SwaggerClient::TraceflowObservationForwarded

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**timestamp_micro** | **Integer** | Timestamp when the observation was created by the transport node (microseconds epoch) | [optional] 
**component_sub_type** | **String** | The sub type of the component that issued the observation. | [optional] 
**resource_type** | **String** |  | 
**component_type** | **String** | The type of the component that issued the observation. | [optional] 
**transport_node_name** | **String** | name of the transport node that observed a traceflow packet | [optional] 
**timestamp** | **Integer** | Timestamp when the observation was created by the transport node (milliseconds epoch) | [optional] 
**transport_node_id** | **String** | id of the transport node that observed a traceflow packet | [optional] 
**sequence_no** | **Integer** | the hop count for observations on the transport node that a traceflow packet is injected in will be 0. The hop count is incremented each time a subsequent transport node receives the traceflow packet. The sequence number of 999 indicates that the hop count could not be determined for the containing observation. | [optional] 
**transport_node_type** | **String** | type of the transport node that observed a traceflow packet | [optional] 
**component_name** | **String** | The name of the component that issued the observation. | [optional] 
**uplink_name** | **String** | The name of the uplink the traceflow packet is forwarded on | [optional] 
**vtep_label** | **Integer** | The virtual tunnel endpoint label | [optional] 
**remote_ip_address** | **String** | IP address of the destination end of the tunnel | [optional] 
**context** | **Integer** | The 64bit tunnel context carried on the wire. | [optional] 
**local_ip_address** | **String** | IP address of the source end of the tunnel | [optional] 
**dst_transport_node_id** | **String** | This field will not be always available. Use remote_ip_address when this field is not set. | [optional] 
**dst_transport_node_name** | **String** | The name of the transport node to which the traceflow packet is forwarded | [optional] 


