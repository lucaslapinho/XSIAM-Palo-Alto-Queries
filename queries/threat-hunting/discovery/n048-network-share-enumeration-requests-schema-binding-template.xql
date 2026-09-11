//Title
Network Share Enumeration Requests - Schema Binding Template

//Description
Returns explicit server share-list requests from validated protocol operations or read-oriented command attempts, keeping their evidence kinds and outcomes distinct.

//Category
Threat Hunting / Discovery

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SHARE_ENUMERATION_DATASET}}
| alter event_time = {{SHARE_ENUM_TIME}},
    event_uid = {{SHARE_ENUM_UID}},
    endpoint = {{SHARE_ENUM_ENDPOINT}},
    account = {{SHARE_ENUM_ACCOUNT}},
    server = {{SHARE_ENUM_SERVER}},
    operation = {{SHARE_ENUM_OPERATION}},
    evidence_kind = {{SHARE_ENUM_KIND}},
    outcome = {{SHARE_ENUM_OUTCOME}},
    query_context = {{SHARE_ENUM_CONTEXT}}
| filter operation = "share_list" and server != null and server != ""
| filter evidence_kind in ("protocol_operation", "command_attempt")
| fields event_time, event_uid, endpoint, account, server, evidence_kind, outcome, query_context
| sort desc event_time
| limit 1000
