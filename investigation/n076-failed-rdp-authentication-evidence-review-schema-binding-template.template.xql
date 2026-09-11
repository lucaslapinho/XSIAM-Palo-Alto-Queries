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
| alter status = {{FAIL_STATUS}}, substatus = {{FAIL_SUBSTATUS}}, failure_reason = {{FAIL_REASON}}, correlation_key = {{RDP_FAILURE_CORRELATION_KEY}}
| filter provider = "Microsoft-Windows-Security-Auditing" and channel = "Security" and event_id = 4625
| join type = left conflict_strategy = left (
dataset = {{RDP_PROVIDER_FAILURE_DATASET}}
| alter rdp_endpoint = {{RDP_FAIL_ENDPOINT}},
    rdp_correlation = {{RDP_FAIL_CORRELATION}},
    rdp_event_uid = {{RDP_FAIL_EVENT_UID}},
    rdp_protocol = {{RDP_FAIL_PROTOCOL}},
    rdp_result = {{RDP_FAIL_RESULT}},
    rdp_time = {{RDP_FAIL_TIME}}
| filter rdp_protocol = "rdp" and rdp_result = "failure" and rdp_correlation != null and rdp_correlation != ""
) as rdp endpoint = rdp.rdp_endpoint and correlation_key = rdp.rdp_correlation and timestamp_diff(rdp.rdp_time, event_time, "SECOND") >= -120 and timestamp_diff(rdp.rdp_time, event_time, "SECOND") <= 120
| filter (logon_type = 10 or rdp.rdp_event_uid != null)
| alter attribution = if(logon_type = 10, "REMOTEINTERACTIVE_FAILURE", "LINKED_RDP_PROVIDER_FAILURE")
| fields event_time, event_uid, endpoint, source, account, logon_type, status, substatus, failure_reason, attribution, rdp.rdp_event_uid
| sort desc event_time
| limit 1000
