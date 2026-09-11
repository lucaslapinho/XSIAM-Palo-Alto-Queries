// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{GROUP_ADDITIONS_DATASET}}
| alter event_time = {{GROUP_ADDITIONS_EVENT_TIME}},
    host_id = {{GROUP_ADDITIONS_HOST_ID}},
    event_id = {{GROUP_ADDITIONS_EVENT_ID}},
    record_id = {{GROUP_ADDITIONS_RECORD_ID}},
    actor_sid = {{GROUP_ADDITIONS_ACTOR_SID}},
    actor_scope = {{GROUP_ADDITIONS_ACTOR_SCOPE}},
    member_sid = {{GROUP_ADDITIONS_MEMBER_SID}},
    member_scope = {{GROUP_ADDITIONS_MEMBER_SCOPE}},
    group_sid = {{GROUP_ADDITIONS_GROUP_SID}},
    change_reference = {{GROUP_ADDITIONS_CHANGE_REFERENCE}}
| fields event_time, host_id, event_id, record_id, actor_sid, actor_scope, member_sid, member_scope, group_sid, change_reference
| filter event_id in (4728, 4732, 4756)
| filter group_sid != null and group_sid != ""
| join type = inner (
dataset = {{PRIVILEGED_GROUPS_DATASET}}
| alter pg_sid = {{PRIVILEGED_GROUPS_PG_SID}},
    pg_scope = {{PRIVILEGED_GROUPS_PG_SCOPE}},
    pg_name = {{PRIVILEGED_GROUPS_PG_NAME}},
    pg_host = {{PRIVILEGED_GROUPS_PG_HOST}}
| fields pg_sid, pg_scope, pg_name, pg_host
) as pg group_sid = pg.pg_sid and host_id = pg.pg_host
| join type = left (
dataset = {{SID_DIRECTORY_DATASET}}
| alter dir_sid = {{SID_DIRECTORY_DIR_SID}},
    dir_scope = {{SID_DIRECTORY_DIR_SCOPE}},
    dir_name = {{SID_DIRECTORY_DIR_NAME}},
    dir_kind = {{SID_DIRECTORY_DIR_KIND}}
| fields dir_sid, dir_scope, dir_name, dir_kind
) as actor actor_sid = actor.dir_sid and actor_scope = actor.dir_scope
| join type = left (
dataset = {{SID_DIRECTORY_DATASET}}
| alter dir_sid = {{SID_DIRECTORY_DIR_SID}},
    dir_scope = {{SID_DIRECTORY_DIR_SCOPE}},
    dir_name = {{SID_DIRECTORY_DIR_NAME}},
    dir_kind = {{SID_DIRECTORY_DIR_KIND}}
| fields dir_sid, dir_scope, dir_name, dir_kind
) as member member_sid = member.dir_sid and member_scope = member.dir_scope
| alter initiator = actor.dir_name, added_member = member.dir_name, privileged_group = pg.pg_name,
    change_context = if(change_reference = null, "NO_ESTABLISHED_CHANGE_REFERENCE", "CHANGE_REFERENCE_PRESENT")
| fields event_time, host_id, record_id, event_id, actor_sid, actor_scope, initiator, member_sid, member_scope, added_member, group_sid, privileged_group, change_context, change_reference
| sort desc event_time
| limit 1000
