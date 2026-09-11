//Title
Threat Hunting - Unexpected Replication Rights Use with Source Context

//Description
Reviews successful Get-Changes-All control-access usage by non-baselined/unassessed principals, resolves the authenticated source, and attaches time-qualified actual DRS operation evidence.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{REPLICATION_RIGHTS_DATASET}}
| alter event_time = {{REPLICATION_RIGHTS_EVENT_TIME}},
    dc_id = {{REPLICATION_RIGHTS_DC_ID}},
    event_id = {{REPLICATION_RIGHTS_EVENT_ID}},
    success = {{REPLICATION_RIGHTS_SUCCESS}},
    subject_sid = {{REPLICATION_RIGHTS_SUBJECT_SID}},
    logon_key = {{REPLICATION_RIGHTS_LOGON_KEY}},
    properties = {{REPLICATION_RIGHTS_PROPERTIES}},
    access_is_control = {{REPLICATION_RIGHTS_ACCESS_IS_CONTROL}},
    expected_principal = {{REPLICATION_RIGHTS_EXPECTED_PRINCIPAL}}
| fields event_time, dc_id, event_id, success, subject_sid, logon_key, properties, access_is_control, expected_principal
| filter event_id = 4662 and success = true and access_is_control = true
| filter (properties contains "1131f6ad-9c07-11d1-f79f-00c04fc2dcd2")
| filter expected_principal = false or expected_principal = null
| join type = left (
dataset = {{REPLICATION_ORIGIN_DATASET}}
| alter o_dc = {{REPLICATION_ORIGIN_O_DC}},
    o_logon = {{REPLICATION_ORIGIN_O_LOGON}},
    o_sid = {{REPLICATION_ORIGIN_O_SID}},
    source_host = {{REPLICATION_ORIGIN_SOURCE_HOST}},
    source_ip = {{REPLICATION_ORIGIN_SOURCE_IP}},
    source_is_dc = {{REPLICATION_ORIGIN_SOURCE_IS_DC}},
    auth_time = {{REPLICATION_ORIGIN_AUTH_TIME}}
| fields o_dc, o_logon, o_sid, source_host, source_ip, source_is_dc, auth_time
) as o dc_id = o.o_dc and logon_key = o.o_logon and subject_sid = o.o_sid
| alter auth_age_seconds = timestamp_diff(event_time, o.auth_time, "SECOND")
| alter origin_valid = if(auth_age_seconds >= 0 and auth_age_seconds <= 86400, true, false)
| alter source_identity = if(origin_valid = true, o.source_host, null), source_address = if(origin_valid = true, o.source_ip, null),
    origin_class = if(origin_valid = false or o.source_is_dc = null, "UNKNOWN", if(o.source_is_dc = true, "DOMAIN_CONTROLLER", "NON_DC_SOURCE"))
| join type = left (
dataset = {{DRS_OPERATIONS_DATASET}}
| alter d_dc = {{DRS_OPERATIONS_D_DC}},
    d_source = {{DRS_OPERATIONS_D_SOURCE}},
    d_time = {{DRS_OPERATIONS_D_TIME}},
    d_operation = {{DRS_OPERATIONS_D_OPERATION}},
    d_result = {{DRS_OPERATIONS_D_RESULT}}
| fields d_dc, d_source, d_time, d_operation, d_result
) as d dc_id = d.d_dc and source_identity = d.d_source
| alter drs_delay = timestamp_diff(d.d_time, event_time, "SECOND")
| alter drs_corroborated = if(drs_delay >= -300 and drs_delay <= 300 and d.d_operation != null, true, false),
    replication_operation = if(drs_delay >= -300 and drs_delay <= 300, d.d_operation, null)
| fields event_time, dc_id, subject_sid, logon_key, properties, expected_principal, source_identity, source_address, origin_class, drs_corroborated, replication_operation
| sort desc event_time
| limit 1000
