//Title
Asset Visibility - Latest Local Administrators Membership Snapshot

//Description
Lists direct members of the built-in local Administrators group from the latest complete membership snapshot per endpoint. Preserves explicit empty snapshots and excludes domain controllers; nested effective membership requires a separate directory expansion.

//Category
Asset Visibility / Local Privileges

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 7d
| dataset = {{LOCAL_MEMBERSHIP_SNAPSHOTS}}
| alter
    endpoint_id = {{MEMBERSHIP_ENDPOINT_ID}},
    snapshot_time = {{MEMBERSHIP_SNAPSHOT_TIME}},
    snapshot_complete = {{MEMBERSHIP_SNAPSHOT_COMPLETE}},
    endpoint_role = {{MEMBERSHIP_ENDPOINT_ROLE}},
    group_sid = {{LOCAL_GROUP_SID}},
    member_sid = {{LOCAL_MEMBER_SID}},
    member_name = {{LOCAL_MEMBER_NAME}},
    member_kind = {{LOCAL_MEMBER_KIND}}
| filter snapshot_complete = true and endpoint_id != null and endpoint_id != ""
| filter endpoint_role in ("workstation", "member_server")
| filter group_sid = "S-1-5-32-544"
| windowcomp max(snapshot_time) by endpoint_id, group_sid as latest_snapshot
| filter snapshot_time = latest_snapshot
| fields endpoint_id, snapshot_time, group_sid, member_sid, member_name, member_kind
| sort asc endpoint_id, asc member_sid
| limit 1000
