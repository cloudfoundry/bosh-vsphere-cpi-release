# SwaggerClient::DnsForwarder

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
**conditional_forwarders** | [**Array&lt;ConditionalForwarderZone&gt;**](ConditionalForwarderZone.md) | The conditional zone forwarders. During matching a zone forwarder, the dns forwarder will use the conditional fowarder with the longest domain name that matches the query.  | [optional] 
**logical_router_id** | **String** | Specify the LogicalRouter where the DnsForwarder runs. The HA mode of the hosting LogicalRouter must be Active/Standby.  | 
**cache_size** | **Integer** | One dns answer cache entry will consume ~120 bytes. Hence 1 KB cache size can cache ~8 dns answer entries, and the default 1024 KB cache size can hold ~8k dns answer entries.  | [optional] [default to 1024]
**default_forwarder** | [**ForwarderZone**](ForwarderZone.md) | The default zone forwarder that catches all other domain names except those matched by conditional forwarder zone.  | 
**log_level** | **String** | Log level of the dns forwarder | [optional] [default to &#39;INFO&#39;]
**enabled** | **BOOLEAN** | Flag to enable/disable the forwarder | [optional] [default to true]
**listener_ip** | **String** | The ip address the dns forwarder listens on. It can be an ip address already owned by the logical-router uplink port or router-link, or a loopback port ip address. But it can not be a downlink port address. User needs to ensure the address is reachable via router or NAT from both client VMs and upstream servers. User will need to create Firewall rules if needed to allow such traffic on a Tier-1 or Tier-0.  | 


