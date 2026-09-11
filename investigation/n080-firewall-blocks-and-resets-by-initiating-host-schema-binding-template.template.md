# Firewall Blocks and Resets by Initiating Host - Schema Binding Template

Aggregates verified firewall deny/drop/reset log records by time-valid initiating-host attribution, rule and action, keeping resets separate from policy blocks and unresolved IP attribution explicit.

[Open query](n080-firewall-blocks-and-resets-by-initiating-host-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N080  
**Category:** Investigation / Firewall  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One initiating-host/source-IP/firewall/rule/application/protocol/action group; metric is unique source log-record count after duplicate-delivery removal.

## Data and setup

**Sources:** `{{FIREWALL_TRAFFIC_DATASET}}`, `{{SOURCE_IP_OWNERSHIP}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{FIREWALL_TRAFFIC_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{FW_TIME}}` | DATETIME |  |
| `{{FW_EVENT_UID}}` | STRING |  |
| `{{FW_DEVICE}}` | STRING |  |
| `{{FW_CLIENT_IP}}` | STRING |  |
| `{{FW_SERVER_IP}}` | STRING |  |
| `{{FW_SERVER_PORT}}` | INTEGER |  |
| `{{FW_PROTOCOL}}` | STRING |  |
| `{{FW_ACTION_RAW}}` | STRING |  |
| `{{FW_ACTION_CLASS}}` | STRING |  |
| `{{FW_RULE_ID}}` | STRING |  |
| `{{FW_APPLICATION}}` | STRING |  |
| `{{SOURCE_IP_OWNERSHIP}}` | DATASET_IDENTIFIER |  |
| `{{OWNER_IP}}` | STRING |  |
| `{{OWNER_ENDPOINT}}` | STRING |  |
| `{{OWNER_HOSTNAME}}` | STRING |  |
| `{{OWNER_FROM}}` | DATETIME |  |
| `{{OWNER_TO}}` | DATETIME |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Firewall reset meanings are vendor-specific; reset records remain RESET rather than automatic policy-deny evidence.
- Source IP ownership must match the correct NAT/address boundary. Ambiguous mappings must not produce asserted host identity.
- Log repeat counters/session start/end records have different cardinality from log rows; this query does not count unique blocked sessions.
- Unresolved IP groups are not verified hosts.
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
| positive | Three unique deny records map to H and two reset_client records map to the same H/rule. | Separate BLOCK count 3 and RESET count 2 groups. |
| negative | Allowed traffic or endpoint network_success=false lacks a firewall denial record. | Excluded. |
| null | Valid block record has no time-valid ownership mapping. | Retained under UNRESOLVED_IP with no invented hostname. |
| edge | Same firewall log is delivered twice, and two hosts sequentially own its source IP. | Duplicate delivery is removed; event-time ownership assigns only the valid host. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [PAN-OS traffic log fields](https://docs.paloaltonetworks.com/ngfw/administration/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
