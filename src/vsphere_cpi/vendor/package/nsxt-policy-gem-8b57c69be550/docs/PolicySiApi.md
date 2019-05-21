# SwaggerClient::PolicySiApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_byod_policy_service_instance**](PolicySiApi.md#create_byod_policy_service_instance) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id} | Create service instance
[**create_or_update_redirection_policy**](PolicySiApi.md#create_or_update_redirection_policy) | **PUT** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id} | Create or update redirection policy
[**create_or_update_redirection_rule**](PolicySiApi.md#create_or_update_redirection_rule) | **PUT** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id}/rules/{rule-id} | Update redirection rule
[**create_or_update_service_reference**](PolicySiApi.md#create_or_update_service_reference) | **PUT** /infra/service-references/{service-reference-id} | Create service reference
[**create_or_update_virtual_endpoint**](PolicySiApi.md#create_or_update_virtual_endpoint) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/endpoints/virtual-endpoints/{virtual-endpoint-id} | Create or update virtual endpoint
[**create_policy_service_instance**](PolicySiApi.md#create_policy_service_instance) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances/{service-instance-id} | Create service instance
[**create_policy_service_profile**](PolicySiApi.md#create_policy_service_profile) | **PUT** /infra/service-references/{service-reference-id}/service-profiles/{service-profile-id} | Create or update service profile
[**create_service_chain**](PolicySiApi.md#create_service_chain) | **PUT** /infra/service-chains/{service-chain-id} | Create  or update service chain
[**create_service_definition**](PolicySiApi.md#create_service_definition) | **POST** /enforcement-points/{enforcement-point-id}/service-definitions | Create a Service Definition on given enforcement point.
[**create_service_instance_endpoint**](PolicySiApi.md#create_service_instance_endpoint) | **PUT** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id}/service-instance-endpoints/{service-instance-endpoint-id} | Create service instance endpoint
[**delete_byod_policy_service_instance**](PolicySiApi.md#delete_byod_policy_service_instance) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id} | Delete BYOD policy service instance
[**delete_policy_service_chain**](PolicySiApi.md#delete_policy_service_chain) | **DELETE** /infra/service-chains/{service-chain-id} | Delete Service chain
[**delete_policy_service_instance**](PolicySiApi.md#delete_policy_service_instance) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances/{service-instance-id} | Delete policy service instance
[**delete_policy_service_instance_endpoint**](PolicySiApi.md#delete_policy_service_instance_endpoint) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id}/service-instance-endpoints/{service-instance-endpoint-id} | Delete policy service instance endpoint
[**delete_policy_service_profile**](PolicySiApi.md#delete_policy_service_profile) | **DELETE** /infra/service-references/{service-reference-id}/service-profiles/{service-profile-id} | Delete Service profile
[**delete_redirection_policy**](PolicySiApi.md#delete_redirection_policy) | **DELETE** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id} | Delete redirection policy
[**delete_redirection_rule**](PolicySiApi.md#delete_redirection_rule) | **DELETE** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id}/rules/{rule-id} | Delete RedirectionRule
[**delete_service_definition**](PolicySiApi.md#delete_service_definition) | **DELETE** /enforcement-points/{enforcement-point-id}/service-definitions/{service-definition-id} | Delete an existing Service Definition on the given enforcement point 
[**delete_service_reference**](PolicySiApi.md#delete_service_reference) | **DELETE** /infra/service-references/{service-reference-id} | Delete Service Reference
[**delete_virtual_endpoint**](PolicySiApi.md#delete_virtual_endpoint) | **DELETE** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/endpoints/virtual-endpoints/{virtual-endpoint-id} | Delete virtual endpoint
[**get_policy_service_instance_statistics**](PolicySiApi.md#get_policy_service_instance_statistics) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances/{service-instance-id}/statistics | Get statistics for all runtimes associated with this PolicyServiceInstance
[**get_policy_service_profile_groups**](PolicySiApi.md#get_policy_service_profile_groups) | **GET** /infra/service-references/{service-reference-id}/service-profiles/{service-profile-id}/group-associations | Get Groups used in Redirection rules for a given Service Profile.
[**list_byod_policy_service_instances_for_tier0**](PolicySiApi.md#list_byod_policy_service_instances_for_tier0) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances | Read all BYOD service instance objects under a tier-0
[**list_policy_service_chain_mappings**](PolicySiApi.md#list_policy_service_chain_mappings) | **GET** /infra/service-references/{service-reference-id}/service-profiles/{service-profile-id}/service-chain-mappings | List all service chain mappings for given service profile.
[**list_policy_service_chains**](PolicySiApi.md#list_policy_service_chains) | **GET** /infra/service-chains | List service chains
[**list_policy_service_instance_endpoints**](PolicySiApi.md#list_policy_service_instance_endpoints) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id}/service-instance-endpoints | List all service instance endpoint
[**list_policy_service_profiles**](PolicySiApi.md#list_policy_service_profiles) | **GET** /infra/service-references/{service-reference-id}/service-profiles | List service profiles
[**list_redirection_policies**](PolicySiApi.md#list_redirection_policies) | **GET** /infra/domains/{domain-id}/redirection-policies | List redirection policys for a domain
[**list_redirection_rules**](PolicySiApi.md#list_redirection_rules) | **GET** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id}/rules | List rules
[**list_service_definitions**](PolicySiApi.md#list_service_definitions) | **GET** /enforcement-points/{enforcement-point-id}/service-definitions | List all Service Definitions registered on given enforcement point.
[**list_service_references**](PolicySiApi.md#list_service_references) | **GET** /infra/service-references | List service references
[**list_virtual_endpoints_for_tier0**](PolicySiApi.md#list_virtual_endpoints_for_tier0) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/endpoints/virtual-endpoints | List all virtual endpoints
[**patch_byod_policy_service_instance**](PolicySiApi.md#patch_byod_policy_service_instance) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id} | Create service instance
[**patch_policy_service_instance**](PolicySiApi.md#patch_policy_service_instance) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances/{service-instance-id} | Create service instance
[**patch_policy_service_profile**](PolicySiApi.md#patch_policy_service_profile) | **PATCH** /infra/service-references/{service-reference-id}/service-profiles/{service-profile-id} | Create service profile
[**patch_redirection_policy**](PolicySiApi.md#patch_redirection_policy) | **PATCH** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id} | Create or update redirection policy
[**patch_redirection_rule**](PolicySiApi.md#patch_redirection_rule) | **PATCH** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id}/rules/{rule-id} | Update redirection rule
[**patch_service_chain**](PolicySiApi.md#patch_service_chain) | **PATCH** /infra/service-chains/{service-chain-id} | Create service chain
[**patch_service_instance_endpoint**](PolicySiApi.md#patch_service_instance_endpoint) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id}/service-instance-endpoints/{service-instance-endpoint-id} | Create service instance endpoint
[**patch_service_reference**](PolicySiApi.md#patch_service_reference) | **PATCH** /infra/service-references/{service-reference-id} | Create service reference
[**patch_virtual_endpoint**](PolicySiApi.md#patch_virtual_endpoint) | **PATCH** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/endpoints/virtual-endpoints/{virtual-endpoint-id} | Create or update virtual endpoint
[**read_all_policy_service_instances_for_tier0**](PolicySiApi.md#read_all_policy_service_instances_for_tier0) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances | Read all service instance objects under a tier-0
[**read_byod_policy_service_instance**](PolicySiApi.md#read_byod_policy_service_instance) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id} | Read byod service instance
[**read_partner_service**](PolicySiApi.md#read_partner_service) | **GET** /infra/partner-services/{service-name} | Read partner service identified by provided name
[**read_partner_services**](PolicySiApi.md#read_partner_services) | **GET** /infra/partner-services | Read partner services
[**read_policy_service_instance**](PolicySiApi.md#read_policy_service_instance) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances/{service-instance-id} | Read service instance
[**read_policy_service_instance_endpoint**](PolicySiApi.md#read_policy_service_instance_endpoint) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/byod-service-instances/{service-instance-id}/service-instance-endpoints/{service-instance-endpoint-id} | Read service instance endpoint
[**read_policy_service_profile**](PolicySiApi.md#read_policy_service_profile) | **GET** /infra/service-references/{service-reference-id}/service-profiles/{service-profile-id} | Read service profile
[**read_redirection_policy**](PolicySiApi.md#read_redirection_policy) | **GET** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id} | Read redirection policy
[**read_redirection_rule**](PolicySiApi.md#read_redirection_rule) | **GET** /infra/domains/{domain-id}/redirection-policies/{redirection-policy-id}/rules/{rule-id} | Read rule
[**read_service_chain**](PolicySiApi.md#read_service_chain) | **GET** /infra/service-chains/{service-chain-id} | Read service chain
[**read_service_definition**](PolicySiApi.md#read_service_definition) | **GET** /enforcement-points/{enforcement-point-id}/service-definitions/{service-definition-id} | Read Service Definition with given service-definition-id.
[**read_service_reference**](PolicySiApi.md#read_service_reference) | **GET** /infra/service-references/{service-reference-id} | Read service reference
[**read_virtual_endpoint**](PolicySiApi.md#read_virtual_endpoint) | **GET** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/endpoints/virtual-endpoints/{virtual-endpoint-id} | Read virtual endpoint
[**renew_authentication_tokens_for_policy_service_instance_reauth**](PolicySiApi.md#renew_authentication_tokens_for_policy_service_instance_reauth) | **POST** /infra/tier-0s/{tier-0-id}/locale-services/{locale-service-id}/service-instances/{service-instance-id}?action&#x3D;reauth | Renew the authentication tokens
[**update_service_definition**](PolicySiApi.md#update_service_definition) | **PUT** /enforcement-points/{enforcement-point-id}/service-definitions/{service-definition-id} | Update an existing Service Definition on the given enforcement point 


# **create_byod_policy_service_instance**
> ByodPolicyServiceInstance create_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, byod_policy_service_instance)

Create service instance

Create BYOD Service Instance which represent instance of service definition created on manager. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Byod service instance id

byod_policy_service_instance = SwaggerClient::ByodPolicyServiceInstance.new # ByodPolicyServiceInstance | 


begin
  #Create service instance
  result = api_instance.create_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, byod_policy_service_instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_byod_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Byod service instance id | 
 **byod_policy_service_instance** | [**ByodPolicyServiceInstance**](ByodPolicyServiceInstance.md)|  | 

### Return type

[**ByodPolicyServiceInstance**](ByodPolicyServiceInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_redirection_policy**
> RedirectionPolicy create_or_update_redirection_policy(domain_id, redirection_policy_id, redirection_policy)

Create or update redirection policy

Create or update the redirection policy. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id

redirection_policy = SwaggerClient::RedirectionPolicy.new # RedirectionPolicy | 


begin
  #Create or update redirection policy
  result = api_instance.create_or_update_redirection_policy(domain_id, redirection_policy_id, redirection_policy)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_or_update_redirection_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 
 **redirection_policy** | [**RedirectionPolicy**](RedirectionPolicy.md)|  | 

### Return type

[**RedirectionPolicy**](RedirectionPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_redirection_rule**
> RedirectionRule create_or_update_redirection_rule(domain_id, redirection_policy_id, rule_id, redirection_rule)

Update redirection rule

Create a rule with the rule-id is not already present, otherwise update the rule. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id

rule_id = 'rule_id_example' # String | Rule id

redirection_rule = SwaggerClient::RedirectionRule.new # RedirectionRule | 


begin
  #Update redirection rule
  result = api_instance.create_or_update_redirection_rule(domain_id, redirection_policy_id, rule_id, redirection_rule)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_or_update_redirection_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 
 **rule_id** | **String**| Rule id | 
 **redirection_rule** | [**RedirectionRule**](RedirectionRule.md)|  | 

### Return type

[**RedirectionRule**](RedirectionRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_service_reference**
> ServiceReference create_or_update_service_reference(service_reference_id, service_reference)

Create service reference

Create Service Reference representing the intent to consume a given 3rd party service. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

service_reference = SwaggerClient::ServiceReference.new # ServiceReference | 


begin
  #Create service reference
  result = api_instance.create_or_update_service_reference(service_reference_id, service_reference)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_or_update_service_reference: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **service_reference** | [**ServiceReference**](ServiceReference.md)|  | 

### Return type

[**ServiceReference**](ServiceReference.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_update_virtual_endpoint**
> VirtualEndpoint create_or_update_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id, virtual_endpoint)

Create or update virtual endpoint

Create or update virtual endpoint. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

virtual_endpoint_id = 'virtual_endpoint_id_example' # String | Virtual endpoint id

virtual_endpoint = SwaggerClient::VirtualEndpoint.new # VirtualEndpoint | 


begin
  #Create or update virtual endpoint
  result = api_instance.create_or_update_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id, virtual_endpoint)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_or_update_virtual_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **virtual_endpoint_id** | **String**| Virtual endpoint id | 
 **virtual_endpoint** | [**VirtualEndpoint**](VirtualEndpoint.md)|  | 

### Return type

[**VirtualEndpoint**](VirtualEndpoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_policy_service_instance**
> PolicyServiceInstance create_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, policy_service_instance)

Create service instance

Create service instance. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

policy_service_instance = SwaggerClient::PolicyServiceInstance.new # PolicyServiceInstance | 


begin
  #Create service instance
  result = api_instance.create_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, policy_service_instance)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **policy_service_instance** | [**PolicyServiceInstance**](PolicyServiceInstance.md)|  | 

### Return type

[**PolicyServiceInstance**](PolicyServiceInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_policy_service_profile**
> PolicyServiceProfile create_policy_service_profile(service_reference_id, service_profile_id, policy_service_profile)

Create or update service profile

Create or update Service profile to specify vendor temp- late attributes for a given 3rd party service.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

service_profile_id = 'service_profile_id_example' # String | Service profile id

policy_service_profile = SwaggerClient::PolicyServiceProfile.new # PolicyServiceProfile | 


begin
  #Create or update service profile
  result = api_instance.create_policy_service_profile(service_reference_id, service_profile_id, policy_service_profile)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_policy_service_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **service_profile_id** | **String**| Service profile id | 
 **policy_service_profile** | [**PolicyServiceProfile**](PolicyServiceProfile.md)|  | 

### Return type

[**PolicyServiceProfile**](PolicyServiceProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_service_chain**
> PolicyServiceChain create_service_chain(service_chain_id, policy_service_chain)

Create  or update service chain

Create or update Service chain representing the sequence in which 3rd party services must be consumed. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_chain_id = 'service_chain_id_example' # String | Service chain id

policy_service_chain = SwaggerClient::PolicyServiceChain.new # PolicyServiceChain | 


begin
  #Create  or update service chain
  result = api_instance.create_service_chain(service_chain_id, policy_service_chain)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_service_chain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_chain_id** | **String**| Service chain id | 
 **policy_service_chain** | [**PolicyServiceChain**](PolicyServiceChain.md)|  | 

### Return type

[**PolicyServiceChain**](PolicyServiceChain.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_service_definition**
> ServiceDefinition create_service_definition(enforcement_point_id, service_definition)

Create a Service Definition on given enforcement point.

Create a Service Definition on given enforcement point.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

enforcement_point_id = 'enforcement_point_id_example' # String | Enforcement point id

service_definition = SwaggerClient::ServiceDefinition.new # ServiceDefinition | 


begin
  #Create a Service Definition on given enforcement point.
  result = api_instance.create_service_definition(enforcement_point_id, service_definition)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_service_definition: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_id** | **String**| Enforcement point id | 
 **service_definition** | [**ServiceDefinition**](ServiceDefinition.md)|  | 

### Return type

[**ServiceDefinition**](ServiceDefinition.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_service_instance_endpoint**
> ServiceInstanceEndpoint create_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id, service_instance_endpoint)

Create service instance endpoint

Create service instance endpoint with given request if not exist. Modification of service instance endpoint is not allowed. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

service_instance_endpoint_id = 'service_instance_endpoint_id_example' # String | Service instance endpoint id

service_instance_endpoint = SwaggerClient::ServiceInstanceEndpoint.new # ServiceInstanceEndpoint | 


begin
  #Create service instance endpoint
  result = api_instance.create_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id, service_instance_endpoint)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->create_service_instance_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **service_instance_endpoint_id** | **String**| Service instance endpoint id | 
 **service_instance_endpoint** | [**ServiceInstanceEndpoint**](ServiceInstanceEndpoint.md)|  | 

### Return type

[**ServiceInstanceEndpoint**](ServiceInstanceEndpoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_byod_policy_service_instance**
> delete_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)

Delete BYOD policy service instance

Delete BYOD policy service instance

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id


begin
  #Delete BYOD policy service instance
  api_instance.delete_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_byod_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_service_chain**
> delete_policy_service_chain(service_chain_id)

Delete Service chain

This API can be user to delete service chain with given service-chain-id.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_chain_id = 'service_chain_id_example' # String | Id of Service chain


begin
  #Delete Service chain
  api_instance.delete_policy_service_chain(service_chain_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_policy_service_chain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_chain_id** | **String**| Id of Service chain | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_service_instance**
> delete_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)

Delete policy service instance

Delete policy service instance

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id


begin
  #Delete policy service instance
  api_instance.delete_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_service_instance_endpoint**
> delete_policy_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id)

Delete policy service instance endpoint

Delete policy service instance endpoint

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

service_instance_endpoint_id = 'service_instance_endpoint_id_example' # String | Service instance endpoint id


begin
  #Delete policy service instance endpoint
  api_instance.delete_policy_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_policy_service_instance_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **service_instance_endpoint_id** | **String**| Service instance endpoint id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_policy_service_profile**
> delete_policy_service_profile(service_reference_id, service_profile_id)

Delete Service profile

This API can be used to delete service profile with given service-profile-id

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Id of Service Reference

service_profile_id = 'service_profile_id_example' # String | Service profile id


begin
  #Delete Service profile
  api_instance.delete_policy_service_profile(service_reference_id, service_profile_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_policy_service_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Id of Service Reference | 
 **service_profile_id** | **String**| Service profile id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_redirection_policy**
> delete_redirection_policy(domain_id, redirection_policy_id)

Delete redirection policy

Delete redirection policy.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id


begin
  #Delete redirection policy
  api_instance.delete_redirection_policy(domain_id, redirection_policy_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_redirection_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_redirection_rule**
> delete_redirection_rule(domain_id, redirection_policy_id, rule_id)

Delete RedirectionRule

Delete RedirectionRule

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain ID

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection Map ID

rule_id = 'rule_id_example' # String | RedirectionRule ID


begin
  #Delete RedirectionRule
  api_instance.delete_redirection_rule(domain_id, redirection_policy_id, rule_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_redirection_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain ID | 
 **redirection_policy_id** | **String**| Redirection Map ID | 
 **rule_id** | **String**| RedirectionRule ID | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_service_definition**
> delete_service_definition(enforcement_point_id, service_definition_id)

Delete an existing Service Definition on the given enforcement point 

Delete an existing Service Definition on the given enforcement point. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

enforcement_point_id = 'enforcement_point_id_example' # String | Enforcement point id

service_definition_id = 'service_definition_id_example' # String | Id of service definition


begin
  #Delete an existing Service Definition on the given enforcement point 
  api_instance.delete_service_definition(enforcement_point_id, service_definition_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_service_definition: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_id** | **String**| Enforcement point id | 
 **service_definition_id** | **String**| Id of service definition | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_service_reference**
> delete_service_reference(service_reference_id)

Delete Service Reference

This API can be used to delete a service reference with the given service-reference-id.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Id of Service Reference


begin
  #Delete Service Reference
  api_instance.delete_service_reference(service_reference_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_service_reference: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Id of Service Reference | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_virtual_endpoint**
> delete_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id)

Delete virtual endpoint

Delete virtual endpoint

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

virtual_endpoint_id = 'virtual_endpoint_id_example' # String | Virtual endpoint id


begin
  #Delete virtual endpoint
  api_instance.delete_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->delete_virtual_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **virtual_endpoint_id** | **String**| Virtual endpoint id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_service_instance_statistics**
> PolicyServiceInstanceStatistics get_policy_service_instance_statistics(tier_0_id, locale_service_id, service_instance_id, opts)

Get statistics for all runtimes associated with this PolicyServiceInstance

Get statistics for all data NICs on all runtimes associated with this PolicyServiceInstance. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get statistics for all runtimes associated with this PolicyServiceInstance
  result = api_instance.get_policy_service_instance_statistics(tier_0_id, locale_service_id, service_instance_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->get_policy_service_instance_statistics: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**PolicyServiceInstanceStatistics**](PolicyServiceInstanceStatistics.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **get_policy_service_profile_groups**
> ServiceProfileGroups get_policy_service_profile_groups(service_reference_id, service_profile_id, opts)

Get Groups used in Redirection rules for a given Service Profile.

List of Groups used in Redirection rules for a given Service Profile. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

service_profile_id = 'service_profile_id_example' # String | Service profile id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #Get Groups used in Redirection rules for a given Service Profile.
  result = api_instance.get_policy_service_profile_groups(service_reference_id, service_profile_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->get_policy_service_profile_groups: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **service_profile_id** | **String**| Service profile id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**ServiceProfileGroups**](ServiceProfileGroups.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_byod_policy_service_instances_for_tier0**
> ByodPolicyServiceInstanceListResult list_byod_policy_service_instances_for_tier0(tier_0_id, locale_service_id, opts)

Read all BYOD service instance objects under a tier-0

Read all BYOD service instance objects under a tier-0

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Read all BYOD service instance objects under a tier-0
  result = api_instance.list_byod_policy_service_instances_for_tier0(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_byod_policy_service_instances_for_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ByodPolicyServiceInstanceListResult**](ByodPolicyServiceInstanceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_service_chain_mappings**
> ServiceChainMappingListResult list_policy_service_chain_mappings(service_reference_id, service_profile_id, opts)

List all service chain mappings for given service profile.

List all service chain mappings in the system for the given service profile. If no explicit enforcement point is provided in the request, will return for default. Else, will return for specified points. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

service_profile_id = 'service_profile_id_example' # String | Service profile id

opts = { 
  enforcement_point_path: 'enforcement_point_path_example' # String | String Path of the enforcement point
}

begin
  #List all service chain mappings for given service profile.
  result = api_instance.list_policy_service_chain_mappings(service_reference_id, service_profile_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_policy_service_chain_mappings: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **service_profile_id** | **String**| Service profile id | 
 **enforcement_point_path** | **String**| String Path of the enforcement point | [optional] 

### Return type

[**ServiceChainMappingListResult**](ServiceChainMappingListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_service_chains**
> PolicyServiceChainListResult list_policy_service_chains(opts)

List service chains

List all the service chains available for service insertion 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List service chains
  result = api_instance.list_policy_service_chains(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_policy_service_chains: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyServiceChainListResult**](PolicyServiceChainListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_service_instance_endpoints**
> ServiceInstanceEndpointListResult list_policy_service_instance_endpoints(tier_0_id, locale_service_id, service_instance_id, opts)

List all service instance endpoint

List all service instance endpoint

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List all service instance endpoint
  result = api_instance.list_policy_service_instance_endpoints(tier_0_id, locale_service_id, service_instance_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_policy_service_instance_endpoints: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ServiceInstanceEndpointListResult**](ServiceInstanceEndpointListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_policy_service_profiles**
> PolicyServiceProfileListResult list_policy_service_profiles(service_reference_id, opts)

List service profiles

List all the service profiles available for given service reference 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List service profiles
  result = api_instance.list_policy_service_profiles(service_reference_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_policy_service_profiles: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyServiceProfileListResult**](PolicyServiceProfileListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_redirection_policies**
> RedirectionPolicyListResult list_redirection_policies(domain_id, opts)

List redirection policys for a domain

List redirection policys for a domain

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List redirection policys for a domain
  result = api_instance.list_redirection_policies(domain_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_redirection_policies: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RedirectionPolicyListResult**](RedirectionPolicyListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_redirection_rules**
> RedirectionRuleListResult list_redirection_rules(domain_id, redirection_policy_id, opts)

List rules

List rules

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List rules
  result = api_instance.list_redirection_rules(domain_id, redirection_policy_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_redirection_rules: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**RedirectionRuleListResult**](RedirectionRuleListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_service_definitions**
> ServiceInsertionServiceListResult list_service_definitions(enforcement_point_id)

List all Service Definitions registered on given enforcement point.

List all Service Definitions registered on given enforcement point. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

enforcement_point_id = 'enforcement_point_id_example' # String | Enforcement point id


begin
  #List all Service Definitions registered on given enforcement point.
  result = api_instance.list_service_definitions(enforcement_point_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_service_definitions: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_id** | **String**| Enforcement point id | 

### Return type

[**ServiceInsertionServiceListResult**](ServiceInsertionServiceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_service_references**
> ServiceReferenceListResult list_service_references(opts)

List service references

List all the partner service references available for service insertion 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List service references
  result = api_instance.list_service_references(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_service_references: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ServiceReferenceListResult**](ServiceReferenceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_virtual_endpoints_for_tier0**
> VirtualEndpointListResult list_virtual_endpoints_for_tier0(tier_0_id, locale_service_id, opts)

List all virtual endpoints

List all virtual endpoints

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List all virtual endpoints
  result = api_instance.list_virtual_endpoints_for_tier0(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->list_virtual_endpoints_for_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**VirtualEndpointListResult**](VirtualEndpointListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_byod_policy_service_instance**
> patch_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, byod_policy_service_instance)

Create service instance

Create BYOD Service Instance which represent instance of service definition created on manager. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

byod_policy_service_instance = SwaggerClient::ByodPolicyServiceInstance.new # ByodPolicyServiceInstance | 


begin
  #Create service instance
  api_instance.patch_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, byod_policy_service_instance)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_byod_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **byod_policy_service_instance** | [**ByodPolicyServiceInstance**](ByodPolicyServiceInstance.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_service_instance**
> patch_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, policy_service_instance)

Create service instance

Create Service Instance. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

policy_service_instance = SwaggerClient::PolicyServiceInstance.new # PolicyServiceInstance | 


begin
  #Create service instance
  api_instance.patch_policy_service_instance(tier_0_id, locale_service_id, service_instance_id, policy_service_instance)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **policy_service_instance** | [**PolicyServiceInstance**](PolicyServiceInstance.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_policy_service_profile**
> patch_policy_service_profile(service_reference_id, service_profile_id, policy_service_profile)

Create service profile

Create Service profile to specify vendor template attri- butes for a given 3rd party service.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

service_profile_id = 'service_profile_id_example' # String | Service profile id

policy_service_profile = SwaggerClient::PolicyServiceProfile.new # PolicyServiceProfile | 


begin
  #Create service profile
  api_instance.patch_policy_service_profile(service_reference_id, service_profile_id, policy_service_profile)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_policy_service_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **service_profile_id** | **String**| Service profile id | 
 **policy_service_profile** | [**PolicyServiceProfile**](PolicyServiceProfile.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_redirection_policy**
> patch_redirection_policy(domain_id, redirection_policy_id, redirection_policy)

Create or update redirection policy

Create or update the redirection policy. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id

redirection_policy = SwaggerClient::RedirectionPolicy.new # RedirectionPolicy | 


begin
  #Create or update redirection policy
  api_instance.patch_redirection_policy(domain_id, redirection_policy_id, redirection_policy)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_redirection_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 
 **redirection_policy** | [**RedirectionPolicy**](RedirectionPolicy.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_redirection_rule**
> patch_redirection_rule(domain_id, redirection_policy_id, rule_id, redirection_rule)

Update redirection rule

Create a rule with the rule-id is not already present, otherwise update the rule. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | RedirectionPolicy id

rule_id = 'rule_id_example' # String | rule id

redirection_rule = SwaggerClient::RedirectionRule.new # RedirectionRule | 


begin
  #Update redirection rule
  api_instance.patch_redirection_rule(domain_id, redirection_policy_id, rule_id, redirection_rule)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_redirection_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| RedirectionPolicy id | 
 **rule_id** | **String**| rule id | 
 **redirection_rule** | [**RedirectionRule**](RedirectionRule.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_chain**
> patch_service_chain(service_chain_id, policy_service_chain)

Create service chain

Create Service chain representing the sequence in which 3rd party services must be consumed. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_chain_id = 'service_chain_id_example' # String | Service chain id

policy_service_chain = SwaggerClient::PolicyServiceChain.new # PolicyServiceChain | 


begin
  #Create service chain
  api_instance.patch_service_chain(service_chain_id, policy_service_chain)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_service_chain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_chain_id** | **String**| Service chain id | 
 **policy_service_chain** | [**PolicyServiceChain**](PolicyServiceChain.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_instance_endpoint**
> patch_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id, service_instance_endpoint)

Create service instance endpoint

Create Service instance endpoint. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

service_instance_endpoint_id = 'service_instance_endpoint_id_example' # String | Service instance endpoint id

service_instance_endpoint = SwaggerClient::ServiceInstanceEndpoint.new # ServiceInstanceEndpoint | 


begin
  #Create service instance endpoint
  api_instance.patch_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id, service_instance_endpoint)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_service_instance_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **service_instance_endpoint_id** | **String**| Service instance endpoint id | 
 **service_instance_endpoint** | [**ServiceInstanceEndpoint**](ServiceInstanceEndpoint.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_service_reference**
> patch_service_reference(service_reference_id, service_reference)

Create service reference

Create Service Reference representing the intent to consume a given 3rd party service. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Service reference id

service_reference = SwaggerClient::ServiceReference.new # ServiceReference | 


begin
  #Create service reference
  api_instance.patch_service_reference(service_reference_id, service_reference)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_service_reference: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Service reference id | 
 **service_reference** | [**ServiceReference**](ServiceReference.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **patch_virtual_endpoint**
> patch_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id, virtual_endpoint)

Create or update virtual endpoint

Create or update virtual endpoint. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

virtual_endpoint_id = 'virtual_endpoint_id_example' # String | Virtual endpoint id

virtual_endpoint = SwaggerClient::VirtualEndpoint.new # VirtualEndpoint | 


begin
  #Create or update virtual endpoint
  api_instance.patch_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id, virtual_endpoint)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->patch_virtual_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **virtual_endpoint_id** | **String**| Virtual endpoint id | 
 **virtual_endpoint** | [**VirtualEndpoint**](VirtualEndpoint.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_all_policy_service_instances_for_tier0**
> PolicyServiceInstanceListResult read_all_policy_service_instances_for_tier0(tier_0_id, locale_service_id, opts)

Read all service instance objects under a tier-0

Read all service instance objects under a tier-0

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Read all service instance objects under a tier-0
  result = api_instance.read_all_policy_service_instances_for_tier0(tier_0_id, locale_service_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_all_policy_service_instances_for_tier0: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyServiceInstanceListResult**](PolicyServiceInstanceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_byod_policy_service_instance**
> ByodPolicyServiceInstance read_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)

Read byod service instance

Read byod service instance

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id


begin
  #Read byod service instance
  result = api_instance.read_byod_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_byod_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 

### Return type

[**ByodPolicyServiceInstance**](ByodPolicyServiceInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_partner_service**
> ServiceDefinition read_partner_service(service_name)

Read partner service identified by provided name

Read the specific partner service identified by provided name.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_name = 'service_name_example' # String | Name of the service


begin
  #Read partner service identified by provided name
  result = api_instance.read_partner_service(service_name)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_partner_service: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_name** | **String**| Name of the service | 

### Return type

[**ServiceDefinition**](ServiceDefinition.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_partner_services**
> ServiceInsertionServiceListResult read_partner_services(opts)

Read partner services

Read all the partner services available for service insertion

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #Read partner services
  result = api_instance.read_partner_services(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_partner_services: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**ServiceInsertionServiceListResult**](ServiceInsertionServiceListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_service_instance**
> PolicyServiceInstance read_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)

Read service instance

Read service instance

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id


begin
  #Read service instance
  result = api_instance.read_policy_service_instance(tier_0_id, locale_service_id, service_instance_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_policy_service_instance: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 

### Return type

[**PolicyServiceInstance**](PolicyServiceInstance.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_service_instance_endpoint**
> ServiceInstanceEndpoint read_policy_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id)

Read service instance endpoint

Read service instance endpoint

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id

service_instance_endpoint_id = 'service_instance_endpoint_id_example' # String | Service instance endpoint id


begin
  #Read service instance endpoint
  result = api_instance.read_policy_service_instance_endpoint(tier_0_id, locale_service_id, service_instance_id, service_instance_endpoint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_policy_service_instance_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 
 **service_instance_endpoint_id** | **String**| Service instance endpoint id | 

### Return type

[**ServiceInstanceEndpoint**](ServiceInstanceEndpoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_policy_service_profile**
> PolicyServiceProfile read_policy_service_profile(service_reference_id, service_profile_id)

Read service profile

This API can be used to read service profile with given service-profile-id

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Id of Service Reference

service_profile_id = 'service_profile_id_example' # String | Service profile id


begin
  #Read service profile
  result = api_instance.read_policy_service_profile(service_reference_id, service_profile_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_policy_service_profile: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Id of Service Reference | 
 **service_profile_id** | **String**| Service profile id | 

### Return type

[**PolicyServiceProfile**](PolicyServiceProfile.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_redirection_policy**
> RedirectionPolicy read_redirection_policy(domain_id, redirection_policy_id)

Read redirection policy

Read redirection policy. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id


begin
  #Read redirection policy
  result = api_instance.read_redirection_policy(domain_id, redirection_policy_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_redirection_policy: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 

### Return type

[**RedirectionPolicy**](RedirectionPolicy.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_redirection_rule**
> RedirectionRule read_redirection_rule(domain_id, redirection_policy_id, rule_id)

Read rule

Read rule

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

domain_id = 'domain_id_example' # String | Domain id

redirection_policy_id = 'redirection_policy_id_example' # String | Redirection map id

rule_id = 'rule_id_example' # String | Rule id


begin
  #Read rule
  result = api_instance.read_redirection_rule(domain_id, redirection_policy_id, rule_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_redirection_rule: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **domain_id** | **String**| Domain id | 
 **redirection_policy_id** | **String**| Redirection map id | 
 **rule_id** | **String**| Rule id | 

### Return type

[**RedirectionRule**](RedirectionRule.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_chain**
> PolicyServiceChain read_service_chain(service_chain_id)

Read service chain

This API can be used to read service chain with given service-chain-id.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_chain_id = 'service_chain_id_example' # String | Id of Service chain


begin
  #Read service chain
  result = api_instance.read_service_chain(service_chain_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_service_chain: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_chain_id** | **String**| Id of Service chain | 

### Return type

[**PolicyServiceChain**](PolicyServiceChain.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_definition**
> ServiceDefinition read_service_definition(enforcement_point_id, service_definition_id)

Read Service Definition with given service-definition-id.

Read Service Definition with given service-definition-id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

enforcement_point_id = 'enforcement_point_id_example' # String | Enforcement point id

service_definition_id = 'service_definition_id_example' # String | Id of service definition


begin
  #Read Service Definition with given service-definition-id.
  result = api_instance.read_service_definition(enforcement_point_id, service_definition_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_service_definition: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_id** | **String**| Enforcement point id | 
 **service_definition_id** | **String**| Id of service definition | 

### Return type

[**ServiceDefinition**](ServiceDefinition.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_service_reference**
> ServiceReference read_service_reference(service_reference_id)

Read service reference

This API can be used to read service reference with the given service-reference-id.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

service_reference_id = 'service_reference_id_example' # String | Id of Service Reference


begin
  #Read service reference
  result = api_instance.read_service_reference(service_reference_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_service_reference: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **service_reference_id** | **String**| Id of Service Reference | 

### Return type

[**ServiceReference**](ServiceReference.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_virtual_endpoint**
> VirtualEndpoint read_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id)

Read virtual endpoint

Read virtual endpoint with given id under given Tier0.

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

virtual_endpoint_id = 'virtual_endpoint_id_example' # String | Virtual endpoint id


begin
  #Read virtual endpoint
  result = api_instance.read_virtual_endpoint(tier_0_id, locale_service_id, virtual_endpoint_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->read_virtual_endpoint: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **virtual_endpoint_id** | **String**| Virtual endpoint id | 

### Return type

[**VirtualEndpoint**](VirtualEndpoint.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **renew_authentication_tokens_for_policy_service_instance_reauth**
> renew_authentication_tokens_for_policy_service_instance_reauth(tier_0_id, locale_service_id, service_instance_id)

Renew the authentication tokens

Use this API when an alarm complaining JWT expiry is raised while deploying partner service VM. The OVF for partner service needs to be downloaded from partner services provider. It might be possible that the authentication token for this communication is expired when the service VM deployment starts. That will either require re-login through UI or use of this API. Certain authentication and authorization steps are internally processed in order to enable communication with partner service provider. This API offers the functionality to re-establish communication with partner services provider. This API needs open id and access token to be passed as headers. Those can be obtained from CSP authorize API. Please make sure to pass headers - Authorization:<Bearer ACCESS_TOKEN> and X-NSX-OpenId:<OPEN_ID>. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

tier_0_id = 'tier_0_id_example' # String | Tier-0 id

locale_service_id = 'locale_service_id_example' # String | Locale service id

service_instance_id = 'service_instance_id_example' # String | Service instance id


begin
  #Renew the authentication tokens
  api_instance.renew_authentication_tokens_for_policy_service_instance_reauth(tier_0_id, locale_service_id, service_instance_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->renew_authentication_tokens_for_policy_service_instance_reauth: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tier_0_id** | **String**| Tier-0 id | 
 **locale_service_id** | **String**| Locale service id | 
 **service_instance_id** | **String**| Service instance id | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **update_service_definition**
> ServiceDefinition update_service_definition(enforcement_point_id, service_definition_id, service_definition)

Update an existing Service Definition on the given enforcement point 

Update an existing Service Definition on the given enforcement point. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicySiApi.new

enforcement_point_id = 'enforcement_point_id_example' # String | Enforcement point id

service_definition_id = 'service_definition_id_example' # String | Id of service definition

service_definition = SwaggerClient::ServiceDefinition.new # ServiceDefinition | 


begin
  #Update an existing Service Definition on the given enforcement point 
  result = api_instance.update_service_definition(enforcement_point_id, service_definition_id, service_definition)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicySiApi->update_service_definition: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **enforcement_point_id** | **String**| Enforcement point id | 
 **service_definition_id** | **String**| Id of service definition | 
 **service_definition** | [**ServiceDefinition**](ServiceDefinition.md)|  | 

### Return type

[**ServiceDefinition**](ServiceDefinition.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



