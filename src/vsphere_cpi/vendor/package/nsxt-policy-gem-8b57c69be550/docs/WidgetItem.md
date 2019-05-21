# SwaggerClient::WidgetItem

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**alignment** | **String** | Aligns widget either left or right. | [optional] [default to &#39;LEFT&#39;]
**separator** | **BOOLEAN** | If true, separates this widget in a container. | [optional] [default to false]
**widget_id** | **String** | Id of the widget configuration that is held by a multi-widget or a container or a view. | 
**weight** | **Integer** | Determines placement of widget or container relative to other widgets and containers. The lower the weight, the higher it is in the placement order. | [optional] [default to 10000]
**label** | [**Label**](Label.md) | Applicable for &#39;DonutConfiguration&#39; and &#39;StatsConfiguration&#39; reports only. If label is not specified, then it defaults to the label of the donut or stats report. | [optional] 


