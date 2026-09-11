# Network Share Enumeration Requests - Schema Binding Template

Returns explicit server share-list requests from validated protocol operations or read-oriented command attempts, keeping their evidence kinds and outcomes distinct.

[Open query](n048-network-share-enumeration-requests-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N048  
**Category:** Threat Hunting / Discovery  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One explicit server share-enumeration request; command attempts remain separate from observed protocol operations.

## Data and setup

**Sources:** `{{SHARE_ENUMERATION_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SHARE_ENUMERATION_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SHARE_ENUM_TIME}}` | DATETIME |  |
| `{{SHARE_ENUM_UID}}` | STRING |  |
| `{{SHARE_ENUM_ENDPOINT}}` | STRING |  |
| `{{SHARE_ENUM_ACCOUNT}}` | STRING |  |
| `{{SHARE_ENUM_SERVER}}` | STRING |  |
| `{{SHARE_ENUM_OPERATION}}` | STRING |  |
| `{{SHARE_ENUM_KIND}}` | STRING |  |
| `{{SHARE_ENUM_OUTCOME}}` | STRING |  |
| `{{SHARE_ENUM_CONTEXT}}` | STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Only explicitly targeted server-share requests qualify; plain net view and net view /domain list computers/domains and are excluded.
- Administrative inventory is common. No maliciousness or successful enumeration is inferred from a command.
- Bind command forms with argv-aware tested parsing; a substring mention in echo/script text is insufficient.
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
| positive | net view with explicit server argument or a verified share-list RPC targets server S. | Returned, with the correct evidence kind. |
| negative | Bare net view, domain listing, share creation or SMB file-open occurs. | Excluded. |
| null | Operation looks like enumeration but server identity is absent. | Excluded and flagged as a coverage gap. |
| edge | A command starts and a corresponding RPC is separately collected. | Two evidence rows remain; not counted as two unique enumeration sessions. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft net view](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/hh875576%28v%3Dws.11%29)
- [Microsoft event 5145](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-5145)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
- [MITRE Network Share Discovery](https://attack.mitre.org/techniques/T1135/)
