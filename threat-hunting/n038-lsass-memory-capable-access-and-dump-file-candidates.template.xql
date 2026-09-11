// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{LSASS_ACCESS_DATASET}}
| alter anchor_time = {{LSASS_ACCESS_ANCHOR_TIME}},
    endpoint_id = {{LSASS_ACCESS_ENDPOINT_ID}},
    anchor_process_id = {{LSASS_ACCESS_ANCHOR_PROCESS_ID}},
    anchor_command = {{LSASS_ACCESS_ANCHOR_COMMAND}},
    anchor_actor = {{LSASS_ACCESS_ANCHOR_ACTOR}},
    target_image = {{LSASS_ACCESS_TARGET_IMAGE}},
    target_process_id = {{LSASS_ACCESS_TARGET_PROCESS_ID}},
    access_rights = {{LSASS_ACCESS_ACCESS_RIGHTS}},
    memory_read_capable = {{LSASS_ACCESS_MEMORY_READ_CAPABLE}},
    access_result = {{LSASS_ACCESS_ACCESS_RESULT}},
    expected_accessor = {{LSASS_ACCESS_EXPECTED_ACCESSOR}}
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, target_image, target_process_id, access_rights, memory_read_capable, access_result, expected_accessor
| filter target_image = "lsass.exe" and memory_read_capable = true
| filter expected_accessor = false or expected_accessor = null
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, target_process_id, access_rights, access_result, expected_accessor
| alter evidence_time = anchor_time, evidence_kind = "LSASS_MEMORY_CAPABLE_ACCESS", evidence_process_id = anchor_process_id,
    evidence_text = anchor_command, evidence_outcome = "OBSERVED_ANCHOR"
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, evidence_time, evidence_kind, evidence_process_id, evidence_text, evidence_outcome, target_process_id, access_rights, access_result, expected_accessor
| union (
dataset = {{LSASS_ACCESS_DATASET}}
| alter anchor_time = {{LSASS_ACCESS_ANCHOR_TIME}},
    endpoint_id = {{LSASS_ACCESS_ENDPOINT_ID}},
    anchor_process_id = {{LSASS_ACCESS_ANCHOR_PROCESS_ID}},
    anchor_command = {{LSASS_ACCESS_ANCHOR_COMMAND}},
    anchor_actor = {{LSASS_ACCESS_ANCHOR_ACTOR}},
    target_image = {{LSASS_ACCESS_TARGET_IMAGE}},
    target_process_id = {{LSASS_ACCESS_TARGET_PROCESS_ID}},
    access_rights = {{LSASS_ACCESS_ACCESS_RIGHTS}},
    memory_read_capable = {{LSASS_ACCESS_MEMORY_READ_CAPABLE}},
    access_result = {{LSASS_ACCESS_ACCESS_RESULT}},
    expected_accessor = {{LSASS_ACCESS_EXPECTED_ACCESSOR}}
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, target_image, target_process_id, access_rights, memory_read_capable, access_result, expected_accessor
| filter target_image = "lsass.exe" and memory_read_capable = true
| filter expected_accessor = false or expected_accessor = null
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, target_process_id, access_rights, access_result, expected_accessor
| join type = inner (
dataset = {{ACCESS_FOLLOWON_FILES_DATASET}}
| alter ctx_host = {{ACCESS_FOLLOWON_FILES_CTX_HOST}},
    ctx_root = {{ACCESS_FOLLOWON_FILES_CTX_ROOT}},
    ctx_time = {{ACCESS_FOLLOWON_FILES_CTX_TIME}},
    ctx_kind = {{ACCESS_FOLLOWON_FILES_CTX_KIND}},
    ctx_process = {{ACCESS_FOLLOWON_FILES_CTX_PROCESS}},
    ctx_text = {{ACCESS_FOLLOWON_FILES_CTX_TEXT}},
    ctx_outcome = {{ACCESS_FOLLOWON_FILES_CTX_OUTCOME}}
| fields ctx_host, ctx_root, ctx_time, ctx_kind, ctx_process, ctx_text, ctx_outcome
| filter ctx_kind in ("DUMP_FILE_CREATE", "DUMP_FILE_WRITE")
) as context endpoint_id = context.ctx_host and anchor_process_id = context.ctx_root
| alter elapsed_seconds = timestamp_diff(context.ctx_time, anchor_time, "SECOND")
| filter elapsed_seconds >= 0 and elapsed_seconds <= 600
| alter evidence_time = context.ctx_time, evidence_kind = context.ctx_kind,
    evidence_process_id = context.ctx_process, evidence_text = context.ctx_text, evidence_outcome = context.ctx_outcome
| fields anchor_time, endpoint_id, anchor_process_id, anchor_command, anchor_actor, evidence_time, evidence_kind, evidence_process_id, evidence_text, evidence_outcome, target_process_id, access_rights, access_result, expected_accessor
)
| sort desc anchor_time, asc evidence_time
| limit 2000
