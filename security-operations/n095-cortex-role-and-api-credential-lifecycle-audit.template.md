# Cortex Role and API Credential Lifecycle Audit

Selects verified role, permission and API-credential lifecycle audit actions and presents safe target identifiers with responsible identity and reported outcome. Requires exact category/action bindings and intentionally excludes credential values and raw request bodies.

[Open query](n095-cortex-role-and-api-credential-lifecycle-audit.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N095  
**Category:** Security Operations / Cortex Audit  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{ROLE_API_AUDIT_SOURCE}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{ROLE_AND_API_EVENT_TYPES}}` | Comma-separated typed enum/string literals | Comma-separated typed enum/string literals: exact audit categories confirmed for role/permission/API-key lifecycle operations. |
| `{{ROLE_AND_API_ACTIONS}}` | Comma-separated quoted STRING literals | Comma-separated quoted STRING literals: exact create/update/revoke/delete action values observed for the categories. |
| `{{ROLE_API_AUDIT_SOURCE}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{ROLE_API_TIME}}` | DATETIME | DATETIME: source audit timestamp. |
| `{{ROLE_API_ACTOR}}` | STRING nullable | STRING nullable: verified responsible identity. |
| `{{ROLE_API_TYPE}}` | ENUM or STRING | ENUM or STRING: original audit category; match the typed values in ROLE_AND_API_EVENT_TYPES. |
| `{{ROLE_API_ACTION}}` | STRING | STRING: original action. |
| `{{ROLE_API_RESULT}}` | STRING or ENUM | STRING or ENUM: raw reported outcome. |
| `{{ROLE_API_TARGET_KIND}}` | STRING | STRING: role/permission/API credential kind. |
| `{{ROLE_API_SAFE_TARGET_ID}}` | STRING | STRING: non-secret role or credential identifier only; never a token, key value or raw request body. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Exact role/API audit coverage is product-version and tenant dependent. Safe metadata must be inspected before binding.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: a known API-key revocation and role update are selected by exact category/action. | See scenario |
| Planned test | Negative: unrelated audit or description-only mention is excluded. | See scenario |
| Planned test | Null: unknown outcome remains unknown. | See scenario |
| Planned test | Edge: no credential secret or raw response is projected. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Cortex audit-source discovery boundary](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
