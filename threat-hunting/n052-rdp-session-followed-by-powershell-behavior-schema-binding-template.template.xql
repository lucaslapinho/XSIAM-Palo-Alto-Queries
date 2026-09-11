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
| filter endpoint != null and session != null and session != "" and event_uid != null
| dedup event_uid by asc event_time
| join type = inner conflict_strategy = left (
dataset = {{SESSION_PROCESS_START_DATASET}}
| alter process_time = {{RDP_PROCESS_TIME}},
    process_endpoint = {{RDP_PROCESS_ENDPOINT}},
    process_session = {{RDP_PROCESS_LOGON_KEY}},
    process_instance = {{RDP_PROCESS_INSTANCE}},
    image = {{RDP_PROCESS_IMAGE}},
    command_line = {{RDP_PROCESS_COMMAND}},
    process_user = {{RDP_PROCESS_USER}},
    start_operation = {{RDP_PROCESS_OPERATION}}
| filter start_operation = "process_start" and process_endpoint != null and process_session != null and process_session != ""
| alter image = lowercase(image)
| filter image in ("powershell.exe", "pwsh.exe") and command_line != null
| filter command_line ~= {{POWERSHELL_BEHAVIOR_RE2}}
) as process endpoint = process.process_endpoint and session = process.process_session
| alter seconds_after_logon = timestamp_diff(process.process_time, event_time, "SECOND")
| filter seconds_after_logon >= 0 and seconds_after_logon <= 1800
| fields event_time, event_uid, endpoint, source, account, session, process.process_time, process.process_instance, process.image, process.command_line, process.process_user, seconds_after_logon
| sort desc event_time
| limit 1000
