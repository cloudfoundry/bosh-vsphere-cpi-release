# SwaggerClient::VirtualNetworkInterface

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
**mac_address** | **String** | MAC address of the virtual network interface. | 
**device_key** | **String** | Device key of the virtual network interface. | 
**host_id** | **String** | Id of the host on which the vm exists. | 
**owner_vm_id** | **String** | Id of the vm to which this virtual network interface belongs. | 
**vm_local_id_on_host** | **String** | Id of the vm unique within the host. | 
**external_id** | **String** | External Id of the virtual network inferface. | 
**lport_attachment_id** | **String** | LPort Attachment Id of the virtual network interface. | [optional] 
**ip_address_info** | [**Array&lt;IpAddressInfo&gt;**](IpAddressInfo.md) | IP Addresses of the the virtual network interface, from various sources. | [optional] 
**device_name** | **String** | Device name of the virtual network interface. | [optional] 


