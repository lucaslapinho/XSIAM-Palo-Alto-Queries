//Title
SSH Accepted Access and Session Command Review - Schema Binding Template

//Description
Preserves accepted SSH authentications and attaches audited exec events through a validated server-session key, showing missing command evidence explicitly.

//Category
Threat Hunting / Lateral Movement

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SSH_AUTH_DATASET}}
| alter event_time = {{SSH_AUTH_TIME}},
    endpoint = {{SSH_TARGET_ENDPOINT}},
    source = {{SSH_CLIENT_IP}},
    account = {{SSH_AUTH_ACCOUNT}},
    method = {{SSH_AUTH_METHOD}},
    session_key = {{SSH_SESSION_KEY}},
    auth_result = {{SSH_AUTH_RESULT}}
| filter auth_result = "success" and endpoint != null and session_key != null and session_key != ""
| join type = left conflict_strategy = left (
dataset = {{SSH_COMMAND_AUDIT_DATASET}}
| alter command_time = {{SSH_COMMAND_TIME}},
    command_endpoint = {{SSH_COMMAND_ENDPOINT}},
    command_session = {{SSH_COMMAND_SESSION}},
    command_uid = {{SSH_COMMAND_UID}},
    effective_user = {{SSH_EFFECTIVE_USER}},
    command_line = {{SSH_COMMAND_LINE}},
    command_operation = {{SSH_COMMAND_OPERATION}}
| filter command_operation = "exec" and command_session != null
) as commands endpoint = commands.command_endpoint and session_key = commands.command_session and commands.command_time >= event_time and timestamp_diff(commands.command_time, event_time, "SECOND") >= 0 and timestamp_diff(commands.command_time, event_time, "SECOND") <= 3600
| alter command_evidence = if(commands.command_uid != null, "SESSION_LINKED_EXEC", "NO_LINKED_EXEC_IN_WINDOW")
| fields event_time, endpoint, source, account, method, session_key, commands.command_time, commands.command_uid, commands.effective_user, commands.command_line, command_evidence
| sort desc event_time
| limit 1000
