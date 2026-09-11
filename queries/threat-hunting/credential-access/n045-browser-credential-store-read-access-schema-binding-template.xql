//Title
Browser Credential Store Read Access - Schema Binding Template

//Description
Finds successful reads of inventoried browser credential-store files and preserves reader identity for review. Requires real access telemetry and time-valid browser-profile paths.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{FILE_ACCESS_DATASET}}
| alter event_time = {{READ_TIME}},
    event_uid = {{READ_EVENT_UID}},
    endpoint = {{READ_ENDPOINT}},
    process_instance = {{READ_PROCESS_INSTANCE}},
    process_image = {{READ_PROCESS_IMAGE}},
    account = {{READ_ACCOUNT}},
    file_path = {{READ_CANONICAL_PATH}},
    operation = {{READ_OPERATION}},
    outcome = {{READ_OUTCOME}}
| filter operation = "read" and outcome = "success"
| filter endpoint != null and process_instance != null and file_path != null
| join type = inner conflict_strategy = left (
dataset = {{BROWSER_STORE_INVENTORY}}
| alter store_endpoint = {{STORE_ENDPOINT}},
    store_path = {{STORE_PATH}},
    browser = {{STORE_BROWSER}},
    valid_from = {{STORE_VALID_FROM}},
    valid_to = {{STORE_VALID_TO}}
) as stores endpoint = stores.store_endpoint and file_path = stores.store_path and event_time >= stores.valid_from and event_time < stores.valid_to
| fields event_time, event_uid, endpoint, process_instance, process_image, account, file_path, stores.browser
| sort desc event_time
| limit 1000
