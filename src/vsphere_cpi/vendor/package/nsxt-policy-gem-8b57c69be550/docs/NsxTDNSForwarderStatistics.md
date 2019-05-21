# SwaggerClient::NsxTDNSForwarderStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** |  | 
**enforcement_point_path** | **String** | Policy path referencing the enforcement point from where the statistics are fetched.  | [optional] 
**queries_forwarded** | **Integer** | The total number of forwarded DNS queries | [optional] 
**cached_entries** | **Integer** | The total number of cached entries | [optional] 
**default_forwarder_statistics** | [**NsxTDNSForwarderZoneStatistics**](NsxTDNSForwarderZoneStatistics.md) | The statistics of default forwarder zone | [optional] 
**queries_answered_locally** | **Integer** | The total number of queries answered from local cache | [optional] 
**used_cache_statistics** | [**Array&lt;NsxTPerNodeUsedCacheStatistics&gt;**](NsxTPerNodeUsedCacheStatistics.md) | The statistics of used cache | [optional] 
**configured_cache_size** | **Integer** | The configured cache size, in kb | [optional] 
**timestamp** | **Integer** | Time stamp of the current statistics, in ms | [optional] 
**conditional_forwarder_statistics** | [**Array&lt;NsxTDNSForwarderZoneStatistics&gt;**](NsxTDNSForwarderZoneStatistics.md) | The statistics of conditional forwarder zones | [optional] 
**total_queries** | **Integer** | The total number of received DNS queries | [optional] 


