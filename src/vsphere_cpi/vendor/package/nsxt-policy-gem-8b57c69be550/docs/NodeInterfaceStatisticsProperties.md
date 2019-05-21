# SwaggerClient::NodeInterfaceStatisticsProperties

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**tx_dropped** | **Integer** | Number of packets dropped | [optional] 
**rx_packets** | **Integer** | Number of packets received | [optional] 
**tx_carrier** | **Integer** | Number of carrier losses detected | [optional] 
**rx_bytes** | **Integer** | Number of bytes received | [optional] 
**tx_errors** | **Integer** | Number of transmit errors | [optional] 
**interface_id** | **String** | Interface ID | [optional] 
**tx_colls** | **Integer** | Number of collisions detected | [optional] 
**rx_frame** | **Integer** | Number of framing errors | [optional] 
**rx_errors** | **Integer** | Number of receive errors | [optional] 
**tx_bytes** | **Integer** | Number of bytes transmitted | [optional] 
**rx_dropped** | **Integer** | Number of packets dropped | [optional] 
**tx_packets** | **Integer** | Number of packets transmitted | [optional] 
**source** | **String** | Source of status data. | [optional] 


