//Title
Security Tool Disablement Requests - Schema Binding Template

//Description
Finds explicit stop, deletion, uninstall or protection-disable requests against time-valid inventoried security targets, preserving action outcome without asserting effective disablement.

//Category
Threat Hunting / Defense Impairment

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SECURITY_CONTROL_ACTION_DATASET}}
| alter event_time = {{CONTROL_ACTION_TIME}},
    action_uid = {{CONTROL_ACTION_UID}},
    endpoint = {{CONTROL_ACTION_ENDPOINT}},
    actor = {{CONTROL_ACTION_ACTOR}},
    operation = {{CONTROL_ACTION_OPERATION}},
    target_type = {{CONTROL_TARGET_TYPE}},
    target_key = {{CONTROL_TARGET_KEY}},
    command_context = {{CONTROL_COMMAND_CONTEXT}},
    reported_result = {{CONTROL_REPORTED_RESULT}}
| filter operation in ("stop_service", "delete_service", "uninstall_product", "disable_protection")
| filter endpoint != null and target_key != null and target_key != ""
| join type = inner conflict_strategy = left (
dataset = {{ENDPOINT_SECURITY_TARGET_INVENTORY}}
| alter security_endpoint = {{CONTROL_INV_ENDPOINT}},
    security_type = {{CONTROL_INV_TYPE}},
    security_key = {{CONTROL_INV_KEY}},
    product = {{CONTROL_INV_PRODUCT}},
    valid_from = {{CONTROL_INV_FROM}},
    valid_to = {{CONTROL_INV_TO}}
) as security endpoint = security.security_endpoint and target_type = security.security_type and target_key = security.security_key and event_time >= security.valid_from and event_time < security.valid_to
| fields event_time, action_uid, endpoint, actor, operation, target_type, target_key, security.product, reported_result, command_context
| sort desc event_time
| limit 1000
