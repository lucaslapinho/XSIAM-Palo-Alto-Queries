// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{AWS_CLOUDTRAIL_DATASET}}
| alter event_time = {{CT_EVENT_TIME}},
    event_uid = {{CT_EVENT_UID}},
    account = {{CT_ACCOUNT}},
    region = {{CT_REGION}},
    service = {{CT_EVENT_SOURCE}},
    operation = {{CT_EVENT_NAME}},
    trail_arn = {{CT_TRAIL_ARN}},
    actor = {{CT_ACTOR_SESSION}},
    source = {{CT_SOURCE_ADDRESS}},
    error_code = {{CT_ERROR_CODE}}
| filter service = "cloudtrail.amazonaws.com" and operation = "StopLogging"
| alter request_evidence = if(error_code != null, "API_ERROR_RECORDED", "NO_API_ERROR_RECORDED")
| join type = left conflict_strategy = left (
dataset = {{TRAIL_STATUS_SNAPSHOTS}}
| alter status_time = {{TRAIL_STATUS_TIME}},
    status_arn = {{TRAIL_STATUS_ARN}},
    status_account = {{TRAIL_STATUS_ACCOUNT}},
    is_logging = {{TRAIL_IS_LOGGING}}
) as status trail_arn = status.status_arn and account = status.status_account and status.status_time >= event_time and timestamp_diff(status.status_time, event_time, "SECOND") >= 0 and timestamp_diff(status.status_time, event_time, "SECOND") <= 900
| alter observed_trail_state = if(status.is_logging = false, "OBSERVED_NOT_LOGGING", if(status.is_logging = true, "OBSERVED_LOGGING", "UNKNOWN"))
| fields event_time, event_uid, account, region, trail_arn, actor, source, error_code, request_evidence, status.status_time, observed_trail_state
| sort desc event_time
| limit 1000
