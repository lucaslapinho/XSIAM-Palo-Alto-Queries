// Scope: Cortex XSIAM interactive XQL Search; one-day observation window.
// Full-query compilation and execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
// Select process starts, not every record with a process-related field.
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != ""
// REQUIRED: replace the exact sentinel with the stable agent_id under review.
| filter agent_id = "AGENT_ID_TO_REVIEW"

// Relevant investigation fields; actor fields describe the initiating process.
| fields
    _time,
    agent_id,
    agent_hostname,
    event_sub_type,
    action_process_image_name,
    action_process_image_path,
    action_process_image_command_line,
    action_process_username,
    action_process_instance_id,
    actor_process_image_name,
    actor_process_command_line,
    actor_process_instance_id,
    actor_effective_username,
    action_process_signature_vendor,
    action_process_signature_status,
    action_process_image_sha256
// Newest observed timestamps first; limit caps output, not upstream scanning.
| sort desc _time
| limit 1000
