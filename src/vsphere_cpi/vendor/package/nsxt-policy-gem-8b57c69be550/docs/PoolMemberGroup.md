# SwaggerClient::PoolMemberGroup

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**grouping_object** | [**ResourceReference**](ResourceReference.md) | Load balancer pool support grouping object as dynamic pool members. The IP list of the grouping object such as NSGroup would be used as pool member IP setting.  | 
**ip_revision_filter** | **String** | Ip revision filter is used to filter IPv4 or IPv6 addresses from the grouping object. If the filter is not specified, both IPv4 and IPv6 addresses would be used as server IPs. The link local and loopback addresses would be always filtered out.  | [optional] [default to &#39;IPV4&#39;]
**max_ip_list_size** | **Integer** | The size is used to define the maximum number of grouping object IP address list. These IP addresses would be used as pool members. If the grouping object includes more than certain number of IP addresses, the redundant parts would be ignored and those IP addresses would not be treated as pool members. If the size is not specified, one member is budgeted for this dynamic pool so that the pool has at least one member even if some other dynamic pools grow beyond the capacity of load balancer service. Other members are picked according to available dynamic capacity. The unused members would be set to DISABLED so that the load balancer system itself is not overloaded during runtime.  | [optional] 
**port** | **Integer** | If port is specified, all connections will be sent to this port. If unset, the same port the client connected to will be used, it could be overridden by default_pool_member_ports setting in virtual server. The port should not specified for multiple ports case.  | [optional] 
**customized_members** | [**Array&lt;PoolMemberSetting&gt;**](PoolMemberSetting.md) | The list is used to show the customized pool member settings. User can only user pool member action API to update the admin state for a specific IP address.  | [optional] 


