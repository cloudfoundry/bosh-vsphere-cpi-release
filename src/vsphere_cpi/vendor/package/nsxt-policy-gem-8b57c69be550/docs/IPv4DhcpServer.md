# SwaggerClient::IPv4DhcpServer

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**dhcp_server_ip** | **String** | dhcp server ip in cidr format | 
**options** | [**DhcpOptions**](DhcpOptions.md) | Defines the default options for all ip-pools and static-bindings of this server. These options will be ignored if options are defined for ip-pools or static-bindings.  | [optional] 
**dns_nameservers** | **Array&lt;String&gt;** | dns ips | [optional] 
**domain_name** | **String** | domain name | [optional] 
**gateway_ip** | **String** | gateway ip | [optional] 


