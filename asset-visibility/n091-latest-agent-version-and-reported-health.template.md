# Latest Agent Version and Reported Health

Lists the latest reported agent version, content version, connectivity and protection state per stable endpoint from a verified health inventory source. Retains report age and tied latest rows rather than treating an old report as proof of current health.

[Open query](n091-latest-agent-version-and-reported-health.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N091  
**Category:** Asset Visibility / Agent Health  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{ENDPOINT_HEALTH_INVENTORY}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{ENDPOINT_HEALTH_INVENTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{HEALTH_ENDPOINT_ID}}` | STRING | STRING: stable agent/endpoint identity. |
| `{{HEALTH_SNAPSHOT_TIME}}` | DATETIME | DATETIME: report freshness, not last traffic time. |
| `{{HEALTH_ENDPOINT_NAME}}` | STRING | STRING: display hostname. |
| `{{HEALTH_AGENT_VERSION}}` | STRING | STRING: installed agent version as reported. |
| `{{HEALTH_CONTENT_VERSION}}` | STRING | STRING: content update version. |
| `{{HEALTH_LAST_SEEN}}` | DATETIME | DATETIME: documented inventory/heartbeat last-seen semantics. |
| `{{HEALTH_CONNECTIVITY}}` | STRING | STRING: raw documented connectivity state. |
| `{{HEALTH_PROTECTION_STATE}}` | STRING | STRING: raw operational/protection state. |
| `{{HEALTH_GROUP_NAMES}}` | ARRAY of STRING | ARRAY of STRING: current group context, not used as a join key. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Health status meanings must be mapped from the actual source. A reported last_seen is not automatically a process/network event time.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: newest report supersedes an older version. | See scenario |
| Planned test | Negative: missing stable endpoint ID is excluded. | See scenario |
| Planned test | Null: missing protection state stays unknown. | See scenario |
| Planned test | Edge: equal newest report timestamps retain both conflicting source rows. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Endpoint API is context only; it does not establish the XQL inventory schema](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR-Platform-APIs/Get-Endpoint?contentId=6uEkAmbyVEjNV0CaIbYDQA)
