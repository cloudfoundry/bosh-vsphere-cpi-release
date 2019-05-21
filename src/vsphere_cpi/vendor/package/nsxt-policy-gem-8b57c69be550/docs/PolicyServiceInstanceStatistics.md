# SwaggerClient::PolicyServiceInstanceStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**service_instance_id** | **String** | PolicyServiceInsatnce path | [optional] 
**instance_runtime_statistics** | [**Array&lt;InstanceRuntimeStatistic&gt;**](InstanceRuntimeStatistic.md) | Statistics for the data NICs for all the runtimes associated with this service instance.  | [optional] 
**enforcement_point_path** | **String** | Enforcement point path, forward slashes must be escaped using %2F.  | [optional] 


