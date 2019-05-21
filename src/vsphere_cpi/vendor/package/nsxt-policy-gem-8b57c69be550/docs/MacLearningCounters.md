# SwaggerClient::MacLearningCounters

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**macs_learned** | **Integer** | Number of MACs learned | [optional] 
**mac_not_learned_packets_dropped** | **Integer** | The number of packets with unknown source MAC address that are dropped without learning the source MAC address. Applicable only when the MAC limit is reached and MAC Limit policy is MAC_LEARNING_LIMIT_POLICY_DROP. | [optional] 
**mac_not_learned_packets_allowed** | **Integer** | The number of packets with unknown source MAC address that are dispatched without learning the source MAC address. Applicable only when the MAC limit is reached and MAC Limit policy is MAC_LEARNING_LIMIT_POLICY_ALLOW. | [optional] 


