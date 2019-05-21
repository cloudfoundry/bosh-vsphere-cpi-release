# SwaggerClient::RouteBasedL3VpnSession

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** | - A Policy Based L3Vpn is a configuration in which protect rules to match local and remote subnet needs to be defined. Tunnel is established for each pair of local and remote subnet defined in protect rules. - A Route Based L3Vpn is more flexible, more powerful and recommended over policy based. IP Tunnel subnet is created and all traffic routed through tunnel subnet (commonly known as VTI) is sent over tunnel. Routes can be learned through BGP. A route based L3Vpn is required when using redundant L3Vpn.  | 
**routing_config_path** | **String** | Policy path referencing the bgp neighbor for a route based L3Vpn. - For an L3Vpn transporting L2Vpn, it is not necessary to provide bgp neighbor configuration. - For an L3Vpn not transporting L2Vpn, this property is necessary.  | [optional] 
**tunnel_subnets** | [**Array&lt;TunnelSubnet&gt;**](TunnelSubnet.md) | Virtual tunnel interface (VTI) port IP subnets to be used to configure route-based L3Vpn session. A max of one tunnel subnet is allowed.  | 
**default_rule_logging** | **BOOLEAN** | Indicates if logging should be enabled for the default whitelisting rule for the VTI interface.  | [optional] [default to false]
**force_whitelisting** | **BOOLEAN** | The default firewall rule Action is set to DROP if true otherwise set to ALLOW.  | [optional] [default to false]


