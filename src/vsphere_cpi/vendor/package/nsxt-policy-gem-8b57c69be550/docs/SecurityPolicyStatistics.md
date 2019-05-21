# SwaggerClient::SecurityPolicyStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**internal_section_id** | **String** | Realized id of the section on NSX MP. Policy Manager can create more than one section per SecurityPolicy, in which case this identifier helps to distinguish between the multiple sections created.  | [optional] 
**result_count** | **Integer** | Total count for rule statistics | [optional] 
**results** | [**Array&lt;RuleStatistics&gt;**](RuleStatistics.md) | List of rule statistics. | [optional] 
**lr_path** | **String** | Path of the LR on which the section is applied in case of Gateway Firewall.  | [optional] 


