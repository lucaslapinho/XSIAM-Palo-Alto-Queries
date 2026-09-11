# Scheduled Task Configuration Change Review

Reviews task creation and modification configurations against the current approved configuration snapshot, preserving subject, XML author, actions, triggers, principal and run level.

[Open query](n031-scheduled-task-configuration-change-review.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N031  
**Category:** Threat Hunting / Persistence  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Actual task-audit configuration workflow reviewed against current approval state. It does not establish whether approval existed at the historical event time. A missing match is a review state, not unauthorized execution.

## Data and setup

**Sources:** `{{APPROVED_TASKS_DATASET}}`, `{{TASK_AUDIT_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{TASK_AUDIT_DATASET}}` | XQL dataset identifier | Actual read-only source for TASK_AUDIT. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{TASK_AUDIT_TASK_TIME}}` | DATETIME scalar expression | Creation/modification event time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_HOST_ID}}` | STRING scalar expression | Stable host identifier Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_RECORD_KEY}}` | STRING scalar expression | Stable event key including provider/host/record identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_EVENT_ID}}` | INTEGER scalar expression | Windows audit ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_TASK_NAME}}` | STRING scalar expression | Configured task name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_CREATOR_SID}}` | STRING scalar expression | Audited subject SID; distinct from XML author Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_XML_AUTHOR}}` | STRING scalar expression | Author extracted from the actual task XML Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_ACTION_COMMAND}}` | STRING scalar expression | Configured executable and arguments from all actions, serialized without losing additional actions Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_TASK_TRIGGERS}}` | STRING scalar expression | Configured triggers from the actual XML Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_RUN_PRINCIPAL}}` | STRING scalar expression | Configured task principal Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_RUN_LEVEL}}` | STRING scalar expression | Normalized run level, including HighestAvailable where explicitly configured Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_TASK_XML}}` | STRING scalar expression | Complete original task XML for investigation Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{TASK_AUDIT_CONFIG_KEY}}` | STRING scalar expression | Canonical configuration identity used by the approved baseline Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{APPROVED_TASKS_DATASET}}` | XQL dataset identifier | Actual read-only source for APPROVED_TASKS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{APPROVED_TASKS_APPROVED_HOST}}` | STRING scalar expression | Same host scope as the task event Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{APPROVED_TASKS_APPROVED_CONFIG}}` | STRING scalar expression | Exact configuration identity with author, actions, triggers and principal; one current approved row per key. This is a review-time snapshot, not historical approval at event time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{APPROVED_TASKS_APPROVAL_ID}}` | STRING scalar expression | Actual current approved task/deployment reference; never infer that approval existed when the historical event occurred Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Bind Security-audit provider/channel and task event versions; the TASK_AUDIT source must exclude unrelated providers reusing IDs.
- The approved dataset must be a complete current snapshot for the evaluation scope; null config identity is UNASSESSED. Historical approval needs a separate effective-interval comparison.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | 4698 creates a highest-run-level task with an unapproved executable/action configuration | Review row with original XML and distinct subject/author. |
| negative | A process merely invokes schtasks but no configuration audit exists | No task-creation row. |
| null | Task XML lacks a parsed configuration identity | UNASSESSED; raw XML remains. |
| edge | 4702 changes a second action or trigger while preserving task name | Canonical config changes and the deviation remains visible. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-006](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-006](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-006](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-006](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-006](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-006](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4698)
- [Official source for TH-006](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4702)
- [Official source for TH-006](https://attack.mitre.org/techniques/T1053/005/)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
