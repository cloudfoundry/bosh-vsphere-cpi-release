# SwaggerClient::LbSnatAutoMap

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**type** | **String** | Load balancers may need to perform SNAT to ensure reverse traffic from the server can be received and processed by them. There are two modes: LbSnatAutoMap uses the load balancer interface IP and an ephemeral port as the source IP and port of the server side connection. LbSnatIpPool allows user to specify one or more IP addresses along with their subnet masks that should be used for SNAT while connecting to any of the servers in the pool.  | 
**port_overload** | **Integer** | Both SNAT automap and SNAT IP list modes support port overloading which allows the same SNAT IP and port to be used for multiple backend connections as long as the tuple (source IP, source port, destination IP, destination port, IP protocol) after SNAT is performed is unique. The valid number is 1, 2, 4, 8, 16, 32. This is a deprecated property. The port overload factor is fixed to 32 in load balancer engine. If it is upgraded from an old version, the value would be changed to 32 automatically.  | [optional] [default to 32]


