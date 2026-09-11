# Account Lockouts with Preceding Authentication Failures

Links Windows Security account lockout records to matching target-identity failures in the preceding 30 minutes. Preserves lockouts with no matched failure and shows source codes for investigation without asserting that a particular failure caused the lockout.

[Open query](n089-account-lockouts-with-preceding-authentication-failures.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N089  
**Category:** Investigation / Account Lockouts  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{WINDOWS_AUTH_FAILURES}}`, `{{WINDOWS_LOCKOUT_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{WINDOWS_LOCKOUT_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{LOCKOUT_TIME}}` | DATETIME | DATETIME: source 4740 timestamp. |
| `{{LOCKOUT_PRINCIPAL_ID}}` | STRING | STRING: verified domain-qualified target SID; never subject SID. |
| `{{LOCKOUT_RECORD_KEY}}` | STRING | STRING: collision-resistant provider/host/record key. |
| `{{LOCKOUT_CALLER_HOST}}` | STRING nullable | STRING nullable: CallerComputerName, not necessarily an IP. |
| `{{LOCKOUT_EVENT_ID}}` | INTEGER | INTEGER: Windows Security event ID. |
| `{{LOCKOUT_PROVIDER}}` | STRING | STRING: event provider name. |
| `{{WINDOWS_AUTH_FAILURES}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{FAILURE_TIME}}` | DATETIME | DATETIME: 4625/4771 source time. |
| `{{FAILURE_PRINCIPAL_ID}}` | STRING | STRING: verified target identity compatible with lockout SID; unresolved names must not be coerced into a match. |
| `{{FAILURE_RECORD_KEY}}` | STRING | STRING: stable per-event record key. |
| `{{FAILURE_EVENT_ID}}` | INTEGER | INTEGER: 4625 or 4771 only. |
| `{{FAILURE_PROVIDER}}` | STRING | STRING: event provider. |
| `{{FAILURE_SOURCE_IP}}` | STRING nullable | STRING nullable: requester address. |
| `{{FAILURE_CODE}}` | STRING nullable | STRING nullable: original status/substatus/failure code. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Cross-host clocks and unresolved SID mappings can prevent or distort matches; the one-day outer boundary truncates prior context near its start.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: same target identity failure ten minutes before lockout matches. | See scenario |
| Planned test | Negative: later or more-than-30-minute-old failure does not match. | See scenario |
| Planned test | Null: unmatched lockout survives the left join. | See scenario |
| Planned test | Edge: two unrelated principals with the same display name must never correlate. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Windows lockout target and caller semantics](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4740)
