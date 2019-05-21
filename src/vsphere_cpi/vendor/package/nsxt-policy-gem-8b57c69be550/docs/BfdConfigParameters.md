# SwaggerClient::BfdConfigParameters

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**receive_interval** | **Integer** | The time interval (in milliseconds) between heartbeat packets for BFD when receiving heartbeats.| For edge cluster type of bare metal, this value should be &gt;&#x3D; 300ms.| For edge cluster type of virtual machine or hybrid, this value should be &gt;&#x3D; 1000ms. | [optional] [default to 1000]
**declare_dead_multiple** | **Integer** | Number of times a packet is missed before BFD declares the neighbor down. | [optional] [default to 3]
**transmit_interval** | **Integer** | The time interval (in milliseconds) between heartbeat packets for BFD when sending heartbeats.| For edge cluster type of bare metal, this value should be &gt;&#x3D; 300ms.| For edge cluster type of virtual machine or hybrid, this value should be &gt;&#x3D; 1000ms. | [optional] [default to 1000]


