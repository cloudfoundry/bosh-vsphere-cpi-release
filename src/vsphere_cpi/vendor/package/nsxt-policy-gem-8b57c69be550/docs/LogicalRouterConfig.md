# SwaggerClient::LogicalRouterConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**internal_transit_network** | **String** | CIDR block defining service router to distributed router links | [optional] 
**transport_zone_id** | **String** | Transport zone of the logical router. If specified then all downlink switches should belong to this transport zone and an error will be thrown if transport zone of the downlink switch doesn&#39;t match with this transport zone. All internal and external transit switches will be created in this transport zone. | [optional] 
**internal_transit_networks** | **Array&lt;String&gt;** | CIDR block defining service router to distributed router links | [optional] 
**ha_vip_configs** | [**Array&lt;HaVipConfig&gt;**](HaVipConfig.md) | This configuration can be defined only for Active-Standby LogicalRouter to provide | redundancy. For mulitple uplink ports, multiple HaVipConfigs must be defined | and each config will pair exactly two uplink ports. The VIP will move and will | always be owned by the Active node. Note - when HaVipConfig[s] are defined, | configuring dynamic-routing is disallowed. | [optional] 
**external_transit_networks** | **Array&lt;String&gt;** | CIDR block defining tier0 to tier1 links | [optional] 


