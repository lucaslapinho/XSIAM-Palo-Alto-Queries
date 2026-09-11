# Observed Stops of Critical Services

Selects observed running-to-stopped transitions for services classified as critical at event time. Retains attributable actor/request context when available and supports maintenance and dependency review without equating a stop command with a completed stop.

[Open query](n068-observed-stops-of-critical-services.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N068  
**Category:** Threat Hunting / Service Availability  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{CRITICAL_SERVICE_HISTORY}}`, `{{SERVICE_STATE_TRANSITIONS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SERVICE_STATE_TRANSITIONS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{SERVICE_STATE_TIME}}` | DATETIME | DATETIME: actual service state transition timestamp. |
| `{{SERVICE_ENDPOINT}}` | STRING | STRING: stable endpoint. |
| `{{SERVICE_ID}}` | STRING | STRING: canonical service identity, not display name only. |
| `{{SERVICE_BEFORE}}` | STRING | STRING: normalized running/stopped/unknown state. |
| `{{SERVICE_AFTER}}` | STRING | STRING: normalized running/stopped/unknown state. |
| `{{SERVICE_ACTOR}}` | STRING nullable | STRING nullable: actor established by linked control request, otherwise null. |
| `{{SERVICE_REQUEST_ID}}` | STRING nullable | STRING nullable: correlated control request, not assumed from temporal proximity. |
| `{{CRITICAL_SERVICE_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{CRITICAL_SERVICE_ENDPOINT}}` | STRING | STRING: endpoint scope. |
| `{{CRITICAL_SERVICE_ID}}` | STRING | STRING: exact canonical service identity. |
| `{{CRITICAL_SERVICE_FROM}}` | DATETIME | DATETIME: criticality start. |
| `{{CRITICAL_SERVICE_UNTIL}}` | DATETIME | DATETIME: criticality end exclusive. |
| `{{CRITICAL_SERVICE_OWNER}}` | STRING | STRING: service owner. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Unexpected crashes, planned maintenance and dependency shutdowns all require contextual interpretation.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: actual critical-service running-to-stopped transition matches. | See scenario |
| Planned test | Negative: failed stop request without a state transition does not match. | See scenario |
| Planned test | Null: unavailable actor stays unknown. | See scenario |
| Planned test | Edge: criticality granted after the event must not classify the earlier transition. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
