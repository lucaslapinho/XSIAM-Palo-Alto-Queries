//Title
Prevention Policy Enforcement Loss Across Snapshots - Schema Binding Template

//Description
Compares controlled before/after effective-policy snapshots for each endpoint and protection scope, selecting enforced-to-unenforced transitions tied to successful policy changes.

//Category
Threat Hunting / Defense Impairment

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{PREVENTION_CHANGE_DATASET}}
| alter event_time = {{POLICY_CHANGE_TIME}},
    change_uid = {{POLICY_CHANGE_UID}},
    policy_id = {{POLICY_OBJECT_ID}},
    actor = {{POLICY_CHANGE_ACTOR}},
    result = {{POLICY_CHANGE_RESULT}},
    before_snapshot = {{POLICY_BEFORE_SNAPSHOT}},
    after_snapshot = {{POLICY_AFTER_SNAPSHOT}}
| filter result = "success" and before_snapshot != null and after_snapshot != null and before_snapshot != after_snapshot
| join type = inner conflict_strategy = left (
dataset = {{EFFECTIVE_PREVENTION_SNAPSHOTS}}
| alter old_snapshot = {{EFFECTIVE_SNAPSHOT_ID}},
    old_endpoint = {{EFFECTIVE_ENDPOINT}},
    old_control = {{EFFECTIVE_CONTROL_KEY}},
    old_enforced = {{EFFECTIVE_ENFORCED}},
    old_mode = {{EFFECTIVE_RAW_MODE}}
) as before before_snapshot = before.old_snapshot
| join type = inner conflict_strategy = left (
dataset = {{EFFECTIVE_PREVENTION_SNAPSHOTS}}
| alter new_snapshot = {{EFFECTIVE_SNAPSHOT_ID}},
    new_endpoint = {{EFFECTIVE_ENDPOINT}},
    new_control = {{EFFECTIVE_CONTROL_KEY}},
    new_enforced = {{EFFECTIVE_ENFORCED}},
    new_mode = {{EFFECTIVE_RAW_MODE}}
) as after after_snapshot = after.new_snapshot and before.old_endpoint = after.new_endpoint and before.old_control = after.new_control
| filter before.old_enforced = true and after.new_enforced = false
| fields event_time, change_uid, policy_id, actor, before.old_endpoint, before.old_control, before.old_mode, after.new_mode, before_snapshot, after_snapshot
| sort desc event_time
| limit 1000
