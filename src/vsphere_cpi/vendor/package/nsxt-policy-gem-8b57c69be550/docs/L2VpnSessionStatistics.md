# SwaggerClient::L2VpnSessionStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** |  | 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point wehere the statistics are fetched.  | [optional] 
**traffic_statistics_per_segment** | [**Array&lt;L2VpnPerSegmentTrafficStatistics&gt;**](L2VpnPerSegmentTrafficStatistics.md) | Traffic statistics per segment. | [optional] 
**tap_traffic_counters** | [**Array&lt;L2VpnTapTrafficStatistics&gt;**](L2VpnTapTrafficStatistics.md) | Tunnel port traffic counters. | [optional] 


