//Title
Threat Hunting - Office Command Shells and Subsequent Activity

//Description
Preserves verified Office-to-cmd process-start anchors and a ten-minute downstream command, download, write and network timeline after ancestry/source binding. Downloads require actual download evidence; a connection alone is not a download.

//Category
Threat Hunting / Execution

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != "" and action_process_instance_id != null and action_process_instance_id != ""
| alter direct_parent_image = {{VERIFIED_DIRECT_PARENT_IMAGE}}
| filter action_process_image_name = "cmd.exe" and direct_parent_image in ("winword.exe", "excel.exe", "powerpnt.exe", "outlook.exe", "msaccess.exe", "onenote.exe", "mspub.exe")
| alter anchor_time = _time, endpoint_id = agent_id, anchor_process_id = action_process_instance_id,
    anchor_command = action_process_image_command_line, anchor_actor = action_process_username
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor
| alter evidence_time = anchor_time, evidence_kind = "ANCHOR", evidence_process_id = anchor_process_id,
    evidence_text = anchor_command, evidence_outcome = "OBSERVED_ANCHOR"
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, evidence_time, evidence_kind, evidence_process_id, evidence_text, evidence_outcome
| union (
dataset = xdr_data
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != "" and action_process_instance_id != null and action_process_instance_id != ""
| alter direct_parent_image = {{VERIFIED_DIRECT_PARENT_IMAGE}}
| filter action_process_image_name = "cmd.exe" and direct_parent_image in ("winword.exe", "excel.exe", "powerpnt.exe", "outlook.exe", "msaccess.exe", "onenote.exe", "mspub.exe")
| alter anchor_time = _time, endpoint_id = agent_id, anchor_process_id = action_process_instance_id,
    anchor_command = action_process_image_command_line, anchor_actor = action_process_username
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor
| join type = inner (
dataset = {{OFFICE_DESCENDANT_ACTIVITY_DATASET}}
| alter ctx_host = {{OFFICE_DESCENDANT_ACTIVITY_CTX_HOST}},
    ctx_root = {{OFFICE_DESCENDANT_ACTIVITY_CTX_ROOT}},
    ctx_time = {{OFFICE_DESCENDANT_ACTIVITY_CTX_TIME}},
    ctx_kind = {{OFFICE_DESCENDANT_ACTIVITY_CTX_KIND}},
    ctx_process = {{OFFICE_DESCENDANT_ACTIVITY_CTX_PROCESS}},
    ctx_text = {{OFFICE_DESCENDANT_ACTIVITY_CTX_TEXT}},
    ctx_outcome = {{OFFICE_DESCENDANT_ACTIVITY_CTX_OUTCOME}}
| fields ctx_host, ctx_root, ctx_time, ctx_kind, ctx_process, ctx_text, ctx_outcome
| filter ctx_kind in ("PROCESS_START", "DOWNLOAD", "FILE_WRITE", "NETWORK")
) as context endpoint_id = context.ctx_host and anchor_process_id = context.ctx_root
| alter elapsed_seconds = timestamp_diff(context.ctx_time, anchor_time, "SECOND")
| filter elapsed_seconds >= 0 and elapsed_seconds <= 600
| alter evidence_time = context.ctx_time, evidence_kind = context.ctx_kind,
    evidence_process_id = context.ctx_process, evidence_text = context.ctx_text, evidence_outcome = context.ctx_outcome
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, evidence_time, evidence_kind, evidence_process_id, evidence_text, evidence_outcome
)
| sort desc anchor_time, asc evidence_time
| limit 2000
