# SwaggerClient::L2VPNSessionStatusNsxT

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**transport_tunnels** | [**Array&lt;L2VPNSessionTransportTunnelStatus&gt;**](L2VPNSessionTransportTunnelStatus.md) | Transport tunnels status. | [optional] 
**runtime_status** | **String** | L2 VPN session status, specifies UP/DOWN. | [optional] 


