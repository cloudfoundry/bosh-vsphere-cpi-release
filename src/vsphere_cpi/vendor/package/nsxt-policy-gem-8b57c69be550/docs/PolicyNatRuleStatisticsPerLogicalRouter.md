# SwaggerClient::PolicyNatRuleStatisticsPerLogicalRouter

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**last_update_timestamp** | **Integer** | Timestamp when the data was last updated.  | [optional] 
**per_node_statistics** | [**Array&lt;PolicyNatRuleStatisticsPerTransportNode&gt;**](PolicyNatRuleStatisticsPerTransportNode.md) | Detailed Rule statistics per logical router.  | [optional] 
**statistics** | [**PolicyNATRuleCounters**](PolicyNATRuleCounters.md) | Rolled up statistics for all rules on the logical router.  | [optional] 
**router_path** | **String** | Path of the router.  | [optional] 
**enforcement_point_path** | **String** | Policy Path referencing the enforcement point from where the statistics are fetched.  | [optional] 


