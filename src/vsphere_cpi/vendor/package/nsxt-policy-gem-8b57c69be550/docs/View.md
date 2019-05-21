# SwaggerClient::View

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_system_owned** | **BOOLEAN** | Indicates system owned resource | [optional] 
**display_name** | **String** | Title of the widget. | 
**description** | **String** | Description of this resource | [optional] 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**_create_user** | **String** | ID of the user who created this resource | [optional] 
**_protection** | **String** | Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite&#x3D;true. UNKNOWN - the _protection field could not be determined for this           entity.  | [optional] 
**_create_time** | **Integer** | Timestamp of resource creation | [optional] 
**_last_modified_time** | **Integer** | Timestamp of last modification | [optional] 
**_last_modified_user** | **String** | ID of the user who last modified this resource | [optional] 
**id** | **String** | Unique identifier of this resource | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**include_roles** | **String** | Comma separated list of roles to which the shared view is visible. Allows user to specify the visibility of a shared view to the specified roles. User defined roles can also be specified in the list. The roles can be obtained via GET /api/v1/aaa/roles. Please visit API documentation for details about roles. | [optional] 
**exclude_roles** | **String** | Comma separated list of roles to which the shared view is not visible. Allows user to prevent the visibility of a shared view to the specified roles. User defined roles can also be specified in the list. The roles can be obtained via GET /api/v1/aaa/roles. Please visit API documentation for details about roles. If include_roles is specified then exclude_roles cannot be specified. | [optional] 
**weight** | **Integer** | Determines placement of view relative to other views. The lower the weight, the higher it is in the placement order. | [optional] [default to 10000]
**widgets** | [**Array&lt;WidgetItem&gt;**](WidgetItem.md) | Array of widgets that are part of the view. | 
**shared** | **BOOLEAN** | Defaults to false. Set to true to publish the view to other users. The widgets of a shared view are visible to other users. | [optional] [default to false]


