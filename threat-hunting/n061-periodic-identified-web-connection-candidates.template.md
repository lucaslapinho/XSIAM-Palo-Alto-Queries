# Periodic Identified Web Connection Candidates

Measures positive time gaps between deduplicated, application-identified web connection starts for an endpoint, process and destination. Selects sufficiently frequent low-spread intervals for review while preserving the distinction between periodicity and malicious beaconing.

[Open query](n061-periodic-identified-web-connection-candidates.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N061  
**Category:** Threat Hunting / Network Periodicity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{IDENTIFIED_WEB_CONNECTION_STARTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MIN_INTERVALS}}` | INTEGER literal at least 5 | INTEGER literal at least 5: minimum observed inter-arrival gaps. |
| `{{MIN_GAP_SECONDS}}` | Positive numeric literal | Positive numeric literal: minimum average gap of interest. |
| `{{MAX_RELATIVE_SPREAD}}` | Numeric literal between 0 and 1 | Numeric literal between 0 and 1: allowed (max_gap-min_gap)/mean_gap; tune using legitimate traffic. |
| `{{IDENTIFIED_WEB_CONNECTION_STARTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{WEB_START_TIME}}` | DATETIME | DATETIME: one connection/session start, not periodic traffic-statistics timestamps. |
| `{{WEB_ENDPOINT_ID}}` | STRING | STRING: stable endpoint identity. |
| `{{WEB_PROCESS_INSTANCE}}` | STRING | STRING: stable owning process instance. |
| `{{WEB_CONNECTION_ID}}` | STRING | STRING: unique connection key within endpoint/process/window; establish lifetime before binding. |
| `{{WEB_DESTINATION}}` | STRING | STRING: normalized identified web destination/domain; not a port-only application label. |
| `{{WEB_IDENTIFIED_FLAG}}` | BOOLEAN | BOOLEAN: true only from protocol/application evidence, not from port 80/443 alone. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Persistent sessions with repeated messages may be missed. Clock ties, connection-ID reuse and periodic telemetry statistics must be resolved before using the metric.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: repeated independent connection starts at nearly equal gaps meet the tuned spread threshold. | See scenario |
| Planned test | Negative: one session with many statistics rows must collapse before gap analysis. | See scenario |
| Planned test | Null: missing stable connection or process key is excluded. | See scenario |
| Planned test | Edge: equal timestamp gaps are discarded; no division by zero is possible. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Preceding-row timestamp navigation](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/lag)
- [Explicit retention and supported string keys](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/dedup)
