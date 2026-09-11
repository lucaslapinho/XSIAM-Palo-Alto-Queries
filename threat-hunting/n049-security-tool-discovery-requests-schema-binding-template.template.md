# Security Tool Discovery Requests - Schema Binding Template

Finds read-oriented queries whose explicit targets resolve to inventoried security products, preserving registry/service/process query distinctions.

[Open query](n049-security-tool-discovery-requests-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N049  
**Category:** Threat Hunting / Discovery  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One security-specific query and matching product target; inventory intervals must not overlap for the same key.

## Data and setup

**Sources:** `{{SECURITY_DISCOVERY_DATASET}}`, `{{SECURITY_PRODUCT_TARGETS}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SECURITY_DISCOVERY_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{SEC_QUERY_TIME}}` | DATETIME |  |
| `{{SEC_QUERY_ENDPOINT}}` | STRING |  |
| `{{SEC_QUERY_ACTOR}}` | STRING |  |
| `{{SEC_QUERY_PROCESS}}` | STRING |  |
| `{{SEC_QUERY_OPERATION}}` | STRING |  |
| `{{SEC_QUERY_TARGET_TYPE}}` | STRING |  |
| `{{SEC_QUERY_TARGET_KEY}}` | STRING |  |
| `{{SEC_QUERY_TEXT}}` | STRING |  |
| `{{SECURITY_PRODUCT_TARGETS}}` | DATASET_IDENTIFIER |  |
| `{{SEC_TARGET_TYPE}}` | STRING |  |
| `{{SEC_TARGET_KEY}}` | STRING |  |
| `{{SEC_PRODUCT}}` | STRING |  |
| `{{SEC_TARGET_FROM}}` | DATETIME |  |
| `{{SEC_TARGET_TO}}` | DATETIME |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Generic tasklist/sc/wmic execution, inventory possession and registry writes are insufficient evidence of a security-specific query.
- Help-desk and health checks are expected benign causes; resolve actual selectors before binding.
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
| positive | A registry read targets a known security-product configuration key at a valid time. | Returned with product context. |
| negative | The same key is modified, or a generic process list has no security selector. | Excluded. |
| null | Query target cannot be parsed or security inventory is missing. | No match; no absence-of-discovery conclusion. |
| edge | Two products intentionally share one target identity. | Multiple product context rows can occur; document inventory cardinality. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [MITRE security software discovery](https://attack.mitre.org/techniques/T1518/001/)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
