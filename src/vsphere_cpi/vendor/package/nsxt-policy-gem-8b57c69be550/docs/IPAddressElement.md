# SwaggerClient::IPAddressElement

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**ip_address** | **String** | IPElement can be a single IP address, IP address range or a Subnet. Its type can be of IPv4 or IPv6. Supported list of formats are \&quot;192.168.1.1\&quot;, \&quot;192.168.1.1-192.168.1.100\&quot;, \&quot;192.168.0.0/24\&quot;, \&quot;fe80::250:56ff:fe83:318c\&quot;, \&quot;fe80::250:56ff:fe83:3181-fe80::250:56ff:fe83:318c\&quot;, \&quot;fe80::250:56ff:fe83:318c/64\&quot;  | 


