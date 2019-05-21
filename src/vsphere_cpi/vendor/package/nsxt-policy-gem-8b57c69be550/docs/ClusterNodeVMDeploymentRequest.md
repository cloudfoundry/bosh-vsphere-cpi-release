# SwaggerClient::ClusterNodeVMDeploymentRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**deployment_config** | [**ClusterNodeVMDeploymentConfig**](ClusterNodeVMDeploymentConfig.md) | Info needed to configure a cluster node VM at deployment for a specific platform. May require different parameters depending on the method used to deploy the VM.  | 
**vm_id** | **String** | ID of the VM maintained internally and used to recognize it. Note: This is automatically generated and cannot be modified.  | [optional] 
**user_settings** | [**NodeUserSettings**](NodeUserSettings.md) | Username and password settings for the cluster node VM. Passwords must be at least 12 characters in length and contain at least one lowercase, one uppercase, one numerical, and one special character. Note: These settings will be honored only during VM deployment. Post-deployment, CLI must be used for changing the user settings and changes to these parameters will not have any effect.  | [optional] 
**roles** | **Array&lt;String&gt;** | List of cluster node role (or roles) which the VM should take on. They specify what type (or types) of cluster node which the new VM should act as. Currently both CONTROLLER and MANAGER must be provided, since this permutation is the only one supported now.  | 
**form_factor** | **String** | Specifies the desired \&quot;size\&quot; of the VM  | [optional] [default to &#39;MEDIUM&#39;]


