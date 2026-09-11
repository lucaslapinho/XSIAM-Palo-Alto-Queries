# Run Key and Startup Artifact Mutations

Combines successful Run/RunOnce value mutations with configured Startup-folder file mutations, retaining writer identity and the configured execution target when observed.

[Open query](n033-run-key-and-startup-artifact-mutations.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N033  
**Category:** Threat Hunting / Persistence  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Both registry and startup branches are present. This describes configuration changes, not proven logon execution.

## Data and setup

**Sources:** `{{RUN_REGISTRY_DATASET}}`, `{{STARTUP_FILES_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{RUN_REGISTRY_DATASET}}` | XQL dataset identifier | Actual read-only source for RUN_REGISTRY. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{RUN_REGISTRY_EVENT_TIME}}` | DATETIME scalar expression | Registry operation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_HOST_ID}}` | STRING scalar expression | Stable host identifier Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_OPERATION}}` | STRING scalar expression | Normalized CREATE_VALUE, SET_VALUE or RENAME_VALUE; exclude reads Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_SUCCESSFUL}}` | BOOLEAN scalar expression | Verified successful mutation result Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_ARTIFACT_PATH}}` | STRING scalar expression | Canonical registry key path, preserving hive and user scope Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_ARTIFACT_NAME}}` | STRING scalar expression | Registry value name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_EXECUTION_TARGET}}` | STRING scalar expression | Written value data, including configured command Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_WRITER_PROCESS}}` | STRING scalar expression | Actual writer process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{RUN_REGISTRY_WRITER_USER}}` | STRING scalar expression | Actual effective writer identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_DATASET}}` | XQL dataset identifier | Actual read-only source for STARTUP_FILES. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{STARTUP_FILES_EVENT_TIME}}` | DATETIME scalar expression | File operation time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_HOST_ID}}` | STRING scalar expression | Stable host identifier Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_OPERATION}}` | STRING scalar expression | Normalized CREATE, WRITE or RENAME including atomic replacement Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_SUCCESSFUL}}` | BOOLEAN scalar expression | Verified successful mutation Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_ARTIFACT_PATH}}` | STRING scalar expression | Resolved configured startup directory plus artifact path; include custom redirected startup folders Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_ARTIFACT_NAME}}` | STRING scalar expression | File name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_EXECUTION_TARGET}}` | STRING scalar expression | Verified executable target from shortcut/content if collected; null rather than inferring from a .lnk name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_WRITER_PROCESS}}` | STRING scalar expression | Actual writer process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_WRITER_USER}}` | STRING scalar expression | Effective writer identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{STARTUP_FILES_IS_STARTUP_LOCATION}}` | BOOLEAN scalar expression | Exact membership in current per-user/machine configured Startup paths, not a substring-only classification Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Bind operation results and resolve hives/user paths and redirected startup directories. Reads are excluded.
- Executable targets from shortcuts require collected/parsing evidence; null targets are retained as unknown.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Run value SET_VALUE succeeds; separately a shortcut is created in an actual configured Startup folder | Both mutation kinds appear. |
| negative | Registry/file read or failed write | Excluded. |
| null | Startup shortcut target is unavailable but creation/path membership is verified | Mutation remains with null execution target. |
| edge | RunOnce key or custom redirected user Startup directory | Included after canonical binding; unrelated RunBackup key excluded. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-008](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-008](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-008](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-008](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-008](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-008](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-008](https://attack.mitre.org/techniques/T1547/001/)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
