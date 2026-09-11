// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{ROLE_API_AUDIT_SOURCE}}
| alter
    event_time = {{ROLE_API_TIME}},
    audit_actor = {{ROLE_API_ACTOR}},
    audit_type = {{ROLE_API_TYPE}},
    audit_action = {{ROLE_API_ACTION}},
    audit_result = {{ROLE_API_RESULT}},
    target_kind = {{ROLE_API_TARGET_KIND}},
    target_id = {{ROLE_API_SAFE_TARGET_ID}}
| filter audit_type in ({{ROLE_AND_API_EVENT_TYPES}}) and audit_action in ({{ROLE_AND_API_ACTIONS}})
| fields event_time, audit_actor, audit_type, audit_action, target_kind, target_id, audit_result
| sort desc event_time
| limit 1000
