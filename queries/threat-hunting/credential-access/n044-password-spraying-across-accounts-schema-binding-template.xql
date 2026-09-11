//Title
Password Spraying Across Accounts - Schema Binding Template

//Description
Ranks source-specific bad-secret failures spread across accounts within 15-minute bins. Retains original reasons and separates source systems; thresholds identify spray-shaped behavior for review.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{AUTH_FAILURE_DATASET}}
| alter event_time = {{FAIL_TIME}},
    event_uid = {{FAIL_EVENT_UID}},
    source_system = {{FAIL_SOURCE_SYSTEM}},
    source = {{FAIL_SOURCE_IP}},
    account = {{FAIL_ACCOUNT_KEY}},
    outcome = {{FAIL_OUTCOME}},
    reason_class = {{FAIL_REASON_CLASS}},
    reason_raw = {{FAIL_REASON_RAW}}
| filter outcome = "failure" and reason_class = "bad_secret"
| filter source != null and source != "" and account != null and account != "" and event_uid != null and event_uid != ""
| dedup source_system, event_uid by asc event_time
| bin event_time span = 15m
| comp count() as failure_events, count_distinct(account) as account_count, values(account) as accounts, values(reason_raw) as reasons by source_system, source, event_time
| alter failures_per_account = failure_events / account_count
| filter account_count >= {{MIN_ACCOUNTS}} and failures_per_account <= {{MAX_FAILURES_PER_ACCOUNT}}
| fields event_time, source_system, source, account_count, failure_events, failures_per_account, accounts, reasons
| sort desc account_count
| limit 1000
