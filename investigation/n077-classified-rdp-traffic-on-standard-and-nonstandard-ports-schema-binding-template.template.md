# Classified RDP Traffic on Standard and Nonstandard Ports - Schema Binding Template

Shows RDP-classified network observations on any valid destination port and attaches client-process context only through a verified stable process-instance relationship.

[Open query](n077-classified-rdp-traffic-on-standard-and-nonstandard-ports-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N077  
**Category:** Investigation / RDP Network Activity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One RDP-classified network record, optionally associated with a process start; includes standard and nonstandard ports.

## Data and setup

**Sources:** `{{RDP_NETWORK_CLASSIFICATION_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{RDP_NETWORK_CLASSIFICATION_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{RDP_FLOW_TIME}}` | DATETIME |  |
| `{{RDP_FLOW_UID}}` | STRING |  |
| `{{RDP_CLIENT_ENDPOINT}}` | STRING |  |
| `{{RDP_FLOW_SOURCE_IP}}` | STRING |  |
| `{{RDP_FLOW_SOURCE_PORT}}` | INTEGER |  |
| `{{RDP_FLOW_DEST_IP}}` | STRING |  |
| `{{RDP_FLOW_DEST_PORT}}` | INTEGER |  |
| `{{RDP_FLOW_PROTOCOL}}` | INTEGER |  |
| `{{RDP_FLOW_APPLICATION}}` | STRING |  |
| `{{RDP_FLOW_ACTION}}` | STRING |  |
| `{{RDP_FLOW_PROCESS_INSTANCE}}` | STRING |  |
| `{{RDP_APPLICATION_VALUES}}` | QUOTED_STRING_LIST |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Client starts without traffic are outside this traffic-driven view and remain available through process timelines.
- Application classification is not authentication success. Alternative or renamed clients can still appear when network classification is available.
- Do not invent a firewall process-instance field or correlate by host/time alone; missing linkage retains network evidence with null process context.
- NAT translation and sensor-boundary mapping are required before claiming endpoint identity.
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
| positive | Classifier identifies RDP on TCP destination 4444 and a verified process instance matches its client start. | NONSTANDARD_PORT with client context. |
| negative | Traffic on 3389 is classified as another protocol, or only mstsc starts without traffic. | Excluded from this classified-traffic view. |
| null | RDP traffic has no verified process-instance relation. | Network record remains with null client process fields. |
| edge | A client process started before the one-day window but traffic occurs inside it. | Network record remains; missing process-start context is not proof of an unknown client. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [PAN-OS traffic log fields](https://docs.paloaltonetworks.com/ngfw/administration/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields)
- [Cortex general event schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
- [Official XSIAM process-start example](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/detect-investigate-and-respond-to-threats/threat-management/detection-rules/what-are-detection-rules/whats-a-bioc/create-a-bioc-rule)
