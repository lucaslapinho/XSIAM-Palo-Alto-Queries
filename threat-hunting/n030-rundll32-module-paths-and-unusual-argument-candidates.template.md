# Rundll32 Module Paths and Unusual Argument Candidates

Reviews rundll32 URL/script/UNC command references or correlated module loads under user/profile/temporary path segments. Actual module identity is retained separately from argument heuristics.

[Open query](n030-rundll32-module-paths-and-unusual-argument-candidates.template.xql) · [Category index](README.md) · [Library](../README.md)

**ID:** N030  
**Category:** Threat Hunting / Proxy Execution  
**Status:** Schema template — map fields before use  
**Product:** Cortex XSIAM · Interactive XQL Search  
**Tenant compilation and execution:** NOT RUN

## What it returns

Complete module-plus-command review; path matches are heuristics and do not establish effective write permissions.

## Data and setup

**Sources:** `xdr_data`.

**Lookback:** `1d`. Adjust the configured window for your investigation and data retention.

Replace the values below before running the query. For `{{TOKEN}}` placeholders, replace the entire token with a verified source or expression of the required type. Do not quote field names. Missing telemetry requires collection or a reviewed source; renaming fields does not create it.

| Parameter | Required type | Meaning / adjustment |
|---|---|---|
| `{{MODULE_LOAD_EVENT_PREDICATE}}` | BOOLEAN expression | Verified xdr_data module-load category/subtype predicate; exclude replay-only snapshots if the objective is new loads |

**Correlation semantics:** Explicit stable-key joins; unique inventory keys or documented one-to-many telemetry. Union anchor rows preserve anchors when correlated records are absent/outside the interval. No event/session deduplication is implied.

## How to use

1. Open the `.xql` file and copy its complete contents into XQL Search.
2. Apply the required input values and schema mappings, then compile in your tenant.
3. Run a bounded window with known positive and negative examples; check nulls, timestamps and duplicate rows.
4. Review matches with host, user and change context before drawing conclusions.

## Interpretation and limitations

- Module replay/population and event subtype require binding. A module loaded by a process started before the window is not covered.
- Command-only candidates can have no observed module; they remain attempts rather than completed proxy execution.
- No tenant compilation or execution. Validate nulls, access, retention and source collection before interpreting empty results.
- A terminal limit bounds displayed output, not upstream scans or join multiplicity.

**Performance:** Bounded lookback and early filters; result caps do not bound upstream scanning. No measured performance claim.

## Validation examples — not executed

| Case | Input scenario | Expected interpretation |
|---|---|---|
| positive | rundll32 loads a user-profile DLL after its start | loaded_path_candidate true with actual module path. |
| negative | System DLL with ordinary command and no risky path/reference | Excluded. |
| null | URL-reference command with no module event | Retained as command-only candidate. |
| edge | Module with the same ID on another endpoint or before the process start | Not treated as an in-window load. |

## References

Retained source references for fields and constructs; these do not establish full-query or tenant acceptance.

- [Official source for TH-005](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields)
- [Official source for TH-005](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/action-actor)
- [Official source for TH-005](https://cortex-docs.paloaltonetworks.com/xql-schema-reference/xdr-data-fields-by-actor/actor-actor)
- [Official source for TH-005](https://cortex-docs.paloaltonetworks.com/xql-command-reference-guide/readme/functions/timestamp_diff)
- [Official source for TH-005](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-2-Left-join?contentId=5iT66RH4ney5McWya7JKjQ)
- [Official source for TH-005](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Official source for TH-005](https://attack.mitre.org/techniques/T1218/011/)
- [Cortex XDR union: process-start and file-write example](https://docs-cortex.paloaltonetworks.com/r/Cortex-XDR/Cortex-XDR-3.x-Documentation/union)
- [XQL filter Example 22: ordinary double-quoted strings](https://docs-cortex.paloaltonetworks.com/r/Cortex/Cortex-XQL-Command-Reference/Example-22-String-manipulation-single-quotes?contentId=lwRG5fwKl6gNfg7ngRAAMA)
- [RE2 syntax reference](https://github.com/google/re2/wiki/syntax)
