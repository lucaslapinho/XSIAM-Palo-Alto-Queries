# Cortex Response Requests and Terminal Outcomes

Links Cortex response requests to terminal audit records by stable action and endpoint identity within 24 hours. Preserves requests without a terminal record and reports original outcomes; no response action is executed by this query.

[Open query](n096-cortex-response-requests-and-terminal-outcomes.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N096  
**Category:** Security Operations / Response Audit  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{RESPONSE_AUDIT_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{REQUEST_STAGES}}` | Comma-separated quoted STRING literals | Comma-separated quoted STRING literals: observed request-stage values. |
| `{{TERMINAL_STAGES}}` | Comma-separated quoted STRING literals | Comma-separated quoted STRING literals: observed completed/failed/canceled/timed-out terminal stages. |
| `{{RESPONSE_AUDIT_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{RESPONSE_TIME}}` | DATETIME | DATETIME: source audit timestamp. |
| `{{RESPONSE_ACTION_ID}}` | STRING | STRING: stable per-action correlation identifier; not a row ID. |
| `{{RESPONSE_ENDPOINT_ID}}` | STRING | STRING: exact target endpoint identity. |
| `{{RESPONSE_ACTOR}}` | STRING nullable | STRING nullable: requesting actor. |
| `{{RESPONSE_ACTION_TYPE}}` | STRING | STRING: isolation, scan, script, uninstall or other verified operation. |
| `{{RESPONSE_STAGE}}` | STRING | STRING: lifecycle stage. |
| `{{RESPONSE_RESULT}}` | STRING | STRING: reported raw outcome. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- A completion record is not necessarily success. Window boundaries can hide terminal events; unmatched is not automatically failed or timed out.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: matching action+endpoint terminal event after request joins. | See scenario |
| Planned test | Negative: another endpoint or earlier terminal event does not join. | See scenario |
| Planned test | Null: request without completion remains visible. | See scenario |
| Planned test | Edge: retries with distinct action IDs remain separate. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Auditing source boundaries; action lifecycle mapping is tenant-specific](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
