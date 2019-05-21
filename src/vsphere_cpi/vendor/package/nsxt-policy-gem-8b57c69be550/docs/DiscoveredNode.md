# SwaggerClient::DiscoveredNode

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
**stateless** | **BOOLEAN** | The stateless property describes whether host persists its state across reboot or not. If state persists, value is set as false otherwise true. | [optional] 
**parent_compute_collection** | **String** | External id of the compute collection to which this node belongs | [optional] 
**certificate** | **String** | Certificate of the discovered node | [optional] 
**origin_id** | **String** | Id of the compute manager from where this node was discovered | [optional] 
**ip_addresses** | **Array&lt;String&gt;** | IP Addresses of the the discovered node. | [optional] 
**hardware_id** | **String** | Hardware Id is generated using system hardware info. It is used to retrieve fabric node of the esx. | [optional] 
**os_version** | **String** | OS version of the discovered node | [optional] 
**node_type** | **String** | Discovered Node type like Host | [optional] 
**os_type** | **String** | OS type of the discovered node | [optional] 
**origin_properties** | [**Array&lt;KeyValuePair&gt;**](KeyValuePair.md) | Key-Value map of additional specific properties of discovered node in the Compute Manager  | [optional] 
**external_id** | **String** | External id of the discovered node, ex. a mo-ref from VC | [optional] 
**cm_local_id** | **String** | Local Id of the discovered node in the Compute Manager | [optional] 


