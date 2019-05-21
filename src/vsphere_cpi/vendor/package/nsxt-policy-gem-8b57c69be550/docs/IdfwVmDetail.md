# SwaggerClient::IdfwVmDetail

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vm_ext_id** | **String** | Virtual machine (external ID or BIOS UUID) where login/logout event occurred. | 
**vm_ip_addresses** | **Array&lt;String&gt;** | List of client machine IP addresses. | [optional] 
**last_login_user_session** | [**ResourceReference**](ResourceReference.md) | Record of the last logged in user session (if exists). | [optional] 
**user_sessions** | [**Array&lt;IdfwUserSessionData&gt;**](IdfwUserSessionData.md) | List of user session data. | 


