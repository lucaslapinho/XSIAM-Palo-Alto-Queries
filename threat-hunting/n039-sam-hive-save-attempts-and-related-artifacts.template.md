# SAM Hive Save Attempts and Related Artifacts

Preserves parsed reg.exe SAM hive-save attempts and correlates SYSTEM hive access, save outcomes and requested-output file creation/write within 30 minutes.

[Open query](n039-sam-hive-save-attempts-and-related-artifacts.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N039  
**Category:** Threat Hunting / Credential Access  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full attempt/outcome/artifact template for the explicit reg-save core. Other export utilities or raw hive copying require an additional bound operation source, not a false claim of comprehensive coverage.

## Data and setup

**Sources:** `xdr_data`, `{{HIVE_EXPORT_CONTEXT_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{REG_SAVE_OPERATION}}` | STRING scalar expression | Validated argv operation parsed from the retained anchor_command alias; SAVE only for the core SAM hive-save attempt |
| `{{REG_SOURCE_HIVE}}` | STRING scalar expression | Canonical source hive parsed from retained anchor_command; map HKEY_LOCAL_MACHINE and HKLM consistently without substring matches |
| `{{REG_OUTPUT_PATH}}` | STRING scalar expression | Destination file path parsed from retained anchor_command; preserve null for invalid/unparseable forms |
| `{{HIVE_EXPORT_CONTEXT_DATASET}}` | XQL dataset identifier | Actual read-only source for HIVE_EXPORT_CONTEXT. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{HIVE_EXPORT_CONTEXT_CTX_HOST}}` | STRING scalar expression | Stable endpoint ID in the same namespace as the anchor Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{HIVE_EXPORT_CONTEXT_CTX_ROOT}}` | STRING scalar expression | Root process instance for this bounded ancestry relation. Relate registry/file events to the SAM-save process or a verified same-operation ancestry root; host co-occurrence alone is insufficient. A native actor or causality-owner field may only be used if that exact relationship is verified; otherwise bind a reviewed ancestry bridge/view. Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{HIVE_EXPORT_CONTEXT_CTX_TIME}}` | DATETIME scalar expression | Original observed activity time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{HIVE_EXPORT_CONTEXT_CTX_KIND}}` | STRING scalar expression | Explicit normalized activity kind derived from verified event type/subtype, not a name-only inference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{HIVE_EXPORT_CONTEXT_CTX_PROCESS}}` | STRING scalar expression | Process instance actually producing the activity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{HIVE_EXPORT_CONTEXT_CTX_TEXT}}` | STRING scalar expression | Activity detail: actual command, downloaded object/URL or file path as appropriate; retain the original event reference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{HIVE_EXPORT_CONTEXT_CTX_OUTCOME}}` | STRING scalar expression | Actual operation outcome; UNKNOWN when absent, never success by default Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Binding the output-artifact kind requires exact destination-path and writer correlation; an arbitrary .hiv file is not enough.
- An attempted save can fail. SYSTEM activity in the same operation is supporting context, not proof of credential recovery.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Parsed reg save HKLM SAM attempt has same-operation SYSTEM access and actual destination file creation | Anchor plus differentiated context records. |
| negative | reg query SAM, save an unrelated hive, or arbitrary output file by another process | No SAM-save anchor or false artifact match. |
| null | No result/output telemetry follows a valid attempt | Attempt remains without success claim. |
| edge | Quoted output path contains spaces and the save fails | Parser preserves exact destination; failure outcome is not reported as extraction. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-014](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-014](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-014](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-014](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-014](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-014](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-014](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/reg-save)
- [Official source for TH-014](https://attack.mitre.org/techniques/T1003/002/)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
