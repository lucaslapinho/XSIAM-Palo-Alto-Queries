# High-Cardinality DNS Name Candidates

Ranks endpoint and base-domain groups with many distinct and long DNS query names using tuned thresholds. Returns record types, responses and process context for investigation; these features alone do not prove tunneling or command and control.

[Open query](n060-high-cardinality-dns-name-candidates.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N060  
**Category:** Threat Hunting / DNS  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{DNS_QUERY_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MIN_DISTINCT_NAMES}}` | Positive INTEGER literal | Positive INTEGER literal: tuned distinct full-query-name count threshold per endpoint/base-domain/day. |
| `{{MIN_MEAN_LENGTH}}` | Positive numeric literal | Positive numeric literal: tuned mean DNS-query-name character length threshold. |
| `{{DNS_QUERY_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{DNS_TIME}}` | DATETIME | DATETIME: DNS query observation time. |
| `{{DNS_ENDPOINT_ID}}` | STRING | STRING: stable endpoint identity. |
| `{{DNS_PROCESS_INSTANCE}}` | STRING nullable | STRING nullable: initiating process instance, not PID alone. |
| `{{DNS_QUERY_NAME}}` | STRING | STRING: full DNS name; bind a lowercase, trailing-dot-normalized value. |
| `{{DNS_BASE_DOMAIN}}` | STRING | STRING: organizational/registrable domain from a validated public-suffix-aware resolver; not simply the last two labels. |
| `{{DNS_QUERY_TYPE}}` | STRING | STRING: DNS record type. |
| `{{DNS_RESPONSE_CODE}}` | STRING nullable | STRING nullable: actual response code; unknown must remain null. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- DNS source must disclose whether rows are individual queries or aggregates. Public suffix normalization and legitimate CDN/security-tool behavior materially change results.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: long, varied names under one verified base domain cross both thresholds. | See scenario |
| Planned test | Negative: repeated queries to one name do not inflate distinct-name count. | See scenario |
| Planned test | Null: missing base domain is excluded. | See scenario |
| Planned test | Edge: multi-label public suffixes must group under the correct registrable domain. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [DNS field family requires source-specific population validation](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [String length](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/len)
- [Public suffix boundaries for domain grouping](https://publicsuffix.org/list/)
