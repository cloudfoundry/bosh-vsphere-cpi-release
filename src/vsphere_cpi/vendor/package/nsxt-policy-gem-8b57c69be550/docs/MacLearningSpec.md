# SwaggerClient::MacLearningSpec

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**limit** | **Integer** | The maximum number of MAC addresses that can be learned on this port | [optional] [default to 4096]
**aging_time** | **Integer** | Aging time in sec for learned MAC address | [optional] [default to 600]
**enabled** | **BOOLEAN** | Allowing source MAC address learning | 
**limit_policy** | **String** | The policy after MAC Limit is exceeded | [optional] [default to &#39;ALLOW&#39;]
**unicast_flooding_allowed** | **BOOLEAN** | Allowing flooding for unlearned MAC for ingress traffic | [optional] [default to true]


