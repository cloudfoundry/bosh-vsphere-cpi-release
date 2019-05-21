# SwaggerClient::IPv6DiscoveryOptions

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**nd_snooping_config** | [**NdSnoopingConfig**](NdSnoopingConfig.md) | Indicates ND snooping options | [optional] 
**dhcp_snooping_v6_enabled** | **BOOLEAN** | Enable this method will snoop the DHCPv6 message transaction which a VM makes with a DHCPv6 server. From the transaction, we learn the IPv6 addresses assigned by the DHCPv6 server to this VM along with its lease time.  | [optional] [default to false]
**vmtools_v6_enabled** | **BOOLEAN** | Enable this method will learn the IPv6 addresses which are configured on interfaces of a VM with the help of the VMTools software.  | [optional] [default to false]


