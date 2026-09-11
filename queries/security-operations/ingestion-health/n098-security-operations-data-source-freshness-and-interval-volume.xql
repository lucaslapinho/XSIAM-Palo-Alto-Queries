//Title
Security Operations - Data Source Freshness and Interval Volume

//Description
Shows per-source ingestion volume, delay metrics and last-log age from metrics_view over one day. Keeps source identity dimensions and zero intervals supplied by the preset; freshness and volume require comparison with each source collection schedule.

//Category
Security Operations / Ingestion Health

:Query:

// Documentation/schema-grounded query candidate.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| preset = metrics_view
// Five-minute metric intervals, including simulated zero entries where supported.
| alter seconds_since_last_log = timestamp_diff(current_time(), last_seen, "SECOND")
| fields _time, _vendor, _product, _collector_type, _collector_id, _collector_name,
    _device_id, _log_type, _reporting_device_name, _final_reporting_device_name,
    _broker_device_id, total_event_count, total_size_bytes,
    data_freshness_max_delay, data_freshness_ninetieth_percentile,
    last_seen, seconds_since_last_log
| sort desc seconds_since_last_log, desc _time
| limit 1000
