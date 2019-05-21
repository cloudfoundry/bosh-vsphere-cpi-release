# SwaggerClient::SIPacketsDroppedBySecurity

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**spoof_guard_dropped** | [**Array&lt;SIPacketTypeAndCounter&gt;**](SIPacketTypeAndCounter.md) | The packets dropped by \&quot;Spoof Guard\&quot;; supported packet types are IPv4, IPv6, ARP, ND, non-IP. | [optional] 
**dhcp_server_dropped_ipv4** | **Integer** | The number of IPv4 packets dropped by \&quot;DHCP server block\&quot;. | [optional] 
**dhcp_server_dropped_ipv6** | **Integer** | The number of IPv6 packets dropped by \&quot;DHCP server block\&quot;. | [optional] 
**dhcp_client_dropped_ipv4** | **Integer** | The number of IPv4 packets dropped by \&quot;DHCP client block\&quot;. | [optional] 
**bpdu_filter_dropped** | **Integer** | The number of packets dropped by \&quot;BPDU filter\&quot;. | [optional] 
**dhcp_client_dropped_ipv6** | **Integer** | The number of IPv6 packets dropped by \&quot;DHCP client block\&quot;. | [optional] 


