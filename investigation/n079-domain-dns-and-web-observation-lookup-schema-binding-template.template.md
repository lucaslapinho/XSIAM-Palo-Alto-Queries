# Domain DNS and Web Observation Lookup - Schema Binding Template

Looks up an exact normalized domain and optionally its true subdomains across DNS questions, DNS responses and web requests, preserving each evidence kind and outcome.

[Open query](n079-domain-dns-and-web-observation-lookup-schema-binding-template.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N079  
**Category:** Investigation / DNS and Web  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One source event for a matching DNS/web domain; arrays retain response answers without treating them as subsequent connections.

## Data and setup

**Sources:** `{{DOMAIN_OBSERVATION_DATASET}}`.

**Lookback:** `1d unless explicitly expanded in body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{DOMAIN_OBSERVATION_DATASET}}` | DATASET_IDENTIFIER |  |
| `{{DOMAIN_EVENT_TIME}}` | DATETIME |  |
| `{{DOMAIN_EVENT_UID}}` | STRING |  |
| `{{DOMAIN_SOURCE_SYSTEM}}` | STRING |  |
| `{{DOMAIN_EVIDENCE_KIND}}` | STRING |  |
| `{{DOMAIN_CANONICAL_NAME}}` | STRING |  |
| `{{DOMAIN_RAW_NAME}}` | STRING |  |
| `{{DOMAIN_CLIENT_KEY}}` | STRING |  |
| `{{DOMAIN_DNS_ANSWERS}}` | STRING_ARRAY |  |
| `{{DOMAIN_RESULT}}` | STRING |  |
| `{{DOMAIN_SAFE_URL}}` | STRING |  |
| `{{DOMAIN_BOUNDARY_RE2}}` | QUOTED_RE2_STRING |  |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- DNS response and web/proxy collection are required separately; questions alone do not satisfy those branches.
- IDN/A-label and root-dot normalization must be validated; no broad substring matching.
- Encrypted/unobserved DNS and direct IP web requests can be absent; a DNS resolution does not establish later access.
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
| positive | Pattern for example.com sees EXAMPLE.COM., sub.example.com DNS response and a matching web host after normalization. | All three evidence kinds can return with separate meanings. |
| negative | evil-example.com and example.com.attacker.test are observed. | Excluded by domain-label boundaries. |
| null | DNS question has no answers or response code. | Question remains with null response fields. |
| edge | Unicode IDN and equivalent A-label inputs occur. | They match only after the declared tested IDN normalization; malformed names stay null. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [RFC 1035 DNS messages](https://datatracker.ietf.org/doc/html/rfc1035)
- [RFC 4343 DNS case handling](https://datatracker.ietf.org/doc/html/rfc4343)
- [PAN-OS traffic log fields](https://docs.paloaltonetworks.com/ngfw/administration/monitoring/use-syslog-for-monitoring/syslog-field-descriptions/traffic-log-fields)
- [Cortex XSIAM comp](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/comp?contentId=6TGIbW601nVvh2ycedN_hw)
- [Cortex XSIAM join](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/join?contentId=MyWFbdks6xgkqm_1lNkfGg)
- [Cortex XSIAM bin](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/bin?contentId=CU_u_bTkg_MICr5pUKivwg)
- [Cortex XSIAM sort](https://docs-cortex.paloaltonetworks.com/r/Cortex-XSIAM/Cortex-XSIAM-3.x-Documentation/sort?contentId=a9tB71nqIWhA~Adcae6R7w)
