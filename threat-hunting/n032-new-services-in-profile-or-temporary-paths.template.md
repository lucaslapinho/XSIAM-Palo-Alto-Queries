# New Services in Profile or Temporary Paths

Preserves successful service-install records whose configured executable path matches a profile/temporary heuristic and adds first observed same-path process-start context within one hour.

[Open query](n032-new-services-in-profile-or-temporary-paths.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N032  
**Category:** Threat Hunting / Persistence  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Full installation-to-execution template. A same-path start is corroboration and does not prove the service manager launched it.

## Data and setup

**Sources:** `xdr_data`, `{{SERVICE_INSTALL_DATASET}}`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{SERVICE_INSTALL_DATASET}}` | XQL dataset identifier | Actual read-only source for SERVICE_INSTALL. Bind a documented/inspected dataset or reviewed view; this name is not a claim of an existing integration. |
| `{{SERVICE_INSTALL_ANCHOR_TIME}}` | DATETIME scalar expression | Successful service installation audit time Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_ENDPOINT_ID}}` | STRING scalar expression | Stable endpoint ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_ANCHOR_PROCESS_ID}}` | STRING scalar expression | Stable installation event identity, not a guessed process ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_ANCHOR_COMMAND}}` | STRING scalar expression | Original configured service image command Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_ANCHOR_ACTOR}}` | STRING scalar expression | Installing subject identity Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_SERVICE_NAME}}` | STRING scalar expression | Installed service name Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_SERVICE_ACCOUNT}}` | STRING scalar expression | Configured service account Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_SERVICE_EXECUTABLE}}` | STRING scalar expression | Lowercased resolved executable path parsed from service configuration; retain quoting/arguments in anchor_command Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |
| `{{SERVICE_INSTALL_EVENT_ID}}` | INTEGER scalar expression | Provider-verified installation event ID Map from the actual source schema; preserve null when unavailable, and validate normalization against raw records. |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Service configuration parsing must resolve quoted paths, arguments and variables without treating DLL arguments as the executable.
- First observed is bounded by collected one-day data and a one-hour post-install interval; paths do not establish ACL writability.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | 4697 installs a service executable under a user profile; matching process starts at +30 and +90 seconds | Install row plus first_execution_time at +30 seconds. |
| negative | Only a pre-install same-path start exists | Install row remains; no first-execution row. |
| null | Configured path cannot be parsed | Excluded from path heuristic; schema acceptance test records this gap. |
| edge | Same executable starts on a different endpoint | No association. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-007](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-007](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-007](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-007](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-007](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-007](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Union-with-an-Inner-XQL-Query)
- [Official source for TH-007](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4697)
- [Official source for TH-007](https://attack.mitre.org/techniques/T1543/003/)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
