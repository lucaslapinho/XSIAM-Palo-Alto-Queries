//Title
Exact IP Investigation Across Address Roles - Schema Binding Template

//Description
Returns exact canonical IP matches across original, translated, DNS-answer and trusted proxy-client roles, preserving source provenance and separate match flags.

//Category
Investigation / Network Activity

:Query:

// SCHEMA BINDING TEMPLATE: resolve every binding before editor validation.
// Cortex XSIAM interactive XQL Search. Compilation and execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{IP_OBSERVATION_DATASET}}
| alter event_time = {{IP_EVENT_TIME}},
    event_uid = {{IP_EVENT_UID}},
    source_system = {{IP_SOURCE_SYSTEM}},
    evidence_kind = {{IP_EVIDENCE_KIND}},
    endpoint = {{IP_ENDPOINT}},
    account = {{IP_ACCOUNT}},
    source_ip = {{IP_SOURCE}},
    destination_ip = {{IP_DESTINATION}},
    nat_source = {{IP_NAT_SOURCE}},
    nat_destination = {{IP_NAT_DESTINATION}},
    dns_answer = {{IP_DNS_ANSWER}},
    proxy_client = {{IP_PROXY_CLIENT}},
    detail = {{IP_SAFE_DETAIL}}
| alter ip_to_review = {{IP_TO_REVIEW}}
| filter ip_to_review != null and ip_to_review != ""
| filter (source_ip = ip_to_review or destination_ip = ip_to_review or nat_source = ip_to_review or nat_destination = ip_to_review or dns_answer = ip_to_review or proxy_client = ip_to_review)
| alter matched_source = if(source_ip = ip_to_review, 1, 0), matched_destination = if(destination_ip = ip_to_review, 1, 0), matched_nat_source = if(nat_source = ip_to_review, 1, 0), matched_nat_destination = if(nat_destination = ip_to_review, 1, 0), matched_dns_answer = if(dns_answer = ip_to_review, 1, 0), matched_proxy_client = if(proxy_client = ip_to_review, 1, 0)
| fields event_time, event_uid, source_system, evidence_kind, endpoint, account, source_ip, destination_ip, nat_source, nat_destination, dns_answer, proxy_client, matched_source, matched_destination, matched_nat_source, matched_nat_destination, matched_dns_answer, matched_proxy_client, detail
| sort desc event_time
| limit 1000
