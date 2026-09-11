# Kubernetes Pod Exec and Attach Audit Responses

Returns Kubernetes pod exec and attach audit response stages with principal, target and original response code. Keeps streaming and completed response stages visible; an API request or protocol upgrade does not prove that a command ran inside the container.

[Open query](n072-kubernetes-pod-exec-and-attach-audit-responses.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N072  
**Category:** Threat Hunting / Kubernetes Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{KUBERNETES_AUDIT_DATASET}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{KUBERNETES_AUDIT_DATASET}}` | Dataset identifier | Dataset identifier: verified Kubernetes audit source; one audit event/stage per row. |
| `{{KUBERNETES_EVENT_TIME}}` | DATETIME expression | DATETIME expression: parsed audit stageTimestamp or requestReceivedTimestamp with the chosen semantics retained. |
| `{{KUBERNETES_CLUSTER_ID}}` | STRING expression | STRING expression: stable cluster identity supplied by trusted collection metadata, not object namespace alone. |
| `{{KUBERNETES_EVENT_JSON}}` | STRING expression | STRING expression: one original Kubernetes audit Event JSON object. Request/response bodies depend on the audit policy. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Request URI can contain command arguments; protect operational outputs. Audit body/policy gaps and GET versus POST transport behavior prevent universal runtime conclusions.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: pods/exec ResponseStarted and ResponseComplete rows are retained. | See scenario |
| Planned test | Negative: ordinary pod get/list or RequestReceived-only stage is excluded. | See scenario |
| Planned test | Null: missing response code remains unknown. | See scenario |
| Planned test | Edge: response 101 is retained as raw protocol context rather than rejected by a success-only 2xx predicate. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Kubernetes audit stages and policy levels](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)
- [Pod exec workflow and runtime distinction](https://kubernetes.io/docs/tasks/debug/debug-application/get-shell-running-container/)
