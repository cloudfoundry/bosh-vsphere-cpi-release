# SwaggerClient::SegmentSubnet

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**gateway_address** | **String** | Gateway IP address in CIDR format for both IPv4 and IPv6.  | [optional] 
**dhcp_ranges** | **Array&lt;String&gt;** | DHCP address ranges are used for dynamic IP allocation. Supports address range and CIDR formats. First valid host address from the first value is assigned to DHCP server IP address. Existing values cannot be deleted or modified, but additional DHCP ranges can be added.  | [optional] 
**network** | **String** | Network CIDR for this subnet calculated from gateway_addresses and prefix_len.  | [optional] 


