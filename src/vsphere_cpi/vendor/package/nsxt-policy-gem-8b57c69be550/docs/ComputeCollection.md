# SwaggerClient::ComputeCollection

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
**origin_id** | **String** | Id of the compute manager from where this Compute Collection was discovered | [optional] 
**origin_properties** | [**Array&lt;KeyValuePair&gt;**](KeyValuePair.md) | Key-Value map of additional specific properties of compute collection in the Compute Manager  | [optional] 
**external_id** | **String** | External ID of the ComputeCollection in the source Compute manager, e.g. mo-ref in VC  | [optional] 
**owner_id** | **String** | Id of the owner of compute collection in the Compute Manager | [optional] 
**origin_type** | **String** | ComputeCollection type like VC_Cluster. Here the Compute Manager type prefix would help in differentiating similar named Compute Collection types from different Compute Managers  | [optional] 
**cm_local_id** | **String** | Local Id of the compute collection in the Compute Manager | [optional] 


