# SwaggerClient::PropertyItem

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**field** | **String** | Represents field value of the property. | 
**separator** | **BOOLEAN** | If true, separates this property in a widget. | [optional] [default to false]
**render_configuration** | [**Array&lt;RenderConfiguration&gt;**](RenderConfiguration.md) | Render configuration to be applied, if any. | [optional] 
**type** | **String** | Data type of the field. | [default to &#39;String&#39;]
**heading** | **BOOLEAN** | Set to true if the field is a heading. Default is false. | [optional] [default to false]
**condition** | **String** | If the condition is met then the property will be displayed. Examples of expression syntax are provided under &#39;example_request&#39; section of &#39;CreateWidgetConfiguration&#39; API. | [optional] 
**label** | [**Label**](Label.md) | If a field represents a heading, then label is not needed | [optional] 


