# SwaggerClient::DonutPart

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**field** | **String** | A numerical value that represents the portion or entity of the donut or stats chart. | 
**drilldown_id** | **String** | Id of drilldown widget, if any. Id should be a valid id of an existing widget. A widget is considered as drilldown widget when it is associated with any other widget and provides more detailed information about any data item from the parent widget. | [optional] 
**render_configuration** | [**Array&lt;RenderConfiguration&gt;**](RenderConfiguration.md) | Additional rendering or conditional evaluation of the field values to be performed, if any. | [optional] 
**navigation** | **String** | Hyperlink of the specified UI page that provides details. If drilldown_id is provided, then navigation cannot be used. | [optional] 
**tooltip** | [**Array&lt;Tooltip&gt;**](Tooltip.md) | Multi-line text to be shown on tooltip while hovering over the portion. | [optional] 
**label** | [**Label**](Label.md) | If a section &#39;template&#39; holds this donut or stats part, then the label is auto-generated from the fetched field values after applying the template. | [optional] 


