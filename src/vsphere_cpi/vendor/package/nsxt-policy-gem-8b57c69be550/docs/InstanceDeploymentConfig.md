# SwaggerClient::InstanceDeploymentConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**context_id** | **String** | Context Id or VCenter Id. | 
**vm_nic_infos** | [**Array&lt;VmNicInfo&gt;**](VmNicInfo.md) | List of NIC information for VMs | 
**storage_id** | **String** | Storage Id. | 
**host_id** | **String** | The service VM will be deployed on the specified host in the specified server within the cluster if host_id is specified. Note: You must ensure that storage and specified networks are accessible by this host.  | [optional] 
**compute_id** | **String** | Resource Pool or Compute Id. | 


