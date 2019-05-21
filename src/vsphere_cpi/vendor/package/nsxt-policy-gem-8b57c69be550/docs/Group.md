# SwaggerClient::Group

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
**state** | **String** | Realization state of this group | [optional] 
**extended_expression** | [**Array&lt;Expression&gt;**](Expression.md) | Extended Expression allows additional higher level context to be specified for grouping criteria. (e.g. user AD group) This field allow users to specified user context as the source of a firewall rule for IDFW feature. Current version only support a single IdentityGroupExpression. In the future, this might expand to support other conjunction and non-conjunction expression.  The extended expression list must follow below criteria: 1. Contains a single IdentityGroupExpression. No conjunction expression is supported. 2. No other non-conjunction expression is supported, except for IdentityGroupExpression. 3. Each expression must be a valid Expression. See the definition of the Expression type for more information. 4. Extended expression are implicitly AND with expression. 5. No nesting can be supported if this value is used. 6. If a Group is using extended expression, this group must be the only member in the source field of an communication map.  | [optional] 
**expression** | [**Array&lt;Expression&gt;**](Expression.md) | The expression list must follow below criteria:   1. A non-empty expression list, must be of odd size. In a list, with   indices starting from 0, all non-conjunction expressions must be at   even indices, separated by a conjunction expression at odd   indices.   2. The total of ConditionExpression and NestedExpression in a list   should not exceed 5.   3. The total of IPAddressExpression, MACAddressExpression, external   IDs in an ExternalIDExpression and paths in a PathExpression must not exceed   500.   4. Each expression must be a valid Expression. See the definition of   the Expression type for more information.  | [optional] 


