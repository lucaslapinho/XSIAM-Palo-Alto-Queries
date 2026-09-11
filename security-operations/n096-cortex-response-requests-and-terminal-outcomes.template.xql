// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{RESPONSE_AUDIT_EVENTS}}
| alter
    event_time = {{RESPONSE_TIME}},
    action_id = {{RESPONSE_ACTION_ID}},
    endpoint_id = {{RESPONSE_ENDPOINT_ID}},
    actor = {{RESPONSE_ACTOR}},
    action_type = {{RESPONSE_ACTION_TYPE}},
    stage = {{RESPONSE_STAGE}},
    result = {{RESPONSE_RESULT}}
| filter stage in ({{REQUEST_STAGES}}) and action_id != null and action_id != ""
| join type = left conflict_strategy = both (
dataset = {{RESPONSE_AUDIT_EVENTS}}
| alter
    terminal_event_time = {{RESPONSE_TIME}},
    terminal_action_id = {{RESPONSE_ACTION_ID}},
    terminal_endpoint_id = {{RESPONSE_ENDPOINT_ID}},
    terminal_actor = {{RESPONSE_ACTOR}},
    terminal_action_type = {{RESPONSE_ACTION_TYPE}},
    terminal_stage = {{RESPONSE_STAGE}},
    terminal_result = {{RESPONSE_RESULT}}
| filter terminal_stage in ({{TERMINAL_STAGES}})
| fields terminal_event_time, terminal_action_id, terminal_endpoint_id, terminal_actor, terminal_action_type, terminal_stage, terminal_result
) as done done.terminal_action_id = action_id and done.terminal_endpoint_id = endpoint_id and done.terminal_event_time >= event_time and timestamp_diff(done.terminal_event_time, event_time, "SECOND") <= 86400
| alter elapsed_minutes = timestamp_diff(done.terminal_event_time, event_time, "MINUTE")
| fields event_time, action_id, endpoint_id, actor, action_type, stage, result, done.terminal_event_time, done.terminal_stage, done.terminal_result, elapsed_minutes
| sort desc event_time
| limit 1000
