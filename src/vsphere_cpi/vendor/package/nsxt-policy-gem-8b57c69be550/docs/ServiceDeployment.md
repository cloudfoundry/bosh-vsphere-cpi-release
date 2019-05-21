# SwaggerClient::ServiceDeployment

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
**perimeter** | **String** | This indicates the deployment perimeter, such as a VC cluster or a host. | [optional] [default to &#39;HOST&#39;]
**deployment_spec_name** | **String** | Name of the deployment spec to be used for deployment, which specifies the OVF provided by the partner and the form factor. | 
**deployment_mode** | **String** | Mode of deployment. Currently, only stand alone deployment is supported. It is a single VM deployed through this deployment spec. In future, HA configurations will be supported here. | [optional] [default to &#39;STAND_ALONE&#39;]
**instance_deployment_template** | [**DeploymentTemplate**](DeploymentTemplate.md) | The deployment template to be used during the deployment to provide customized attributes to the service VM. | 
**service_deployment_config** | [**ServiceDeploymentConfig**](ServiceDeploymentConfig.md) | Deployment Config contains the deployment specification, such as the storage and network to be used along with the cluster where the service VM can be deployed. | 
**service_id** | **String** | The Service to which the service deployment is associated. | [optional] 
**clustered_deployment_count** | **Integer** | Number of instances in case of clustered deployment. | [optional] [default to 1]
**deployed_to** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of resource references where service instance be deployed. Ex. Tier 0 Logical Router in case of N-S ServiceInsertion. Service Attachment in case of E-W ServiceInsertion. | [optional] 
**deployment_type** | **String** | Specifies whether the service VM should be deployed on each host such that it provides partner service locally on the host, or whether the service VMs can be deployed as a cluster. If deployment_type is CLUSTERED, then the clustered_deployment_count should be provided. | [optional] [default to &#39;CLUSTERED&#39;]


