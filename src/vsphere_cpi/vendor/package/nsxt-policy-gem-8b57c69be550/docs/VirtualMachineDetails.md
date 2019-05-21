# SwaggerClient::VirtualMachineDetails

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**active_sessions** | [**Array&lt;UserSession&gt;**](UserSession.md) | List of active (still logged in) user login/session data (no limit). | [optional] 
**archived_sessions** | [**Array&lt;UserSession&gt;**](UserSession.md) | Optional list of up to 5 most recent archived (previously logged in) user login/session data. | [optional] 


