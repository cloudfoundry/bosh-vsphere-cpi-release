# SwaggerClient::SegmentAdvancedConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**connectivity** | **String** | Connectivity configuration to manually connect (ON) or disconnect (OFF) a logical entity from network topology.  | [optional] [default to &#39;ON&#39;]
**address_pool_paths** | **Array&lt;String&gt;** | Policy path to IP address pools.  | [optional] 
**hybrid** | **BOOLEAN** | When set to true, all the ports created on this segment will behave in a hybrid fashion. The hybrid port indicates to NSX that the VM intends to operate in underlay mode, but retains the ability to forward egress traffic to the NSX overlay network. This property is only applicable for segment created with transport zone type OVERLAY_STANDARD. This property cannot be modified after segment is created.  | [optional] [default to false]


