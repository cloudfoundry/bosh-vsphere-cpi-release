# SwaggerClient::RouteMapEntrySet

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**med** | **Integer** | Multi exit descriminator (MED) is a hint to BGP neighbors about the preferred path into an autonomous system (AS) that has multiple entry points. A lower MED value is preferred over a higher value.  | [optional] 
**local_preference** | **Integer** | Local preference indicates the degree of preference for one BGP route over other BGP routes. The path with highest local preference is preferred.  | [optional] [default to 100]
**as_path_prepend** | **String** | AS path prepend to influence route selection.  | [optional] 
**weight** | **Integer** | Weight is used to select a route when multiple routes are available to the same network. Route with the highest weight is preferred.  | [optional] 
**community** | **String** | Set BGP community for matching routes. Both well-known community name or community value in aa:nn (2byte:2byte) format are supported  | [optional] 


