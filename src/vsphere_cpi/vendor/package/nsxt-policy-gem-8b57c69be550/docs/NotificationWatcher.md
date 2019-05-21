# SwaggerClient::NotificationWatcher

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_system_owned** | **BOOLEAN** | Indicates system owned resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**description** | **String** | Optional description that can be associated with this NotificationWatcher. | [optional] 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**_create_user** | **String** | ID of the user who created this resource | [optional] 
**_protection** | **String** | Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite&#x3D;true. UNKNOWN - the _protection field could not be determined for this           entity.  | [optional] 
**_create_time** | **Integer** | Timestamp of resource creation | [optional] 
**_last_modified_time** | **Integer** | Timestamp of last modification | [optional] 
**_last_modified_user** | **String** | ID of the user who last modified this resource | [optional] 
**id** | **String** | System generated identifier to identify a notification watcher uniquely.  | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**certificate_sha256_thumbprint** | **String** | Contains the hex-encoded SHA256 thumbprint of the HTTPS certificate. It must be specified if use_https is set to true. | [optional] 
**method** | **String** | Type of method notification requests should be made on the specified server. The value must be set to POST. | 
**authentication_scheme** | [**NotificationAuthenticationScheme**](NotificationAuthenticationScheme.md) | A NotificationAuthenticationScheme that describes how notification requests should authenticate to the server. | 
**port** | **Integer** | Optional integer port value to specify a non-standard HTTP or HTTPS port. | [optional] 
**uri** | **String** | URI notification requests should be made on the specified server. | 
**use_https** | **BOOLEAN** | Optional field, when set to true indicates REST API server should use HTTPS. | [optional] [default to false]
**server** | **String** | IP address or fully qualified domain name of the partner/customer watcher. | 


