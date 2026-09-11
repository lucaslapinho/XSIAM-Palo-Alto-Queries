//Title
Asset Visibility - Latest Agent Version and Reported Health

//Description
Lists the latest reported agent version, content version, connectivity and protection state per stable endpoint from a verified health inventory source. Retains report age and tied latest rows rather than treating an old report as proof of current health.

//Category
Asset Visibility / Agent Health

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 7d
| dataset = {{ENDPOINT_HEALTH_INVENTORY}}
| alter
    endpoint_id = {{HEALTH_ENDPOINT_ID}},
    snapshot_time = {{HEALTH_SNAPSHOT_TIME}},
    endpoint_name = {{HEALTH_ENDPOINT_NAME}},
    agent_version = {{HEALTH_AGENT_VERSION}},
    content_version = {{HEALTH_CONTENT_VERSION}},
    last_seen = {{HEALTH_LAST_SEEN}},
    connectivity = {{HEALTH_CONNECTIVITY}},
    protection_state = {{HEALTH_PROTECTION_STATE}},
    group_names = {{HEALTH_GROUP_NAMES}}
| filter endpoint_id != null and endpoint_id != "" and snapshot_time != null
| windowcomp max(snapshot_time) by endpoint_id as latest_snapshot
| filter snapshot_time = latest_snapshot
| alter report_age_minutes = timestamp_diff(current_time(), snapshot_time, "MINUTE")
| fields endpoint_id, endpoint_name, snapshot_time, report_age_minutes, last_seen, agent_version, content_version, connectivity, protection_state, group_names
| sort desc report_age_minutes, asc endpoint_id
| limit 1000
