# SwaggerClient::IdfwUserSessionData

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**user_id** | **String** | AD user ID (may not exist). | [optional] 
**user_session_id** | **Integer** | User session ID.  This also indicates whether this is VDI / RDSH. | 
**vm_ext_id** | **String** | Virtual machine (external ID or BIOS UUID) where login/logout events occurred. | [optional] 
**id** | **String** | Identifier of user session data. | [optional] 
**login_time** | **Integer** | Login time. | 
**user_name** | **String** | AD user name. | 
**logout_time** | **Integer** | Logout time if applicable.  An active user session has no logout time. Non-active user session is stored (up to last 5 most recent entries) per VM and per user.  | [optional] 
**domain_name** | **String** | AD Domain of user. | 


