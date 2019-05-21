# SwaggerClient::ConditionalForwarderZone

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**upstream_servers** | **Array&lt;String&gt;** | Ip address of the upstream dns servers the dns forwarder accesses.  | 
**source_ip** | **String** | The source ip used by the fowarder of the zone. If no source ip specified, the ip address of listener of the dns forwarder will be used.  | [optional] 
**domain_names** | **Array&lt;String&gt;** | A forwarder domain name should be a valid FQDN. If reverse lookup is needed for this zone, reverse lookup domain name like X.in-addr.arpa can be defined. Here the X represents a subnet.  | 


