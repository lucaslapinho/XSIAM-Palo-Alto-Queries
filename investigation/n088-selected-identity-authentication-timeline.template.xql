// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{AUTHENTICATION_EVENTS}}
| alter
    event_time = {{AUTH_TIME}},
    provider = {{AUTH_PROVIDER}},
    principal_id = {{AUTH_PRINCIPAL_ID}},
    principal_name = {{AUTH_PRINCIPAL_NAME}},
    outcome = {{AUTH_OUTCOME}},
    raw_result = {{AUTH_RAW_RESULT}},
    auth_kind = {{AUTH_KIND}},
    source_ip = {{AUTH_SOURCE_IP}},
    target = {{AUTH_TARGET}},
    correlation_id = {{AUTH_CORRELATION_ID}}
| filter principal_id = {{PRINCIPAL_TO_REVIEW}}
| fields event_time, provider, principal_id, principal_name, auth_kind, outcome, raw_result, source_ip, target, correlation_id
| sort desc event_time
| limit 1000
