# SwaggerClient::PolicyServiceInstance

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_system_owned** | **BOOLEAN** | Indicates system owned resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**description** | **String** | Description of this resource | [optional] 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**_create_user** | **String** | ID of the user who created this resource | [optional] 
**_protection** | **String** | Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite&#x3D;true. UNKNOWN - the _protection field could not be determined for this           entity.  | [optional] 
**_create_time** | **Integer** | Timestamp of resource creation | [optional] 
**_last_modified_time** | **Integer** | Timestamp of last modification | [optional] 
**_last_modified_user** | **String** | ID of the user who last modified this resource | [optional] 
**id** | **String** | Unique identifier of this resource | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**path** | **String** | Absolute path of this object | [optional] 
**parent_path** | **String** | Path of its parent | [optional] 
**relative_path** | **String** | Path relative from its parent | [optional] 
**children** | [**Array&lt;ChildPolicyConfigResource&gt;**](ChildPolicyConfigResource.md) | subtree for this type within policy tree containing nested elements.  | [optional] 
**marked_for_delete** | **BOOLEAN** | Intent objects are not directly deleted from the system when a delete is invoked on them. They are marked for deletion and only when all the realized entities for that intent object gets deleted, the intent object is deleted. Objects that are marked for deletion are not returned in GET call. One can use the search API to get these objects.  | [optional] [default to false]
**partner_service_name** | **String** | Unique name of Partner Service in the Marketplace | 
**transport_type** | **String** | Transport to be used while deploying Service-VM. | [optional] [default to &#39;L2_BRIDGE&#39;]
**deployment_mode** | **String** | Deployment mode specifies how the partner appliance will be deployed i.e. in HA or standalone mode. | [optional] [default to &#39;ACTIVE_STANDBY&#39;]
**primary_interface_mgmt_ip** | **String** | Management IP Address of primary interface of the Service | 
**context_id** | **String** | UUID of VCenter/Compute Manager as seen on NSX Manager, to which this service needs to be deployed. | [optional] 
**secondary_interface_mgmt_ip** | **String** | Management IP Address of secondary interface of the Service | 
**compute_id** | **String** | Id of the compute(ResourcePool) to which this service needs to be deployed. | 
**deployment_spec_name** | **String** | Form factor for the deployment of partner service. | 
**deployment_template_name** | **String** | Template for the deployment of partnet service. | 
**storage_id** | **String** | Id of the storage(Datastore). VC moref of Datastore to which this service needs to be deployed. | 
**attributes** | [**Array&lt;Attribute&gt;**](Attribute.md) | List of attributes specific to a partner for which the service is created. There attributes are passed on to the partner appliance. | 
**secondary_interface_network** | **String** | Path of Network to which secondary interface of the Service VM needs to be connected | 
**primary_interface_network** | **String** | Path of the Network to which primary interface of the Service VM needs to be connected | 
**failure_policy** | **String** | Failure policy for the Service VM. If this values is not provided, it will be defaulted to FAIL_CLOSE. | [optional] [default to &#39;BLOCK&#39;]


