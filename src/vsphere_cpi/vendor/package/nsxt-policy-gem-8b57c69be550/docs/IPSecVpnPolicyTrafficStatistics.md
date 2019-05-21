# SwaggerClient::IpSecVpnPolicyTrafficStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**tunnel_interface_path** | **String** | Policy path referencing the IPSec VPN Tunnel Interface. | [optional] 
**aggregate_traffic_counters** | [**IPSecVpnTrafficCounters**](IPSecVpnTrafficCounters.md) | Aggregate traffic statistics across all IPSec tunnels. | [optional] 
**tunnel_statistics** | [**Array&lt;IpSecVpnTunnelTrafficStatistics&gt;**](IpSecVpnTunnelTrafficStatistics.md) | Tunnel statistics. | [optional] 
**rule_path** | **String** | Policy path referencing the IPSec VPN Rule. | [optional] 


