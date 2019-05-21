# SwaggerClient::ControllerClusterRoleConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**type** | **String** | Type of this role configuration | [optional] 
**mpa_msg_client_info** | [**MsgClientInfo**](MsgClientInfo.md) |  | [optional] 
**host_msg_client_info** | [**MsgClientInfo**](MsgClientInfo.md) |  | [optional] 
**control_plane_listen_addr** | [**ServiceEndpoint**](ServiceEndpoint.md) | The IP and port for the control plane service on this node | [optional] 
**control_cluster_listen_addr** | [**ServiceEndpoint**](ServiceEndpoint.md) | The IP and port for the control cluster service on this node | [optional] 


