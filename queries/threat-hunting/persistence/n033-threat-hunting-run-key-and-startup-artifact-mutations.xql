//Title
Threat Hunting - Run Key and Startup Artifact Mutations

//Description
Combines successful Run/RunOnce value mutations with configured Startup-folder file mutations, retaining writer identity and the configured execution target when observed.

//Category
Threat Hunting / Persistence

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{RUN_REGISTRY_DATASET}}
| alter event_time = {{RUN_REGISTRY_EVENT_TIME}},
    host_id = {{RUN_REGISTRY_HOST_ID}},
    operation = {{RUN_REGISTRY_OPERATION}},
    successful = {{RUN_REGISTRY_SUCCESSFUL}},
    artifact_path = {{RUN_REGISTRY_ARTIFACT_PATH}},
    artifact_name = {{RUN_REGISTRY_ARTIFACT_NAME}},
    execution_target = {{RUN_REGISTRY_EXECUTION_TARGET}},
    writer_process = {{RUN_REGISTRY_WRITER_PROCESS}},
    writer_user = {{RUN_REGISTRY_WRITER_USER}}
| fields event_time, host_id, operation, successful, artifact_path, artifact_name, execution_target, writer_process, writer_user
| filter successful = true and operation in ("CREATE_VALUE", "SET_VALUE", "RENAME_VALUE")
| filter artifact_path ~= "(?i)\\software\\(?:wow6432node\\)?microsoft\\windows\\currentversion\\run(?:once)?$"
| alter evidence_kind = "RUN_KEY_MUTATION"
| union (
dataset = {{STARTUP_FILES_DATASET}}
| alter event_time = {{STARTUP_FILES_EVENT_TIME}},
    host_id = {{STARTUP_FILES_HOST_ID}},
    operation = {{STARTUP_FILES_OPERATION}},
    successful = {{STARTUP_FILES_SUCCESSFUL}},
    artifact_path = {{STARTUP_FILES_ARTIFACT_PATH}},
    artifact_name = {{STARTUP_FILES_ARTIFACT_NAME}},
    execution_target = {{STARTUP_FILES_EXECUTION_TARGET}},
    writer_process = {{STARTUP_FILES_WRITER_PROCESS}},
    writer_user = {{STARTUP_FILES_WRITER_USER}},
    is_startup_location = {{STARTUP_FILES_IS_STARTUP_LOCATION}}
| fields event_time, host_id, operation, successful, artifact_path, artifact_name, execution_target, writer_process, writer_user, is_startup_location
| filter successful = true and operation in ("CREATE", "WRITE", "RENAME") and is_startup_location = true
| alter evidence_kind = "STARTUP_ARTIFACT_MUTATION"
| fields event_time, host_id, operation, successful, artifact_path, artifact_name, execution_target, writer_process, writer_user, evidence_kind
)
| fields event_time, host_id, evidence_kind, operation, artifact_path, artifact_name, execution_target, writer_process, writer_user
| sort desc event_time
| limit 1000
