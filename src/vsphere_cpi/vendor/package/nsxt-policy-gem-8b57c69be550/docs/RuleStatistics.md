# SwaggerClient::RuleStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**total_session_count** | **Integer** | Aggregated number of sessions processed by all the rules This is aggregated statistic which are computed with lower frequency compared to individual generic rule  statistics. It may have a computation delay up to 15 minutes in response to this API.  | [optional] 
**popularity_index** | **Integer** | This is calculated by sessions count divided by age of the rule. | [optional] 
**max_session_count** | **Integer** | Maximum value of sessions count of all rules of the type. This is aggregated statistic which are computed with lower frequency compared to generic rule statistics. It may have a computation delay up to 15 minutes in response to this API.  | [optional] 
**byte_count** | **Integer** | Aggregated number of bytes processed by the rule.  | [optional] 
**max_popularity_index** | **Integer** | Maximum value of popularity index of all rules of the type. This is aggregated statistic which are computed with lower frequency compared to individual generic rule statistics. It may have a computation delay up to 15 minutes in response to this API.  | [optional] 
**session_count** | **Integer** | Aggregated number of sessions processed by the rule.  | [optional] 
**rule** | **String** | Path of the rule. | [optional] 
**packet_count** | **Integer** | Aggregated number of packets processed by the rule.  | [optional] 
**internal_rule_id** | **String** | Realized id of the rule on NSX MP. Policy Manager can create more than one rule per policy rule, in which case this identifier helps to distinguish between the multple rules created.  | [optional] 
**hit_count** | **Integer** | Aggregated number of hits received by the rule. | [optional] 
**lr_path** | **String** | Path of the LR on which the section is applied in case of Edge FW. | [optional] 


