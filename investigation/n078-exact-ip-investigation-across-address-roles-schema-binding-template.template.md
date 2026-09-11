# Exact IP Investigation Across Address Roles - Schema Binding Template

Returns exact canonical IP matches across original, translated, DNS-answer and trusted proxy-client roles, preserving source provenance and separate match flags.

[Open query](n078-exact-ip-investigation-across-address-roles-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N078  
**Category:** Investigation / Network Activity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One source observation/address-answer row; a single event can have multiple matching role flags and DNS answers may expand rows.

## Data and setup

**Sources:** `{{IP_OBSERVATION_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{IP_OBSERVATION_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{IP_EVENT_TIME}}` | DATETIME |  |
| `{{IP_EVENT_UID}}` | STRING |  |
| `{{IP_SOURCE_SYSTEM}}` | STRING |  |
| `{{IP_EVIDENCE_KIND}}` | STRING |  |
| `{{IP_ENDPOINT}}` | STRING |  |
| `{{IP_ACCOUNT}}` | STRING |  |
| `{{IP_SOURCE}}` | STRING |  |
| `{{IP_DESTINATION}}` | STRING |  |
| `{{IP_NAT_SOURCE}}` | STRING |  |
| `{{IP_NAT_DESTINATION}}` | STRING |  |
| `{{IP_DNS_ANSWER}}` | STRING |  |
| `{{IP_PROXY_CLIENT}}` | STRING |  |
| `{{IP_SAFE_DETAIL}}` | STRING |  |
| `{{IP_TO_REVIEW}}` | QUOTED_IP_STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- A common-schema view must be bound and validated per included source; uncollected DNS/proxy branches remain explicit gaps, not fabricated fields.
- Shared, reassigned or translated IPs do not uniquely identify an endpoint/user.
- Do not deduplicate across providers by time/IP; these are independent evidence records.
- Canonical IPv4-mapped IPv6 handling must be deliberate and identical for the parameter and each field.
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
| positive | The target IP appears only in post-NAT destination and DNS-answer roles of separate events. | Both returned with the correct flags. |
| negative | The target string appears only inside a command or a longer IP-like string. | Excluded. |
| null | All IP fields are null. | Excluded without assigning UNKNOWN to the target. |
| edge | The same address is both source and destination in loopback or hairpin traffic. | Both flags set; no arbitrary single-role choice. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Cortex action schema](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [PAN-OS traffic log fields](https://docs.paloaltonetworks.com/ngfw/administration/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields)
- [Microsoft event 4624](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4624)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
