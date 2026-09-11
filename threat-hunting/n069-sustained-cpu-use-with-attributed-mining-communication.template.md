# Sustained CPU Use with Attributed Mining Communication

Correlates sustained high CPU samples with independently identified mining communication from the same process within a fixed 15-minute interval. Requires genuine resource metrics and protocol attribution; software names, ports and EDR row counts do not establish cryptomining.

[Open query](n069-sustained-cpu-use-with-attributed-mining-communication.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N069  
**Category:** Threat Hunting / Resource Abuse  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{IDENTIFIED_MINING_PROTOCOL_EVENTS}}`, `{{PROCESS_RESOURCE_METRICS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MIN_SPAN_SECONDS}}` | INTEGER 600..899 | INTEGER 600..899: minimum first-to-last sample duration in the 15-minute interval. |
| `{{MAX_SAMPLE_GAP_SECONDS}}` | Positive INTEGER | Positive INTEGER: maximum admitted gap between consecutive samples; set to the validated collection cadence plus reviewed jitter, for example 90 for a 60-second collector. |
| `{{MIN_CPU_PERCENT}}` | Numeric literal 0..100 | Numeric literal 0..100: workload-reviewed sustained CPU threshold. |
| `{{MIN_SAMPLES}}` | INTEGER at least 3 | INTEGER at least 3: minimum metric samples in a 15-minute window; source cadence must be known. |
| `{{PROCESS_RESOURCE_METRICS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{RESOURCE_METRIC_TIME}}` | DATETIME | DATETIME: actual sampled utilization time. |
| `{{RESOURCE_ENDPOINT}}` | STRING | STRING: stable host/workload identity. |
| `{{RESOURCE_PROCESS}}` | STRING | STRING: stable process instance, same namespace as attributed network events. |
| `{{RESOURCE_CPU_PERCENT}}` | FLOAT | FLOAT: normalized percentage of the reviewed CPU capacity, 0..100; specify per-core versus whole-host denominator. |
| `{{RESOURCE_METRIC_KIND}}` | STRING | STRING: normalized cpu_percent; exclude unlike units or counters. |
| `{{IDENTIFIED_MINING_PROTOCOL_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{MINING_NETWORK_TIME}}` | DATETIME | DATETIME: actual attributed protocol observation time. |
| `{{MINING_NETWORK_ENDPOINT}}` | STRING | STRING: same endpoint namespace. |
| `{{MINING_NETWORK_PROCESS}}` | STRING | STRING: same process instance namespace. |
| `{{MINING_PROTOCOL_IDENTIFIED}}` | BOOLEAN | BOOLEAN: true only from independently validated mining protocol/content classification; an indicator match, destination reputation or common port alone cannot set this flag. |
| `{{MINING_POOL_DESTINATION}}` | STRING | STRING: observed pool/service destination. |
| `{{MINING_PROTOCOL_EVIDENCE}}` | STRING | STRING: safe evidence label; preserve attribution and confidence. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Sampling gaps, denominator changes, GPU-only mining and unattributed proxy traffic can be missed. Duplicate metric samples must be resolved before binding.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: enough sustained CPU samples plus same-process mining protocol evidence match. | See scenario |
| Planned test | Negative: busy approved compute with no mining communication does not match. | See scenario |
| Planned test | Null: absent process attribution cannot correlate. | See scenario |
| Planned test | Edge: a protocol event from another process does not substantiate the metric; three clustered samples or a long sampling gap must fail the sustained-span criteria. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Resource utilization is separately collected telemetry, not process-event volume](https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/)
