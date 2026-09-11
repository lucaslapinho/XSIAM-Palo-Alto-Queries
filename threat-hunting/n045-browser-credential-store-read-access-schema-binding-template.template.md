# Browser Credential Store Read Access - Schema Binding Template

Finds successful reads of inventoried browser credential-store files and preserves reader identity for review. Requires real access telemetry and time-valid browser-profile paths.

[Open query](n045-browser-credential-store-read-access-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N045  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One observed read paired with one valid credential-store inventory entry; contract requires nonoverlapping inventory intervals.

## Data and setup

**Sources:** `{{FILE_ACCESS_DATASET}}`, `{{BROWSER_STORE_INVENTORY}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{FILE_ACCESS_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{READ_TIME}}` | DATETIME |  |
| `{{READ_EVENT_UID}}` | STRING |  |
| `{{READ_ENDPOINT}}` | STRING |  |
| `{{READ_PROCESS_INSTANCE}}` | STRING |  |
| `{{READ_PROCESS_IMAGE}}` | STRING |  |
| `{{READ_ACCOUNT}}` | STRING |  |
| `{{READ_CANONICAL_PATH}}` | STRING |  |
| `{{READ_OPERATION}}` | STRING |  |
| `{{READ_OUTCOME}}` | STRING |  |
| `{{BROWSER_STORE_INVENTORY}}` | DATASET_IDENTIFIER |  |
| `{{STORE_ENDPOINT}}` | STRING |  |
| `{{STORE_PATH}}` | STRING |  |
| `{{STORE_BROWSER}}` | STRING |  |
| `{{STORE_VALID_FROM}}` | DATETIME |  |
| `{{STORE_VALID_TO}}` | DATETIME |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Browser, backup and security tools can read these files legitimately; baseline reader identity before escalation.
- Reads do not prove decryption, copying, archiving or credential exfiltration. Follow-on artifacts are investigation pivots, not implied outputs.
- No generic Login Data substring or write-only proxy substitutes for verified store paths and reads.
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
| positive | Reader P reads an inventoried Login Data path on host H inside its validity interval. | One access record with browser/profile context. |
| negative | The same process modifies the file or reads an unrelated SQLite database. | Excluded. |
| null | A read has no process instance or the inventory lacks the path. | Excluded; incomplete attribution/coverage is recorded. |
| edge | A browser profile moves at noon; access uses the old path at 13:00. | Old expired inventory entry cannot join. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [MITRE browser credential stores](https://attack.mitre.org/techniques/T1555/003/)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
