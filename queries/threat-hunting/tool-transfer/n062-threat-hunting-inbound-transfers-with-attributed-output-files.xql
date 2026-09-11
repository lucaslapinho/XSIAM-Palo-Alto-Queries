//Title
Threat Hunting - Inbound Transfers with Attributed Output Files

//Description
Correlates successful inbound transfer observations with a candidate output file written by the same process on the same endpoint within ten minutes. Returns URL, path and available content hash for subsequent reputation and execution pivots.

//Category
Threat Hunting / Tool Transfer

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{CONFIRMED_TRANSFER_EVENTS}}
| alter
    event_time = {{TRANSFER_TIME}},
    endpoint_id = {{TRANSFER_ENDPOINT}},
    process_id = {{TRANSFER_PROCESS}},
    url = {{TRANSFER_URL}},
    direction = {{TRANSFER_DIRECTION}},
    transfer_success = {{TRANSFER_SUCCESS}},
    output_path = {{TRANSFER_OUTPUT_PATH}}
| filter direction = "inbound" and transfer_success = true and endpoint_id != null and process_id != null and output_path != null
| join type = inner conflict_strategy = both (
dataset = {{FILE_CREATION_EVENTS}}
| alter
    file_time = {{TRANSFER_FILE_TIME}},
    file_endpoint = {{TRANSFER_FILE_ENDPOINT}},
    writer_process = {{TRANSFER_WRITER_PROCESS}},
    file_path = {{TRANSFER_FILE_PATH}},
    file_hash = {{TRANSFER_FILE_SHA256}}
| fields file_time, file_endpoint, writer_process, file_path, file_hash
) as f f.file_endpoint = endpoint_id and f.writer_process = process_id and f.file_path = output_path and f.file_time >= event_time and timestamp_diff(f.file_time, event_time, "SECOND") <= 600
| fields event_time, endpoint_id, process_id, url, output_path, f.file_time, f.file_hash
| sort desc event_time
| limit 1000
