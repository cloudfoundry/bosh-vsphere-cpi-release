# SwaggerClient::BgpNeighborStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**connection_state** | **String** | Current state of the BGP session. | [optional] 
**messages_sent** | **Integer** | Count of messages sent to the neighbor | [optional] 
**neighbor_router_id** | **String** | Router ID of the BGP neighbor. | [optional] 
**total_out_prefix_count** | **Integer** | Sum of out prefixes counts across all address families. | [optional] 
**lr_component_id** | **String** | Logical router component(Service Router/Distributed Router) id | [optional] 
**established_connection_count** | **Integer** | Count of connections established | [optional] 
**keep_alive_interval** | **Integer** | Time in ms to wait for HELLO packet from BGP peer | [optional] 
**time_since_established** | **Integer** | Time(in milliseconds) since connection was established. | [optional] 
**hold_time** | **Integer** | Time in ms to wait for HELLO from BGP peer. If a HELLO packet is not seen from BGP Peer withing hold_time then BGP neighbor will be marked as down. | [optional] 
**graceful_restart** | **BOOLEAN** | Indicate current state of graceful restart where graceful_restart &#x3D; true indicate graceful restart is enabled and graceful_restart &#x3D; false indicate graceful restart is disabled. | [optional] 
**connection_drop_count** | **Integer** | Count of connection drop | [optional] 
**remote_port** | **Integer** | TCP port number of remote BGP Connection | [optional] 
**total_in_prefix_count** | **Integer** | Sum of in prefixes counts across all address families. | [optional] 
**messages_received** | **Integer** | Count of messages received from the neighbor | [optional] 
**transport_node** | [**ResourceReference**](ResourceReference.md) | Transport node id and name | [optional] 
**local_port** | **Integer** | TCP port number of Local BGP connection | [optional] 
**remote_as_number** | **String** | AS number of the BGP neighbor | [optional] 
**announced_capabilities** | **Array&lt;String&gt;** | BGP capabilities sent to BGP neighbor. | [optional] 
**negotiated_capability** | **Array&lt;String&gt;** | BGP capabilities negotiated with BGP neighbor. | [optional] 
**address_families** | [**Array&lt;BgpAddressFamily&gt;**](BgpAddressFamily.md) | Address families of BGP neighbor | [optional] 
**source_address** | **String** | The Ip address of logical port | [optional] 
**neighbor_address** | **String** | The IP of the BGP neighbor | [optional] 


