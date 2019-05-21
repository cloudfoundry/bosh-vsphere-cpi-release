# SwaggerClient::HostSwitch

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**pnics** | [**Array&lt;Pnic&gt;**](Pnic.md) | Physical NICs connected to the host switch | [optional] 
**host_switch_name** | **String** | If this name is unset or empty then the default host switch name will be used. The name must be unique among all host switches specified in a given Transport Node; unset name, empty name and the default host switch name are considered the same in terms of uniqueness. | [optional] [default to &#39;nsxDefaultHostSwitch&#39;]
**static_ip_pool_id** | **String** | ID of configured Static IP Pool. If specified allocate IP for Endpoints from Pool. Else assume IP will be assigned for Endpoints from DHCP. This field is deprecated, use ip_assignment_spec field instead. | [optional] 
**host_switch_profile_ids** | [**Array&lt;HostSwitchProfileTypeIdEntry&gt;**](HostSwitchProfileTypeIdEntry.md) | HostSwitch profiles bound to this HostSwitch. If a profile ID is not provided for any HostSwitchProfileType that is supported by the Transport Node, the corresponding default profile will be bound to the HostSwitch. | [optional] 


