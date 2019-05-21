# SwaggerClient::NSXTConnectionInfo

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**enforcement_point_address** | **String** | Value of this property could be hostname or ip. eg. For NSX-T manager running on default port the value can be \&quot;10.192.1.1\&quot;, for NSX-T manager running on custom port value can be \&quot;192.168.1.1:32789\&quot;. For NSX-T manager in VMC deployments value  can have url prefix eg. \&quot;192.168.1.1:5480/nsxapi\&quot;  | 
**resource_type** | **String** |  | 
**username** | **String** | UserName | [optional] 
**transport_zone_ids** | **Array&lt;String&gt;** | Transport Zone UUIDs on enforcement point. Transport zone information is required for creating logical L2, L3 constructs on enforcement point. Max 1 transport zone ID. This is a deprecated property. The transport zone id is now auto populated from enforcement point and its value can be read using APIs GET /infra/sites/site-id/enforcement-points/enforcementpoint-id/transport-zones and GET /infra/sites/site-id/enforcement-points/enforcementpoint-id/transport-zones/transport-zone-id. The value passed through this property will be ignored.  | [optional] 
**password** | **String** | Password | [optional] 
**edge_cluster_ids** | **Array&lt;String&gt;** | Edge Cluster UUIDs on enforcement point. Edge cluster information is required for creating logical L2, L3 constructs on enforcement point. Max 1 edge cluster ID. This is a deprecated property. The edge cluster id is now auto populated from enforcement point and its value can be read using APIs GET /infra/sites/site-id/enforcement-points/enforcementpoint-id/edge-clusters and GET /infra/sites/site-id/enforcement-points/enforcementpoint-1/edge-clusters/edge-cluster-id. The value passed through this property will be ignored.  | [optional] 
**thumbprint** | **String** | Thumbprint of EnforcementPoint. sha-256 hash represented in lower case hex.  | [optional] 


