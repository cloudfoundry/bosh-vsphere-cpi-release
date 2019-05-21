# SwaggerClient::CommunicationMap

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
**communication_entries** | [**Array&lt;CommunicationEntry&gt;**](CommunicationEntry.md) | CommunicationEntries that are a part of this CommunicationMap | [optional] 
**category** | **String** | - Distributed Firewall - Policy framework for Distributed Firewall provides four pre-defined categories for classifying a communication map. They are \&quot;Emergency\&quot;, \&quot;Infrastructure\&quot;, \&quot;Environment\&quot; and \&quot;Application\&quot;. Amongst the layer 3 communication maps,there is a pre-determined order in which the policy framework manages the priority of these communication maps. Emergency category has the highest priority followed by Infrastructure, Environment and then Application rules. Administrator can choose to categorize a communication  map into the above categories or can choose to leave it empty. If empty it will have the least precedence w.r.t the above four layer 3 categories.  | [optional] 
**precedence** | **Integer** | This field is used to resolve conflicts between communication maps across domains. In order to change the precedence of a communication map, it is recommended to send a PUT request to the following URL /infra/domains/&lt;domain-id&gt;/communication-map?action&#x3D;revise The precedence field will reflect the value of the computed precedence upon execution of the above mentioned PUT request. For scenarios where the administrator is using a template to update several communication maps, the only way to set the precedence is to explicitly specify the precedence number for each communication map.  | [optional] 


