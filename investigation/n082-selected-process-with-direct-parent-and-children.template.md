# Selected Process with Direct Parent and Children

Returns a selected process instance, its verified direct parent and direct child starts on one endpoint, preserving causality as separate context.

[Open query](n082-selected-process-with-direct-parent-and-children.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N082  
**Category:** Investigation / Process Relationships  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Complete one-generation parent/child pivot template. Causality is displayed but not reclassified as direct ancestry; arbitrary descendant recursion is outside this selected-instance view.

## Data and setup

**Sources:** `{{PROCESS_RELATIONSHIPS_DATASET}}`.

**Lookback:** `7d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{PROCESS_RELATIONSHIPS_DATASET}}` | XQL dataset identifier | Actual read-only source for PROCESS_RELATIONSHIPS. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{PROCESS_RELATIONSHIPS_EVENT_TIME}}` | DATETIME scalar expression | Process start time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_HOST_ID}}` | STRING scalar expression | Stable endpoint identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_PROCESS_ID}}` | STRING scalar expression | Stable process-instance key, never PID alone Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_PARENT_ID}}` | STRING scalar expression | Verified immediate-parent instance key Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_CAUSALITY_ID}}` | STRING scalar expression | Causality group identifier with documented scope; null when unavailable Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_IMAGE}}` | STRING scalar expression | Started image path Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_COMMAND_LINE}}` | STRING scalar expression | Started command line Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{PROCESS_RELATIONSHIPS_ACCOUNT}}` | STRING scalar expression | Started account Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SELECTED_ENDPOINT_ID}}` | STRING literal | Quoted stable endpoint ID; no empty/all-host fallback |
| `{{SELECTED_PROCESS_INSTANCE}}` | STRING literal | Quoted stable process-instance ID; numeric PID alone is not accepted |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Parent and selected starts predating the seven-day scan may be absent; process lifetime/current state is not inferred.
- Stable process IDs and verified parent linkage must use a common host/boot namespace; validate process-provider replay/duplicate behavior.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | Selected stable instance P has parent A and children B/C | SELECTED_PROCESS, DIRECT_PARENT and both DIRECT_CHILD rows. |
| negative | Numeric PID reused by a different instance or another host | No false relationship. |
| null | Parent instance missing or outside retention | Selected/child rows remain; no guessed parent. |
| edge | Causality owner differs from direct parent | Only verified parent is DIRECT_PARENT; causality remains context. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for OP-012](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for OP-012](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for OP-012](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for OP-012](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for OP-012](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for OP-012](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for OP-012](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
