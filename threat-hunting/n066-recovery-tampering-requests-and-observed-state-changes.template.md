# Recovery Tampering Requests and Observed State Changes

Links selected recovery-control change requests to independently observed resource state changes on the same endpoint. Preserves requests without confirmed effects and distinguishes backup maintenance from conclusions about inhibited recovery.

[Open query](n066-recovery-tampering-requests-and-observed-state-changes.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N066  
**Category:** Threat Hunting / Recovery Controls  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{RECOVERY_CHANGE_AUDIT}}`, `{{RECOVERY_STATE_CHANGES}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{RECOVERY_OPERATIONS}}` | Comma-separated quoted STRING literals | Comma-separated quoted STRING literals: exact verified operations for shadow-copy deletion, backup catalog deletion or recovery setting changes. |
| `{{RECOVERY_CHANGE_AUDIT}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{RECOVERY_TIME}}` | DATETIME | DATETIME: recovery-change request time. |
| `{{RECOVERY_ENDPOINT}}` | STRING | STRING: affected endpoint. |
| `{{RECOVERY_OPERATION_ID}}` | STRING | STRING: stable operation/correlation key. |
| `{{RECOVERY_ACTOR}}` | STRING nullable | STRING nullable: responsible principal. |
| `{{RECOVERY_OPERATION}}` | STRING | STRING: exact operation name. |
| `{{RECOVERY_RESOURCE}}` | STRING | STRING: affected shadow-copy/backup/configuration resource. |
| `{{RECOVERY_REQUEST_RESULT}}` | STRING | STRING: original request result; not final state. |
| `{{RECOVERY_STATE_CHANGES}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{RECOVERY_STATE_TIME}}` | DATETIME | DATETIME: observed state transition time. |
| `{{RECOVERY_STATE_ENDPOINT}}` | STRING | STRING: affected endpoint. |
| `{{RECOVERY_STATE_OPERATION_ID}}` | STRING | STRING: independently verified linkage to the request. |
| `{{RECOVERY_STATE_RESOURCE}}` | STRING | STRING: same affected-resource namespace. |
| `{{RECOVERY_BEFORE_STATE}}` | STRING | STRING: captured prior value/state. |
| `{{RECOVERY_AFTER_STATE}}` | STRING | STRING: captured new value/state. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Operation IDs and resource linkage must be verified; maintenance and troubleshooting can produce the same changes.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: exact deletion/change request and linked state transition appear together. | See scenario |
| Planned test | Negative: unrelated backup query operation is excluded. | See scenario |
| Planned test | Null: unmatched effect stays absent, not successful. | See scenario |
| Planned test | Edge: a state change on another resource must not corroborate the request. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Shadow-copy deletion command semantics](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/vssadmin-delete-shadows)
- [Legitimate recovery-setting maintenance context](https://learn.microsoft.com/en-us/troubleshoot/windows-client/performance/windows-boot-issues-troubleshooting)
