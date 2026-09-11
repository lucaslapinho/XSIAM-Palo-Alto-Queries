//Title
Threat Hunting - SAM Hive Save Attempts and Related Artifacts

//Description
Preserves parsed reg.exe SAM hive-save attempts and correlates SYSTEM hive access, save outcomes and requested-output file creation/write within 30 minutes.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != "" and action_process_instance_id != null and action_process_instance_id != ""
| filter action_process_image_name = "reg.exe"
| alter anchor_time = _time, endpoint_id = agent_id, anchor_process_id = action_process_instance_id,
    anchor_command = action_process_image_command_line, anchor_actor = action_process_username
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor
| alter requested_operation = {{REG_SAVE_OPERATION}}, requested_hive = {{REG_SOURCE_HIVE}}, requested_output = {{REG_OUTPUT_PATH}}
| filter requested_operation = "SAVE" and requested_hive = "HKLM\SAM"
| alter evidence_time = anchor_time, evidence_kind = "SAM_HIVE_SAVE_ATTEMPT", evidence_process_id = anchor_process_id,
    evidence_text = anchor_command, evidence_outcome = "OBSERVED_ANCHOR"
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, evidence_time, evidence_kind, evidence_process_id, evidence_text, evidence_outcome, requested_operation, requested_hive, requested_output
| union (
dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != "" and action_process_instance_id != null and action_process_instance_id != ""
| filter action_process_image_name = "reg.exe"
| alter anchor_time = _time, endpoint_id = agent_id, anchor_process_id = action_process_instance_id,
    anchor_command = action_process_image_command_line, anchor_actor = action_process_username
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor
| alter requested_operation = {{REG_SAVE_OPERATION}}, requested_hive = {{REG_SOURCE_HIVE}}, requested_output = {{REG_OUTPUT_PATH}}
| filter requested_operation = "SAVE" and requested_hive = "HKLM\SAM"
| join type = inner (
dataset = {{HIVE_EXPORT_CONTEXT_DATASET}}
| alter ctx_host = {{HIVE_EXPORT_CONTEXT_CTX_HOST}},
    ctx_root = {{HIVE_EXPORT_CONTEXT_CTX_ROOT}},
    ctx_time = {{HIVE_EXPORT_CONTEXT_CTX_TIME}},
    ctx_kind = {{HIVE_EXPORT_CONTEXT_CTX_KIND}},
    ctx_process = {{HIVE_EXPORT_CONTEXT_CTX_PROCESS}},
    ctx_text = {{HIVE_EXPORT_CONTEXT_CTX_TEXT}},
    ctx_outcome = {{HIVE_EXPORT_CONTEXT_CTX_OUTCOME}}
| fields ctx_host, ctx_root, ctx_time, ctx_kind, ctx_process, ctx_text, ctx_outcome
| filter ctx_kind in ("SYSTEM_HIVE_ACCESS", "SAM_HIVE_SAVE_RESULT", "REQUESTED_OUTPUT_FILE_CREATE", "REQUESTED_OUTPUT_FILE_WRITE")
) as context endpoint_id = context.ctx_host and anchor_process_id = context.ctx_root
| alter elapsed_seconds = timestamp_diff(context.ctx_time, anchor_time, "SECOND")
| filter elapsed_seconds >= 0 and elapsed_seconds <= 1800
| alter evidence_time = context.ctx_time, evidence_kind = context.ctx_kind,
    evidence_process_id = context.ctx_process, evidence_text = context.ctx_text, evidence_outcome = context.ctx_outcome
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, evidence_time, evidence_kind, evidence_process_id, evidence_text, evidence_outcome, requested_operation, requested_hive, requested_output
)
| sort desc anchor_time, asc evidence_time
| limit 2000
