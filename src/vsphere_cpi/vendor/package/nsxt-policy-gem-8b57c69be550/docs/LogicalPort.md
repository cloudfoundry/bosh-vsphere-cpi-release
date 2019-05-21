# SwaggerClient::LogicalPort

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
**logical_switch_id** | **String** | Id of the Logical switch that this port belongs to. | 
**init_state** | **String** | Set initial state when a new logical port is created. &#39;UNBLOCKED_VLAN&#39; means new port will be unblocked on traffic in creation, also VLAN will be set with corresponding logical switch setting.  | [optional] 
**switching_profile_ids** | [**Array&lt;SwitchingProfileTypeIdEntry&gt;**](SwitchingProfileTypeIdEntry.md) |  | [optional] 
**attachment** | [**LogicalPortAttachment**](LogicalPortAttachment.md) | Logical port attachment | [optional] 
**admin_state** | **String** | Represents Desired state of the logical port | 
**extra_configs** | [**Array&lt;ExtraConfig&gt;**](ExtraConfig.md) | This property could be used for vendor specific configuration in key value string pairs. Logical port setting will override logical switch setting if the same key was set on both logical switch and logical port.  | [optional] 
**address_bindings** | [**Array&lt;PacketAddressClassifier&gt;**](PacketAddressClassifier.md) | Each address binding must contain both an IPElement and MAC address. VLAN ID is optional. This binding configuration can be used by features such as spoof-guard and overrides any discovered bindings. Any non unique entries are deduplicated to generate a unique set of address bindings and then stored. A maximum of 128 unique address bindings is allowed per port.  | [optional] 
**ignore_address_bindings** | [**Array&lt;PacketAddressClassifier&gt;**](PacketAddressClassifier.md) | IP Discovery module uses various mechanisms to discover address bindings being used on each port. If a user would like to ignore any specific discovered address bindings or prevent the discovery of a particular set of discovered bindings, then those address bindings can be provided here. Currently IP range in CIDR format is not supported.  | [optional] 


