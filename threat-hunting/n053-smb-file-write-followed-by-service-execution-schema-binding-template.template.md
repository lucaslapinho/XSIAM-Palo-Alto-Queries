# SMB File Write Followed by Service Execution - Schema Binding Template

Correlates a completed SMB write, successful installation of a service using the same resolved executable path, and a verified service-associated process start in bounded sequence.

[Open query](n053-smb-file-write-followed-by-service-execution-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N053  
**Category:** Threat Hunting / Lateral Movement  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One write/install/start evidence chain. A maximum ten-minute gap is enforced at each transition; many valid pairs can remain.

## Data and setup

**Sources:** `{{SMB_FILE_WRITE_DATASET}}`, `{{SERVICE_INSTALL_DATASET}}`, `{{SERVICE_PROCESS_START_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SMB_FILE_WRITE_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SMB_WRITE_TIME}}` | DATETIME |  |
| `{{SMB_WRITE_UID}}` | STRING |  |
| `{{SMB_TARGET_ENDPOINT}}` | STRING |  |
| `{{SMB_WRITE_SOURCE}}` | STRING |  |
| `{{SMB_WRITE_ACCOUNT}}` | STRING |  |
| `{{SMB_SERVER_FILE_PATH}}` | STRING |  |
| `{{SMB_WRITE_RESULT}}` | STRING |  |
| `{{SERVICE_INSTALL_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SERVICE_INSTALL_TIME}}` | DATETIME |  |
| `{{SERVICE_INSTALL_UID}}` | STRING |  |
| `{{SERVICE_ENDPOINT}}` | STRING |  |
| `{{SERVICE_NAME}}` | STRING |  |
| `{{SERVICE_EXECUTABLE_PATH}}` | STRING |  |
| `{{SERVICE_INSTALL_RESULT}}` | STRING |  |
| `{{SERVICE_ACCOUNT}}` | STRING |  |
| `{{SERVICE_PROCESS_START_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SERVICE_START_TIME}}` | DATETIME |  |
| `{{SERVICE_START_ENDPOINT}}` | STRING |  |
| `{{STARTED_SERVICE_NAME}}` | STRING |  |
| `{{STARTED_SERVICE_PATH}}` | STRING |  |
| `{{SERVICE_START_INSTANCE}}` | STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Deployment tools commonly create this sequence; no PsExec filename dependency or maliciousness claim.
- Path equivalence does not prove bytes are unchanged between events; add hash verification before claiming exact transferred-file identity.
- 5145 access authorization and a bare 4697 installation cannot substitute for completed write or actual service-associated execution.
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
| positive | A completed SMB write at 10:00 is installed as service S at 10:02 and S starts at 10:03 on the same host/path. | One complete sequence. |
| negative | Only access-granted 5145 plus a service install appears, or no service process starts. | Excluded. |
| null | Service executable cannot be separated from command-line arguments or its start cannot be associated with S. | Required binding unresolved; no valid chain. |
| edge | Two writes update the same path within ten minutes before installation. | Both candidate chains can appear; do not report unique transferred payload identity. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft event 5145](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-5145)
- [Microsoft event 4697](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4697)
- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
