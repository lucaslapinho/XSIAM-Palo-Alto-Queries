# Kubernetes Bindings to Reviewed Privileged Roles

Finds successful binding changes whose admitted role reference resolves to a reviewed privileged role at event time. Uses cluster, role kind, name and namespace scope explicitly; request patches and role names alone do not establish effective privileges.

[Open query](n073-kubernetes-bindings-to-reviewed-privileged-roles.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N073  
**Category:** Threat Hunting / Kubernetes RBAC  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{KUBERNETES_AUDIT_DATASET}}`, `{{KUBERNETES_REVIEWED_ROLE_HISTORY}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{KUBERNETES_AUDIT_DATASET}}` | Dataset identifier | Dataset identifier: verified Kubernetes audit source; one audit event/stage per row. |
| `{{KUBERNETES_EVENT_TIME}}` | DATETIME expression | DATETIME expression: parsed audit stageTimestamp or requestReceivedTimestamp with the chosen semantics retained. |
| `{{KUBERNETES_CLUSTER_ID}}` | STRING expression | STRING expression: stable cluster identity supplied by trusted collection metadata, not object namespace alone. |
| `{{KUBERNETES_EVENT_JSON}}` | STRING expression | STRING expression: one original Kubernetes audit Event JSON object. Request/response bodies depend on the audit policy. |
| `{{KUBERNETES_REVIEWED_ROLE_HISTORY}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{ROLE_REVIEW_CLUSTER}}` | STRING | STRING: same stable cluster ID. |
| `{{ROLE_REVIEW_KIND}}` | STRING | STRING: Role or ClusterRole, exact case. |
| `{{ROLE_REVIEW_NAME}}` | STRING | STRING: exact role name, not a privileged-name substring. |
| `{{ROLE_REVIEW_NAMESPACE}}` | STRING nullable | STRING nullable: Role namespace; null/empty for ClusterRole. |
| `{{ROLE_REVIEW_FROM}}` | DATETIME | DATETIME: reviewed resolved role-rules validity start. |
| `{{ROLE_REVIEW_UNTIL}}` | DATETIME | DATETIME: role-rules validity end exclusive. |
| `{{ROLE_REVIEW_HIGH_PRIVILEGE}}` | BOOLEAN | BOOLEAN: reviewed effective rule set is privileged; evaluate wildcards, bind/escalate/impersonate, aggregation and resource scope. |
| `{{ROLE_REVIEW_REASON}}` | STRING | STRING: resolved permissions and scope rationale. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Requires RequestResponse-level body coverage sufficient for responseObject. Omitted response bodies are excluded rather than guessed from patch fragments. Role definition changes can change privileges without a binding event.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: admitted roleRef matches a time-valid reviewed privileged role in the same cluster. | See scenario |
| Planned test | Negative: nonprivileged or different-namespace Role does not match. | See scenario |
| Planned test | Null: missing admitted roleRef is excluded. | See scenario |
| Planned test | Edge: ClusterRole namespace comparison is not confused with a namespaced Role; a stale role version must not qualify. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Audit body and response-stage coverage](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)
- [RoleBinding, ClusterRoleBinding and effective role-reference semantics](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
