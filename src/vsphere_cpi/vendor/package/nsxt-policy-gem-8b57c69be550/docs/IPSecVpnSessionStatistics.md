# SwaggerClient::IPSecVpnSessionStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** |  | 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the statistics are fetched.  | [optional] 
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated.  | [optional] 
**ike_traffic_statistics** | [**IPSecVpnIkeTrafficStatistics**](IPSecVpnIkeTrafficStatistics.md) | Traffic statistics for IPSec VPN Ike session. Note - Not supported in this release.  | [optional] 
**ike_status** | [**IPSecVpnIkeSessionStatus**](IPSecVpnIkeSessionStatus.md) | Status for IPSec VPN Ike session UP/DOWN and fail reason if Ike session is down.  | [optional] 
**policy_statistics** | [**Array&lt;IPSecVpnPolicyTrafficStatistics&gt;**](IPSecVpnPolicyTrafficStatistics.md) | Gives aggregate traffic statistics across all ipsec tunnels and individual tunnel statistics.  | [optional] 
**aggregate_traffic_counters** | [**IPSecVpnTrafficCounters**](IPSecVpnTrafficCounters.md) | Aggregate traffic statistics across all ipsec tunnels.  | [optional] 


