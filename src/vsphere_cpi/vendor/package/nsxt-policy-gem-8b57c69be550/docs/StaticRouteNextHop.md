# SwaggerClient::StaticRouteNextHop

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**blackhole_action** | **String** | Action to be taken on matching packets for NULL routes. | [optional] 
**administrative_distance** | **Integer** | Administrative Distance for the next hop IP | [optional] [default to 1]
**ip_address** | **String** | Next Hop IP | [optional] 
**bfd_enabled** | **BOOLEAN** | Status of bfd for this next hop where bfd_enabled &#x3D; true indicate bfd is enabled for this next hop and bfd_enabled &#x3D; false indicate bfd peer is disabled or not configured for this next hop. | [optional] [default to false]
**logical_router_port_id** | [**ResourceReference**](ResourceReference.md) | Reference of logical router port to be used for next hop | [optional] 


