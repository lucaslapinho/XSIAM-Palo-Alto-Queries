//Title
Threat Hunting - Observed Stops of Critical Services

//Description
Selects observed running-to-stopped transitions for services classified as critical at event time. Retains attributable actor/request context when available and supports maintenance and dependency review without equating a stop command with a completed stop.

//Category
Threat Hunting / Service Availability

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{SERVICE_STATE_TRANSITIONS}}
| alter
    event_time = {{SERVICE_STATE_TIME}},
    endpoint_id = {{SERVICE_ENDPOINT}},
    service_id = {{SERVICE_ID}},
    before_state = {{SERVICE_BEFORE}},
    after_state = {{SERVICE_AFTER}},
    actor = {{SERVICE_ACTOR}},
    request_id = {{SERVICE_REQUEST_ID}}
| filter before_state = "running" and after_state = "stopped"
| join type = inner conflict_strategy = both (
dataset = {{CRITICAL_SERVICE_HISTORY}}
| alter
    critical_endpoint = {{CRITICAL_SERVICE_ENDPOINT}},
    critical_service = {{CRITICAL_SERVICE_ID}},
    valid_from = {{CRITICAL_SERVICE_FROM}},
    valid_until = {{CRITICAL_SERVICE_UNTIL}},
    owner = {{CRITICAL_SERVICE_OWNER}}
| fields critical_endpoint, critical_service, valid_from, valid_until, owner
) as c c.critical_endpoint = endpoint_id and c.critical_service = service_id and event_time >= c.valid_from and event_time < c.valid_until
| fields event_time, endpoint_id, service_id, before_state, after_state, actor, request_id, c.owner
| sort desc event_time
| limit 1000
