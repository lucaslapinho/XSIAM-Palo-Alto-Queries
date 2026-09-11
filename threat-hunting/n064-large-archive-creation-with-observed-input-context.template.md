# Large Archive Creation with Observed Input Context

Links a process observed accessing many distinct input files to a sufficiently large archive it creates, preserving sensitive-data classification context. Supports staging investigation and later transfer pivots without equating an archiver command with a completed archive.

[Open query](n064-large-archive-creation-with-observed-input-context.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N064  
**Category:** Threat Hunting / Data Staging  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{ARCHIVE_INPUT_OBSERVATIONS}}`, `{{ARCHIVE_OUTPUT_CREATIONS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MIN_INPUT_FILES}}` | Positive INTEGER literal | Positive INTEGER literal: tuned distinct observed input-file count. |
| `{{MIN_ARCHIVE_BYTES}}` | Positive INTEGER literal | Positive INTEGER literal: minimum created archive size in bytes. |
| `{{ARCHIVE_INPUT_OBSERVATIONS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{ARCHIVE_INPUT_TIME}}` | DATETIME | DATETIME: observed input access timestamp. |
| `{{ARCHIVE_ENDPOINT}}` | STRING | STRING: endpoint identity. |
| `{{ARCHIVE_PROCESS}}` | STRING | STRING: archive-producing process instance. |
| `{{ARCHIVE_INPUT_PATH}}` | STRING | STRING: observed input path, not merely a command-line mention. |
| `{{ARCHIVE_INPUT_SENSITIVE}}` | BOOLEAN | BOOLEAN: true only from authoritative data/path classification. |
| `{{ARCHIVE_INPUT_OPERATION}}` | STRING | STRING: unique archive operation identity, linked independently to both input observations and the output file event; never an inferred name-only relationship. |
| `{{ARCHIVE_OUTPUT_PATH}}` | STRING | STRING: exact filesystem output path; preserve case for case-sensitive filesystems, normalize only within a verified case-insensitive namespace on both sides. |
| `{{ARCHIVE_OUTPUT_CREATIONS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{ARCHIVE_CREATED_OPERATION}}` | STRING | STRING: independently linked archive operation identity, matching ARCHIVE_INPUT_OPERATION. |
| `{{ARCHIVE_CREATED_TIME}}` | DATETIME | DATETIME: archive file creation/write completion. |
| `{{ARCHIVE_CREATED_ENDPOINT}}` | STRING | STRING: matching endpoint. |
| `{{ARCHIVE_CREATED_PROCESS}}` | STRING | STRING: actual writer process instance. |
| `{{ARCHIVE_CREATED_PATH}}` | STRING | STRING: same normalized filesystem path as ARCHIVE_OUTPUT_PATH. |
| `{{ARCHIVE_CREATED_BYTES}}` | INTEGER | INTEGER: file size in bytes, not network volume. |
| `{{ARCHIVE_CREATED_SHA256}}` | STRING nullable | STRING nullable: archive content SHA-256. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Archive identification and complete input access telemetry must be established. Legitimate build/backup workloads can meet both thresholds.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: observed inputs plus matching large output satisfy thresholds. | See scenario |
| Planned test | Negative: command mention without observed output does not match. | See scenario |
| Planned test | Null: absent size cannot meet the volume threshold. | See scenario |
| Planned test | Edge: repeated reads of one file do not inflate distinct-input count. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
