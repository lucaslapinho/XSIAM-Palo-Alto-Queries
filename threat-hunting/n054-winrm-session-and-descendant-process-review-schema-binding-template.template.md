# WinRM Session and Descendant Process Review - Schema Binding Template

Links authenticated WinRM shells to process starts through verified provider-instance ancestry, retaining requester, command and principal context within 30 minutes.

[Open query](n054-winrm-session-and-descendant-process-review-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N054  
**Category:** Threat Hunting / Lateral Movement  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One authenticated WinRM shell and attributed descendant start; provider reuse across shells requires unique shell-to-process linkage in the contract.

## Data and setup

**Sources:** `{{WINRM_SESSION_DATASET}}`, `{{WINRM_DESCENDANT_PROCESS_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{WINRM_SESSION_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{WINRM_AUTH_TIME}}` | DATETIME |  |
| `{{WINRM_ENDPOINT}}` | STRING |  |
| `{{WINRM_SOURCE}}` | STRING |  |
| `{{WINRM_ACCOUNT}}` | STRING |  |
| `{{WINRM_SHELL_KEY}}` | STRING |  |
| `{{WINRM_AUTH_RESULT}}` | STRING |  |
| `{{WINRM_PROVIDER_INSTANCE}}` | STRING |  |
| `{{WINRM_DESCENDANT_PROCESS_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{WINRM_PROCESS_TIME}}` | DATETIME |  |
| `{{WINRM_PROCESS_ENDPOINT}}` | STRING |  |
| `{{WINRM_ANCESTOR_INSTANCE}}` | STRING |  |
| `{{WINRM_PROCESS_INSTANCE}}` | STRING |  |
| `{{WINRM_PROCESS_IMAGE}}` | STRING |  |
| `{{WINRM_PROCESS_COMMAND}}` | STRING |  |
| `{{WINRM_PROCESS_USER}}` | STRING |  |
| `{{WINRM_PROCESS_OPERATION}}` | STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Port 5985/5986 or wsmprovhost naming alone cannot satisfy authentication and ancestry contracts.
- If a provider instance serves multiple simultaneous shells, bind a stricter proven shell/process relationship or hold the template; never attribute solely by host/time.
- Approved PowerShell remoting is common and should be compared with account/endpoint policy.
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
| positive | Successful shell S maps to provider instance P; its validated descendant starts within five minutes. | Returned. |
| negative | A local PowerShell start or unrelated provider instance occurs on the same host. | Excluded. |
| null | Shell-to-provider mapping is missing. | Excluded; no execution attribution. |
| edge | One provider serves two concurrent shells with different users and descendants cannot be assigned. | Binding fails acceptance until attribution ambiguity is resolved. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Microsoft WinRM authentication](https://learn.microsoft.com/en-us/windows/win32/winrm/authentication-for-remote-connections)
- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Cortex actor schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
