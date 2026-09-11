# Privileged Domain Group Discovery - Schema Binding Template

Selects read-oriented requests targeting authoritative privileged domain-group SIDs, preserving requester and raw query context. Localized names are resolved through a time-valid group inventory.

[Open query](n046-privileged-domain-group-discovery-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N046  
**Category:** Threat Hunting / Discovery  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One group-read event paired with an authoritative privileged group valid at query time.

## Data and setup

**Sources:** `{{DIRECTORY_QUERY_DATASET}}`, `{{PRIVILEGED_GROUP_INVENTORY}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{DIRECTORY_QUERY_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{GROUP_QUERY_TIME}}` | DATETIME |  |
| `{{GROUP_QUERY_ENDPOINT}}` | STRING |  |
| `{{GROUP_QUERY_ACTOR}}` | STRING |  |
| `{{GROUP_QUERY_OPERATION}}` | STRING |  |
| `{{GROUP_QUERY_SID}}` | STRING |  |
| `{{GROUP_QUERY_TEXT}}` | STRING |  |
| `{{GROUP_QUERY_OUTCOME}}` | STRING |  |
| `{{PRIVILEGED_GROUP_INVENTORY}}` | DATASET_IDENTIFIER |  |
| `{{PRIV_GROUP_SID}}` | STRING |  |
| `{{PRIV_GROUP_NAME}}` | STRING |  |
| `{{PRIV_GROUP_REALM}}` | STRING |  |
| `{{PRIV_GROUP_FROM}}` | DATETIME |  |
| `{{PRIV_GROUP_TO}}` | DATETIME |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- A process start supplies an attempt only; actual directory query outcome requires directory audit evidence.
- Broad group inventories, membership changes and English-name substring matches cannot satisfy the group_read/SID contract.
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
| positive | A localized Domain Admins group read resolves to a privileged SID valid at the time. | Returned with its local display name. |
| negative | A member is added to the same group, or an ordinary group is read. | Excluded. |
| null | A query names a group but cannot resolve the SID and realm. | Excluded; unresolved-target coverage remains unknown. |
| edge | Identical localized names exist in two domains but only one SID is privileged. | Only the authoritative SID matches. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
- [MITRE Domain Groups Discovery](https://attack.mitre.org/techniques/T1069/002/)
