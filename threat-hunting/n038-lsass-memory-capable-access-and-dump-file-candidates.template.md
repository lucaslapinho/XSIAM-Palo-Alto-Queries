# LSASS Memory-capable Access and Dump-file Candidates

Reviews non-baselined or unassessed processes with observed LSASS memory-capable access and correlates subsequent dump-file candidates by source process and endpoint within ten minutes.

[Open query](n038-lsass-memory-capable-access-and-dump-file-candidates.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N038  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Access-right evidence is mandatory; source/target process names alone cannot satisfy the query. Dump-file kind requires artifact/operation evidence and remains a candidate unless contents are validated.

## Data and setup

**Sources:** `{{ACCESS_FOLLOWON_FILES_DATASET}}`, `{{LSASS_ACCESS_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{LSASS_ACCESS_DATASET}}` | XQL dataset identifier | Actual read-only source for LSASS_ACCESS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{LSASS_ACCESS_ANCHOR_TIME}}` | DATETIME scalar expression | Target process access time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_ENDPOINT_ID}}` | STRING scalar expression | Stable endpoint identifier Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_ANCHOR_PROCESS_ID}}` | STRING scalar expression | Source accessing process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_ANCHOR_COMMAND}}` | STRING scalar expression | Accessing process image/path/command context Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_ANCHOR_ACTOR}}` | STRING scalar expression | Accessing account Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_TARGET_IMAGE}}` | STRING scalar expression | Verified target process basename Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_TARGET_PROCESS_ID}}` | STRING scalar expression | Target LSASS process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_ACCESS_RIGHTS}}` | STRING scalar expression | Actual requested/granted access mask or equivalent sensor signal Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_MEMORY_READ_CAPABLE}}` | BOOLEAN scalar expression | Granted PROCESS_VM_READ capability or documented equivalent memory-access signal; distinguish requested from granted and do not label a handle-open as completed dumping Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_ACCESS_RESULT}}` | STRING scalar expression | Actual access outcome Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{LSASS_ACCESS_EXPECTED_ACCESSOR}}` | BOOLEAN scalar expression | Scoped approved security/diagnostic accessor baseline match; null when unassessed Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_DATASET}}` | XQL dataset identifier | Actual read-only source for ACCESS_FOLLOWON_FILES. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{ACCESS_FOLLOWON_FILES_CTX_HOST}}` | STRING scalar expression | Stable endpoint ID in the same namespace as the anchor Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_CTX_ROOT}}` | STRING scalar expression | Root process instance for this bounded ancestry relation. The root must be the source process that accessed LSASS; descendant widening requires a separately verified relation. A native actor or causality-owner field may only be used if that exact relationship is verified; otherwise bind a reviewed ancestry bridge/view. Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_CTX_TIME}}` | DATETIME scalar expression | Original observed activity time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_CTX_KIND}}` | STRING scalar expression | Explicit normalized activity kind derived from verified event type/subtype, not a name-only inference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_CTX_PROCESS}}` | STRING scalar expression | Process instance actually producing the activity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_CTX_TEXT}}` | STRING scalar expression | Activity detail: actual command, downloaded object/URL or file path as appropriate; retain the original event reference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{ACCESS_FOLLOWON_FILES_CTX_OUTCOME}}` | STRING scalar expression | Actual operation outcome; UNKNOWN when absent, never success by default Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- ProcessAccess/handle capability does not prove that memory was read or dumped. Security tools can perform the same access.
- The source must carry rights, target identity and outcome. Suppressing approved accessors requires a reviewed complete baseline; unknown accessors remain visible.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Unapproved source receives memory-read-capable LSASS access, then writes a dump candidate 15 seconds later | Access anchor and subsequent dump row. |
| negative | Only query-information rights or source targets a different process | Excluded. |
| null | Approval baseline status missing, but access target/capability verified | Retained as unassessed access. |
| edge | Dump on another host or before access | No follow-on association. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-013](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-013](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-013](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-013](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-013](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-013](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-013](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-013](https://learn.microsoft.com/en-us/windows/win32/procthread/process-security-and-access-rights)
- [Official source for TH-013](https://attack.mitre.org/techniques/T1003/001/)
