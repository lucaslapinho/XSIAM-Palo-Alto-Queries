//Title
Threat Hunting - Domain Controller Database and Snapshot Activity

//Description
Builds a domain-controller timeline of actual NTDS path access/copy, raw reads of its volume, and relevant snapshot/database utility starts with outcome and backup context.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{DIRECTORY_DATABASE_ACTIVITY_DATASET}}
| alter event_time = {{DIRECTORY_DATABASE_ACTIVITY_EVENT_TIME}},
    host_id = {{DIRECTORY_DATABASE_ACTIVITY_HOST_ID}},
    operation = {{DIRECTORY_DATABASE_ACTIVITY_OPERATION}},
    object_path = {{DIRECTORY_DATABASE_ACTIVITY_OBJECT_PATH}},
    volume_path = {{DIRECTORY_DATABASE_ACTIVITY_VOLUME_PATH}},
    destination_path = {{DIRECTORY_DATABASE_ACTIVITY_DESTINATION_PATH}},
    process_name = {{DIRECTORY_DATABASE_ACTIVITY_PROCESS_NAME}},
    process_id = {{DIRECTORY_DATABASE_ACTIVITY_PROCESS_ID}},
    command_line = {{DIRECTORY_DATABASE_ACTIVITY_COMMAND_LINE}},
    subject = {{DIRECTORY_DATABASE_ACTIVITY_SUBJECT}},
    outcome = {{DIRECTORY_DATABASE_ACTIVITY_OUTCOME}},
    backup_context = {{DIRECTORY_DATABASE_ACTIVITY_BACKUP_CONTEXT}}
| fields event_time, host_id, operation, object_path, volume_path, destination_path, process_name, process_id, command_line, subject, outcome, backup_context
| join type = inner (
dataset = {{DOMAIN_CONTROLLER_DATABASES_DATASET}}
| alter dc_host = {{DOMAIN_CONTROLLER_DATABASES_DC_HOST}},
    database_path = {{DOMAIN_CONTROLLER_DATABASES_DATABASE_PATH}},
    database_volume = {{DOMAIN_CONTROLLER_DATABASES_DATABASE_VOLUME}},
    domain_name = {{DOMAIN_CONTROLLER_DATABASES_DOMAIN_NAME}}
| fields dc_host, database_path, database_volume, domain_name
) as dc host_id = dc.dc_host
| alter direct_database_activity = if(operation in ("FILE_READ", "FILE_COPY") and object_path = dc.database_path, true, false),
    raw_database_volume = if(operation = "RAW_VOLUME_READ" and volume_path = dc.database_volume, true, false),
    snapshot_tool_candidate = if(operation = "PROCESS_START" and process_name in ("ntdsutil.exe", "esentutl.exe", "vssadmin.exe", "wbadmin.exe", "diskshadow.exe"), true, false)
| filter direct_database_activity = true or raw_database_volume = true or snapshot_tool_candidate = true
| fields event_time, host_id, dc.domain_name, operation, object_path, volume_path, destination_path, process_name, process_id, command_line, subject, outcome, backup_context, direct_database_activity, raw_database_volume, snapshot_tool_candidate
| sort desc event_time
| limit 2000
