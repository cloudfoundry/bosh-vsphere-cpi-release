# SwaggerClient::ServiceIP

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**is_arp_proxy_enabled** | **BOOLEAN** | Flag to denote status of ARP Proxy for service IP. | [optional] [default to false]
**ip_address** | **String** | Service IP address registerd by the service. | [optional] 
**is_loopback_enabled** | **BOOLEAN** | Flag to denote loopback status for service IP. | [optional] [default to false]
**service** | [**ResourceReference**](ResourceReference.md) | Service which registered the ip. | [optional] 
**is_advertised** | **BOOLEAN** | Flag to denote advertisement status of service IP to TIER0 LR. | [optional] [default to false]


