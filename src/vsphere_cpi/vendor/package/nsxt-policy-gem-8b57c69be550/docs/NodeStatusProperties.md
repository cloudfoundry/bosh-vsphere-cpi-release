# SwaggerClient::NodeStatusProperties

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**load_average** | **Array&lt;Float&gt;** | One, five, and fifteen minute load averages for the system | [optional] 
**swap_used** | **Integer** | Amount of swap disk in use, in kilobytes | [optional] 
**mem_used** | **Integer** | Amount of RAM in use on the system, in kilobytes | [optional] 
**swap_total** | **Integer** | Amount of disk available for swap, in kilobytes | [optional] 
**system_time** | **Integer** | Current time expressed in milliseconds since epoch | [optional] 
**cpu_cores** | **Integer** | Number of CPU cores on the system | [optional] 
**uptime** | **Integer** | Milliseconds since system start | [optional] 
**mem_cache** | **Integer** | Amount of RAM on the system that can be flushed out to disk, in kilobytes | [optional] 
**mem_total** | **Integer** | Amount of RAM allocated to the system, in kilobytes | [optional] 
**file_systems** | [**Array&lt;NodeFileSystemProperties&gt;**](NodeFileSystemProperties.md) | File systems configured on the system | [optional] 
**source** | **String** | Source of status data. | [optional] 


