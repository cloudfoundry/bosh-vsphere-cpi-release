# SwaggerClient::ResourceAllocation

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**reservation** | **Float** | Minimum guaranteed bandwidth percentage | 
**traffic_type** | [**HostInfraTrafficType**](HostInfraTrafficType.md) | Resource allocation traffic type | 
**limit** | **Float** | The limit property specifies the maximum bandwidth allocation for a given traffic type and is expressed in percentage. The default value for this field is set to -1 which means the traffic is unbounded for the traffic type. All other negative values for this property is not supported and will be rejected by the API.  | 
**shares** | **Integer** | Shares | [default to 50]


