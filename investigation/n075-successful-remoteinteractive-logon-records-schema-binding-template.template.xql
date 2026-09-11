// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
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
| filter event_uid != null and event_uid != ""
| dedup event_uid by asc event_time
| fields event_time, event_uid, endpoint, source, account, session, provider, channel, event_id, logon_type
| sort desc event_time
| limit 1000
