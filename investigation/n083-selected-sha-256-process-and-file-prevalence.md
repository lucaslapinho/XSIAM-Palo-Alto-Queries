# Selected SHA-256 Process and File Prevalence

Summarizes a selected SHA-256 across process starts and file-event observations over 30 days, retaining separate evidence-family counts, distinct endpoints, paths/users and first/last observations.

[Open query](n083-selected-sha-256-process-and-file-prevalence.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N083  
**Category:** Investigation / File Identity  
**Status:** Query candidate — tenant validation pending  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Both process and file branches are implemented with documented SHA-256 fields. Family separation prevents a combined event count from masquerading as unique execution prevalence.

## Data and setup

**Sources:** `xdr_data`.

**Lookback:** `30d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `sha256_to_review` | STRING value | Replace SHA256_TO_REVIEW with a 64-hex SHA-256 string; the unchanged sentinel matches no valid hash. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- File events are hash-bearing observations, not a complete installed/current-file inventory; operations may repeat.
- Counts are retained rows per family. First/last are observation bounds, not first-ever use; array contexts can be large.
- FILE symbolic acceptance and all projected field population remain tenant-unverified.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Same selected hash appears in process starts on two endpoints and file events on three | Separate family rows with prevalence 2 and 3. |
| negative | Other hashes, malformed hashes and empty endpoint IDs | Excluded. |
| null | File event lacks SHA-256 or process account | Null hash excluded; null account does not remove valid hash evidence. |
| edge | Same endpoint repeats a hash across paths and many operations | Event count increases; distinct endpoint count does not. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for OP-013](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for OP-013](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for OP-013](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for OP-013](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for OP-013](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
