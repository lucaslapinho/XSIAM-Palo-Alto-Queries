//Title
Threat Hunting - Service-ticket Bursts and Rare Requesters

//Description
Compares successful service-ticket activity in fixed ten-minute windows with a covered prior requester/peer baseline, retaining all encryption types as context.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{SERVICE_TICKETS_DATASET}}
| alter ticket_time = {{SERVICE_TICKETS_TICKET_TIME}},
    requester = {{SERVICE_TICKETS_REQUESTER}},
    source_ip = {{SERVICE_TICKETS_SOURCE_IP}},
    service_target = {{SERVICE_TICKETS_SERVICE_TARGET}},
    encryption_type = {{SERVICE_TICKETS_ENCRYPTION_TYPE}},
    event_id = {{SERVICE_TICKETS_EVENT_ID}},
    success = {{SERVICE_TICKETS_SUCCESS}}
| fields ticket_time, requester, source_ip, service_target, encryption_type, event_id, success
| filter event_id = 4769 and success = true
| filter requester != null and service_target != null
| alter age_seconds = timestamp_diff(current_time(), ticket_time, "SECOND")
| filter age_seconds >= 0 and age_seconds < 86400
| alter bucket_time = ticket_time
| bin bucket_time span = 10m
| comp count() as request_rows, count_distinct(service_target) as distinct_service_targets, values(service_target) as service_targets, values(encryption_type) as encryption_types by requester, source_ip, bucket_time
| join type = left (
dataset = {{TICKET_REQUESTER_BASELINE_DATASET}}
| alter b_requester = {{TICKET_REQUESTER_BASELINE_B_REQUESTER}},
    baseline_days = {{TICKET_REQUESTER_BASELINE_BASELINE_DAYS}},
    prior_request_rows = {{TICKET_REQUESTER_BASELINE_PRIOR_REQUEST_ROWS}},
    expected_peak_targets = {{TICKET_REQUESTER_BASELINE_EXPECTED_PEAK_TARGETS}},
    baseline_complete = {{TICKET_REQUESTER_BASELINE_BASELINE_COMPLETE}}
| fields b_requester, baseline_days, prior_request_rows, expected_peak_targets, baseline_complete
) as b requester = b.b_requester
| alter baseline_ready = if(b.baseline_complete = true and b.baseline_days >= 7, true, false),
    rare_requester = if(b.baseline_complete = true and b.baseline_days >= 7 and b.prior_request_rows = 0, true, false)
| alter burst_candidate = if(distinct_service_targets >= {{MIN_DISTINCT_SERVICES}} and baseline_ready = true and distinct_service_targets > b.expected_peak_targets * {{BURST_MULTIPLIER}}, true, false)
| filter burst_candidate = true or rare_requester = true or baseline_ready = false
| alter assessment = if(baseline_ready = false, "BASELINE_UNASSESSED", if(burst_candidate = true, "REQUEST_BURST_CANDIDATE", "RARE_REQUESTER_CANDIDATE"))
| fields bucket_time, requester, source_ip, request_rows, distinct_service_targets, service_targets, encryption_types, assessment, rare_requester, burst_candidate, b.baseline_days, b.expected_peak_targets
| sort desc distinct_service_targets
| limit 1000
