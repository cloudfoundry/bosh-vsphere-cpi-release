# SwaggerClient::IpDiscoverySwitchingProfile

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
**required_capabilities** | **Array&lt;String&gt;** |  | [optional] 
**arp_snooping_enabled** | **BOOLEAN** | Indicates whether ARP snooping is enabled | [optional] [default to true]
**arp_bindings_limit** | **Integer** | Indicates the number of arp snooped IP addresses to be remembered per LogicalPort. Decreasing this value, will retain the latest bindings from the existing list of address bindings. Increasing this value will retain existing bindings and also learn any new address bindings discovered on the port until the new limit is reached. This limit only applies to IPv4 addresses and is independent of the nd_bindings_limit used for IPv6 snooping. | [optional] [default to 1]
**dhcpv6_snooping_enabled** | **BOOLEAN** | This option is the IPv6 equivalent of DHCP snooping. | [optional] [default to false]
**nd_snooping_enabled** | **BOOLEAN** | This option is the IPv6 equivalent of ARP snooping. | [optional] [default to false]
**vm_tools_v6_enabled** | **BOOLEAN** | This option is only supported on ESX where vm-tools is installed. | [optional] [default to false]
**dhcp_snooping_enabled** | **BOOLEAN** | Indicates whether DHCP snooping is enabled | [optional] [default to true]
**arp_nd_binding_timeout** | **Integer** | This property controls the ARP and ND cache timeout period.It is recommended that this property be greater than the ARP/ND cache timeout on the VM.  | [optional] [default to 10]
**vm_tools_enabled** | **BOOLEAN** | This option is only supported on ESX where vm-tools is installed. | [optional] [default to true]
**trust_on_first_use_enabled** | **BOOLEAN** | ARP snooping being inherently susceptible to ARP spoofing, uses a turst-on-fisrt-use (TOFU) paradigm where only the first IP address discovered via ARP snooping is trusted. The remaining are ignored. In order to allow for more flexibility, we allow the user to configure how many ARP snooped address bindings should be trusted for the lifetime of the logical port. This is controlled by the arp_bindings_limit property in the IP Discovery profile. We refer to this extension of TOFU as N-TOFU. However, if TOFU is disabled, then N ARP snooped IP addresses will be trusted until they are timed out, where N is configured by arp_bindings_limit.  | [optional] [default to true]
**nd_bindings_limit** | **Integer** | Indicates the number of neighbor-discovery snooped IP addresses to be remembered per LogicalPort. Decreasing this value, will retain the latest bindings from the existing list of address bindings. Increasing this value will retain existing bindings and also learn any new address bindings discovered on the port until the new limit is reached. This limit only applies to IPv6 addresses and is independent of the arp_bindings_limit used for IPv4 snooping. | [optional] [default to 3]
**duplicate_ip_detection** | [**DuplicateIPDetection**](DuplicateIPDetection.md) | Duplicate IP detection is used to determine if there is any IP conflict with any other port on the same logical switch. If a conflict is detected, then the IP is marked as a duplicate on the port where the IP was discovered last. The duplicate IP will not be added to the realized address binings for the port and hence will not be used in DFW rules or other security configurations for the port.  | [optional] 


