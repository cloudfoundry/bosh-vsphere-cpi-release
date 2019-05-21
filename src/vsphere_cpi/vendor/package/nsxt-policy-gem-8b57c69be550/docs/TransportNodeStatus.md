# SwaggerClient::TransportNodeStatus

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** | Roll-up status of pNIC, management connection, control connection, tunnel status, agent status | [optional] 
**threat_status** | [**ThreatStatus**](ThreatStatus.md) | Threat status | [optional] 
**agent_status** | [**AgentStatusCount**](AgentStatusCount.md) | NSX agents status | [optional] 
**node_uuid** | **String** | Transport node uuid | [optional] 
**tunnel_status** | [**TunnelStatusCount**](TunnelStatusCount.md) | Tunnel Status | [optional] 
**mgmt_connection_status** | **String** | Management connection status | [optional] 
**control_connection_status** | [**StatusCount**](StatusCount.md) | Control connection status | [optional] 
**pnic_status** | [**StatusCount**](StatusCount.md) | pNIC status | [optional] 
**node_status** | [**NodeStatus**](NodeStatus.md) | Node status | [optional] 
**node_display_name** | **String** | Transport node display name | [optional] 


