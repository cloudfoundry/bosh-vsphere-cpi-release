# SwaggerClient::PacketCaptureRequest

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**node** | **String** | Define the transport node to capture data. | [optional] 
**cappoint** | **String** | Define the point to capture data. | 
**capduration** | **Integer** | Define the packet capture duration time. After the capture duration time, the capture process will stop working. | [optional] 
**capamount** | **Integer** | Define the packet capture amount size. | [optional] 
**capsource** | **String** | This type is used to differenite the incoming request from CLI/UI. | 
**filtertype** | **String** | Define the capture filter type. Support PRE/POST mode. | [optional] 
**direction** | **String** | Define the capture direction. Support three types INPUT/OUTPUT/DUAL. | [optional] 
**capfilesize** | **Integer** | Define the packet capture file size limit. | [optional] 
**options** | [**PacketCaptureOptionList**](PacketCaptureOptionList.md) | Define the packet capture additional options to filter the capture data. | [optional] 
**streamport** | **Integer** | Set the stream port to receive the capture packet. | [optional] 
**capsnaplen** | **Integer** | Limit the number of bytes captured from each packet. | [optional] 
**caprate** | **Integer** | Define the rate of packet capture process. | [optional] 
**capvalue** | **String** | Define the capture value of given capture point. | [optional] 
**streamaddress** | **String** | Set the stream address to receive the capture packet. | [optional] 
**capmode** | **String** | Define the capture streaming mode. The STREAM mode will send the data to given stream address and port. And the STANDALONE mode will save the capture file in local folder. | [optional] 


