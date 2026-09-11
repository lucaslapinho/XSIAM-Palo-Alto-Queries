# Windows Event Log Clearing Records - Schema Binding Template

Returns verified log-clearing audit events with the actual cleared channel and correctly parsed subject identity. The provider/event allowlist keeps confirmed clearing separate from attempted commands.

[Open query](n057-windows-event-log-clearing-records-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N057  
**Category:** Threat Hunting / Defense Impairment  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One collected clearing event for a specifically identified Windows log channel; source allowlist defines coverage.

## Data and setup

**Sources:** `{{WINDOWS_LOG_CLEAR_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{WINDOWS_LOG_CLEAR_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{LOG_CLEAR_TIME}}` | DATETIME |  |
| `{{LOG_CLEAR_UID}}` | STRING |  |
| `{{LOG_CLEAR_ENDPOINT}}` | STRING |  |
| `{{LOG_CLEAR_PROVIDER}}` | STRING |  |
| `{{LOG_CLEAR_CHANNEL}}` | STRING |  |
| `{{LOG_CLEAR_EVENT_ID}}` | INTEGER |  |
| `{{LOG_CLEAR_TARGET_CHANNEL}}` | STRING |  |
| `{{LOG_CLEAR_OPERATION}}` | STRING |  |
| `{{LOG_CLEAR_SUBJECT_SID}}` | STRING |  |
| `{{LOG_CLEAR_SUBJECT_ACCOUNT}}` | STRING |  |
| `{{LOG_CLEAR_SUBJECT_LOGON}}` | STRING |  |
| `{{VERIFIED_CLEAR_EVENT_PREDICATE}}` | BOOLEAN_EXPRESSION |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Security 1102 alone covers Security clearing, not every Windows channel.
- 1102 identity comes from UserData; ordinary EventData extraction cannot be presumed equivalent.
- Central retention and preceding collection coverage require independent review; missing earlier events are not proof of local clearing.
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
| positive | A valid Security 1102 with UserData Subject identity names Security as the cleared channel. | Returned with subject mapping. |
| negative | wevtutil command starts but no confirming clear event exists. | Excluded from this confirmed-event view. |
| null | Subject SID is absent but clearing channel/event semantics are verified. | Event remains with null actor context. |
| edge | EventID 1102 from an unrelated provider or an unverified channel is present. | Excluded by the exact provider/channel predicate. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft event 1102](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-1102)
- [MITRE Disable or Modify Tools](https://attack.mitre.org/techniques/T1685/)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
