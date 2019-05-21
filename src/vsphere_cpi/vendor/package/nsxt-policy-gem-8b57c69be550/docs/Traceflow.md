# SwaggerClient::Traceflow

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**operation_state** | **String** | Represents the traceflow operation state | [optional] 
**logical_counters** | [**TraceflowObservationCounters**](TraceflowObservationCounters.md) | counters of observations from logical components | [optional] 
**timeout** | **Integer** | Maximum time (in ms) the management plane will be waiting for this traceflow round. | [optional] 
**result_overflowed** | **BOOLEAN** | A flag, when set true, indicates some observations were deleted from the result set. | [optional] 
**lport_id** | **String** | id of the source logical port used for injecting the traceflow packet | [optional] 
**counters** | [**TraceflowObservationCounters**](TraceflowObservationCounters.md) | observation counters | [optional] 
**request_status** | **String** | The status of the traceflow RPC request. SUCCESS - The traceflow request is sent successfully. TIMEOUT - The traceflow request gets timeout. SOURCE_PORT_NOT_FOUND - The source port of the request is not found. DATA_PATH_NOT_READY - The datapath component is not ready to receive request. CONNECTION_ERROR - There is connection error on datapath component. UNKNOWN - The status of traceflow request is not determined. | [optional] 
**analysis** | **Array&lt;String&gt;** | Traceflow result analysis notes | [optional] 
**id** | **String** | The id of the traceflow round | [optional] 


