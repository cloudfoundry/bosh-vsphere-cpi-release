# SwaggerClient::FirewallSessionTimerProfile

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
**resource_type** | **String** | Resource type to use as profile type | 
**tcp_closed** | **Integer** | The timeout value of connection in seconds after one endpoint sends an RST. | [default to 20]
**tcp_opening** | **Integer** | The timeout value of connection in seconds after a second packet has been transferred. | [default to 30]
**udp_single** | **Integer** | The timeout value of connection in seconds if the source host sends more than one packet but the destination host has never sent one back. | [default to 30]
**tcp_finwait** | **Integer** | The timeout value of connection in seconds after both FINs have been exchanged and connection is closed. | [default to 45]
**tcp_first_packet** | **Integer** | The timeout value of connection in seconds after the first packet has been sent. | [default to 120]
**tcp_closing** | **Integer** | The timeout value of connection in seconds after the first FIN has been sent. | [default to 120]
**tcp_established** | **Integer** | The timeout value of connection in seconds once the connection has become fully established. | [default to 43200]
**udp_multiple** | **Integer** | The timeout value of connection in seconds if both hosts have sent packets. | [default to 60]
**icmp_error_reply** | **Integer** | The timeout value for the connection after an ICMP error came back in response to an ICMP packet. | [default to 10]
**udp_first_packet** | **Integer** | The timeout value of connection in seconds after the first packet. This will be the initial timeout for the new UDP flow. | [default to 60]
**icmp_first_packet** | **Integer** | The timeout value of connection in seconds after the first packet. This will be the initial timeout for the new ICMP flow. | [default to 20]


