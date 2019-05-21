# SwaggerClient::IPSecVpnSessionStatisticsNsxT

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alarm** | [**PolicyRuntimeAlarm**](PolicyRuntimeAlarm.md) | Alarm information details. | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the info is fetched.  | [optional] 
**resource_type** | **String** |  | 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated.  | [optional] 
**ike_traffic_statistics** | [**IPSecVpnIkeTrafficStatistics**](IPSecVpnIkeTrafficStatistics.md) | Traffic statistics for IPSec VPN Ike session.  | [optional] 
**ike_status** | [**IPSecVpnIkeSessionStatus**](IPSecVpnIkeSessionStatus.md) | Status for IPSec VPN Ike session UP/DOWN and fail reason if Ike session is down.  | [optional] 
**policy_statistics** | [**Array&lt;IpSecVpnPolicyTrafficStatistics&gt;**](IpSecVpnPolicyTrafficStatistics.md) | Gives aggregate traffic statistics across all ipsec tunnels and individual tunnel statistics.  | [optional] 
**aggregate_traffic_counters** | [**IPSecVpnTrafficCounters**](IPSecVpnTrafficCounters.md) | Aggregate traffic statistics across all ipsec tunnels.  | [optional] 


