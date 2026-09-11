//Title
Threat Hunting - Scheduled Task Configuration Change Review

//Description
Reviews task creation and modification configurations against the current approved configuration snapshot, preserving subject, XML author, actions, triggers, principal and run level.

//Category
Threat Hunting / Persistence

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{TASK_AUDIT_DATASET}}
| alter task_time = {{TASK_AUDIT_TASK_TIME}},
    host_id = {{TASK_AUDIT_HOST_ID}},
    record_key = {{TASK_AUDIT_RECORD_KEY}},
    event_id = {{TASK_AUDIT_EVENT_ID}},
    task_name = {{TASK_AUDIT_TASK_NAME}},
    creator_sid = {{TASK_AUDIT_CREATOR_SID}},
    xml_author = {{TASK_AUDIT_XML_AUTHOR}},
    action_command = {{TASK_AUDIT_ACTION_COMMAND}},
    task_triggers = {{TASK_AUDIT_TASK_TRIGGERS}},
    run_principal = {{TASK_AUDIT_RUN_PRINCIPAL}},
    run_level = {{TASK_AUDIT_RUN_LEVEL}},
    task_xml = {{TASK_AUDIT_TASK_XML}},
    config_key = {{TASK_AUDIT_CONFIG_KEY}}
| fields task_time, host_id, record_key, event_id, task_name, creator_sid, xml_author, action_command, task_triggers, run_principal, run_level, task_xml, config_key
| filter event_id in (4698, 4702)
| join type = left (
dataset = {{APPROVED_TASKS_DATASET}}
| alter approved_host = {{APPROVED_TASKS_APPROVED_HOST}},
    approved_config = {{APPROVED_TASKS_APPROVED_CONFIG}},
    approval_id = {{APPROVED_TASKS_APPROVAL_ID}}
| fields approved_host, approved_config, approval_id
) as approved host_id = approved.approved_host and config_key = approved.approved_config
| alter path_candidate = if(action_command ~= "(?i)\\(users|temp|appdata)\\", true, false), elevated_context = if(run_level = "HighestAvailable", true, false),
    baseline_state = if(config_key = null, "UNASSESSED", if(approved.approval_id = null, "NOT_IN_CURRENT_APPROVED_BASELINE", "CURRENT_APPROVED_CONFIGURATION"))
| filter baseline_state != "CURRENT_APPROVED_CONFIGURATION" or path_candidate = true or elevated_context = true
| fields task_time, host_id, record_key, event_id, task_name, creator_sid, xml_author, action_command, task_triggers, run_principal, run_level, task_xml, baseline_state, path_candidate, elevated_context
| sort desc task_time
| limit 1000
