// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 7d
| dataset = {{PROCESS_RELATIONSHIPS_DATASET}}
| alter event_time = {{PROCESS_RELATIONSHIPS_EVENT_TIME}},
    host_id = {{PROCESS_RELATIONSHIPS_HOST_ID}},
    process_id = {{PROCESS_RELATIONSHIPS_PROCESS_ID}},
    parent_id = {{PROCESS_RELATIONSHIPS_PARENT_ID}},
    causality_id = {{PROCESS_RELATIONSHIPS_CAUSALITY_ID}},
    image = {{PROCESS_RELATIONSHIPS_IMAGE}},
    command_line = {{PROCESS_RELATIONSHIPS_COMMAND_LINE}},
    account = {{PROCESS_RELATIONSHIPS_ACCOUNT}}
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account
| filter host_id = {{SELECTED_ENDPOINT_ID}} and process_id = {{SELECTED_PROCESS_INSTANCE}}
| alter relationship = "SELECTED_PROCESS"
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account, relationship
| union (
dataset = {{PROCESS_RELATIONSHIPS_DATASET}}
| alter event_time = {{PROCESS_RELATIONSHIPS_EVENT_TIME}},
    host_id = {{PROCESS_RELATIONSHIPS_HOST_ID}},
    process_id = {{PROCESS_RELATIONSHIPS_PROCESS_ID}},
    parent_id = {{PROCESS_RELATIONSHIPS_PARENT_ID}},
    causality_id = {{PROCESS_RELATIONSHIPS_CAUSALITY_ID}},
    image = {{PROCESS_RELATIONSHIPS_IMAGE}},
    command_line = {{PROCESS_RELATIONSHIPS_COMMAND_LINE}},
    account = {{PROCESS_RELATIONSHIPS_ACCOUNT}}
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account
| filter host_id = {{SELECTED_ENDPOINT_ID}}
| join type = inner (
dataset = {{PROCESS_RELATIONSHIPS_DATASET}}
| alter event_time = {{PROCESS_RELATIONSHIPS_EVENT_TIME}},
    host_id = {{PROCESS_RELATIONSHIPS_HOST_ID}},
    process_id = {{PROCESS_RELATIONSHIPS_PROCESS_ID}},
    parent_id = {{PROCESS_RELATIONSHIPS_PARENT_ID}},
    causality_id = {{PROCESS_RELATIONSHIPS_CAUSALITY_ID}},
    image = {{PROCESS_RELATIONSHIPS_IMAGE}},
    command_line = {{PROCESS_RELATIONSHIPS_COMMAND_LINE}},
    account = {{PROCESS_RELATIONSHIPS_ACCOUNT}}
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account
| filter host_id = {{SELECTED_ENDPOINT_ID}} and process_id = {{SELECTED_PROCESS_INSTANCE}}
| fields host_id as seed_host, parent_id as seed_parent
) as seed host_id = seed.seed_host and process_id = seed.seed_parent
| alter relationship = "DIRECT_PARENT"
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account, relationship
)
| union (
dataset = {{PROCESS_RELATIONSHIPS_DATASET}}
| alter event_time = {{PROCESS_RELATIONSHIPS_EVENT_TIME}},
    host_id = {{PROCESS_RELATIONSHIPS_HOST_ID}},
    process_id = {{PROCESS_RELATIONSHIPS_PROCESS_ID}},
    parent_id = {{PROCESS_RELATIONSHIPS_PARENT_ID}},
    causality_id = {{PROCESS_RELATIONSHIPS_CAUSALITY_ID}},
    image = {{PROCESS_RELATIONSHIPS_IMAGE}},
    command_line = {{PROCESS_RELATIONSHIPS_COMMAND_LINE}},
    account = {{PROCESS_RELATIONSHIPS_ACCOUNT}}
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account
| filter host_id = {{SELECTED_ENDPOINT_ID}} and parent_id = {{SELECTED_PROCESS_INSTANCE}}
| alter relationship = "DIRECT_CHILD"
| fields event_time, host_id, process_id, parent_id, causality_id, image, command_line, account, relationship
)
| sort asc event_time
| limit 2000
