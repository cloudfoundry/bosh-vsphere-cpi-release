# SwaggerClient::RouteMapSequenceSet

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**local_preference** | **Integer** | Local preference indicates the degree of preference for one BGP route over other BGP routes. The path/route with highest local preference value is preferred/selected. If local preference value is not specified then it will be considered as 100 by default.  | [optional] 
**as_path_prepend** | **String** | As Path Prepending to influence path selection | [optional] 
**community** | **String** | Either well-known community name or community value in aa:nn(2byte:2byte) format | [optional] 
**weight** | **Integer** | Weight used to select certain path | [optional] 
**multi_exit_discriminator** | **Integer** | Multi Exit Discriminator (MED) | [optional] 


