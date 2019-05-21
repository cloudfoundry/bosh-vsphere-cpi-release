# SwaggerClient::ServiceInstance

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
**resource_type** | **String** | ServiceInstance is used when NSX handles the lifecyle of   appliance. Deployment and appliance related all the information is necessary. ByodServiceInstance is a custom instance to be used when NSX is not handling   the lifecycles of appliance/s. User will manage their own appliance (BYOD)   to connect with NSX. VirtualServiceInstance is a a custom instance to be used when NSX is not   handling the lifecycle of an appliance and when the user is not bringing   their own appliance.  | 
**on_failure_policy** | **String** | Failure policy of the service instance - if it has to be different from the service. By default the service instance inherits the FailurePolicy of the service it belongs to. | [optional] 
**transport_type** | **String** | Transport to be used by this service instance for deploying the Service-VM. This field is to be set Not Applicable(NA) if the service only caters to functionality EPP(Endpoint Protection). | 
**service_id** | **String** | The Service to which the service instance is associated. | [optional] 
**deployment_spec_name** | **String** | Name of the deployment spec to be used by this service instance. | 
**instance_deployment_template** | [**DeploymentTemplate**](DeploymentTemplate.md) | The deployment template to be used by this service instance. The attribute values specific to this instance can be added. | 
**implementation_type** | **String** | Implementation to be used by this service instance for deploying the Service-VM. | 
**attachment_point** | **String** | Attachment point to be used by this service instance for deploying the Service-VM. | 
**instance_deployment_config** | [**InstanceDeploymentConfig**](InstanceDeploymentConfig.md) | Instance Deployment Config contains the information to be injected during Service-VM deployment. This field is optional if the service only caters to functionality EPP(Endpoint Protection). | [optional] 
**deployment_mode** | **String** | Deployment mode specifies where the partner appliance will be deployed in HA or non-HA i.e standalone mode. | [default to &#39;ACTIVE_STANDBY&#39;]
**deployed_to** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of resource references where service instance be deployed. Ex. Tier 0 Logical Router in case of N-S ServiceInsertion. | 
**service_deployment_id** | **String** | Id of the Service Deployment using which the instances were deployed. Its available only for instances that were deployed using service deployment API. | [optional] 


