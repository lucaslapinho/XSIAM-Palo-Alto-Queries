//Title
Security Operations - Cortex Management Audit Timeline

//Description
Returns one day of Cortex management-audit records with actor, host, category, result and severity context. Preserves reported outcomes and supports administrative review without treating every audit record as a successful configuration change.

//Category
Security Operations / Cortex Audit

:Query:

// Documentation/schema-grounded query candidate.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = management_auditing
// Preserve all results/categories; this is a management-audit review timeline.
| fields _time, host_name, user_name, user_agent,
    management_auditing_type, management_auditing_result, management_auditing_severity
| sort desc _time
| limit 1000
