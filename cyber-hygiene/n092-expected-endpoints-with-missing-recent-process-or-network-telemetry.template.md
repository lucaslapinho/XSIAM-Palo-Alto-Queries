# Expected Endpoints with Missing Recent Process or Network Telemetry

Compares an authoritative expected-active endpoint population with the latest process or network record in a seven-day window. Keeps endpoints with no matching telemetry and shows independent heartbeat context; silence is an investigation lead rather than proof of agent failure.

[Open query](n092-expected-endpoints-with-missing-recent-process-or-network-telemetry.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N092  
**Category:** Cyber Hygiene / Collection Coverage  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `xdr_data`, `{{EXPECTED_ACTIVE_ENDPOINTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{STALE_MINUTES}}` | Positive numeric literal | Positive numeric literal: owner-approved inactivity threshold in minutes; choose for endpoint lifecycle and expected usage. |
| `{{EXPECTED_ACTIVE_ENDPOINTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{EXPECTED_ENDPOINT_ID}}` | STRING | STRING: one current expected-active record per endpoint. |
| `{{EXPECTED_ENDPOINT_NAME}}` | STRING | STRING: hostname. |
| `{{EXPECTED_ACTIVE_FLAG}}` | BOOLEAN | BOOLEAN: true only for operational endpoints expected to send telemetry now. |
| `{{EXPECTED_MAINTENANCE_FLAG}}` | BOOLEAN | BOOLEAN: explicit maintenance exemption, false for non-exempt endpoints. |
| `{{EXPECTED_HEARTBEAT_TIME}}` | DATETIME nullable | DATETIME nullable: independent heartbeat time, not the last process event. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Sources must expose current expected-state snapshots independently of the query lookback; idle endpoints can be benign. Heartbeat and activity gaps have different meanings.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: expected active endpoint with no process/network rows survives and is returned. | See scenario |
| Planned test | Negative: retired or maintenance endpoint is excluded. | See scenario |
| Planned test | Null: absent heartbeat is retained as unknown. | See scenario |
| Planned test | Edge: fresh heartbeat with stale activity remains a telemetry-gap candidate, not a disconnected-agent verdict. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Documented process/network event categories and stable agent identity](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
