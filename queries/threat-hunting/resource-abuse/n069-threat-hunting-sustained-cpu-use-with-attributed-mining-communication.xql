//Title
Threat Hunting - Sustained CPU Use with Attributed Mining Communication

//Description
Correlates sustained high CPU samples with independently identified mining communication from the same process within a fixed 15-minute interval. Requires genuine resource metrics and protocol attribution; software names, ports and EDR row counts do not establish cryptomining.

//Category
Threat Hunting / Resource Abuse

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{PROCESS_RESOURCE_METRICS}}
| alter
    metric_time = {{RESOURCE_METRIC_TIME}},
    endpoint_id = {{RESOURCE_ENDPOINT}},
    process_id = {{RESOURCE_PROCESS}},
    cpu_percent = {{RESOURCE_CPU_PERCENT}},
    metric_kind = {{RESOURCE_METRIC_KIND}}
| filter metric_kind = "cpu_percent" and cpu_percent >= 0 and cpu_percent <= 100 and endpoint_id != null and process_id != null
| filter metric_time != null
| alter sample_time = metric_time
| bin metric_time span = 15m
| windowcomp lag(sample_time) by metric_time, endpoint_id, process_id sort asc sample_time as previous_sample
| alter sample_gap = timestamp_diff(sample_time, previous_sample, "SECOND")
| comp count() as sample_count, avg(cpu_percent) as mean_cpu, min(cpu_percent) as lowest_cpu, min(sample_time) as first_sample, max(sample_time) as last_sample, max(sample_gap) as largest_gap by metric_time, endpoint_id, process_id
| alter observed_span = timestamp_diff(last_sample, first_sample, "SECOND")
| filter sample_count >= {{MIN_SAMPLES}} and lowest_cpu >= {{MIN_CPU_PERCENT}} and observed_span >= {{MIN_SPAN_SECONDS}} and largest_gap <= {{MAX_SAMPLE_GAP_SECONDS}}
| join type = inner conflict_strategy = both (
dataset = {{IDENTIFIED_MINING_PROTOCOL_EVENTS}}
| alter
    pool_time = {{MINING_NETWORK_TIME}},
    pool_endpoint = {{MINING_NETWORK_ENDPOINT}},
    pool_process = {{MINING_NETWORK_PROCESS}},
    protocol_identified = {{MINING_PROTOCOL_IDENTIFIED}},
    pool_destination = {{MINING_POOL_DESTINATION}},
    protocol_evidence = {{MINING_PROTOCOL_EVIDENCE}}
| filter protocol_identified = true
| fields pool_time, pool_endpoint, pool_process, protocol_identified, pool_destination, protocol_evidence
) as n n.pool_endpoint = endpoint_id and n.pool_process = process_id and timestamp_diff(n.pool_time, metric_time, "SECOND") >= 0 and timestamp_diff(n.pool_time, metric_time, "SECOND") < 900
| fields metric_time, endpoint_id, process_id, sample_count, mean_cpu, lowest_cpu, first_sample, last_sample, observed_span, largest_gap, n.pool_time, n.pool_destination, n.protocol_evidence
| sort desc mean_cpu
| limit 1000
