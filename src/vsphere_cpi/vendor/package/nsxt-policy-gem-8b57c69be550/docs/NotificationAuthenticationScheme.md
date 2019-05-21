# SwaggerClient::NotificationAuthenticationScheme

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**username** | **String** | Username to use if scheme_name is BASIC_AUTH. | [optional] 
**certificate_id** | **String** | Certificate ID with a valid certificate and private key, procured from trust-management API. | [optional] 
**scheme_name** | **String** | Authentication scheme to use when making notification requests to the partner/customer specified watcher. Specify one of BASIC_AUTH or CERTIFICATE. | 
**password** | **String** | Password to use if scheme_name is BASIC_AUTH. | [optional] 


