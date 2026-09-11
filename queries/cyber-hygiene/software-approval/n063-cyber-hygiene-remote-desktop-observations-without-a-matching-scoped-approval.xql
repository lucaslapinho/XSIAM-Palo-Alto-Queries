//Title
Cyber Hygiene - Remote Desktop Observations without a Matching Scoped Approval

//Description
Compares verified remote-desktop software observations with time-valid approvals scoped to endpoint, principal, product and version. Returns unmatched observations for policy review and keeps inventory evidence distinct from process execution.

//Category
Cyber Hygiene / Software Approval

:Query:

// SCHEMA-BINDING TEMPLATE: replace every binding according to the query guide.
// Binding placeholders are not Cortex field names or executable XQL.
// Cortex XSIAM interactive XQL Search. Full-query compilation/execution: NOT RUN.
config case_sensitive = true timeframe = 1d
| dataset = {{REMOTE_DESKTOP_SOFTWARE_OBSERVATIONS}}
| alter
    event_time = {{REMOTE_SOFTWARE_TIME}},
    endpoint_id = {{REMOTE_SOFTWARE_ENDPOINT}},
    principal_id = {{REMOTE_SOFTWARE_USER}},
    product_id = {{REMOTE_SOFTWARE_PRODUCT}},
    version = {{REMOTE_SOFTWARE_VERSION}},
    identity_verified = {{REMOTE_SOFTWARE_IDENTITY_VERIFIED}},
    evidence_kind = {{REMOTE_SOFTWARE_EVIDENCE_KIND}}
| filter identity_verified = true and endpoint_id != null and principal_id != null and product_id != null and version != null and version != ""
| join type = left conflict_strategy = both (
dataset = {{REMOTE_DESKTOP_APPROVAL_HISTORY}}
| alter
    approval_endpoint = {{APPROVED_ENDPOINT}},
    approval_principal = {{APPROVED_PRINCIPAL}},
    approval_product = {{APPROVED_PRODUCT}},
    approval_version = {{APPROVED_VERSION}},
    approval_from = {{APPROVED_FROM}},
    approval_until = {{APPROVED_UNTIL}},
    approval_owner = {{APPROVAL_OWNER}}
| fields approval_endpoint, approval_principal, approval_product, approval_version, approval_from, approval_until, approval_owner
) as a a.approval_endpoint = endpoint_id and a.approval_principal = principal_id and a.approval_product = product_id and a.approval_version = version and event_time >= a.approval_from and event_time < a.approval_until
| filter a.approval_product = null
| fields event_time, endpoint_id, principal_id, product_id, version, evidence_kind
| sort desc event_time
| limit 1000
