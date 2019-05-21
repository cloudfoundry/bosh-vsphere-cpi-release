# SwaggerClient::VmToolsInfo

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_last_sync_time** | **Integer** | Timestamp of last modification | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**description** | **String** | Description of this resource | [optional] 
**resource_type** | **String** | The type of this resource. | 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**source** | [**ResourceReference**](ResourceReference.md) | Reference of the Host or Public Cloud Gateway that reported the VM. | [optional] 
**vm_type** | **String** | Type of VM - Edge, Service or other. | [optional] 
**network_agent_version** | **String** | Version of network agent on the VM of a third party partner solution. | [optional] 
**host_local_id** | **String** | Id of the VM which is assigned locally by the host. It is the VM-moref on ESXi hosts, in other environments it is VM UUID. | [optional] 
**external_id** | **String** | Current external id of this virtual machine in the system. | [optional] 
**tools_version** | **String** | Version of VMTools installed on the VM. | [optional] 
**file_agent_version** | **String** | Version of file agent on the VM of a third party partner solution. | [optional] 


