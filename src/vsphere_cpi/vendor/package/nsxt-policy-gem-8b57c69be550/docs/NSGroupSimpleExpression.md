# SwaggerClient::NSGroupSimpleExpression

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** |  | 
**target_resource** | [**ResourceReference**](ResourceReference.md) | Reference of the target. Will be populated when the property is a resource id, the op (operator) is EQUALS and populate_references is set to be true.  | [optional] 
**target_property** | **String** | Field of the resource on which this expression is evaluated | 
**target_type** | **String** | Type of the resource on which this expression is evaluated | 
**value** | **String** | Value that satisfies this expression | 
**op** | **String** | Operator of the expression | 


