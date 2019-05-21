# SwaggerClient::RenderConfiguration

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**color** | **String** | The color to use when rendering an entity. For example, set color as &#39;RED&#39; to render a portion of donut in red. | [optional] 
**condition** | **String** | If the condition is met then the rendering specified for the condition will be applied. Examples of expression syntax are provided under &#39;example_request&#39; section of &#39;CreateWidgetConfiguration&#39; API. | [optional] 
**display_value** | **String** | If specified, overrides the field value. This can be used to display a meaningful value in situations where field value is not available or not configured. | [optional] 
**tooltip** | [**Array&lt;Tooltip&gt;**](Tooltip.md) | Multi-line text to be shown on tooltip while hovering over the UI element if the condition is met. | [optional] 
**icons** | [**Array&lt;Icon&gt;**](Icon.md) | Icons to be applied at dashboard for widgets and UI elements. | [optional] 


