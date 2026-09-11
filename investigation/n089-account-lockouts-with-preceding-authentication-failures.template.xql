// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{WINDOWS_LOCKOUT_EVENTS}}
| alter
    event_time = {{LOCKOUT_TIME}},
    principal_id = {{LOCKOUT_PRINCIPAL_ID}},
    lockout_id = {{LOCKOUT_RECORD_KEY}},
    caller_host = {{LOCKOUT_CALLER_HOST}},
    event_id = {{LOCKOUT_EVENT_ID}},
    provider = {{LOCKOUT_PROVIDER}}
| filter provider = "Microsoft-Windows-Security-Auditing" and event_id = 4740
| filter principal_id != null and principal_id != ""
| join type = left conflict_strategy = both (
dataset = {{WINDOWS_AUTH_FAILURES}}
| alter
    failure_time = {{FAILURE_TIME}},
    failure_principal = {{FAILURE_PRINCIPAL_ID}},
    failure_id = {{FAILURE_RECORD_KEY}},
    failure_event = {{FAILURE_EVENT_ID}},
    failure_provider = {{FAILURE_PROVIDER}},
    failure_source = {{FAILURE_SOURCE_IP}},
    failure_code = {{FAILURE_CODE}}
| filter failure_provider = "Microsoft-Windows-Security-Auditing" and failure_event in (4625, 4771)
| fields failure_time, failure_principal, failure_id, failure_event, failure_provider, failure_source, failure_code
) as f f.failure_principal = principal_id and f.failure_time <= event_time and timestamp_diff(event_time, f.failure_time, "SECOND") <= 1800
| fields event_time, lockout_id, principal_id, caller_host, f.failure_time, f.failure_event, f.failure_source, f.failure_code
| sort desc event_time
| limit 1000
