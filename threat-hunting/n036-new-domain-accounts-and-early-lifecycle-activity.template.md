# New Domain Accounts and Early Lifecycle Activity

Preserves verified domain-account creation and adds first observed successful authentication plus subsequent group additions within 24 hours using stable SID/domain keys.

[Open query](n036-new-domain-accounts-and-early-lifecycle-activity.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N036  
**Category:** Threat Hunting / Identity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full creation-to-authentication-to-membership template. First means observed after creation inside the selected retention/window, not first-ever activity.

## Data and setup

**Sources:** `{{ACCOUNT_LIFECYCLE_EVENTS_DATASET}}`, `{{DOMAIN_ACCOUNT_CREATION_DATASET}}`.

**Lookback:** `3d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{DOMAIN_ACCOUNT_CREATION_DATASET}}` | XQL dataset identifier | Actual read-only source for DOMAIN_ACCOUNT_CREATION. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{DOMAIN_ACCOUNT_CREATION_CREATION_TIME}}` | DATETIME scalar expression | 4720 creation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_ACCOUNT_SID}}` | STRING scalar expression | Created TargetSid Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_DOMAIN_ID}}` | STRING scalar expression | Authoritative domain SID/identifier; cannot be inferred from host/account name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_CREATOR_SID}}` | STRING scalar expression | Creating subject SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_CREATION_HOST}}` | STRING scalar expression | Auditing host Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_CREATED_NAME}}` | STRING scalar expression | Created account name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_EVENT_ID}}` | INTEGER scalar expression | Provider-verified event ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_ACCOUNT_CREATION_IS_DOMAIN_ACCOUNT}}` | BOOLEAN scalar expression | Verified domain-account classification from DC/domain inventory and TargetSid, excluding local accounts Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_DATASET}}` | XQL dataset identifier | Actual read-only source for ACCOUNT_LIFECYCLE_EVENTS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_L_SID}}` | STRING scalar expression | Target authenticated SID or added MemberSid Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_L_DOMAIN}}` | STRING scalar expression | Same authoritative domain namespace Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_L_TIME}}` | DATETIME scalar expression | Later activity time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_L_KIND}}` | STRING scalar expression | Normalized SUCCESSFUL_AUTH or GROUP_ADDITION from actual outcome/event family Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_L_HOST}}` | STRING scalar expression | Authentication/group-change target host Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCOUNT_LIFECYCLE_EVENTS_L_DETAIL}}` | STRING scalar expression | Provider/outcome/source context or target group SID and role Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- 4720 on a member/workstation can create a local account and must not pass the domain-account binding.
- A three-day scan supplies event context; creation near the scan end has incomplete future follow-up. Group additions are privilege context only after target-group review.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Verified domain account created at T, authenticates at T+10 and T+20 minutes, then joins a group | Creation, first-auth at +10 and group-add evidence. |
| negative | Local workstation account with 4720 or a different domain reuses the display name | Excluded or not correlated. |
| null | Created SID has no subsequent telemetry | Creation remains without fabricated authentication. |
| edge | Group addition at T-1 or T+86401 seconds | Excluded from subsequent lifecycle evidence. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-011](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-011](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-011](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-011](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-011](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-011](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-011](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4720)
- [Official source for TH-011](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Official source for TH-011](https://attack.mitre.org/techniques/T1136/002/)
