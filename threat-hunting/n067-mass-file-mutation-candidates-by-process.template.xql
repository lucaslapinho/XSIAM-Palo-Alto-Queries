// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{FILE_MUTATION_EVENTS}}
| alter
    event_time = {{MUTATION_TIME}},
    endpoint_id = {{MUTATION_ENDPOINT}},
    process_id = {{MUTATION_PROCESS}},
    operation = {{MUTATION_OPERATION}},
    operation_success = {{MUTATION_SUCCESS}},
    file_key = {{MUTATION_FILE_KEY}},
    old_path = {{MUTATION_OLD_PATH}},
    new_path = {{MUTATION_NEW_PATH}},
    user_id = {{MUTATION_USER}}
| filter operation in ("write", "rename", "delete") and operation_success = true
| filter endpoint_id != null and process_id != null and file_key != null
| bin event_time span = 5m
| comp count() as mutation_rows, count_distinct(file_key) as modified_files, values(operation) as operations, values(user_id) as users by event_time, endpoint_id, process_id
| filter modified_files >= {{MIN_MODIFIED_FILES}}
| fields event_time, endpoint_id, process_id, modified_files, mutation_rows, operations, users
| sort desc modified_files, desc event_time
| limit 1000
