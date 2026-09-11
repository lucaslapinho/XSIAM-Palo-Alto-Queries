// QUERY_CANDIDATE: field/construct evidence does not certify tenant execution.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 30d
| dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != ""
| alter executable_hash = lowercase(action_process_image_sha256), age_seconds = timestamp_diff(current_time(), _time, "SECOND")
| filter executable_hash ~= "^[a-f0-9]{64}$" and age_seconds >= 0 and age_seconds < 2592000
// Current last 24 hours and prior 29 days are disjoint; current rows never enter the prior count.
| alter current_flag = if(age_seconds < 86400, 1, 0), prior_flag = if(age_seconds >= 86400, 1, 0), current_host = if(age_seconds < 86400, agent_id, null), current_path = if(age_seconds < 86400, action_process_image_path, null), current_user = if(age_seconds < 86400, action_process_username, null)
| comp sum(current_flag) as current_start_rows, sum(prior_flag) as prior_start_rows, values(current_host) as current_endpoints, values(current_path) as current_paths, values(current_user) as current_users, min(_time) as first_observed, max(_time) as last_observed by executable_hash
| filter current_start_rows > 0 and prior_start_rows = 0
| fields executable_hash, current_start_rows, prior_start_rows, current_endpoints, current_paths, current_users, first_observed, last_observed
| sort desc current_start_rows
| limit 1000
