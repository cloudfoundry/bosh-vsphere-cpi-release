# SwaggerClient::TransportNodeState

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**state** | **String** | Gives details of state of desired configuration | [optional] 
**details** | [**Array&lt;ConfigurationStateElement&gt;**](ConfigurationStateElement.md) | Array of configuration state of various sub systems | [optional] 
**failure_code** | **Integer** | Error code | [optional] 
**failure_message** | **String** | Error message in case of failure | [optional] 
**node_deployment_state** | [**ConfigurationState**](ConfigurationState.md) | Deployment status of installation | [optional] 
**host_switch_states** | [**Array&lt;HostSwitchState&gt;**](HostSwitchState.md) | States of HostSwitches on the host | [optional] 
**maintenance_mode_state** | **String** | the present realized maintenance mode state | [optional] 
**transport_node_id** | **String** | Unique Id of the TransportNode | [optional] 


