# Kubernetes Audit Timeline with Time-Valid Workload Context

Presents response-stage Kubernetes audit events for one cluster and adds workload context only when cluster, stable object UID and inventory validity match. Keeps unmatched audit events visible and avoids assigning current workload names retrospectively to recreated objects.

[Open query](n100-kubernetes-audit-timeline-with-time-valid-workload-context.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N100  
**Category:** Investigation / Kubernetes Audit  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{KUBERNETES_AUDIT_DATASET}}`, `{{KUBERNETES_WORKLOAD_IDENTITY_HISTORY}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{CLUSTER_TO_REVIEW}}` | Quoted STRING literal | Quoted STRING literal: one stable collected cluster identity. |
| `{{KUBERNETES_AUDIT_DATASET}}` | Dataset identifier | Dataset identifier: verified Kubernetes audit source; one audit event/stage per row. |
| `{{KUBERNETES_EVENT_TIME}}` | DATETIME expression | DATETIME expression: parsed audit stageTimestamp or requestReceivedTimestamp with the chosen semantics retained. |
| `{{KUBERNETES_CLUSTER_ID}}` | STRING expression | STRING expression: stable cluster identity supplied by trusted collection metadata, not object namespace alone. |
| `{{KUBERNETES_EVENT_JSON}}` | STRING expression | STRING expression: one original Kubernetes audit Event JSON object. Request/response bodies depend on the audit policy. |
| `{{KUBERNETES_WORKLOAD_IDENTITY_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{WORKLOAD_CLUSTER}}` | STRING | STRING: same stable cluster key. |
| `{{WORKLOAD_OBJECT_UID}}` | STRING | STRING: audited object UID; pre-resolve ownerReferences only with time-valid resource UID evidence. |
| `{{WORKLOAD_VALID_FROM}}` | DATETIME | DATETIME: inventory validity start inclusive. |
| `{{WORKLOAD_VALID_UNTIL}}` | DATETIME | DATETIME: validity end exclusive. |
| `{{WORKLOAD_KIND}}` | STRING | STRING: resolved workload kind. |
| `{{WORKLOAD_NAME}}` | STRING | STRING: resolved workload display name. |
| `{{WORKLOAD_NODE_NAME}}` | STRING nullable | STRING nullable: node observed for this workload/pod at that time. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Objects without UIDs, absent workload histories and long-running stream completion gaps remain visible as limitations. No runtime execution is inferred from the API record.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: matching object UID and validity interval enrich the event. | See scenario |
| Planned test | Negative: same object name with a different UID must not enrich it. | See scenario |
| Planned test | Null: missing object UID preserves the audit row with no inventory match. | See scenario |
| Planned test | Edge: an object moved/recreated after the event does not acquire current context. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Kubernetes audit event identity and stage](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)
- [Kubernetes names and immutable object UID distinction](https://kubernetes.io/docs/concepts/overview/working-with-objects/names/)
