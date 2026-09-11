# RDP from Sources Absent in a Verified Baseline - Schema Binding Template

Finds current-day successful RemoteInteractive logons whose target/source pair is absent from the preceding 30-day window, only for targets with verified baseline coverage.

[Open query](n050-rdp-from-sources-absent-in-a-verified-baseline-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N050  
**Category:** Threat Hunting / Lateral Movement  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One current-day RDP authentication observation for a previously unobserved target/source pair inside an explicit 31-day search; not first-ever history.

## Data and setup

**Sources:** `{{WINDOWS_AUTH_DATASET}}`, `{{RDP_BASELINE_COVERAGE}}`.

**Lookback:** `31d: current 24-hour observation plus preceding 720-hour baseline`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{WINDOWS_AUTH_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{AUTH_TIME}}` | DATETIME |  |
| `{{AUTH_EVENT_UID}}` | STRING |  |
| `{{AUTH_PROVIDER}}` | STRING |  |
| `{{AUTH_CHANNEL}}` | STRING |  |
| `{{AUTH_EVENT_ID}}` | INTEGER |  |
| `{{AUTH_LOGON_TYPE}}` | INTEGER |  |
| `{{AUTH_TARGET_ENDPOINT}}` | STRING |  |
| `{{AUTH_SOURCE_IP}}` | STRING |  |
| `{{AUTH_TARGET_ACCOUNT_KEY}}` | STRING |  |
| `{{AUTH_LOGON_KEY}}` | STRING |  |
| `{{RDP_BASELINE_COVERAGE}}` | DATASET_IDENTIFIER |  |
| `{{COVERAGE_ENDPOINT}}` | STRING |  |
| `{{COVERAGE_START}}` | DATETIME |  |
| `{{COVERAGE_END}}` | DATETIME |  |
| `{{COVERAGE_COMPLETE}}` | BOOLEAN |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Gateway/NAT addresses can collapse clients. Canonical IP representation must be consistent across current and historical rows.
- Completeness records are required; no records or incomplete collection cannot establish first-seen behavior.
- The preceding baseline is hours 24 through 744 before evaluation, and observation is hours 0 through 24. Clock skew/future events are excluded.
- All bindings are explicit contracts, not claims that a source or field exists. Bind field/expression placeholders to typed tenant fields or tested extraction expressions; never substitute a made-up name.
- One-day telemetry lookback unless stated otherwise. Source-clock, retention, collection and permission gaps can remove evidence; _time filtering must cover each source event time.
- All canonical normalized words in expressions are local mapping contracts, not undocumented Cortex enum values.
- Result limits apply after analysis and do not cap scanned data or join fan-out. No tenant compile, execution, performance or deployment claim.
- ATT&CK, where present, is an analytical interpretation requiring context, not proof of compromise.
- Inventory/coverage/snapshot source bindings must return every relevant validity record under the configured query timeframe; if their storage timestamps differ, establish and test an explicit inner timeframe before use. A missing lookup row is never automatically benign.
- Comparisons are case-sensitive. Binding owners must canonicalize values only in source namespaces proven case-insensitive (such as reviewed Windows service/path/account keys and DNS A-label names), identically on both join sides. Preserve Unix paths, case-sensitive identities, ARN resource components, and source evidence text. All normalized operation/result labels must match the documented local contract spelling exactly.
- Time-difference bounds are expressed at second resolution. Validate subsecond boundary behavior using source fixtures; direct timestamp comparisons enforce before/after ordering where required.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Target H has complete preceding coverage; source A appears at age 2 hours but never in hours 24-744. | Returned. |
| negative | The same H/A pair appears at age 48 hours. | Excluded. |
| null | No complete coverage record exists for H. | Excluded; history is unknown. |
| edge | An H/A event occurs exactly 24 hours ago. | It is baseline evidence and not an observation-row candidate. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
