// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 31d
| dataset = {{WINDOWS_AUTH_DATASET}}
| alter event_time = {{AUTH_TIME}},
    event_uid = {{AUTH_EVENT_UID}},
    provider = {{AUTH_PROVIDER}},
    channel = {{AUTH_CHANNEL}},
    event_id = {{AUTH_EVENT_ID}},
    logon_type = {{AUTH_LOGON_TYPE}},
    endpoint = {{AUTH_TARGET_ENDPOINT}},
    source = {{AUTH_SOURCE_IP}},
    account = {{AUTH_TARGET_ACCOUNT_KEY}},
    session = {{AUTH_LOGON_KEY}}
| filter provider = "Microsoft-Windows-Security-Auditing" and channel = "Security" and event_id = 4624 and logon_type = 10
| filter event_time != null and endpoint != null and endpoint != "" and source != null and source != ""
| filter event_time <= current_time() and timestamp_diff(current_time(), event_time, "SECOND") >= 0 and timestamp_diff(current_time(), event_time, "SECOND") < 86400
| join type = left conflict_strategy = left (
dataset = {{WINDOWS_AUTH_DATASET}}
| alter base_event_time = {{AUTH_TIME}},
    base_event_uid = {{AUTH_EVENT_UID}},
    base_provider = {{AUTH_PROVIDER}},
    base_channel = {{AUTH_CHANNEL}},
    base_event_id = {{AUTH_EVENT_ID}},
    base_logon_type = {{AUTH_LOGON_TYPE}},
    base_endpoint = {{AUTH_TARGET_ENDPOINT}},
    base_source = {{AUTH_SOURCE_IP}},
    base_account = {{AUTH_TARGET_ACCOUNT_KEY}},
    base_session = {{AUTH_LOGON_KEY}}
| filter base_provider = "Microsoft-Windows-Security-Auditing" and base_channel = "Security" and base_event_id = 4624 and base_logon_type = 10
| filter base_source != null and base_source != "" and base_endpoint != null
| filter timestamp_diff(current_time(), base_event_time, "SECOND") >= 86400 and timestamp_diff(current_time(), base_event_time, "SECOND") < 2678400
| comp count() as baseline_events by base_endpoint, base_source
) as history endpoint = history.base_endpoint and source = history.base_source
| filter history.baseline_events = null
| join type = inner conflict_strategy = left (
dataset = {{RDP_BASELINE_COVERAGE}}
| alter coverage_endpoint = {{COVERAGE_ENDPOINT}},
    coverage_start = {{COVERAGE_START}},
    coverage_end = {{COVERAGE_END}},
    coverage_complete = {{COVERAGE_COMPLETE}}
| filter coverage_complete = true
| filter timestamp_diff(current_time(), coverage_start, "SECOND") >= 2678400 and timestamp_diff(current_time(), coverage_end, "SECOND") <= 86400
) as coverage endpoint = coverage.coverage_endpoint
| fields event_time, event_uid, endpoint, source, account, session, coverage.coverage_start, coverage.coverage_end
| sort desc event_time
| limit 1000
