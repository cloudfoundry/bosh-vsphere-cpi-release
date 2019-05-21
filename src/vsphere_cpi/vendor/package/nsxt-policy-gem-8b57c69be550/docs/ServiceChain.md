# SwaggerClient::ServiceChain

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
**reverse_path_service_profiles** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of ServiceInsertionServiceProfiles id. Reverse path service profiles are applied to egress traffic and is optional. 2 different set of profiles can be defined for forward and reverse path. If not defined, the reverse of the forward path service profile is applied. | [optional] 
**service_attachments** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | Service attachment specifies the scope i.e Service plane at which the SVMs are deployed. | 
**forward_path_service_profiles** | [**Array&lt;ResourceReference&gt;**](ResourceReference.md) | List of ServiceInsertionServiceProfiles that constitutes the the service chain. The forward path service profiles are applied to ingress traffic. | 
**service_chain_id** | **String** | A unique id generated for every service chain. This is not a uuid. | [optional] 
**path_selection_policy** | **String** | Path selection policy can be - ANY - Service Insertion is free to redirect to any service path regardless of any load balancing considerations or flow pinning. LOCAL - means to prefer local service insances. REMOTE - preference is to redirect to the SVM co-located on the same host. | [optional] [default to &#39;ANY&#39;]
**on_failure_policy** | **String** | Failure policy for the service tells datapath, the action to take i.e to allow or block traffic during failure scenarios. | [optional] [default to &#39;ALLOW&#39;]


