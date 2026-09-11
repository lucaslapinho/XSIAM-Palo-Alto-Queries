# Mshta URL or Script References and Follow-on Activity

Finds mshta start records containing URL or script-protocol text and preserves a ten-minute child-process, network and download evidence timeline after relationship binding.

[Open query](n029-mshta-url-or-script-references-and-follow-on-activity.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N029  
**Category:** Threat Hunting / Proxy Execution  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Text is a reference/attempt candidate. The template includes children and connections; retrieval and script execution are not asserted from text.

## Data and setup

**Sources:** `xdr_data`, `{{MSHTA_ACTIVITY_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MSHTA_ACTIVITY_DATASET}}` | XQL dataset identifier | Actual read-only source for MSHTA_ACTIVITY. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{MSHTA_ACTIVITY_CTX_HOST}}` | STRING scalar expression | Stable endpoint ID in the same namespace as the anchor Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MSHTA_ACTIVITY_CTX_ROOT}}` | STRING scalar expression | Root process instance for this bounded ancestry relation. Associate the mshta instance and verified children, retaining direct-versus-descendant scope in the source mapping. A native actor or causality-owner field may only be used if that exact relationship is verified; otherwise bind a reviewed ancestry bridge/view. Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MSHTA_ACTIVITY_CTX_TIME}}` | DATETIME scalar expression | Original observed activity time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MSHTA_ACTIVITY_CTX_KIND}}` | STRING scalar expression | Explicit normalized activity kind derived from verified event type/subtype, not a name-only inference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MSHTA_ACTIVITY_CTX_PROCESS}}` | STRING scalar expression | Process instance actually producing the activity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MSHTA_ACTIVITY_CTX_TEXT}}` | STRING scalar expression | Activity detail: actual command, downloaded object/URL or file path as appropriate; retain the original event reference Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{MSHTA_ACTIVITY_CTX_OUTCOME}}` | STRING scalar expression | Actual operation outcome; UNKNOWN when absent, never success by default Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Quoted, unused or malformed references can match. Alternative obfuscation and missing command lines can be missed.
- The source bridge must not equate host co-occurrence with mshta ancestry.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | mshta URL-text anchor followed by an instance-linked network event | Both anchor and network row. |
| negative | Unrelated process contains URL text or another host reuses the process key | No false anchor/context. |
| null | mshta starts with null command line | Excluded; record the coverage gap. |
| edge | A child exists but the connection belongs to a sibling unrelated process | Child may appear; unrelated network evidence must not. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-004](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-004](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-004](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-004](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-004](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-004](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-004](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-004](https://attack.mitre.org/techniques/T1218/005/)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
