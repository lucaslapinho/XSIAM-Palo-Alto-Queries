//Title
Investigation - Selected AWS Account API Audit Timeline

//Description
Returns AWS API audit activity for one account with operation, actor/session issuer, region, event category and original error code. Keeps management and data-event coverage explicit and does not collapse an assumed-role session into the human who may have initiated it.

//Category
Investigation / AWS Audit

:Query:

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
| filter account_id = {{AWS_ACCOUNT_TO_REVIEW}}
| alter region = json_extract_scalar(event_json, "$.awsRegion"),
    session_issuer = json_extract_scalar(event_json, "$.userIdentity.sessionContext.sessionIssuer.arn"),
    event_category = json_extract_scalar(event_json, "$.eventCategory"),
    read_only = json_extract_scalar(event_json, "$.readOnly"),
    request_id = json_extract_scalar(event_json, "$.requestID")
| fields event_time, event_id, request_id, account_id, region, event_category, event_source, event_name, read_only, actor_type, actor_arn, actor_principal, session_issuer, source_ip, error_code
| sort desc event_time
| limit 1000
