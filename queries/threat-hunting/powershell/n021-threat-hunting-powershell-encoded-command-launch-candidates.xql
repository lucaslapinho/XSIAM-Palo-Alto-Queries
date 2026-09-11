//Title
Threat Hunting - PowerShell Encoded Command Launch Candidates

//Description
Finds process-start records for Windows PowerShell or pwsh with selected encoded-command launch switches and a Base64-shaped argument. Returns image, user, initiating-process and signature context; matching does not validate the payload or prove successful or malicious execution.

//Category
Threat Hunting / PowerShell

:Query:

// Scope: Cortex XSIAM interactive XQL Search; one-day observation window.
// Full-query compilation and execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = xdr_data
// Select process starts, not every record with a process-related field.
| filter event_type = PROCESS and event_sub_type = PROCESS_START
| filter agent_id != null and agent_id != ""
| filter action_process_image_name in ("powershell.exe", "pwsh.exe")
| filter action_process_image_command_line != null and action_process_image_command_line != ""
// Anchored argument grammar avoids mistaking inline Command/File text for a launch switch.
// Only selected full startup options and documented encoded-switch spellings are covered.
| filter (
    (action_process_image_name = "powershell.exe" and action_process_image_command_line ~= "(?i)^\s*(?:\x22(?:[^\x22\r\n]*[\\/])?powershell(?:\.exe)?\x22|(?:[^\s\x22]*[\\/])?powershell(?:\.exe)?)(?:\s+(?:(?:-(?:NoProfile|NonInteractive|NoLogo|NoExit|STA|MTA)|\x22-(?:NoProfile|NonInteractive|NoLogo|NoExit|STA|MTA)\x22)|(?:-ExecutionPolicy|\x22-ExecutionPolicy\x22)\s+(?:(?:Bypass|Unrestricted|RemoteSigned|AllSigned|Restricted|Default|Undefined)|\x22(?:Bypass|Unrestricted|RemoteSigned|AllSigned|Restricted|Default|Undefined)\x22)|(?:-WindowStyle|\x22-WindowStyle\x22)\s+(?:(?:Normal|Minimized|Maximized|Hidden)|\x22(?:Normal|Minimized|Maximized|Hidden)\x22)))*\s+(?:-(?:EncodedCommand|enc)|\x22-(?:EncodedCommand|enc)\x22)\s+(?:[A-Za-z0-9+/]+={0,2}|\x22[A-Za-z0-9+/]+={0,2}\x22)\s*$")
    or (action_process_image_name = "pwsh.exe" and action_process_image_command_line ~= "(?i)^\s*(?:\x22(?:[^\x22\r\n]*[\\/])?pwsh(?:\.exe)?\x22|(?:[^\s\x22]*[\\/])?pwsh(?:\.exe)?)(?:\s+(?:(?:-(?:NoProfile|NonInteractive|NoLogo|NoExit|STA|MTA)|\x22-(?:NoProfile|NonInteractive|NoLogo|NoExit|STA|MTA)\x22)|(?:-ExecutionPolicy|\x22-ExecutionPolicy\x22)\s+(?:(?:Bypass|Unrestricted|RemoteSigned|AllSigned|Restricted|Default|Undefined)|\x22(?:Bypass|Unrestricted|RemoteSigned|AllSigned|Restricted|Default|Undefined)\x22)|(?:-WindowStyle|\x22-WindowStyle\x22)\s+(?:(?:Normal|Minimized|Maximized|Hidden)|\x22(?:Normal|Minimized|Maximized|Hidden)\x22)))*\s+(?:-(?:EncodedCommand|e|ec|enc)|\x22-(?:EncodedCommand|e|ec|enc)\x22)\s+(?:[A-Za-z0-9+/]+={0,2}|\x22[A-Za-z0-9+/]+={0,2}\x22)\s*$")
)

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
