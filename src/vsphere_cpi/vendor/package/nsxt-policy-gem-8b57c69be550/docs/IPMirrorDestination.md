# SwaggerClient::IPMirrorDestination

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** | Resource types of mirror destination | 
**destination_ips** | **Array&lt;String&gt;** | The destination IPs of the mirror packet will be sent to. | 
**encapsulation_type** | **String** | You can choose GRE, ERSPAN II or ERSPAN III. | [default to &#39;GRE&#39;]
**erspan_id** | **Integer** | Used by physical switch for the mirror traffic forwarding. Must be provided and only effective when encapsulation type is ERSPAN type II or type III.  | [optional] 
**gre_key** | **Integer** | User-configurable 32-bit key only for GRE | [optional] 


