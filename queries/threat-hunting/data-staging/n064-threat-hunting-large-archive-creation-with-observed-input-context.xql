//Title
Threat Hunting - Large Archive Creation with Observed Input Context

//Description
Links a process observed accessing many distinct input files to a sufficiently large archive it creates, preserving sensitive-data classification context. Supports staging investigation and later transfer pivots without equating an archiver command with a completed archive.

//Category
Threat Hunting / Data Staging

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{ARCHIVE_INPUT_OBSERVATIONS}}
| alter
    event_time = {{ARCHIVE_INPUT_TIME}},
    endpoint_id = {{ARCHIVE_ENDPOINT}},
    process_id = {{ARCHIVE_PROCESS}},
    input_path = {{ARCHIVE_INPUT_PATH}},
    sensitive_input = {{ARCHIVE_INPUT_SENSITIVE}},
    archive_operation = {{ARCHIVE_INPUT_OPERATION}},
    output_path = {{ARCHIVE_OUTPUT_PATH}}
| filter endpoint_id != null and process_id != null and input_path != null and output_path != null and archive_operation != null
| comp count_distinct(input_path) as distinct_input_files, max(event_time) as last_input, min(event_time) as first_input, values(sensitive_input) as sensitivity_flags by endpoint_id, process_id, archive_operation, output_path
| filter distinct_input_files >= {{MIN_INPUT_FILES}}
| join type = inner conflict_strategy = both (
dataset = {{ARCHIVE_OUTPUT_CREATIONS}}
| alter
    output_operation = {{ARCHIVE_CREATED_OPERATION}},
    output_time = {{ARCHIVE_CREATED_TIME}},
    output_endpoint = {{ARCHIVE_CREATED_ENDPOINT}},
    output_process = {{ARCHIVE_CREATED_PROCESS}},
    created_path = {{ARCHIVE_CREATED_PATH}},
    archive_bytes = {{ARCHIVE_CREATED_BYTES}},
    archive_hash = {{ARCHIVE_CREATED_SHA256}}
| fields output_operation, output_time, output_endpoint, output_process, created_path, archive_bytes, archive_hash
) as o o.output_endpoint = endpoint_id and o.output_process = process_id and o.created_path = output_path and o.output_operation = archive_operation and o.output_time >= last_input and timestamp_diff(o.output_time, last_input, "MINUTE") >= 0 and timestamp_diff(o.output_time, last_input, "SECOND") <= 1800
| filter o.archive_bytes >= {{MIN_ARCHIVE_BYTES}}
| fields endpoint_id, process_id, archive_operation, output_path, first_input, last_input, distinct_input_files, sensitivity_flags, o.output_time, o.archive_bytes, o.archive_hash
| sort desc o.archive_bytes
| limit 1000
