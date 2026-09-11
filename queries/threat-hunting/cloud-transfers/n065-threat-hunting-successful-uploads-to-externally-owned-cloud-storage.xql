//Title
Threat Hunting - Successful Uploads to Externally Owned Cloud Storage

//Description
Selects successful object-upload/write events with measured outbound volume and confirmed external destination ownership. Requires upload-capable proxy, CASB or storage data-event telemetry; an observed storage domain or TLS connection is insufficient.

//Category
Threat Hunting / Cloud Transfers

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{CLOUD_STORAGE_UPLOAD_EVENTS}}
| alter
    event_time = {{UPLOAD_TIME}},
    principal_id = {{UPLOAD_PRINCIPAL}},
    endpoint_id = {{UPLOAD_ENDPOINT}},
    storage_service = {{UPLOAD_SERVICE}},
    destination_account = {{UPLOAD_DESTINATION_ACCOUNT}},
    destination_owned = {{UPLOAD_DESTINATION_OWNED}},
    operation = {{UPLOAD_OPERATION}},
    success = {{UPLOAD_SUCCESS}},
    object_id = {{UPLOAD_OBJECT_ID}},
    outbound_bytes = {{UPLOAD_OUTBOUND_BYTES}}
| filter operation in ("object_upload", "object_write") and success = true and destination_owned = false
| filter outbound_bytes >= {{MIN_UPLOAD_BYTES}}
| fields event_time, principal_id, endpoint_id, storage_service, destination_account, operation, object_id, outbound_bytes
| sort desc event_time
| limit 1000
