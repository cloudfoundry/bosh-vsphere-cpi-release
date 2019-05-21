# SwaggerClient::NSGroupTagExpression

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** |  | 
**tag_op** | **String** | Target_type VirtualMachine supports all specified operators for tag expression while LogicalSwitch and LogicalPort supports only EQUALS operator.  | [optional] [default to &#39;EQUALS&#39;]
**scope** | **String** | The tag.scope attribute of the object | [optional] 
**scope_op** | **String** | Operator of the scope expression eg- tag.scope &#x3D; \&quot;S1\&quot;. | [optional] [default to &#39;EQUALS&#39;]
**tag** | **String** | The tag.tag attribute of the object | [optional] 
**target_type** | **String** | Type of the resource on which this expression is evaluated | 


