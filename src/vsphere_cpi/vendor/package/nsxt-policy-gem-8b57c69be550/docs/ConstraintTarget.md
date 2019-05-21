# SwaggerClient::ConstraintTarget

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**attribute** | **String** | Attribute name of the target entity. | [optional] 
**path_prefix** | **String** | Path prefix of the entity to apply constraint. This is required to further disambiguiate if multiple policy entities share the same resource type. Example - Edge FW and DFW use the same resource type CommunicationMap, CommunicationEntry, Group, etc.  | [optional] 
**target_resource_type** | **String** | Resource type of the target entity. | 


