//Title
Cyber Hygiene - Expected Endpoints with Missing Recent Process or Network Telemetry

//Description
Compares an authoritative expected-active endpoint population with the latest process or network record in a seven-day window. Keeps endpoints with no matching telemetry and shows independent heartbeat context; silence is an investigation lead rather than proof of agent failure.

//Category
Cyber Hygiene / Collection Coverage

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 7d
| dataset = {{EXPECTED_ACTIVE_ENDPOINTS}}
| alter
    endpoint_id = {{EXPECTED_ENDPOINT_ID}},
    endpoint_name = {{EXPECTED_ENDPOINT_NAME}},
    is_expected = {{EXPECTED_ACTIVE_FLAG}},
    maintenance = {{EXPECTED_MAINTENANCE_FLAG}},
    heartbeat_time = {{EXPECTED_HEARTBEAT_TIME}}
| filter is_expected = true and maintenance = false and endpoint_id != null and endpoint_id != ""
| join type = left conflict_strategy = both (
 dataset = xdr_data
 | filter agent_id != null and agent_id != "" and event_type in (1, 2)
 | comp max(_time) as last_activity, count() as telemetry_rows by agent_id
) as t t.agent_id = endpoint_id
| alter inactivity_minutes = timestamp_diff(current_time(), t.last_activity, "MINUTE"), heartbeat_age_minutes = timestamp_diff(current_time(), heartbeat_time, "MINUTE")
| filter t.last_activity = null or inactivity_minutes > {{STALE_MINUTES}}
| fields endpoint_id, endpoint_name, heartbeat_time, heartbeat_age_minutes, t.last_activity, inactivity_minutes, t.telemetry_rows
| sort desc inactivity_minutes, asc endpoint_id
| limit 1000
