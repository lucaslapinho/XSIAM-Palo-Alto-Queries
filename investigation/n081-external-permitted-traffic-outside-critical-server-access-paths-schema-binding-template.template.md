# External Permitted Traffic Outside Critical Server Access Paths - Schema Binding Template

Finds policy-permitted traffic from authoritatively external zones to time-valid critical servers when the exact source/server/protocol/port path is absent from a complete approved-path inventory.

[Open query](n081-external-permitted-traffic-outside-critical-server-access-paths-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N081  
**Category:** Investigation / Critical Assets  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One firewall traffic record outside the reviewed allowed-path set for a valid critical server; policy permit is network evidence only.

## Data and setup

**Sources:** `{{INBOUND_FIREWALL_TRAFFIC}}`, `{{CRITICAL_SERVER_IP_INVENTORY}}`, `{{APPROVED_CRITICAL_ACCESS_PATHS}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{INBOUND_FIREWALL_TRAFFIC}}` | DATASET_IDENTIFIER |  |
| `{{INBOUND_TIME}}` | DATETIME |  |
| `{{INBOUND_UID}}` | STRING |  |
| `{{INBOUND_FIREWALL}}` | STRING |  |
| `{{INBOUND_SOURCE_ZONE}}` | STRING |  |
| `{{INBOUND_DEST_ZONE}}` | STRING |  |
| `{{INBOUND_SOURCE_IP}}` | STRING |  |
| `{{INBOUND_DEST_IP}}` | STRING |  |
| `{{INBOUND_TRANSLATED_DEST}}` | STRING |  |
| `{{INBOUND_DEST_PORT}}` | INTEGER |  |
| `{{INBOUND_PROTOCOL}}` | STRING |  |
| `{{INBOUND_ACTION_CLASS}}` | STRING |  |
| `{{INBOUND_RULE_ID}}` | STRING |  |
| `{{EXTERNAL_ZONE_KEYS}}` | QUOTED_STRING_LIST |  |
| `{{CRITICAL_SERVER_IP_INVENTORY}}` | DATASET_IDENTIFIER |  |
| `{{CRITICAL_SERVER_IP}}` | STRING |  |
| `{{CRITICAL_SERVER_ENDPOINT}}` | STRING |  |
| `{{CRITICAL_SERVER_NAME}}` | STRING |  |
| `{{CRITICAL_SERVER_FLAG}}` | BOOLEAN |  |
| `{{CRITICAL_SERVER_FROM}}` | DATETIME |  |
| `{{CRITICAL_SERVER_TO}}` | DATETIME |  |
| `{{APPROVED_PATH_BASELINE_COMPLETE}}` | BOOLEAN_LITERAL |  |
| `{{APPROVED_CRITICAL_ACCESS_PATHS}}` | DATASET_IDENTIFIER |  |
| `{{APPROVED_PATH_ID}}` | STRING |  |
| `{{APPROVED_PATH_ZONE_KEY}}` | STRING |  |
| `{{APPROVED_PATH_SOURCE_IP}}` | STRING |  |
| `{{APPROVED_PATH_ENDPOINT}}` | STRING |  |
| `{{APPROVED_PATH_PROTOCOL}}` | STRING |  |
| `{{APPROVED_PATH_PORT}}` | INTEGER |  |
| `{{APPROVED_PATH_FROM}}` | DATETIME |  |
| `{{APPROVED_PATH_TO}}` | DATETIME |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- An absent path is meaningful only after the explicit completeness gate is true; incomplete policy information must remain unknown.
- Exact-IP allowlist expansion must cover approved ranges and IPv6 correctly; do not expand huge ranges impractically or silently treat a range string as an IP.
- Pre/post-NAT address and port mapping must be verified. Ambiguous dynamic/shared IP ownership cannot establish a critical endpoint.
- Allowed traffic is not authentication, exploit success or unauthorized access without owner/context review.
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
| positive | Allowed traffic from an external zone reaches critical server H on post-NAT port 22; complete approved paths allow only source B and observed source is A. | Returned. |
| negative | The exact source/server/protocol/port path is approved at event time, or action is deny. | Excluded. |
| null | Criticality/ownership is unknown or approved-path completeness is false. | No outside-approved-path result. |
| edge | An approval expires at noon and the traffic is at exactly noon. | Expired approval does not match because validity end is exclusive. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [PAN-OS traffic log fields](https://docs.paloaltonetworks.com/ngfw/administration/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
