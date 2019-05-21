# SwaggerClient::NodeUserSettings

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**cli_username** | **String** | To configure username, you must provide this property together with &lt;b&gt;cli_password&lt;/b&gt;.  | [optional] [default to &#39;admin&#39;]
**audit_username** | **String** | The default username is \&quot;audit\&quot;. To configure username, you must provide this property together with &lt;b&gt;audit_password&lt;/b&gt;.  | [optional] 
**root_password** | **String** | Password for the node root user. For deployment, this property is required. After deployment, this property is ignored, and the node cli must be used to change the password. The password specified must be at least 12 characters in length and must contain at least one lowercase, one uppercase, one numeric character and one special character (except quotes).  | [optional] 
**cli_password** | **String** | Password for the node cli user. For deployment, this property is required. After deployment, this property is ignored, and the node cli must be used to change the password. The password specified must be at least 12 characters in length and must contain at least one lowercase, one uppercase, one numeric character and one special character (except quotes).  | [optional] 
**audit_password** | **String** | Password for the node audit user. For deployment, this property is required. After deployment, this property is ignored, and the node cli must be used to change the password. The password specified must be at least 12 characters in length and must contain at least one lowercase, one uppercase, one numeric character and one special character (except quotes).  | [optional] 


