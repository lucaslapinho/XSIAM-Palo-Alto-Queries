# Office Command Shells and Subsequent Activity

Preserves verified Office-to-cmd process-start anchors and a ten-minute downstream command, download, write and network timeline after ancestry/source binding. Downloads require actual download evidence; a connection alone is not a download.

[Open query](n027-office-command-shells-and-subsequent-activity.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N027  
**Category:** Threat Hunting / Execution  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full shell-plus-downstream workflow template. The ancestry bridge and activity kind mappings must cover the agreed descendant depth; no macro/phishing or successful-download inference from ancestry.

## Data and setup

**Sources:** `xdr_data`, `{{OFFICE_DESCENDANT_ACTIVITY_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{VERIFIED_DIRECT_PARENT_IMAGE}}` | STRING scalar expression | Immediate parent image from verified process relationship evidence, not an assumed actor/causality owner |
| `{{OFFICE_DESCENDANT_ACTIVITY_DATASET}}` | XQL dataset identifier | Actual read-only source for OFFICE_DESCENDANT_ACTIVITY. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_HOST}}` | STRING scalar expression | Stable endpoint ID in the same namespace as the anchor Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_ROOT}}` | STRING scalar expression | Root process instance for this bounded ancestry relation. Must relate the selected cmd process and its descendants to the same root with a documented maximum depth and stable IDs. A native actor or causality-owner field may only be used if that exact relationship is verified; otherwise bind a reviewed ancestry bridge/view. Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_TIME}}` | DATETIME scalar expression | Original observed activity time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_KIND}}` | STRING scalar expression | Explicit normalized activity kind derived from verified event type/subtype, not a name-only inference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_PROCESS}}` | STRING scalar expression | Process instance actually producing the activity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_TEXT}}` | STRING scalar expression | Activity detail: actual command, downloaded object/URL or file path as appropriate; retain the original event reference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{OFFICE_DESCENDANT_ACTIVITY_CTX_OUTCOME}}` | STRING scalar expression | Actual operation outcome; UNKNOWN when absent, never success by default Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Office-launched shells can be authorized. Descendant events outside the ten-minute window or retained ancestry depth are excluded.
- One anchor can have many context rows; cross-endpoint or reused numeric PID matches are disallowed.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Office directly creates cmd P1; a verified descendant writes a file 30 seconds later | Anchor and FILE_WRITE evidence rows. |
| negative | cmd has an unrelated direct parent or a same-PID process on another endpoint | No Office anchor or false cross-host context. |
| null | Valid anchor with missing descendant telemetry | Anchor remains; no invented downstream success. |
| edge | Context exactly 600 seconds after the anchor, and a second event at 601 | Only the 600-second context is admitted. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-002](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-002](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-002](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-002](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-002](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-002](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-002](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-002](https://attack.mitre.org/techniques/T1059/003/)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
