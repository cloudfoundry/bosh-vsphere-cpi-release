# SwaggerClient::LBSourceIpPersistenceProfile

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
**resource_type** | **String** |  | 
**path** | **String** | Absolute path of this object | [optional] 
**parent_path** | **String** | Path of its parent | [optional] 
**relative_path** | **String** | Path relative from its parent | [optional] 
**children** | [**Array&lt;ChildPolicyConfigResource&gt;**](ChildPolicyConfigResource.md) | subtree for this type within policy tree containing nested elements.  | [optional] 
**marked_for_delete** | **BOOLEAN** | Intent objects are not directly deleted from the system when a delete is invoked on them. They are marked for deletion and only when all the realized entities for that intent object gets deleted, the intent object is deleted. Objects that are marked for deletion are not returned in GET call. One can use the search API to get these objects.  | [optional] [default to false]
**persistence_shared** | **BOOLEAN** | Persistence shared setting indicates that all LBVirtualServers that consume this LBPersistenceProfile should share the same persistence mechanism when enabled.  Meaning, persistence entries of a client accessing one virtual server will also affect the same client&#39;s connections to a different virtual server. For example, say there are two virtual servers vip-ip1:80 and vip-ip1:8080 bound to the same Group g1 consisting of two servers (s11:80 and s12:80). By default, each virtual server will have its own persistence table or cookie. So, in the earlier example, there will be two tables (vip-ip1:80, p1) and (vip-ip1:8080, p1) or cookies. So, if a client connects to vip1:80 and later connects to vip1:8080, the second connection may be sent to a different server than the first.  When persistence_shared is enabled, then the second connection will always connect to the same server as the original connection. For COOKIE persistence type, the same cookie will be shared by multiple virtual servers. For SOURCE_IP persistenct type, the persistence table will be shared across virtual servers.  | [optional] [default to false]
**purge** | **String** | Persistence purge setting. | [optional] [default to &#39;FULL&#39;]
**ha_persistence_mirroring_enabled** | **BOOLEAN** | Persistence entries are not synchronized to the HA peer by default.  | [optional] [default to false]
**timeout** | **Integer** | When all connections complete (reference count reaches 0), persistence entry timer is started with the expiration time.  | [optional] [default to 300]


