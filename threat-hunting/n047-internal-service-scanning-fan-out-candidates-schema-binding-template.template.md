# Internal Service Scanning Fan-Out Candidates - Schema Binding Template

Groups outgoing TCP/UDP endpoint-associated network observations into five-minute bins and selects high destination or port fan-out within verified internal address scope.

[Open query](n047-internal-service-scanning-fan-out-candidates-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N047  
**Category:** Threat Hunting / Discovery  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One endpoint/protocol/subtype/bin; distinct targets and ports resist repeated-row inflation while row counts remain explicitly telemetry volume.

## Data and setup

**Sources:** .

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{INTERNAL_DESTINATION_PREDICATE}}` | BOOLEAN_EXPRESSION |  |
| `{{MIN_TARGETS}}` | INTEGER_LITERAL |  |
| `{{MIN_PORTS}}` | INTEGER_LITERAL |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Native protocol is documented INTEGER but tenant Schema exposed ENUM; numeric 6/17 comparison remains compiler-unverified.
- No unique connection count is asserted. Approved scanner and management baselines must be reviewed before interpreting fan-out.
- Fixed bins can split a scan across boundaries; distributed and slow scans are out of scope.
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
| positive | One endpoint contacts 20 internal hosts on TCP 445 in five minutes; thresholds are 20. | One horizontal fan-out group. |
| negative | A workstation repeatedly connects to one internal host/port 1000 times. | No group when both fan-out thresholds are 20. |
| null | Direction or remote address is null. | Excluded, not classified as internal/outgoing. |
| edge | Ten targets before and ten after a bin boundary. | May be missed by design; verify an offset-window follow-up separately. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Cortex general event schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Cortex actor schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
- [MITRE Network Service Discovery](https://attack.mitre.org/techniques/T1046/)
