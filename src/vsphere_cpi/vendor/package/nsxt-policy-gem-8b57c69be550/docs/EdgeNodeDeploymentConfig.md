# SwaggerClient::EdgeNodeDeploymentConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**node_user_settings** | [**NodeUserSettings**](NodeUserSettings.md) | Username and password settings for the node. Note - these settings will be honored only during node deployment. Post deployment, CLI must be used for changing the user settings, changes to these parameters will not have any effect.  | 
**vm_deployment_config** | [**DeploymentConfig**](DeploymentConfig.md) |  | 
**form_factor** | **String** | Supported edge form factor. | [optional] [default to &#39;MEDIUM&#39;]


