// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SSH_KEY_FILE_CHANGES_DATASET}}
| alter event_time = {{SSH_KEY_FILE_CHANGES_EVENT_TIME}},
    host_id = {{SSH_KEY_FILE_CHANGES_HOST_ID}},
    record_id = {{SSH_KEY_FILE_CHANGES_RECORD_ID}},
    file_path = {{SSH_KEY_FILE_CHANGES_FILE_PATH}},
    operation = {{SSH_KEY_FILE_CHANGES_OPERATION}},
    successful = {{SSH_KEY_FILE_CHANGES_SUCCESSFUL}},
    writer_id = {{SSH_KEY_FILE_CHANGES_WRITER_ID}},
    writer_process = {{SSH_KEY_FILE_CHANGES_WRITER_PROCESS}}
| fields event_time, host_id, record_id, file_path, operation, successful, writer_id, writer_process
| filter successful = true and operation in ("CREATE", "WRITE", "RENAME", "DELETE")
| join type = inner (
dataset = {{AUTHORIZED_KEYS_CONFIGURATION_DATASET}}
| alter key_host = {{AUTHORIZED_KEYS_CONFIGURATION_KEY_HOST}},
    key_path = {{AUTHORIZED_KEYS_CONFIGURATION_KEY_PATH}},
    account_id = {{AUTHORIZED_KEYS_CONFIGURATION_ACCOUNT_ID}},
    configuration_from = {{AUTHORIZED_KEYS_CONFIGURATION_CONFIGURATION_FROM}},
    configuration_until = {{AUTHORIZED_KEYS_CONFIGURATION_CONFIGURATION_UNTIL}}
| fields key_host, key_path, account_id, configuration_from, configuration_until
) as k host_id = k.key_host and file_path = k.key_path
| filter event_time >= k.configuration_from and (k.configuration_until = null or event_time < k.configuration_until)
| join type = left (
dataset = {{KEY_CHANGE_WINDOWS_DATASET}}
| alter w_host = {{KEY_CHANGE_WINDOWS_W_HOST}},
    w_account = {{KEY_CHANGE_WINDOWS_W_ACCOUNT}},
    window_start = {{KEY_CHANGE_WINDOWS_WINDOW_START}},
    window_end = {{KEY_CHANGE_WINDOWS_WINDOW_END}},
    change_id = {{KEY_CHANGE_WINDOWS_CHANGE_ID}}
| fields w_host, w_account, window_start, window_end, change_id
) as w host_id = w.w_host and k.account_id = w.w_account
| alter in_window = if(event_time >= w.window_start and event_time <= w.window_end, 1, 0), matching_change = if(event_time >= w.window_start and event_time <= w.window_end, w.change_id, null)
| comp sum(in_window) as matching_window_rows, values(matching_change) as change_references by event_time, host_id, record_id, file_path, operation, writer_id, writer_process, k.account_id
| alter window_state = if(matching_window_rows > 0, "APPROVED_WINDOW_OVERLAP", "NO_APPROVED_WINDOW_MATCH")
| fields event_time, host_id, record_id, file_path, operation, k.account_id, writer_id, writer_process, window_state, change_references
| sort desc event_time
| limit 1000
