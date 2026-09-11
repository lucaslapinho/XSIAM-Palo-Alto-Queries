# RDP Session Followed by PowerShell Behavior - Schema Binding Template

Links successful RemoteInteractive authentication to qualifying PowerShell process starts within 30 minutes using a validated endpoint and logon-session key.

[Open query](n052-rdp-session-followed-by-powershell-behavior-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N052  
**Category:** Threat Hunting / Lateral Movement  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One authenticated session event and same-session process-start pair within 30 minutes; multiple qualifying starts remain separate.

## Data and setup

**Sources:** `{{WINDOWS_AUTH_DATASET}}`, `{{SESSION_PROCESS_START_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

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
| `{{SESSION_PROCESS_START_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{RDP_PROCESS_TIME}}` | DATETIME |  |
| `{{RDP_PROCESS_ENDPOINT}}` | STRING |  |
| `{{RDP_PROCESS_LOGON_KEY}}` | STRING |  |
| `{{RDP_PROCESS_INSTANCE}}` | STRING |  |
| `{{RDP_PROCESS_IMAGE}}` | STRING |  |
| `{{RDP_PROCESS_COMMAND}}` | STRING |  |
| `{{RDP_PROCESS_USER}}` | STRING |  |
| `{{RDP_PROCESS_OPERATION}}` | STRING |  |
| `{{POWERSHELL_BEHAVIOR_RE2}}` | QUOTED_RE2_STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Session namespace equivalence is a hard prerequisite. Host/time-only matching must not be substituted.
- The behavior regex is analyst-controlled and requires benign/negative fixtures; user/admin intent and process success remain unproved.
- Repeated or reconnect authentication events can multiply pairs; preserve IDs and validate session lifecycle before any session-count interpretation.
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
| positive | Auth A on H/session L is followed five minutes later by an encoded PowerShell start on H/L. The source basename is PowerShell.EXE and reviewed command grammar admits its case-equivalent executable token. | One linked pair. |
| negative | Same host/time and command behavior occur in a different logon session. | Excluded. |
| null | Process has only a Terminal Services ID with no validated Windows logon mapping. | Do not bind or run; no linkage result is valid. |
| edge | Qualifying process occurs exactly 1800 seconds later or one second before authentication. | 1800-second pair included; negative elapsed time excluded. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Cortex actor schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
