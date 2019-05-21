# SwaggerClient::VifAttachmentContext

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**allocate_addresses** | **String** | A flag to indicate whether to allocate addresses from allocation     pools bound to the parent logical switch.  | [optional] 
**resource_type** | **String** | Used to identify which concrete class it is | 
**vif_type** | **String** | Type of the VIF attached to logical port | 
**parent_vif_id** | **String** | VIF ID of the parent VIF if vif_type is CHILD | [optional] 
**app_id** | **String** | An application ID used to identify / look up a child VIF behind a parent VIF. Only effective when vif_type is CHILD.  | [optional] 
**traffic_tag** | **Integer** | Current we use VLAN id as the traffic tag. Only effective when vif_type is CHILD. Each logical port inside a container must have a unique traffic tag. If the traffic_tag is not unique, no error is generated, but traffic will not be delivered to any port with a non-unique tag.  | [optional] 
**transport_node_uuid** | **String** | Only effective when vif_type is INDEPENDENT. Each logical port inside a bare metal server or container must have a transport node UUID. We use transport node ID as transport node UUID.  | [optional] 


