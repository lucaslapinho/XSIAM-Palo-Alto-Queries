//Title
Security Operations - Collector Error and Warning Audit Records

//Description
Returns collector error and warning audit records with instance and Broker VM context from collection_auditing. Supports failure triage and subsequent recovery pivots; a historical warning does not establish a currently unhealthy collector.

//Category
Security Operations / Collection Health

:Query:

// Documentation/schema-grounded query candidate.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = collection_auditing
| filter classification in ("Error", "Warning")
| fields _time, collector_type, instance, classification, description,
    _broker_device_id, _broker_device_name
| sort desc _time
| limit 1000
