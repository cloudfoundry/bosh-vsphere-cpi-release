# SwaggerClient::LogicalRouterRouteEntry

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lr_component_id** | **String** | Logical router component(Service Router/Distributed Router) id | [optional] 
**next_hop** | **String** | The IP address of the next hop | [optional] 
**lr_component_type** | **String** | Logical router component(Service Router/Distributed Router) type | [optional] 
**network** | **String** | CIDR network address | 
**route_type** | **String** | Route type (USER, CONNECTED, NSX_INTERNAL,..) | 
**logical_router_port_id** | **String** | The id of the logical router port which is used as the next hop | [optional] 
**admin_distance** | **Integer** | The admin distance of the next hop | [optional] 


