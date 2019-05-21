# SwaggerClient::LogicalSwitch

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
**switch_type** | **String** | This readonly field indicates purpose of a LogicalSwitch. It is set by manager internally and any user provided values will not be honored. DEFAULT type LogicalSwitches are created for basic L2 connectivity by API users. SERVICE_PLANE type LogicalSwitches are system created service plane LogicalSwitches - Service Insertion service.  | [optional] 
**replication_mode** | **String** | Replication mode of the Logical Switch | [optional] 
**extra_configs** | [**Array&lt;ExtraConfig&gt;**](ExtraConfig.md) | This property could be used for vendor specific configuration in key value string pairs, the setting in extra_configs will be automatically inheritted by logical ports in the logical switch.  | [optional] 
**uplink_teaming_policy_name** | **String** | This name has to be one of the switching uplink teaming policy names listed inside the logical switch&#39;s TransportZone. If this field is not specified, the logical switch will not have a teaming policy associated with it and the host switch&#39;s default teaming policy will be used. | [optional] 
**transport_zone_id** | **String** | Id of the TransportZone to which this LogicalSwitch is associated | 
**ip_pool_id** | **String** | IP pool id that associated with a LogicalSwitch. | [optional] 
**vlan** | **Integer** | This property is dedicated to VLAN based network, to set VLAN of logical network. It is mutually exclusive with &#39;vlan_trunk_spec&#39;.  | [optional] 
**hybrid** | **BOOLEAN** | If this flag is set to true, then all the logical switch ports attached to this logical switch will behave in a hybrid fashion. The hybrid logical switch port indicates to NSX that the VM intends to operate in underlay mode, but retains the ability to forward egress traffic to the NSX overlay network. This flag can be enabled only for the logical switches in the overlay type transport zone which has host switch mode as STANDARD and also has either CrossCloud or CloudScope tag scopes. Only the NSX public cloud gateway (PCG) uses this flag, other host agents like ESX, KVM and Edge will ignore it. This property cannot be modified once the logical switch is created.  | [optional] [default to false]
**mac_pool_id** | **String** | Mac pool id that associated with a LogicalSwitch. | [optional] 
**vni** | **Integer** | Only for OVERLAY network. A VNI will be auto-allocated from the default VNI pool if not given; otherwise the given VNI has to be inside the default pool and not used by any other LogicalSwitch.  | [optional] 
**vlan_trunk_spec** | [**VlanTrunkSpec**](VlanTrunkSpec.md) | This property is used for VLAN trunk specification of logical switch. It&#39;s mutually exclusive with &#39;vlan&#39;. Also it could be set to do guest VLAN tagging in overlay network.  | [optional] 
**admin_state** | **String** | Represents Desired state of the Logical Switch | 
**address_bindings** | [**Array&lt;PacketAddressClassifier&gt;**](PacketAddressClassifier.md) | Address bindings for the Logical switch | [optional] 
**switching_profile_ids** | [**Array&lt;SwitchingProfileTypeIdEntry&gt;**](SwitchingProfileTypeIdEntry.md) |  | [optional] 


