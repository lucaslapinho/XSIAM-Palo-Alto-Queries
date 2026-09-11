# Mass File Mutation Candidates by Process

Counts distinct files successfully written, renamed or deleted by one process in fixed five-minute windows. Supports investigation of bulk changes while distinguishing mutation volume from encryption, ransomware or destructive intent.

[Open query](n067-mass-file-mutation-candidates-by-process.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N067  
**Category:** Threat Hunting / File Activity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

One retained source event or explicitly described aggregate/correlation row.

## Data and setup

**Sources:** `{{FILE_MUTATION_EVENTS}}`.

**Lookback:** `1d unless explicitly stated in the body`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MIN_MODIFIED_FILES}}` | INTEGER literal greater than 1 | INTEGER literal greater than 1: per-process five-minute distinct-file threshold tuned to workload. |
| `{{FILE_MUTATION_EVENTS}}` | Dataset identifier | Dataset identifier: tenant-verified source with the row grain and collection requirements described below. |
| `{{MUTATION_TIME}}` | DATETIME | DATETIME: actual mutation time. |
| `{{MUTATION_ENDPOINT}}` | STRING | STRING: stable endpoint. |
| `{{MUTATION_PROCESS}}` | STRING | STRING: responsible process instance, not PID alone. |
| `{{MUTATION_OPERATION}}` | STRING | STRING: normalized write/rename/delete; exclude reads and opens. |
| `{{MUTATION_SUCCESS}}` | BOOLEAN | BOOLEAN: actual operation success; absent success semantics cannot be treated as true. |
| `{{MUTATION_FILE_KEY}}` | STRING | STRING: stable file identity when available; otherwise documented normalized-path identity with rename limits. |
| `{{MUTATION_OLD_PATH}}` | STRING nullable | STRING nullable: pre-rename path. |
| `{{MUTATION_NEW_PATH}}` | STRING nullable | STRING nullable: resulting path. |
| `{{MUTATION_USER}}` | STRING nullable | STRING nullable: responsible identity. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Path-based identities can double-count renames; verify the chosen file key. Encryption/content changes and ransom notes require independent evidence.
- Comparisons preserve case. Bind normalized enum values exactly as shown, normalize Windows case-insensitive paths consistently on both sides, and preserve case for Linux paths, cloud resource names and opaque identifiers. Correlation bounds use whole-second precision; subsecond boundary interpretation requires an explicit tenant check.
- Retention, access and missing collection can hide activity. Empty results are not proof of absence.
- A final result limit does not cap upstream work. Full-query compiler and execution acceptance remain NOT RUN.

**Benign matches:** Approved maintenance, support, deployments or legitimate workload behavior may meet the analytic conditions.

**Possible misses:** Missing collection, unmatched bindings, events outside the lookback, unmodeled variants and result caps can hide relevant activity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| Planned test | Positive: many distinct successful file mutations cross the threshold. | See scenario |
| Planned test | Negative: many reads or repeated writes to one file do not qualify. | See scenario |
| Planned test | Null: unknown success or file identity is excluded. | See scenario |
| Planned test | Edge: activity across a five-minute boundary produces separate groups. | See scenario |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [XSIAM source and preset boundaries](https://cortex-docs.paloaltonetworks.com/cortex-xsiam/reference-and-developer-docs/cortex-agentix-xql/get-started-with-xql/datasets-and-presets)
- [Explicit joins and aliases](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/join)
- [Grouping changes row cardinality](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/comp)
- [Filters and null handling](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/stages/filter)
- [Timestamp differences and units](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [File-operation field family and operation-specific coverage requirements](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
