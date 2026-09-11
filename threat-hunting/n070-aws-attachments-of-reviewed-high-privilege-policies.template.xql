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
| filter event_source = "iam.amazonaws.com" and event_name in ("AttachRolePolicy", "AttachUserPolicy", "AttachGroupPolicy")
| filter error_code = null or error_code = ""
| alter policy_arn = json_extract_scalar(event_json, "$.requestParameters.policyArn"),
    beneficiary_role = json_extract_scalar(event_json, "$.requestParameters.roleName"),
    beneficiary_user = json_extract_scalar(event_json, "$.requestParameters.userName"),
    beneficiary_group = json_extract_scalar(event_json, "$.requestParameters.groupName")
| filter account_id != null and policy_arn != null
| join type = inner conflict_strategy = both (
dataset = {{REVIEWED_HIGH_PRIVILEGE_POLICY_HISTORY}}
| alter
    review_policy_arn = {{PRIVILEGED_POLICY_ARN}},
    review_account = {{PRIVILEGED_POLICY_ACCOUNT}},
    review_from = {{PRIVILEGED_POLICY_FROM}},
    review_until = {{PRIVILEGED_POLICY_UNTIL}},
    review_scope = {{PRIVILEGED_POLICY_REASON}}
| fields review_policy_arn, review_account, review_from, review_until, review_scope
) as pol pol.review_policy_arn = policy_arn and pol.review_account = account_id and event_time >= pol.review_from and event_time < pol.review_until
| fields event_time, event_id, account_id, actor_arn, actor_principal, event_name, beneficiary_role, beneficiary_user, beneficiary_group, policy_arn, pol.review_scope, source_ip
| sort desc event_time
| limit 1000
