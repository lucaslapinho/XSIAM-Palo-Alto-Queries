//Title
Security Operations - Domain Controller Operational Event Timeline

//Description
Returns an approved set of replication, DNS, time and service events on hosts confirmed as domain controllers at event time. Joins exact provider/channel/event selections to prevent cross-provider event-ID collisions.

//Category
Security Operations / Domain Controllers

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{DC_OPERATIONAL_EVENTS}}
| alter
    event_time = {{DC_EVENT_TIME}},
    endpoint_id = {{DC_EVENT_ENDPOINT}},
    provider = {{DC_EVENT_PROVIDER}},
    channel = {{DC_EVENT_CHANNEL}},
    event_id = {{DC_EVENT_ID}},
    severity = {{DC_EVENT_LEVEL}},
    message = {{DC_EVENT_MESSAGE}}
| join type = inner conflict_strategy = both (
dataset = {{DOMAIN_CONTROLLER_HISTORY}}
| alter
    dc_endpoint = {{DC_INVENTORY_ENDPOINT}},
    dc_from = {{DC_ROLE_VALID_FROM}},
    dc_until = {{DC_ROLE_VALID_UNTIL}}
| fields dc_endpoint, dc_from, dc_until
) as dc dc.dc_endpoint = endpoint_id and event_time >= dc.dc_from and event_time < dc.dc_until
| join type = inner conflict_strategy = both (
dataset = {{APPROVED_DC_EVENT_SELECTION}}
| alter
    sel_provider = {{SELECTED_PROVIDER}},
    sel_channel = {{SELECTED_CHANNEL}},
    sel_event = {{SELECTED_EVENT_ID}},
    sel_purpose = {{SELECTED_PURPOSE}}
| fields sel_provider, sel_channel, sel_event, sel_purpose
) as sel sel.sel_provider = provider and sel.sel_channel = channel and sel.sel_event = event_id
| fields event_time, endpoint_id, provider, channel, event_id, severity, sel.sel_purpose, message
| sort desc event_time
| limit 1000
