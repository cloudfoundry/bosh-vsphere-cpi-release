# SwaggerClient::VirtualMachine

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
**source** | [**ResourceReference**](ResourceReference.md) | Reference of the Host or Public Cloud Gateway that reported the VM | [optional] 
**local_id_on_host** | **String** | Id of the vm unique within the host. | 
**type** | **String** | Virtual Machine type; Edge, Service VM or other. | [optional] 
**guest_info** | [**GuestInfo**](GuestInfo.md) | Guest virtual machine details include OS name, computer name of guest VM. Currently this is supported for guests on ESXi that have VMware Tools installed.  | [optional] 
**power_state** | **String** | Current power state of this virtual machine in the system. | 
**compute_ids** | **Array&lt;String&gt;** | List of external compute ids of the virtual machine in the format &#39;id-type-key:value&#39; , list of external compute ids [&#39;uuid:xxxx-xxxx-xxxx-xxxx&#39;, &#39;moIdOnHost:moref-11&#39;, &#39;instanceUuid:xxxx-xxxx-xxxx-xxxx&#39;] | 
**host_id** | **String** | Id of the host in which this virtual machine exists. | [optional] 
**external_id** | **String** | Current external id of this virtual machine in the system. | 


