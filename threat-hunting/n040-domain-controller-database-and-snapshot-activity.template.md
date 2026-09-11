# Domain Controller Database and Snapshot Activity

Builds a domain-controller timeline of actual NTDS path access/copy, raw reads of its volume, and relevant snapshot/database utility starts with outcome and backup context.

[Open query](n040-domain-controller-database-and-snapshot-activity.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N040  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full access/copy/raw-volume/tooling review template. Each evidence category stays distinct; no filename/tool match is promoted to confirmed database extraction.

## Data and setup

**Sources:** `{{DIRECTORY_DATABASE_ACTIVITY_DATASET}}`, `{{DOMAIN_CONTROLLER_DATABASES_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{DIRECTORY_DATABASE_ACTIVITY_DATASET}}` | XQL dataset identifier | Actual read-only source for DIRECTORY_DATABASE_ACTIVITY. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{DIRECTORY_DATABASE_ACTIVITY_EVENT_TIME}}` | DATETIME scalar expression | Observed activity time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_HOST_ID}}` | STRING scalar expression | Stable endpoint identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_OPERATION}}` | STRING scalar expression | Normalized FILE_READ, FILE_COPY, RAW_VOLUME_READ or PROCESS_START based on real operation evidence Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_OBJECT_PATH}}` | STRING scalar expression | Actual file path involved in read/copy; canonical Windows path Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_VOLUME_PATH}}` | STRING scalar expression | Canonical target volume for raw-volume reads Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_DESTINATION_PATH}}` | STRING scalar expression | Observed copy destination when explicitly recorded; null otherwise Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_PROCESS_NAME}}` | STRING scalar expression | Producing/started process basename Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_PROCESS_ID}}` | STRING scalar expression | Stable producing process instance Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_COMMAND_LINE}}` | STRING scalar expression | Observed process command line Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_SUBJECT}}` | STRING scalar expression | Actual actor identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_OUTCOME}}` | STRING scalar expression | Operation outcome Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DIRECTORY_DATABASE_ACTIVITY_BACKUP_CONTEXT}}` | STRING scalar expression | Time/process-scoped approved backup/recovery reference if established; UNKNOWN otherwise Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_CONTROLLER_DATABASES_DATASET}}` | XQL dataset identifier | Actual read-only source for DOMAIN_CONTROLLER_DATABASES. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{DOMAIN_CONTROLLER_DATABASES_DC_HOST}}` | STRING scalar expression | Authoritative DC endpoint identity; one applicable row per actual database path/volume Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_CONTROLLER_DATABASES_DATABASE_PATH}}` | STRING scalar expression | Actual NTDS database path, not assumed default Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_CONTROLLER_DATABASES_DATABASE_VOLUME}}` | STRING scalar expression | Actual database volume Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{DOMAIN_CONTROLLER_DATABASES_DOMAIN_NAME}}` | STRING scalar expression | Authoritative AD domain Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Actual database path/DC inventory and file-read or raw-read telemetry are required. Ordinary file-create telemetry is not a substitute for reads.
- A raw volume read can target unrelated bytes; utility starts can be legitimate backup/recovery.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | A verified DC database path is read, then copied to a recorded destination | Both actual operations appear with producing process/outcome. |
| negative | Same filename on a non-DC or unrelated file read on a DC | Excluded. |
| null | Raw-volume event has no destination file | Raw-volume lead retained without invented copy destination. |
| edge | DC uses a nondefault NTDS path or separate volume | Actual inventory path/volume is used; no default-path blind spot. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-015](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-015](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-015](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-015](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-015](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-015](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4663)
- [Official source for TH-015](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-015](https://attack.mitre.org/techniques/T1003/003/)
