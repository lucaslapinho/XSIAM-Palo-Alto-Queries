//Title
Investigation - File Creation Write Rename and Deletion Timeline

//Description
Returns validated create/write/rename/delete operations for an exact path on a selected endpoint, preserving both rename paths, producing process, actor and outcome.

//Category
Investigation / File Activity

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{FILE_OPERATIONS_DATASET}}
| alter event_time = {{FILE_OPERATIONS_EVENT_TIME}},
    host_id = {{FILE_OPERATIONS_HOST_ID}},
    operation = {{FILE_OPERATIONS_OPERATION}},
    old_path = {{FILE_OPERATIONS_OLD_PATH}},
    new_path = {{FILE_OPERATIONS_NEW_PATH}},
    file_hash = {{FILE_OPERATIONS_FILE_HASH}},
    process_id = {{FILE_OPERATIONS_PROCESS_ID}},
    writer = {{FILE_OPERATIONS_WRITER}},
    outcome = {{FILE_OPERATIONS_OUTCOME}}
| fields event_time, host_id, operation, old_path, new_path, file_hash, process_id, writer, outcome
| filter host_id = {{FILE_REVIEW_ENDPOINT}}
| filter operation in ("CREATE", "WRITE", "RENAME", "DELETE")
| filter old_path = {{FILE_REVIEW_EXACT_PATH}} or new_path = {{FILE_REVIEW_EXACT_PATH}}
| fields event_time, host_id, operation, old_path, new_path, file_hash, process_id, writer, outcome
| sort asc event_time
| limit 2000
