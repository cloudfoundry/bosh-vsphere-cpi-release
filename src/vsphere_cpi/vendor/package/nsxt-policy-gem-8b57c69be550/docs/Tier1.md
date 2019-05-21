# SwaggerClient::Tier1

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
**failover_mode** | **String** | Determines the behavior when a Tier-1 instance in ACTIVE-STANDBY high-availability mode restarts after a failure. If set to PREEMPTIVE, the preferred node will take over, even if it causes another failure. If set to NON_PREEMPTIVE, then the instance that restarted will remain secondary. This property must not be populated unless the ha_mode property is set to ACTIVE_STANDBY.  | [optional] [default to &#39;NON_PREEMPTIVE&#39;]
**force_whitelisting** | **BOOLEAN** | Flag to add whitelisting FW rule during realization | [optional] [default to false]
**route_advertisement_types** | **Array&lt;String&gt;** | Enable different types of route advertisements.  | [optional] 
**default_rule_logging** | **BOOLEAN** | Indicates if logging should be enabled for the default whitelisting rule.  | [optional] [default to false]
**tier0_path** | **String** | Specify Tier-1 connectivity to Tier-0 instance.  | [optional] 
**dhcp_config_paths** | **Array&lt;String&gt;** | DHCP configuration for Segments connected to Tier-1. DHCP service is enabled in relay mode.  | [optional] 
**disable_firewall** | **BOOLEAN** | Disable or enable gateway fiewall. | [optional] [default to false]


