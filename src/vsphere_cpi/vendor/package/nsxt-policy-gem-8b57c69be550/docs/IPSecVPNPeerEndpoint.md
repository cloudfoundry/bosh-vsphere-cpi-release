# SwaggerClient::IPSecVPNPeerEndpoint

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
**psk** | **String** | IPSec Pre-shared key. Maximum length of this field is 128 characters. | [optional] 
**peer_id** | **String** | Peer identifier. | 
**ipsec_tunnel_profile_id** | **String** | Tunnel profile id to be used. By default it will point to system default profile. | [optional] 
**authentication_mode** | **String** | Authentication mode used for the peer authentication. For PSK (Pre Shared Key) authentication mode, &#39;psk&#39; property is mandatory and for the CERTIFICATE authentication mode, &#39;peer_id&#39; property is mandatory. | [optional] [default to &#39;PSK&#39;]
**peer_address** | **String** | IPV4 address of peer endpoint on remote site. | 
**connection_initiation_mode** | **String** | Connection initiation mode used by local endpoint to establish ike connection with peer endpoint. INITIATOR - In this mode local endpoint initiates tunnel setup and will also respond to incoming tunnel setup requests from peer gateway. RESPOND_ONLY - In this mode, local endpoint shall only respond to incoming tunnel setup requests. It shall not initiate the tunnel setup. ON_DEMAND - In this mode local endpoint will initiate tunnel creation once first packet matching the policy rule is received and will also respond to incoming initiation request.  | [optional] [default to &#39;INITIATOR&#39;]
**dpd_profile_id** | **String** | Dead peer detection (DPD) profile id. Default will be set according to system default policy. | [optional] 
**ike_profile_id** | **String** | IKE profile id to be used. Default will be set according to system default policy. | [optional] 


