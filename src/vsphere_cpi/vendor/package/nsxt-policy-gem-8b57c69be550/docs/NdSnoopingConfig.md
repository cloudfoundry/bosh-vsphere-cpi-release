# SwaggerClient::NdSnoopingConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**nd_snooping_limit** | **Integer** | Maximum number of ND (Neighbor Discovery Protocol) snooped IPv6 addresses  | [optional] [default to 3]
**nd_snooping_enabled** | **BOOLEAN** | Enable this method will snoop the NS (Neighbor Solicitation) and NA (Neighbor Advertisement) messages in the ND (Neighbor Discovery Protocol) family of messages which are transmitted by a VM. From the NS messages, we will learn about the source which sent this NS message. From the NA message, we will learn the resolved address in the message which the VM is a recipient of. Addresses snooped by this method are subject to TOFU (Trust on First Use) policies as enforced by the system.  | [optional] [default to false]


