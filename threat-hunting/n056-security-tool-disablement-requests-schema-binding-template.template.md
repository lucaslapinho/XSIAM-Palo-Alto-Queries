# Security Tool Disablement Requests - Schema Binding Template

Finds explicit stop, deletion, uninstall or protection-disable requests against time-valid inventoried security targets, preserving action outcome without asserting effective disablement.

[Open query](n056-security-tool-disablement-requests-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N056  
**Category:** Threat Hunting / Defense Impairment  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One security-targeted action attempt and valid inventory target; no state-change success inferred.

## Data and setup

**Sources:** `{{SECURITY_CONTROL_ACTION_DATASET}}`, `{{ENDPOINT_SECURITY_TARGET_INVENTORY}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SECURITY_CONTROL_ACTION_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{CONTROL_ACTION_TIME}}` | DATETIME |  |
| `{{CONTROL_ACTION_UID}}` | STRING |  |
| `{{CONTROL_ACTION_ENDPOINT}}` | STRING |  |
| `{{CONTROL_ACTION_ACTOR}}` | STRING |  |
| `{{CONTROL_ACTION_OPERATION}}` | STRING |  |
| `{{CONTROL_TARGET_TYPE}}` | STRING |  |
| `{{CONTROL_TARGET_KEY}}` | STRING |  |
| `{{CONTROL_COMMAND_CONTEXT}}` | STRING |  |
| `{{CONTROL_REPORTED_RESULT}}` | STRING |  |
| `{{ENDPOINT_SECURITY_TARGET_INVENTORY}}` | DATASET_IDENTIFIER |  |
| `{{CONTROL_INV_ENDPOINT}}` | STRING |  |
| `{{CONTROL_INV_TYPE}}` | STRING |  |
| `{{CONTROL_INV_KEY}}` | STRING |  |
| `{{CONTROL_INV_PRODUCT}}` | STRING |  |
| `{{CONTROL_INV_FROM}}` | DATETIME |  |
| `{{CONTROL_INV_TO}}` | DATETIME |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Maintenance, upgrades and approved troubleshooting can legitimately match.
- Process launch/accepted job does not prove service stop, uninstall completion or impaired protection. Pivot to state/configuration evidence.
- General service operations are excluded unless the exact endpoint target is inventoried as security software.
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
| positive | A stop_service request explicitly targets a security service installed on H at the request time. | Returned with reported result, including failures. |
| negative | A status query or stop of an unrelated application service occurs. | Excluded. |
| null | Target cannot be parsed or endpoint security inventory is absent. | Excluded; coverage gap remains. |
| edge | A security package was removed from inventory before a later unrelated package reuses its name. | Expired inventory cannot label the later target as security software. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [MITRE Disable or Modify Tools](https://attack.mitre.org/techniques/T1685/)
- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
