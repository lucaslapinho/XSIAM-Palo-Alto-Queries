// Scope: Cortex XSIAM interactive XQL Search; one-day observation window.
// Full-query compilation and execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
// Documented event category 2 is Network; retain operation subtype context.
| filter event_type = 2
| filter agent_id != null and agent_id != ""
// REQUIRED: replace the exact sentinel with the stable agent_id under review.
| filter agent_id = "AGENT_ID_TO_REVIEW"
// Preserve all Network subtypes and raw direction/success values, including nulls.

// Relevant investigation fields; actor fields describe the initiating process.
| fields
    _time,
    agent_id,
    agent_hostname,
    event_sub_type,
    action_local_ip,
    action_local_port,
    action_remote_ip,
    action_remote_port,
    action_network_is_server,
    action_network_protocol,
    action_network_success,
    action_network_connection_id,
    actor_process_image_name,
    actor_process_command_line,
    actor_process_instance_id,
    actor_effective_username
// Newest observed timestamps first; limit caps output, not upstream scanning.
| sort desc _time
| limit 1000
