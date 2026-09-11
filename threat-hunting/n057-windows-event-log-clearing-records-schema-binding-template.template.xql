// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{WINDOWS_LOG_CLEAR_DATASET}}
| alter event_time = {{LOG_CLEAR_TIME}},
    event_uid = {{LOG_CLEAR_UID}},
    endpoint = {{LOG_CLEAR_ENDPOINT}},
    provider = {{LOG_CLEAR_PROVIDER}},
    channel = {{LOG_CLEAR_CHANNEL}},
    event_id = {{LOG_CLEAR_EVENT_ID}},
    cleared_channel = {{LOG_CLEAR_TARGET_CHANNEL}},
    operation = {{LOG_CLEAR_OPERATION}},
    subject_sid = {{LOG_CLEAR_SUBJECT_SID}},
    subject_account = {{LOG_CLEAR_SUBJECT_ACCOUNT}},
    subject_logon = {{LOG_CLEAR_SUBJECT_LOGON}}
| filter operation = "log_cleared" and endpoint != null and cleared_channel != null and cleared_channel != ""
| filter ({{VERIFIED_CLEAR_EVENT_PREDICATE}})
| fields event_time, event_uid, endpoint, provider, channel, event_id, cleared_channel, subject_sid, subject_account, subject_logon
| sort desc event_time
| limit 1000
