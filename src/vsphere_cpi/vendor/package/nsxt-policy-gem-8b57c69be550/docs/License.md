# SwaggerClient::License

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**features** | **String** | semicolon delimited feature list | [optional] 
**description** | **String** | license edition | [optional] 
**product_version** | **String** | product version | [optional] 
**expiry** | **Integer** | date that license expires | [optional] 
**is_eval** | **BOOLEAN** | true for evalution license | [optional] 
**is_mh** | **BOOLEAN** | multi-hypervisor support | [optional] 
**license_key** | **String** | license key | [optional] 
**is_expired** | **BOOLEAN** | whether the license has expired | [optional] 
**product_name** | **String** | product name | [optional] 
**capacity_type** | **String** | License metrics specifying the capacity type of license key. Types are: - VM - CPU - USER(Concurrent User)  | [optional] 
**quantity** | **Integer** | license capacity; 0 for unlimited | [optional] 


