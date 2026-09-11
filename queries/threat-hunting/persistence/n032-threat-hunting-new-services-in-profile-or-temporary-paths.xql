//Title
Threat Hunting - New Services in Profile or Temporary Paths

//Description
Preserves successful service-install records whose configured executable path matches a profile/temporary heuristic and adds first observed same-path process-start context within one hour.

//Category
Threat Hunting / Persistence

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{SERVICE_INSTALL_DATASET}}
| alter anchor_time = {{SERVICE_INSTALL_ANCHOR_TIME}},
    endpoint_id = {{SERVICE_INSTALL_ENDPOINT_ID}},
    anchor_process_id = {{SERVICE_INSTALL_ANCHOR_PROCESS_ID}},
    anchor_command = {{SERVICE_INSTALL_ANCHOR_COMMAND}},
    anchor_actor = {{SERVICE_INSTALL_ANCHOR_ACTOR}},
    service_name = {{SERVICE_INSTALL_SERVICE_NAME}},
    service_account = {{SERVICE_INSTALL_SERVICE_ACCOUNT}},
    service_executable = {{SERVICE_INSTALL_SERVICE_EXECUTABLE}},
    event_id = {{SERVICE_INSTALL_EVENT_ID}}
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, service_name, service_account, service_executable, event_id
| filter event_id = 4697
| filter service_executable ~= "(?i)\\(users|temp|appdata)\\"
| alter evidence_kind = "SERVICE_INSTALL", first_execution_time = null, execution_ids = null
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, service_name, service_account, service_executable, evidence_kind, first_execution_time, execution_ids
| union (
dataset = {{SERVICE_INSTALL_DATASET}}
| alter anchor_time = {{SERVICE_INSTALL_ANCHOR_TIME}},
    endpoint_id = {{SERVICE_INSTALL_ENDPOINT_ID}},
    anchor_process_id = {{SERVICE_INSTALL_ANCHOR_PROCESS_ID}},
    anchor_command = {{SERVICE_INSTALL_ANCHOR_COMMAND}},
    anchor_actor = {{SERVICE_INSTALL_ANCHOR_ACTOR}},
    service_name = {{SERVICE_INSTALL_SERVICE_NAME}},
    service_account = {{SERVICE_INSTALL_SERVICE_ACCOUNT}},
    service_executable = {{SERVICE_INSTALL_SERVICE_EXECUTABLE}},
    event_id = {{SERVICE_INSTALL_EVENT_ID}}
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, service_name, service_account, service_executable, event_id
| filter event_id = 4697
| filter service_executable ~= "(?i)\\(users|temp|appdata)\\"
| join type = inner (
dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| alter execution_time = _time, execution_host = agent_id, executed_path = lowercase(action_process_image_path), execution_id = action_process_instance_id
| fields execution_time, execution_host, executed_path, execution_id
) as e endpoint_id = e.execution_host and service_executable = e.executed_path
| alter delay_seconds = timestamp_diff(e.execution_time, anchor_time, "SECOND")
| filter delay_seconds >= 0 and delay_seconds <= 3600
| comp min(e.execution_time) as first_execution_time, values(e.execution_id) as execution_ids by anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, service_name, service_account, service_executable
| alter evidence_kind = "FIRST_OBSERVED_MATCHING_EXECUTION"
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, service_name, service_account, service_executable, evidence_kind, first_execution_time, execution_ids
)
| sort desc anchor_time
| limit 1000
