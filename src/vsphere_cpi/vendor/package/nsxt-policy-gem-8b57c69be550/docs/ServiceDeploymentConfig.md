# SwaggerClient::ServiceDeploymentConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**storage_id** | **String** | Moref of the datastore in VC. If it is to be taken from &#39;Agent VM Settings&#39;, then it should be empty. | [optional] 
**host_id** | **String** | The service VM will be deployed on the specified host in the specified server within the cluster if host_id is specified. Note: You must ensure that storage and specified networks are accessible       by this host.  | [optional] 
**compute_collection_id** | **String** | Resource Pool or cluster Id. | 
**vm_nic_info** | [**VmNicInfo**](VmNicInfo.md) | VM NIC information for VMs | [optional] 
**compute_manager_id** | **String** | Context Id or VCenter Id. | 


