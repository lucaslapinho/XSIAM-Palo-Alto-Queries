// Documentation/schema-grounded query candidate.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = collection_auditing
| filter classification in ("Error", "Warning")
| fields _time, collector_type, instance, classification, description,
    _broker_device_id, _broker_device_name
| sort desc _time
| limit 1000
