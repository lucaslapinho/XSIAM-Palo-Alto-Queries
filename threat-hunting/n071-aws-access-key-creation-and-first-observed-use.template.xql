// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{AWS_AUDIT_DATASET}}
| alter event_time = {{AWS_EVENT_TIME}}, event_json = {{AWS_EVENT_JSON}}
| alter event_source = json_extract_scalar(event_json, "$.eventSource"),
    event_name = json_extract_scalar(event_json, "$.eventName"),
    event_id = json_extract_scalar(event_json, "$.eventID"),
    account_id = json_extract_scalar(event_json, "$.recipientAccountId"),
    actor_arn = json_extract_scalar(event_json, "$.userIdentity.arn"),
    actor_principal = json_extract_scalar(event_json, "$.userIdentity.principalId"),
    actor_type = json_extract_scalar(event_json, "$.userIdentity.type"),
    source_ip = json_extract_scalar(event_json, "$.sourceIPAddress"),
    error_code = json_extract_scalar(event_json, "$.errorCode")
| filter event_source = "iam.amazonaws.com" and event_name = "CreateAccessKey"
| filter error_code = null or error_code = ""
| alter beneficiary = json_extract_scalar(event_json, "$.responseElements.accessKey.userName"),
    created_key_id = json_extract_scalar(event_json, "$.responseElements.accessKey.accessKeyId"),
    key_status = json_extract_scalar(event_json, "$.responseElements.accessKey.status"),
    key_created_at = json_extract_scalar(event_json, "$.responseElements.accessKey.createDate")
| filter created_key_id != null and account_id != null
| join type = left conflict_strategy = both (
dataset = {{AWS_ACCESS_KEY_USE_EVENTS}}
| alter
    use_time = {{AWS_KEY_USE_TIME}},
    used_key_id = {{AWS_USED_KEY_ID}},
    use_account = {{AWS_KEY_USE_ACCOUNT}},
    use_event = {{AWS_KEY_USE_EVENT}},
    use_source = {{AWS_KEY_USE_SOURCE}}
| fields use_time, used_key_id, use_account, use_event, use_source
) as u u.used_key_id = created_key_id and u.use_account = account_id and u.use_time >= event_time and timestamp_diff(u.use_time, event_time, "SECOND") <= 86400
| comp min(u.use_time) as first_observed_use, count(u.use_time) as matched_use_rows, values(u.use_event) as use_operations by event_time, event_id, account_id, actor_arn, beneficiary, created_key_id, key_status, key_created_at
| fields event_time, event_id, account_id, actor_arn, beneficiary, created_key_id, key_status, key_created_at, first_observed_use, matched_use_rows, use_operations
| sort desc event_time
| limit 1000
