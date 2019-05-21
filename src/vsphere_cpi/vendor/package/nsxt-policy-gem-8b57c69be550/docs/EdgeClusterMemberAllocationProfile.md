# SwaggerClient::EdgeClusterMemberAllocationProfile

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**allocation_pool** | [**EdgeClusterMemberAllocationPool**](EdgeClusterMemberAllocationPool.md) | Logical router allocation can be tracked for specific services and services may have their own hard limits and allocation sizes. For example load balancer pool should be specified if load balancer service will be attached to logical router.  | [optional] 
**enable_standby_relocation** | **BOOLEAN** | Flag to enable the auto-relocation of standby service router running on edge cluster and node associated with the logical router. Only manually placed service contexts for tier1 logical routers are considered for the relocation.  | [optional] [default to false]


