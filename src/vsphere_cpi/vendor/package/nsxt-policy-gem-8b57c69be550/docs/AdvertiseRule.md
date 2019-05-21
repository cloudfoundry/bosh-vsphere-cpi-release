# SwaggerClient::AdvertiseRule

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**action** | **String** | ALLOW action enables the advertisment and DENY action disables the advertisement of a filtered routes to the connected TIER0 router. | [optional] [default to &#39;ALLOW&#39;]
**rule_filter** | [**AdvertisementRuleFilter**](AdvertisementRuleFilter.md) | Rule filter for the advertise rule | [optional] 
**display_name** | **String** | Display name | [optional] 
**networks** | **Array&lt;String&gt;** | network(CIDR) to be routed | 
**description** | **String** | Description | [optional] 


