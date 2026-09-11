// QUERY_CANDIDATE: field/construct evidence does not certify tenant execution.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 30d
| dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| alter observed_hash = lowercase(action_process_image_sha256), observed_path = action_process_image_path, observed_user = action_process_username, evidence_family = "PROCESS_START"
| fields _time, agent_id, agent_hostname, observed_hash, observed_path, observed_user, evidence_family
| union (
    dataset = xdr_data
    | filter event_type = FILE
    | alter observed_hash = lowercase(action_file_sha256), observed_path = action_file_path, observed_user = actor_effective_username, evidence_family = "FILE_EVENT"
    | fields _time, agent_id, agent_hostname, observed_hash, observed_path, observed_user, evidence_family
)
| filter agent_id != null and agent_id != "" and observed_hash ~= "^[a-f0-9]{64}$"
| filter observed_hash = "SHA256_TO_REVIEW"
| comp count() as observed_event_rows, count_distinct(agent_id) as endpoint_prevalence, values(agent_id) as endpoint_ids, values(agent_hostname) as hostnames, values(observed_path) as paths, values(observed_user) as observed_users, min(_time) as first_observed, max(_time) as last_observed by observed_hash, evidence_family
| sort desc endpoint_prevalence
| limit 10
