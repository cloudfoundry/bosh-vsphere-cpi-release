# SwaggerClient::ALGTypeNSService

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** | The specific type of NSServiceElement | 
**alg** | **String** | The Application Layer Gateway (ALG) protocol. Please note, protocol NBNS_BROADCAST and NBDG_BROADCAST are  deprecated. Please use UDP protocol and create L4 Port Set type of service instead.  | 
**destination_ports** | **Array&lt;String&gt;** | The destination_port cannot be empty and must be a single value. | [optional] 
**source_ports** | **Array&lt;String&gt;** | Source ports | [optional] 


