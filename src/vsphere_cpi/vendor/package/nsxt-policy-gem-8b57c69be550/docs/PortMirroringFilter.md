# SwaggerClient::PortMirroringFilter

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**filter_action** | **String** | If set to MIRROR, packets will be mirrored. If set to DO_NOT_MIRROR, packets will not be mirrored. | [optional] [default to &#39;MIRROR&#39;]
**ip_protocol** | **String** | The transport protocols of TCP or UDP, used to match the transport protocol of a packet. If not provided, no filtering by IP protocols is performed. | [optional] 
**src_ips** | [**IPAddresses**](IPAddresses.md) | Source IP in the form of IPAddresses, used to match the source IP of a packet. If not provided, no filtering by source IPs is performed. | [optional] 
**dst_ips** | [**IPAddresses**](IPAddresses.md) | Destination IP in the form of IPAddresses, used to match the destination IP of a packet. If not provided, no filtering by destination IPs is performed. | [optional] 
**dst_ports** | **String** | Destination port in the form of a port or port range, used to match the destination port of a packet. If not provided, no filtering by destination port is performed. | [optional] 
**src_ports** | **String** | Source port in the form of a port or port range, used to match the source port of a packet. If not provided, no filtering by source port is performed. | [optional] 


