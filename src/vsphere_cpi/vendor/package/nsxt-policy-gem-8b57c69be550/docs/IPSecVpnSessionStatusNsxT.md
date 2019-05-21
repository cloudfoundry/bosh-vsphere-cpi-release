# SwaggerClient::IPSecVpnSessionStatusNsxT

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**runtime_status** | **String** | Gives session status consolidated using IKE status and tunnel status. It can be UP, DOWN, DEGRADED. If IKE and all tunnels are UP status will be UP, if all down it will be DOWN, otherwise it will be DEGRADED.  | [optional] 
**failed_tunnels** | **Integer** | Number of failed tunnels. | [optional] 
**negotiated_tunnels** | **Integer** | Number of negotiated tunnels. | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated. | [optional] 
**total_tunnels** | **Integer** | Total number of tunnels. | [optional] 
**ike_status** | [**IPSecVpnIkeSessionStatus**](IPSecVpnIkeSessionStatus.md) | Status for IPSec VPN IKE session UP/DOWN and fail reason if IKE session is down.  | [optional] 
**aggregate_traffic_counters** | [**IPSecVpnTrafficCounters**](IPSecVpnTrafficCounters.md) | Aggregate traffic statistics across all ipsec tunnels. | [optional] 


