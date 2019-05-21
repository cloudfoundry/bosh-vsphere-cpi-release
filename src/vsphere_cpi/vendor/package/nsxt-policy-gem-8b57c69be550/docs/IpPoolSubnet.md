# SwaggerClient::IpPoolSubnet

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**dns_nameservers** | **Array&lt;String&gt;** | The collection of upto 3 DNS servers for the subnet. | [optional] 
**cidr** | **String** | Represents network address and the prefix length which will be associated with a layer-2 broadcast domain | 
**gateway_ip** | **String** | The default gateway address on a layer-3 router. | [optional] 
**allocation_ranges** | [**Array&lt;IpPoolRange&gt;**](IpPoolRange.md) | A collection of IPv4 or IPv6 IP Pool Ranges. | 
**dns_suffix** | **String** | The DNS suffix for the DNS server. | [optional] 


