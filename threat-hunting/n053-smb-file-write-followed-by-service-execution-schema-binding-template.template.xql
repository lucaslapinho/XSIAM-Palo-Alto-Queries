// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SMB_FILE_WRITE_DATASET}}
| alter write_time = {{SMB_WRITE_TIME}},
    write_uid = {{SMB_WRITE_UID}},
    endpoint = {{SMB_TARGET_ENDPOINT}},
    source = {{SMB_WRITE_SOURCE}},
    account = {{SMB_WRITE_ACCOUNT}},
    path = {{SMB_SERVER_FILE_PATH}},
    write_result = {{SMB_WRITE_RESULT}}
| filter write_result = "success" and endpoint != null and path != null and path != ""
| join type = inner conflict_strategy = left (
dataset = {{SERVICE_INSTALL_DATASET}}
| alter install_time = {{SERVICE_INSTALL_TIME}},
    install_uid = {{SERVICE_INSTALL_UID}},
    service_endpoint = {{SERVICE_ENDPOINT}},
    service_name = {{SERVICE_NAME}},
    service_path = {{SERVICE_EXECUTABLE_PATH}},
    install_result = {{SERVICE_INSTALL_RESULT}},
    service_user = {{SERVICE_ACCOUNT}}
| filter install_result = "success" and service_endpoint != null and service_path != null
) as service endpoint = service.service_endpoint and path = service.service_path
| alter write_to_install = timestamp_diff(service.install_time, write_time, "SECOND")
| filter write_to_install >= 0 and write_to_install <= 600
| join type = inner conflict_strategy = left (
dataset = {{SERVICE_PROCESS_START_DATASET}}
| alter start_time = {{SERVICE_START_TIME}},
    start_endpoint = {{SERVICE_START_ENDPOINT}},
    started_service = {{STARTED_SERVICE_NAME}},
    started_path = {{STARTED_SERVICE_PATH}},
    process_instance = {{SERVICE_START_INSTANCE}}
) as started endpoint = started.start_endpoint and service.service_name = started.started_service and path = started.started_path
| alter install_to_start = timestamp_diff(started.start_time, service.install_time, "SECOND")
| filter install_to_start >= 0 and install_to_start <= 600
| fields write_time, write_uid, endpoint, source, account, path, service.install_uid, service.service_name, service.service_user, service.install_time, started.start_time, started.process_instance, write_to_install, install_to_start
| sort desc write_time
| limit 1000
