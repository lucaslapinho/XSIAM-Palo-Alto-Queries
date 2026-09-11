//Title
Privileged Domain Group Discovery - Schema Binding Template

//Description
Selects read-oriented requests targeting authoritative privileged domain-group SIDs, preserving requester and raw query context. Localized names are resolved through a time-valid group inventory.

//Category
Threat Hunting / Discovery

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{DIRECTORY_QUERY_DATASET}}
| alter event_time = {{GROUP_QUERY_TIME}},
    endpoint = {{GROUP_QUERY_ENDPOINT}},
    actor = {{GROUP_QUERY_ACTOR}},
    operation = {{GROUP_QUERY_OPERATION}},
    group_sid = {{GROUP_QUERY_SID}},
    query_text = {{GROUP_QUERY_TEXT}},
    outcome = {{GROUP_QUERY_OUTCOME}}
| filter operation = "group_read" and group_sid != null and group_sid != ""
| join type = inner conflict_strategy = left (
dataset = {{PRIVILEGED_GROUP_INVENTORY}}
| alter priv_sid = {{PRIV_GROUP_SID}},
    priv_name = {{PRIV_GROUP_NAME}},
    priv_realm = {{PRIV_GROUP_REALM}},
    valid_from = {{PRIV_GROUP_FROM}},
    valid_to = {{PRIV_GROUP_TO}}
) as privileged group_sid = privileged.priv_sid and event_time >= privileged.valid_from and event_time < privileged.valid_to
| fields event_time, endpoint, actor, group_sid, privileged.priv_name, privileged.priv_realm, query_text, outcome
| sort desc event_time
| limit 1000
