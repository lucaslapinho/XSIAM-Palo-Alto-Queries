# Privileged Group Membership Additions

Selects local/global/universal group addition events against an explicit privileged-group SID scope, resolves initiator/member identities and retains established change context.

[Open query](n035-privileged-group-membership-additions.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N035  
**Category:** Threat Hunting / Identity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

The template implements privileged membership additions with identity resolution. Baseline membership is supplied explicitly; no group-name prefix or actor exclusion establishes privilege.

## Data and setup

**Sources:** `{{GROUP_ADDITIONS_DATASET}}`, `{{PRIVILEGED_GROUPS_DATASET}}`, `{{SID_DIRECTORY_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{GROUP_ADDITIONS_DATASET}}` | XQL dataset identifier | Actual read-only source for GROUP_ADDITIONS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{GROUP_ADDITIONS_EVENT_TIME}}` | DATETIME scalar expression | Membership-addition time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_HOST_ID}}` | STRING scalar expression | Auditing host identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_EVENT_ID}}` | INTEGER scalar expression | Provider-verified Security event ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_RECORD_ID}}` | STRING scalar expression | Unique source event key Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_ACTOR_SID}}` | STRING scalar expression | Subject SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_ACTOR_SCOPE}}` | STRING scalar expression | Authoritative SID issuer domain or machine namespace for actor_sid; local/builtin SIDs must include their applicable host scope Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_MEMBER_SID}}` | STRING scalar expression | Added member SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_MEMBER_SCOPE}}` | STRING scalar expression | Authoritative SID issuer domain or machine namespace for member_sid; preserve host scope for local/builtin SIDs Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_GROUP_SID}}` | STRING scalar expression | Target group SID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{GROUP_ADDITIONS_CHANGE_REFERENCE}}` | STRING scalar expression | Actual associated approved-change reference; null when not established Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PRIVILEGED_GROUPS_DATASET}}` | XQL dataset identifier | Actual read-only source for PRIVILEGED_GROUPS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{PRIVILEGED_GROUPS_PG_SID}}` | STRING scalar expression | Exact privileged group SID in this scope, including scoped local groups Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PRIVILEGED_GROUPS_PG_SCOPE}}` | STRING scalar expression | Host/domain scope preventing local-group cross-host confusion Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PRIVILEGED_GROUPS_PG_NAME}}` | STRING scalar expression | Reviewed privileged group name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PRIVILEGED_GROUPS_PG_HOST}}` | STRING scalar expression | Resolved auditing host scope; expand a domain-wide baseline deliberately to applicable audit hosts Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SID_DIRECTORY_DATASET}}` | XQL dataset identifier | Actual read-only source for SID_DIRECTORY. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{SID_DIRECTORY_DIR_SID}}` | STRING scalar expression | SID in the selected authoritative directory/scope Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SID_DIRECTORY_DIR_SCOPE}}` | STRING scalar expression | Authoritative issuer domain or machine namespace matching the corresponding event-side actor_scope/member_scope Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SID_DIRECTORY_DIR_NAME}}` | STRING scalar expression | Resolved account/group name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SID_DIRECTORY_DIR_KIND}}` | STRING scalar expression | Account/group type; one applicable row per SID plus issuer/machine scope Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Local SID reuse must be scoped to its host; reference rows must be unique and valid for the event.
- An approved-change reference is context, not proof that every addition in a window was authorized.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | 4732 adds SID A to a host-scoped privileged local group | Addition with resolved actor/member and preserved SIDs. |
| negative | Addition to a nonprivileged group or removal event | Excluded. |
| null | Member SID has no directory resolution | Addition remains with original SID and null resolved name. |
| edge | Same local group SID is privileged only on host B but event is on host A | No false cross-host privileged match. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-010](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-010](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-010](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-010](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-010](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-010](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4728)
- [Official source for TH-010](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4732)
- [Official source for TH-010](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4756)
- [Official source for TH-010](https://attack.mitre.org/techniques/T1098/007/)
