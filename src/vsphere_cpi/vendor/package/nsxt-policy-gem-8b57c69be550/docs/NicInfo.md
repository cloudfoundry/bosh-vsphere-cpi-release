# SwaggerClient::NicInfo

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**subnet_mask** | **String** | Subnet mask associated with the NIC metadata. | [optional] 
**gateway_address** | **String** | Gateway address associated with the NIC metadata. | [optional] 
**nic_metadata** | [**NicMetadata**](NicMetadata.md) | NIC metadata information. | [optional] 
**network_id** | **String** | Network Id associated with the NIC metadata. It can be a moref, or a logical switch ID. If it is to be taken from &#39;Agent VM Settings&#39;, then it should be empty. | [optional] 
**ip_pool_id** | **String** | If the nic should get IP using a static IP pool then IP pool id should be provided here. | [optional] 
**ip_address** | **String** | IP address associated with the NIC metadata. Required only when assigning IP statically for a deployment that is for a single VM instance. | [optional] 


