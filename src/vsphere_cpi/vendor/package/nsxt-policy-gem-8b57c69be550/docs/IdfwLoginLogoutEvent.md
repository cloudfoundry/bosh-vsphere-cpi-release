# SwaggerClient::IdfwLoginLogoutEvent

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vm_ext_id** | **String** | Virtual machine external ID or BIOS UUID. | [optional] 
**event_type** | **String** | User session event type can be one of:   - USER_LOGIN (user login)   - USER_LOGOUT (user logout)   - USER_DISCONNECT (user session disconnect)   - USER_RECONNECT (user session reconnect)  | [optional] 
**user_session_id** | **Integer** | User console/RDSH session ID. | [optional] 
**vm_ip** | **String** | Machine IP Address. | [optional] 
**timestamp** | **Integer** | Event timestamp. | [optional] 
**user_name** | **String** | AD user name. | [optional] 
**domain_name** | **String** | AD domain name (e.g. abc.com). | [optional] 


