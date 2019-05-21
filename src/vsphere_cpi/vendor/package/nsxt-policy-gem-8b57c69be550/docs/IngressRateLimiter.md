# SwaggerClient::IngressRateLimiter

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**enabled** | **BOOLEAN** |  | 
**resource_type** | **String** | Type rate limiter  | 
**peak_bandwidth** | **Integer** | The peak bandwidth rate is used to support burst traffic. | [optional] [default to 0]
**average_bandwidth** | **Integer** | You can use the average bandwidth to reduce network congestion. | [optional] [default to 0]
**burst_size** | **Integer** | The burst duration is set in the burst size setting. | [optional] [default to 0]


