// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{RECOVERY_CHANGE_AUDIT}}
| alter
    event_time = {{RECOVERY_TIME}},
    endpoint_id = {{RECOVERY_ENDPOINT}},
    operation_id = {{RECOVERY_OPERATION_ID}},
    actor = {{RECOVERY_ACTOR}},
    operation = {{RECOVERY_OPERATION}},
    resource_id = {{RECOVERY_RESOURCE}},
    request_result = {{RECOVERY_REQUEST_RESULT}}
| filter operation in ({{RECOVERY_OPERATIONS}}) and endpoint_id != null and operation_id != null
| join type = left conflict_strategy = both (
dataset = {{RECOVERY_STATE_CHANGES}}
| alter
    state_time = {{RECOVERY_STATE_TIME}},
    state_endpoint = {{RECOVERY_STATE_ENDPOINT}},
    state_operation = {{RECOVERY_STATE_OPERATION_ID}},
    state_resource = {{RECOVERY_STATE_RESOURCE}},
    before_state = {{RECOVERY_BEFORE_STATE}},
    after_state = {{RECOVERY_AFTER_STATE}}
| fields state_time, state_endpoint, state_operation, state_resource, before_state, after_state
) as s s.state_endpoint = endpoint_id and s.state_operation = operation_id and s.state_resource = resource_id and s.state_time >= event_time and timestamp_diff(s.state_time, event_time, "SECOND") <= 1800
| fields event_time, endpoint_id, operation_id, actor, operation, resource_id, request_result, s.state_time, s.before_state, s.after_state
| sort desc event_time
| limit 1000
