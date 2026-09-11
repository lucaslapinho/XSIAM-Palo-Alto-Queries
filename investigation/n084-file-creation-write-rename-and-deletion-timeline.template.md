# File Creation Write Rename and Deletion Timeline

Returns validated create/write/rename/delete operations for an exact path on a selected endpoint, preserving both rename paths, producing process, actor and outcome.

[Open query](n084-file-creation-write-rename-and-deletion-timeline.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N084  
**Category:** Investigation / File Activity  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full path-based operation timeline template. Actor/process output provides the process pivot; operation coverage must be bound independently.

## Data and setup

**Sources:** `{{FILE_OPERATIONS_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{FILE_OPERATIONS_DATASET}}` | XQL dataset identifier | Actual read-only source for FILE_OPERATIONS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{FILE_OPERATIONS_EVENT_TIME}}` | DATETIME scalar expression | Observed file operation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_HOST_ID}}` | STRING scalar expression | Stable endpoint ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_OPERATION}}` | STRING scalar expression | CREATE, WRITE, RENAME, DELETE derived from verified event category/subtype Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_OLD_PATH}}` | STRING scalar expression | Canonical previous path for rename/delete when observed. Preserve case for case-sensitive namespaces; fold case only after verifying a case-insensitive Windows namespace and apply identical normalization to the selected path Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_NEW_PATH}}` | STRING scalar expression | Canonical current/destination path for create/write/rename. Preserve case for case-sensitive namespaces; fold case only after verifying a case-insensitive Windows namespace and apply identical normalization to the selected path Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_FILE_HASH}}` | STRING scalar expression | SHA-256 if observed; never infer after delete Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_PROCESS_ID}}` | STRING scalar expression | Actual producing process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_WRITER}}` | STRING scalar expression | Actual effective actor identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_OPERATIONS_OUTCOME}}` | STRING scalar expression | Original success/failure/result meaning Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{FILE_REVIEW_ENDPOINT}}` | STRING literal | Quoted stable endpoint ID |
| `{{FILE_REVIEW_EXACT_PATH}}` | STRING literal | Quoted exact path in the same bound canonicalization as old_path/new_path. Preserve case for case-sensitive namespaces; fold case only for verified case-insensitive Windows paths on all three sides |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Global case-sensitive comparison preserves Linux path distinctions. Case-insensitive Windows namespaces require explicit identical normalization in old_path, new_path and the selected path; never fold case for a case-sensitive directory.
- File reads are not included; deletion may legitimately lack hash/current path. Unknown outcomes remain original values.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | File is created, written, renamed away from the selected path and later deleted at that path | Each matching old/new-path operation is returned. |
| negative | Read event or similar substring path | Excluded. |
| null | Deletion has old_path but no new_path/hash | Deletion remains. |
| edge | Rename enters versus leaves the selected path; a Linux path differs only in case | Rename matches through new_path or old_path respectively; different-case Linux path does not match. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for OP-014](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for OP-014](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for OP-014](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for OP-014](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
