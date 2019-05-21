# SwaggerClient::ColumnItem

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**sort_key** | **String** | Sorting on column is based on the sort_key. sort_key represents the field in the output data on which sort is requested. | [optional] 
**type** | **String** | Data type of the field. | [default to &#39;String&#39;]
**tooltip** | [**Array&lt;Tooltip&gt;**](Tooltip.md) | Multi-line text to be shown on tooltip while hovering over a cell in the grid. | [optional] 
**label** | [**Label**](Label.md) | Label of the column. | 
**field** | **String** | Field from which values of the column will be derived. | 
**sort_ascending** | **BOOLEAN** | If true, the value of the column are sorted in ascending order. Otherwise, in descending order. | [optional] [default to true]
**drilldown_id** | **String** | Id of drilldown widget, if any. Id should be a valid id of an existing widget. | [optional] 
**hidden** | **BOOLEAN** | If set to true, hides the column | [optional] [default to false]
**navigation** | **String** | Hyperlink of the specified UI page that provides details. If drilldown_id is provided, then navigation cannot be used. | [optional] 
**column_identifier** | **String** | Identifies the column and used for fetching content upon an user click or drilldown. If column identifier is not provided, the column&#39;s data will not participate in searches and drilldowns. | [optional] 
**render_configuration** | [**Array&lt;RenderConfiguration&gt;**](RenderConfiguration.md) | Render configuration to be applied, if any. | [optional] 


