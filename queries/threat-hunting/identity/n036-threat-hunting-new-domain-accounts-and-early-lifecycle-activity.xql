//Title
Threat Hunting - New Domain Accounts and Early Lifecycle Activity

//Description
Preserves verified domain-account creation and adds first observed successful authentication plus subsequent group additions within 24 hours using stable SID/domain keys.

//Category
Threat Hunting / Identity

:Query:

// SCHEMA_BINDING_TEMPLATE: all schema binding tokens require documented mappings before editor use.
// Cortex XSIAM interactive XQL Search; C: NOT RUN; E: NOT RUN.
config case_sensitive = false timeframe = 3d
| dataset = {{DOMAIN_ACCOUNT_CREATION_DATASET}}
| alter creation_time = {{DOMAIN_ACCOUNT_CREATION_CREATION_TIME}},
    account_sid = {{DOMAIN_ACCOUNT_CREATION_ACCOUNT_SID}},
    domain_id = {{DOMAIN_ACCOUNT_CREATION_DOMAIN_ID}},
    creator_sid = {{DOMAIN_ACCOUNT_CREATION_CREATOR_SID}},
    creation_host = {{DOMAIN_ACCOUNT_CREATION_CREATION_HOST}},
    created_name = {{DOMAIN_ACCOUNT_CREATION_CREATED_NAME}},
    event_id = {{DOMAIN_ACCOUNT_CREATION_EVENT_ID}},
    is_domain_account = {{DOMAIN_ACCOUNT_CREATION_IS_DOMAIN_ACCOUNT}}
| fields creation_time, account_sid, domain_id, creator_sid, creation_host, created_name, event_id, is_domain_account
| filter event_id = 4720 and is_domain_account = true
| filter account_sid != null and account_sid != ""
| alter evidence_time = creation_time, evidence_kind = "DOMAIN_ACCOUNT_CREATED", evidence_detail = created_name
| fields creation_time, domain_id, account_sid, created_name, creator_sid, creation_host, evidence_time, evidence_kind, evidence_detail
| union (
dataset = {{DOMAIN_ACCOUNT_CREATION_DATASET}}
| alter creation_time = {{DOMAIN_ACCOUNT_CREATION_CREATION_TIME}},
    account_sid = {{DOMAIN_ACCOUNT_CREATION_ACCOUNT_SID}},
    domain_id = {{DOMAIN_ACCOUNT_CREATION_DOMAIN_ID}},
    creator_sid = {{DOMAIN_ACCOUNT_CREATION_CREATOR_SID}},
    creation_host = {{DOMAIN_ACCOUNT_CREATION_CREATION_HOST}},
    created_name = {{DOMAIN_ACCOUNT_CREATION_CREATED_NAME}},
    event_id = {{DOMAIN_ACCOUNT_CREATION_EVENT_ID}},
    is_domain_account = {{DOMAIN_ACCOUNT_CREATION_IS_DOMAIN_ACCOUNT}}
| fields creation_time, account_sid, domain_id, creator_sid, creation_host, created_name, event_id, is_domain_account
| filter event_id = 4720 and is_domain_account = true
| filter account_sid != null and account_sid != ""
| join type = inner (
dataset = {{ACCOUNT_LIFECYCLE_EVENTS_DATASET}}
| alter l_sid = {{ACCOUNT_LIFECYCLE_EVENTS_L_SID}},
    l_domain = {{ACCOUNT_LIFECYCLE_EVENTS_L_DOMAIN}},
    l_time = {{ACCOUNT_LIFECYCLE_EVENTS_L_TIME}},
    l_kind = {{ACCOUNT_LIFECYCLE_EVENTS_L_KIND}},
    l_host = {{ACCOUNT_LIFECYCLE_EVENTS_L_HOST}},
    l_detail = {{ACCOUNT_LIFECYCLE_EVENTS_L_DETAIL}}
| fields l_sid, l_domain, l_time, l_kind, l_host, l_detail
| filter l_kind in ("SUCCESSFUL_AUTH", "GROUP_ADDITION")
) as l account_sid = l.l_sid and domain_id = l.l_domain
| alter elapsed_seconds = timestamp_diff(l.l_time, creation_time, "SECOND")
| filter elapsed_seconds >= 0 and elapsed_seconds <= 86400
| filter l.l_kind = "SUCCESSFUL_AUTH"
| comp min(l.l_time) as evidence_time by creation_time, domain_id, account_sid, created_name, creator_sid, creation_host
| alter evidence_kind = "FIRST_OBSERVED_SUCCESSFUL_AUTH", evidence_detail = "First successful authentication observed within 24 hours after creation"
| fields creation_time, domain_id, account_sid, created_name, creator_sid, creation_host, evidence_time, evidence_kind, evidence_detail
)
| union (
dataset = {{DOMAIN_ACCOUNT_CREATION_DATASET}}
| alter creation_time = {{DOMAIN_ACCOUNT_CREATION_CREATION_TIME}},
    account_sid = {{DOMAIN_ACCOUNT_CREATION_ACCOUNT_SID}},
    domain_id = {{DOMAIN_ACCOUNT_CREATION_DOMAIN_ID}},
    creator_sid = {{DOMAIN_ACCOUNT_CREATION_CREATOR_SID}},
    creation_host = {{DOMAIN_ACCOUNT_CREATION_CREATION_HOST}},
    created_name = {{DOMAIN_ACCOUNT_CREATION_CREATED_NAME}},
    event_id = {{DOMAIN_ACCOUNT_CREATION_EVENT_ID}},
    is_domain_account = {{DOMAIN_ACCOUNT_CREATION_IS_DOMAIN_ACCOUNT}}
| fields creation_time, account_sid, domain_id, creator_sid, creation_host, created_name, event_id, is_domain_account
| filter event_id = 4720 and is_domain_account = true
| filter account_sid != null and account_sid != ""
| join type = inner (
dataset = {{ACCOUNT_LIFECYCLE_EVENTS_DATASET}}
| alter l_sid = {{ACCOUNT_LIFECYCLE_EVENTS_L_SID}},
    l_domain = {{ACCOUNT_LIFECYCLE_EVENTS_L_DOMAIN}},
    l_time = {{ACCOUNT_LIFECYCLE_EVENTS_L_TIME}},
    l_kind = {{ACCOUNT_LIFECYCLE_EVENTS_L_KIND}},
    l_host = {{ACCOUNT_LIFECYCLE_EVENTS_L_HOST}},
    l_detail = {{ACCOUNT_LIFECYCLE_EVENTS_L_DETAIL}}
| fields l_sid, l_domain, l_time, l_kind, l_host, l_detail
| filter l_kind in ("SUCCESSFUL_AUTH", "GROUP_ADDITION")
) as l account_sid = l.l_sid and domain_id = l.l_domain
| alter elapsed_seconds = timestamp_diff(l.l_time, creation_time, "SECOND")
| filter elapsed_seconds >= 0 and elapsed_seconds <= 86400
| filter l.l_kind = "GROUP_ADDITION"
| alter evidence_time = l.l_time, evidence_kind = l.l_kind, evidence_detail = l.l_detail
| fields creation_time, domain_id, account_sid, created_name, creator_sid, creation_host, evidence_time, evidence_kind, evidence_detail
)
| sort desc creation_time, asc evidence_time
| limit 2000
