//Title
Security Tool Discovery Requests - Schema Binding Template

//Description
Finds read-oriented queries whose explicit targets resolve to inventoried security products, preserving registry/service/process query distinctions.

//Category
Threat Hunting / Discovery

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SECURITY_DISCOVERY_DATASET}}
| alter event_time = {{SEC_QUERY_TIME}},
    endpoint = {{SEC_QUERY_ENDPOINT}},
    actor = {{SEC_QUERY_ACTOR}},
    process_instance = {{SEC_QUERY_PROCESS}},
    operation = {{SEC_QUERY_OPERATION}},
    target_type = {{SEC_QUERY_TARGET_TYPE}},
    target_key = {{SEC_QUERY_TARGET_KEY}},
    query_text = {{SEC_QUERY_TEXT}}
| filter operation in ("registry_read", "service_query", "process_query", "software_query")
| filter target_key != null and target_key != ""
| join type = inner conflict_strategy = left (
dataset = {{SECURITY_PRODUCT_TARGETS}}
| alter sec_type = {{SEC_TARGET_TYPE}},
    sec_key = {{SEC_TARGET_KEY}},
    product = {{SEC_PRODUCT}},
    valid_from = {{SEC_TARGET_FROM}},
    valid_to = {{SEC_TARGET_TO}}
) as security target_type = security.sec_type and target_key = security.sec_key and event_time >= security.valid_from and event_time < security.valid_to
| fields event_time, endpoint, actor, process_instance, operation, target_type, target_key, security.product, query_text
| sort desc event_time
| limit 1000
