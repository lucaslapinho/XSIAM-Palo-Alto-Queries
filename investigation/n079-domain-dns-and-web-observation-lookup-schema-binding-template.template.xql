// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{DOMAIN_OBSERVATION_DATASET}}
| alter event_time = {{DOMAIN_EVENT_TIME}},
    event_uid = {{DOMAIN_EVENT_UID}},
    source_system = {{DOMAIN_SOURCE_SYSTEM}},
    evidence_kind = {{DOMAIN_EVIDENCE_KIND}},
    domain = {{DOMAIN_CANONICAL_NAME}},
    raw_name = {{DOMAIN_RAW_NAME}},
    client = {{DOMAIN_CLIENT_KEY}},
    answers = {{DOMAIN_DNS_ANSWERS}},
    result = {{DOMAIN_RESULT}},
    url = {{DOMAIN_SAFE_URL}}
| filter evidence_kind in ("dns_question", "dns_response", "web_request")
| filter domain != null and domain != ""
| filter domain ~= {{DOMAIN_BOUNDARY_RE2}}
| fields event_time, event_uid, source_system, evidence_kind, client, domain, raw_name, answers, result, url
| sort desc event_time
| limit 1000
