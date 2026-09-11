//Title
Threat Hunting - Domain Account Discovery - Net User Query Attempts

//Description
Finds net.exe or net1.exe process starts requesting primary-domain user listings or a single user detail view with an explicit /domain switch. Restricts command shapes to exclude account-changing arguments; results show query attempts and require administrative context and outcome verification.

//Category
Threat Hunting / Account Discovery

:Query:

// Scope: Cortex XSIAM interactive XQL Search; one-day observation window.
// Full-query compilation and execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
// Select process starts, not every record with a process-related field.
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != ""
| filter action_process_image_name in ("net.exe", "net1.exe")
| filter action_process_image_command_line != null and action_process_image_command_line != ""
// Read-oriented net user [one ordinary username] /domain forms only.
// Local user queries, group commands, passwords and mutation options are excluded.
| filter action_process_image_command_line ~= "(?i)^\s*(?:\x22(?:[^\x22\r\n]*[\\/])?net1?(?:\.exe)?\x22|(?:[^\s\x22]*[\\/])?net1?(?:\.exe)?)\s+(?:user|\x22user\x22)\s+(?:(?:[A-Za-z0-9_.@$-]+|\x22[A-Za-z0-9_.@$-][A-Za-z0-9_.@$ -]*\x22)\s+)?(?:/domain|\x22/domain\x22)\s*$"

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
