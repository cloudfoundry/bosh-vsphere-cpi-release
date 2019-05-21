# SwaggerClient::LbWafProfileBinding

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**waf_profile_id** | **String** | UUID of web application firewall profile | 
**operational_mode** | **String** | In DETECTION mode, WAF will detect and only report to log what it considers an attack, but will not reject the requests. In PROTECTION mode, WAF will detect and reject the requests if the requests match the rules.  | [optional] 
**debug_log_level** | **String** | NO_LOG means WAF engine will not print logs. ERROR means errors such as fatal processing errors, block transactions. WARNING means warning informations such as nonblocking rule matches. NOTICE means notices such as nonfatal processing errors. INFO means informations of handling of transactions and performance. DETAIL means detailed syntax of the rules. EVERYTHING means all detailed informations about transactions (e.g. variable expansion and setting of variables). It is recommended to set debug log level to NO_LOG value in production environment with high performance requirement.  | [optional] [default to &#39;NO_LOG&#39;]


