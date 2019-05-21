# SwaggerClient::DonutConfiguration

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_system_owned** | **BOOLEAN** | Indicates system owned resource | [optional] 
**display_name** | **String** | Title of the widget. If display_name is omitted, the widget will be shown without a title. | [optional] 
**description** | **String** | Description of this resource | [optional] 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**_create_user** | **String** | ID of the user who created this resource | [optional] 
**_protection** | **String** | Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite&#x3D;true. UNKNOWN - the _protection field could not be determined for this           entity.  | [optional] 
**_create_time** | **Integer** | Timestamp of resource creation | [optional] 
**_last_modified_time** | **Integer** | Timestamp of last modification | [optional] 
**_last_modified_user** | **String** | ID of the user who last modified this resource | [optional] 
**id** | **String** | Unique identifier of this resource | [optional] 
**resource_type** | **String** | Supported visualization types are LabelValueConfiguration, DonutConfiguration, GridConfiguration, StatsConfiguration, MultiWidgetConfiguration, GraphConfiguration and ContainerConfiguration. | 
**datasources** | [**Array&lt;Datasource&gt;**](Datasource.md) | The &#39;datasources&#39; represent the sources from which data will be fetched. Currently, only NSX-API is supported as a &#39;default&#39; datasource. An example of specifying &#39;default&#39; datasource along with the urls to fetch data from is given at &#39;example_request&#39; section of &#39;CreateWidgetConfiguration&#39; API. | [optional] 
**weight** | **Integer** | Specify relavite weight in WidgetItem for placement in a view. Please see WidgetItem for details. | [optional] 
**icons** | [**Array&lt;Icon&gt;**](Icon.md) | Icons to be applied at dashboard for widgets and UI elements. | [optional] 
**shared** | **BOOLEAN** | Please use the property &#39;shared&#39; of View instead of this. The widgets of a shared view are visible to other users. | [optional] 
**footer** | [**Footer**](Footer.md) |  | [optional] 
**drilldown_id** | **String** | Id of drilldown widget, if any. Id should be a valid id of an existing widget. A widget is considered as drilldown widget when it is associated with any other widget and provides more detailed information about any data item from the parent widget. | [optional] 
**is_drilldown** | **BOOLEAN** | Set to true if this widget should be used as a drilldown. | [optional] [default to false]
**legend** | [**Legend**](Legend.md) | Legend to be displayed. If legend is not needed, do not include it. | [optional] 
**navigation** | **String** | Hyperlink of the specified UI page that provides details. | [optional] 
**display_count** | **BOOLEAN** | If true, displays the count of entities in the donut | [optional] [default to true]
**sections** | [**Array&lt;DonutSection&gt;**](DonutSection.md) | Sections | 
**label** | [**Label**](Label.md) | Displayed at the middle of the donut, by default. It labels the entities of donut. | [optional] 


