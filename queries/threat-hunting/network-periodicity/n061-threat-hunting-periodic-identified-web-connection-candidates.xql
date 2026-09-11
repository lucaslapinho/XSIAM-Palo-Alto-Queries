//Title
Threat Hunting - Periodic Identified Web Connection Candidates

//Description
Measures positive time gaps between deduplicated, application-identified web connection starts for an endpoint, process and destination. Selects sufficiently frequent low-spread intervals for review while preserving the distinction between periodicity and malicious beaconing.

//Category
Threat Hunting / Network Periodicity

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{IDENTIFIED_WEB_CONNECTION_STARTS}}
| alter
    event_time = {{WEB_START_TIME}},
    endpoint_id = {{WEB_ENDPOINT_ID}},
    process_id = {{WEB_PROCESS_INSTANCE}},
    connection_id = {{WEB_CONNECTION_ID}},
    destination = {{WEB_DESTINATION}},
    is_web = {{WEB_IDENTIFIED_FLAG}}
| filter is_web = true and endpoint_id != null and process_id != null and connection_id != null and destination != null
| dedup endpoint_id, process_id, connection_id by asc event_time
| windowcomp lag(event_time) by endpoint_id, process_id, destination sort asc event_time as previous_start
| alter gap_seconds = timestamp_diff(event_time, previous_start, "SECOND")
| filter gap_seconds > 0
| comp count() as interval_count, avg(gap_seconds) as mean_gap, min(gap_seconds) as min_gap, max(gap_seconds) as max_gap by endpoint_id, process_id, destination
| filter interval_count >= {{MIN_INTERVALS}} and mean_gap >= {{MIN_GAP_SECONDS}}
| alter relative_spread = (max_gap - min_gap) / mean_gap
| filter relative_spread <= {{MAX_RELATIVE_SPREAD}}
| fields endpoint_id, process_id, destination, interval_count, mean_gap, min_gap, max_gap, relative_spread
| sort asc relative_spread, desc interval_count
| limit 1000
