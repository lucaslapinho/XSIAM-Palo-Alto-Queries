//Title
Threat Hunting - Rundll32 Module Paths and Unusual Argument Candidates

//Description
Reviews rundll32 URL/script/UNC command references or correlated module loads under user/profile/temporary path segments. Actual module identity is retained separately from argument heuristics.

//Category
Threat Hunting / Proxy Execution

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter action_process_image_name = "rundll32.exe"
| filter agent_id != null and action_process_instance_id != null
| alter process_time = _time, process_id = action_process_instance_id, endpoint_id = agent_id, command_line = action_process_image_command_line
| fields process_time, process_id, endpoint_id, command_line
| join type = left (
    dataset = xdr_data
    | filter {{MODULE_LOAD_EVENT_PREDICATE}}
    | fields _time as module_time, agent_id as module_host, action_module_process_instance_id as loader_id, action_module_path as module_path, action_module_sha256 as module_sha256
) as m endpoint_id = m.module_host and process_id = m.loader_id
| alter load_delay = timestamp_diff(m.module_time, process_time, "SECOND")
| alter load_in_window = if(load_delay >= 0 and load_delay <= 600, true, false),
    command_pattern = if(command_line ~= "(?i)(javascript:|https?://|\\\\)", true, false)
| alter loaded_path_candidate = if(load_in_window = true and m.module_path ~= "(?i)\\(users|temp|appdata)\\", true, false)
| filter command_pattern = true or loaded_path_candidate = true
| alter observed_module_path = if(load_in_window = true, m.module_path, null), observed_module_hash = if(load_in_window = true, m.module_sha256, null)
| fields process_time, endpoint_id, process_id, command_line, command_pattern, loaded_path_candidate, observed_module_path, observed_module_hash
| sort desc process_time
| limit 1000
