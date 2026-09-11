# Admitted Containers with Privileged or Host-Access Settings

Selects admitted normal, init and ephemeral container specifications with privileged execution or host-access settings. Requires normalized admitted specs and mounted-volume resolution; a requested privileged spec does not establish admission or a running container.

[Open query](n074-admitted-containers-with-privileged-or-host-access-settings.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N074  
**Category:** Threat Hunting / Kubernetes Workloads  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{ADMITTED_KUBERNETES_CONTAINER_SPECS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{ADMITTED_KUBERNETES_CONTAINER_SPECS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{CONTAINER_ADMISSION_TIME}}` | DATETIME | DATETIME: successful admitted spec/version observation time. |
| `{{CONTAINER_CLUSTER}}` | STRING | STRING: stable cluster ID. |
| `{{CONTAINER_NAMESPACE}}` | STRING | STRING: namespace. |
| `{{CONTAINER_POD_UID}}` | STRING | STRING: admitted pod UID, stable across same-name recreation. |
| `{{CONTAINER_NAME}}` | STRING | STRING: container name. |
| `{{CONTAINER_KIND}}` | STRING | STRING: normal/init/ephemeral; source must expand all three lists into distinct rows. |
| `{{CONTAINER_ADMISSION_ACTOR}}` | STRING nullable | STRING nullable: verified originating audit principal. |
| `{{CONTAINER_ADMITTED_FLAG}}` | BOOLEAN | BOOLEAN: true only for the admitted object; request-only and denied objects must not be marked true. |
| `{{CONTAINER_PRIVILEGED}}` | BOOLEAN nullable | BOOLEAN nullable: effective securityContext.privileged with version/OS defaults resolved. |
| `{{CONTAINER_HOST_PID}}` | BOOLEAN nullable | BOOLEAN nullable: effective pod hostPID. |
| `{{CONTAINER_HOST_IPC}}` | BOOLEAN nullable | BOOLEAN nullable: effective pod hostIPC. |
| `{{CONTAINER_HOST_NETWORK}}` | BOOLEAN nullable | BOOLEAN nullable: effective pod hostNetwork. |
| `{{CONTAINER_HOSTPATH_MOUNT}}` | BOOLEAN nullable | BOOLEAN nullable: true only if this container mounts a hostPath-backed volume; do not flag unused pod volumes. |
| `{{CONTAINER_RUNTIME_ID}}` | STRING nullable | STRING nullable: independently observed runtime container identity, if available. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Approved infrastructure often needs host access. Admission mutation, OS-specific defaults and controller-to-pod resolution must be established in the source contract.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: admitted init container with privileged=true is included. | See scenario |
| Planned test | Negative: denied request or unused hostPath volume does not qualify. | See scenario |
| Planned test | Null: unknown flags are not treated as true. | See scenario |
| Planned test | Edge: recreated pod with the same name retains a different UID; ephemeral containers are included. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Privileged and host-access security settings](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [Requested/admitted audit evidence boundaries](https://kubernetes.io/docs/tasks/debug/debug-cluster/audit/)
