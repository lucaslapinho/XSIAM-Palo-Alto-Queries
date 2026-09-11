// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 30d
| preset = host_inventory_applications
| filter endpoint_id != null and endpoint_id != "" and report_timestamp != null
| fields endpoint_id, endpoint_name, application_name, vendor, version, report_timestamp, platform
| join type = inner (
dataset = {{APPLICATION_SNAPSHOT_STATE_DATASET}}
| alter snapshot_endpoint = {{APPLICATION_SNAPSHOT_STATE_SNAPSHOT_ENDPOINT}},
    snapshot_time = {{APPLICATION_SNAPSHOT_STATE_SNAPSHOT_TIME}},
    snapshot_empty = {{APPLICATION_SNAPSHOT_STATE_SNAPSHOT_EMPTY}}
| fields snapshot_endpoint, snapshot_time, snapshot_empty
) as latest endpoint_id = latest.snapshot_endpoint and report_timestamp = latest.snapshot_time
| filter latest.snapshot_empty = false
| join type = left (
dataset = {{ENDPOINT_GROUP_MEMBERSHIP_DATASET}}
| alter group_endpoint = {{ENDPOINT_GROUP_MEMBERSHIP_GROUP_ENDPOINT}},
    group_name = {{ENDPOINT_GROUP_MEMBERSHIP_GROUP_NAME}},
    group_id = {{ENDPOINT_GROUP_MEMBERSHIP_GROUP_ID}}
| fields group_endpoint, group_name, group_id
) as g endpoint_id = g.group_endpoint
| fields endpoint_id, endpoint_name, application_name, vendor, version, report_timestamp, platform, g.group_id, g.group_name
| sort asc endpoint_name, asc application_name, asc version
| limit 5000
