//Title
Successful RDP Fan-Out Across Servers - Schema Binding Template

//Description
Counts distinct inventoried servers reached by successful RemoteInteractive logons per client/account in 15-minute bins, preserving criticality and logon-event volume.

//Category
Threat Hunting / Lateral Movement

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{WINDOWS_AUTH_DATASET}}
| alter event_time = {{AUTH_TIME}},
    event_uid = {{AUTH_EVENT_UID}},
    provider = {{AUTH_PROVIDER}},
    channel = {{AUTH_CHANNEL}},
    event_id = {{AUTH_EVENT_ID}},
    logon_type = {{AUTH_LOGON_TYPE}},
    endpoint = {{AUTH_TARGET_ENDPOINT}},
    source = {{AUTH_SOURCE_IP}},
    account = {{AUTH_TARGET_ACCOUNT_KEY}},
    session = {{AUTH_LOGON_KEY}}
| filter provider = "Microsoft-Windows-Security-Auditing" and channel = "Security" and event_id = 4624 and logon_type = 10
| filter event_uid != null and event_uid != "" and source != null and source != "" and account != null and account != "" and endpoint != null
| dedup event_uid by asc event_time
| join type = inner conflict_strategy = left (
dataset = {{SERVER_INVENTORY}}
| alter server_endpoint = {{SERVER_ENDPOINT}},
    server_role = {{SERVER_ROLE}},
    criticality = {{SERVER_CRITICALITY}},
    server_from = {{SERVER_VALID_FROM}},
    server_to = {{SERVER_VALID_TO}}
| filter server_role = "server"
) as servers endpoint = servers.server_endpoint and event_time >= servers.server_from and event_time < servers.server_to
| bin event_time span = 15m
| comp count() as successful_logon_events, count_distinct(endpoint) as server_count, values(endpoint) as servers, values(servers.criticality) as criticality_tiers by source, account, event_time
| filter server_count >= {{MIN_RDP_SERVERS}}
| fields event_time, source, account, server_count, successful_logon_events, servers, criticality_tiers
| sort desc server_count
| limit 1000
