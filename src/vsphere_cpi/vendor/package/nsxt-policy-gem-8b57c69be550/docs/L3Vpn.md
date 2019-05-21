# SwaggerClient::L3Vpn

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
**remote_private_address** | **String** | This field is used to resolve conflicts in case of a remote site being behind NAT as remote public ip address is not enough. If it is not the case the remote public address should be provided here. If not provided, the value of this field is set to remote_public_address.  | [optional] 
**tunnel_digest_algorithms** | **Array&lt;String&gt;** | Algorithm to be used for message digest during tunnel establishment. Default algorithm is empty.  | [optional] 
**passphrases** | **Array&lt;String&gt;** | List of IPSec pre-shared keys used for IPSec authentication. If not specified, the older passphrase values are retained if there are any.  | [optional] 
**enable_perfect_forward_secrecy** | **BOOLEAN** | If true, perfect forward secrecy (PFS) is enabled.  | [optional] [default to true]
**ike_digest_algorithms** | **Array&lt;String&gt;** | Algorithm to be used for message digest during Internet Key Exchange(IKE) negotiation. Default is SHA2_256.  | [optional] 
**ike_version** | **String** | IKE protocol version to be used. IKE-Flex will initiate IKE-V2 and responds to both IKE-V1 and IKE-V2.  | [optional] [default to &#39;IKE_V2&#39;]
**ike_encryption_algorithms** | **Array&lt;String&gt;** | Algorithm to be used during Internet Key Exchange(IKE) negotiation. Default is AES_128.  | [optional] 
**local_address** | **String** | IPv4 address of local gateway | 
**l3vpn_session** | [**L3VpnSession**](L3VpnSession.md) | L3Vpn Session | 
**dh_groups** | **Array&lt;String&gt;** | Diffie-Hellman group to be used if PFS is enabled. Default group is GROUP14.  | [optional] 
**tunnel_encryption_algorithms** | **Array&lt;String&gt;** | Encryption algorithm to encrypt/decrypt the messages exchanged between IPSec VPN initiator and responder during tunnel negotiation. Default is AES_GCM_128.  | [optional] 
**enabled** | **BOOLEAN** | Flag to enable L3Vpn. Default is enabled.  | [optional] [default to true]
**remote_public_address** | **String** | Public IPv4 address of remote gateway | 


