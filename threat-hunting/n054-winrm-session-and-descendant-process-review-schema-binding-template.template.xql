// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{WINRM_SESSION_DATASET}}
| alter event_time = {{WINRM_AUTH_TIME}},
    endpoint = {{WINRM_ENDPOINT}},
    source = {{WINRM_SOURCE}},
    account = {{WINRM_ACCOUNT}},
    shell_key = {{WINRM_SHELL_KEY}},
    auth_result = {{WINRM_AUTH_RESULT}},
    provider_instance = {{WINRM_PROVIDER_INSTANCE}}
| filter auth_result = "success" and shell_key != null and shell_key != "" and provider_instance != null and endpoint != null
| join type = inner conflict_strategy = left (
dataset = {{WINRM_DESCENDANT_PROCESS_DATASET}}
| alter process_time = {{WINRM_PROCESS_TIME}},
    process_endpoint = {{WINRM_PROCESS_ENDPOINT}},
    ancestor_instance = {{WINRM_ANCESTOR_INSTANCE}},
    process_instance = {{WINRM_PROCESS_INSTANCE}},
    image = {{WINRM_PROCESS_IMAGE}},
    command_line = {{WINRM_PROCESS_COMMAND}},
    process_user = {{WINRM_PROCESS_USER}},
    process_operation = {{WINRM_PROCESS_OPERATION}}
| filter process_operation = "process_start" and ancestor_instance != null
) as executed endpoint = executed.process_endpoint and provider_instance = executed.ancestor_instance
| alter elapsed_seconds = timestamp_diff(executed.process_time, event_time, "SECOND")
| filter elapsed_seconds >= 0 and elapsed_seconds <= 1800
| fields event_time, endpoint, source, account, shell_key, provider_instance, executed.process_time, executed.process_instance, executed.image, executed.command_line, executed.process_user, elapsed_seconds
| sort desc event_time
| limit 1000
