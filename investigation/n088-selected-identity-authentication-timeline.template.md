# Selected Identity Authentication Timeline

Returns source-qualified authentication records for one stable principal, retaining raw outcomes, authentication type, target and source address. Requires verified mappings for each included provider and does not merge identities by matching display names.

[Open query](n088-selected-identity-authentication-timeline.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N088  
**Category:** Investigation / Authentication  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{AUTHENTICATION_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{PRINCIPAL_TO_REVIEW}}` | Quoted STRING literal | Quoted STRING literal: one stable provider-qualified identity, not a display-name substring. |
| `{{AUTHENTICATION_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{AUTH_TIME}}` | DATETIME | DATETIME: source authentication event time. |
| `{{AUTH_PROVIDER}}` | STRING | STRING: provider/tenant authority. |
| `{{AUTH_PRINCIPAL_ID}}` | STRING | STRING: immutable authority-qualified subject identity. |
| `{{AUTH_PRINCIPAL_NAME}}` | STRING nullable | STRING nullable: readable identity. |
| `{{AUTH_OUTCOME}}` | STRING | STRING: normalized success/failure/unknown, retaining a separate raw result. |
| `{{AUTH_RAW_RESULT}}` | STRING nullable | STRING nullable: original provider outcome/code. |
| `{{AUTH_KIND}}` | STRING | STRING: interactive/noninteractive/service/unknown. |
| `{{AUTH_SOURCE_IP}}` | STRING nullable | STRING nullable: requester IP, not destination IP. |
| `{{AUTH_TARGET}}` | STRING nullable | STRING nullable: service/asset/application identity. |
| `{{AUTH_CORRELATION_ID}}` | STRING nullable | STRING nullable: provider correlation/session key, not automatically globally unique. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- No assumed identity equivalence across tenant/domain authorities.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: known success and failure for the selected principal both remain. | See scenario |
| Planned test | Negative: same display name in another tenant is excluded. | See scenario |
| Planned test | Null: unknown result remains unknown. | See scenario |
| Planned test | Edge: related service and interactive events remain separately labeled. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
