//Title
Threat Hunting - No-preauthentication Accounts and TGT Request Activity

//Description
Correlates successful no-preauthentication TGT requests with time-valid account configuration, source/request baselines and approved service exceptions.

//Category
Threat Hunting / Credential Access

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 1d
| dataset = {{TGT_REQUESTS_DATASET}}
| alter event_time = {{TGT_REQUESTS_EVENT_TIME}},
    event_id = {{TGT_REQUESTS_EVENT_ID}},
    account_sid = {{TGT_REQUESTS_ACCOUNT_SID}},
    domain_id = {{TGT_REQUESTS_DOMAIN_ID}},
    source_ip = {{TGT_REQUESTS_SOURCE_IP}},
    preauth_type = {{TGT_REQUESTS_PREAUTH_TYPE}},
    success = {{TGT_REQUESTS_SUCCESS}},
    encryption_type = {{TGT_REQUESTS_ENCRYPTION_TYPE}}
| fields event_time, event_id, account_sid, domain_id, source_ip, preauth_type, success, encryption_type
| filter event_id = 4768 and success = true and preauth_type = 0
| filter account_sid != null and account_sid != ""
| join type = inner (
dataset = {{PREAUTH_ACCOUNT_STATE_DATASET}}
| alter a_sid = {{PREAUTH_ACCOUNT_STATE_A_SID}},
    a_domain = {{PREAUTH_ACCOUNT_STATE_A_DOMAIN}},
    does_not_require_preauth = {{PREAUTH_ACCOUNT_STATE_DOES_NOT_REQUIRE_PREAUTH}},
    effective_from = {{PREAUTH_ACCOUNT_STATE_EFFECTIVE_FROM}},
    effective_until = {{PREAUTH_ACCOUNT_STATE_EFFECTIVE_UNTIL}},
    approved_exception = {{PREAUTH_ACCOUNT_STATE_APPROVED_EXCEPTION}}
| fields a_sid, a_domain, does_not_require_preauth, effective_from, effective_until, approved_exception
) as a account_sid = a.a_sid and domain_id = a.a_domain
| filter a.does_not_require_preauth = true and event_time >= a.effective_from and event_time < a.effective_until
| comp count() as request_rows, min(event_time) as first_observed, max(event_time) as last_observed, values(encryption_type) as encryption_types by account_sid, domain_id, source_ip, a.approved_exception
| join type = left (
dataset = {{ASREP_REQUEST_BASELINE_DATASET}}
| alter b_sid = {{ASREP_REQUEST_BASELINE_B_SID}},
    b_domain = {{ASREP_REQUEST_BASELINE_B_DOMAIN}},
    known_source = {{ASREP_REQUEST_BASELINE_KNOWN_SOURCE}},
    prior_requests = {{ASREP_REQUEST_BASELINE_PRIOR_REQUESTS}},
    expected_daily_peak = {{ASREP_REQUEST_BASELINE_EXPECTED_DAILY_PEAK}},
    baseline_complete = {{ASREP_REQUEST_BASELINE_BASELINE_COMPLETE}}
| fields b_sid, b_domain, known_source, prior_requests, expected_daily_peak, baseline_complete
) as b account_sid = b.b_sid and domain_id = b.b_domain and source_ip = b.known_source
| alter baseline_state = if(b.baseline_complete = true, "COVERED", "UNASSESSED"),
    request_burst = if(b.baseline_complete = true and request_rows >= {{ASREP_DAILY_THRESHOLD}} and request_rows > b.expected_daily_peak, true, false),
    newly_observed_source = if(b.baseline_complete = true and b.prior_requests = 0, true, false)
| filter request_burst = true or newly_observed_source = true or baseline_state = "UNASSESSED" or a.approved_exception = false or a.approved_exception = null
| fields account_sid, domain_id, source_ip, first_observed, last_observed, request_rows, encryption_types, a.approved_exception, baseline_state, request_burst, newly_observed_source
| sort desc request_rows
| limit 1000
