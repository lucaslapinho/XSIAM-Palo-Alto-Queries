# Inbound Transfers with Attributed Output Files

Correlates successful inbound transfer observations with a candidate output file written by the same process on the same endpoint within ten minutes. Returns URL, path and available content hash for subsequent reputation and execution pivots.

[Open query](n062-inbound-transfers-with-attributed-output-files.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N062  
**Category:** Threat Hunting / Tool Transfer  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{CONFIRMED_TRANSFER_EVENTS}}`, `{{FILE_CREATION_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{CONFIRMED_TRANSFER_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{TRANSFER_TIME}}` | DATETIME | DATETIME: transfer operation time. |
| `{{TRANSFER_ENDPOINT}}` | STRING | STRING: endpoint identity. |
| `{{TRANSFER_PROCESS}}` | STRING | STRING: owning process instance. |
| `{{TRANSFER_URL}}` | STRING | STRING: observed requested URL, scrubbed of tokens if necessary. |
| `{{TRANSFER_DIRECTION}}` | STRING | STRING: normalized inbound/outbound; inbound means downloaded to endpoint. |
| `{{TRANSFER_SUCCESS}}` | BOOLEAN | BOOLEAN: transfer outcome, not process-start success. |
| `{{TRANSFER_OUTPUT_PATH}}` | STRING | STRING: normalized destination path when attributable to this operation. |
| `{{FILE_CREATION_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{TRANSFER_FILE_TIME}}` | DATETIME | DATETIME: observed file creation/write completion. |
| `{{TRANSFER_FILE_ENDPOINT}}` | STRING | STRING: matching endpoint identity. |
| `{{TRANSFER_WRITER_PROCESS}}` | STRING | STRING: exact responsible process instance. |
| `{{TRANSFER_FILE_PATH}}` | STRING | STRING: same normalized path namespace as output_path; case rules must follow the source OS. |
| `{{TRANSFER_FILE_SHA256}}` | STRING nullable | STRING nullable: resulting content SHA-256; absence is not a mismatch. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Downloads that delegate writing to another process or use renamed temporary files can be missed; output-path normalization must not merge unrelated OS paths.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: transfer and same-process output path within ten minutes correlate. | See scenario |
| Planned test | Negative: another process writing the same filename does not correlate. | See scenario |
| Planned test | Null: missing output path cannot support the join. | See scenario |
| Planned test | Edge: a later matching process launch is a separate pivot, not implicitly claimed here. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Documented file and process artifact fields motivate verified source mappings](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
