# SwaggerClient::TunnelProperties

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**status** | **String** | Status of tunnel | [optional] 
**egress_interface** | **String** | Corresponds to the interface where local_ip_address is routed. | [optional] 
**remote_node_display_name** | **String** | Represents the display name of the remote transport node at the other end of the tunnel. | [optional] 
**remote_node_id** | **String** | UUID of the remote transport node | [optional] 
**encap** | **String** | Tunnel encap | [optional] 
**bfd** | [**BFDProperties**](BFDProperties.md) | Detailed information about BFD configured on interface | [optional] 
**name** | **String** | Name of tunnel | [optional] 
**local_ip** | **String** | Local IP address of tunnel | [optional] 
**last_updated_time** | **Integer** | Time at which the Tunnel status has been fetched last time. | [optional] 
**remote_ip** | **String** | Remote IP address of tunnel | [optional] 


